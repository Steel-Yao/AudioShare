import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

import 'models/audio_settings.dart';
import 'models/audio_stats.dart';
import 'models/device_model.dart';
import 'services/adb_service.dart';
import 'services/audio_capture.dart';
import 'utils/prefs.dart';

enum UiErrorType {
  recordingPermissionRequired,
  captureInitializationFailed,
  captureStopped,
  captureStartFailed,
  listenerStartFailed,
  noAvailablePort,
  connectAndroidDeviceFailed,
  connectDeviceFailed,
}

class UiError {
  const UiError({required this.type, this.nativeError, this.exception});
  final UiErrorType type;
  final AudioCaptureError? nativeError;
  final Object? exception;
}

class DataSource extends ChangeNotifier {
  final AdbService _adb;
  final AudioCaptureService _capture;
  final Stopwatch _sessionClock = Stopwatch();
  final List<AudioHistorySample> _history = [];
  List<DeviceModel> _devices = [];
  List<AudioInputDevice> _inputDevices = [];
  AudioSettings _settings = const AudioSettings();
  CaptureSnapshot _captureStats = const CaptureSnapshot();
  PlaybackSnapshot? _playbackStats;
  String? _activeDeviceId;
  String? _socketName;
  int _state = 0;
  int _deviceState = 0;
  bool _lastCheck = true;
  String _lastDeviceId = '';
  String _lastAutoDeviceId = '';
  UiError? _pendingError;
  int _session = 0;
  bool _disposed = false;
  bool _polling = false;
  int _missingDevicePolls = 0;
  int _lastBytes = 0;
  int _lastSampleMs = 0;
  Timer? _pollTimer;
  Timer? _statsTimer;
  Timer? _connectTimeout;
  final Set<Future<void>> _connectTasks = {};
  final Set<Future<void>> _reverseRemovals = {};

  DataSource({
    bool startPolling = true,
    AdbService? adb,
    AudioCaptureService? capture,
  })  : _adb = adb ?? AdbService(),
        _capture = capture ?? AudioCaptureService() {
    Prefs.load();
    _lastDeviceId = Prefs.getString('lastDeviceId');
    _lastCheck = Prefs.getBool('lastCheck', defaultValue: true);
    try {
      final saved =
          jsonDecode(Prefs.getString('audioSettings', defaultValue: '{}'));
      if (saved is Map<String, dynamic>) {
        _settings = AudioSettings.fromJson(saved);
      }
    } on FormatException {
      _settings = const AudioSettings();
    }
    if (!Platform.isWindows) {
      _settings =
          _settings.copyWith(source: AudioSource.systemOutput, deviceId: '');
    }
    _adb.onStats = (snapshot) {
      if (_disposed || _state == 0) return;
      _playbackStats = snapshot;
      if (_captureStats.running) {
        _state = 2;
        _connectTimeout?.cancel();
      }
    };
    _adb.onServerExit = (message) {
      if (_state != 0) {
        _fail(UiError(type: UiErrorType.captureStopped, exception: message));
      }
    };
    refreshAudioDevices();
    if (startPolling) {
      unawaited(_pollDevices());
      _pollTimer =
          Timer.periodic(const Duration(seconds: 3), (_) => _pollDevices());
      _statsTimer = Timer.periodic(
          const Duration(milliseconds: 500), (_) => _pollStats());
    }
  }

  List<DeviceModel> get devices => List.unmodifiable(_devices);
  List<AudioInputDevice> get inputDevices => List.unmodifiable(_inputDevices);
  AudioSettings get settings => _settings;
  CaptureSnapshot get captureStats => _captureStats;
  PlaybackSnapshot? get playbackStats => _playbackStats;
  List<AudioHistorySample> get history => List.unmodifiable(_history);
  int get deviceState => _deviceState;
  bool get lastCheck => _lastCheck;
  bool get hasSession => _state != 0;
  bool get settingsEnabled => !hasSession;
  int getConnectState(String deviceId) =>
      deviceId == _activeDeviceId ? _state : 0;
  bool getConnectEnable(String deviceId) =>
      _state == 0 || _state == 2 || deviceId == _activeDeviceId;

  UiError? takePendingError() {
    final error = _pendingError;
    _pendingError = null;
    return error;
  }

  set lastCheck(bool value) {
    _lastCheck = value;
    _lastAutoDeviceId = _lastDeviceId;
    Prefs.setBool('lastCheck', value);
    _notify();
  }

  void updateSettings(AudioSettings value) {
    if (!settingsEnabled || value == _settings) return;
    final changedSource = value.source != _settings.source;
    _settings = value;
    Prefs.setString('audioSettings', jsonEncode(value.toJson()));
    if (changedSource) refreshAudioDevices();
    _notify();
  }

  void refreshAudioDevices() {
    _inputDevices = _capture.devices(_settings.source);
    _notify();
  }

  void clearHistory() {
    _history.clear();
    _notify();
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  Future<void> _pollDevices() async {
    if (_disposed || _polling) return;
    _polling = true;
    try {
      final devices = await _adb.devices();
      if (_disposed) return;
      _devices = devices;
      _deviceState = devices.isEmpty ? 1 : 2;
      final activePresent =
          devices.any((device) => device.deviceId == _activeDeviceId);
      _missingDevicePolls =
          hasSession && !activePresent ? _missingDevicePolls + 1 : 0;
      if (_missingDevicePolls >= 2) {
        _fail(const UiError(
            type: UiErrorType.captureStopped,
            exception: 'Android device disconnected'));
      }
      final lastPresent =
          devices.any((device) => device.deviceId == _lastDeviceId);
      if (!lastPresent) _lastAutoDeviceId = '';
      if (!hasSession &&
          _lastCheck &&
          lastPresent &&
          _lastDeviceId.isNotEmpty &&
          _lastAutoDeviceId != _lastDeviceId) {
        connectDevice(_lastDeviceId);
      }
      _notify();
    } finally {
      _polling = false;
    }
  }

  void _pollStats() {
    if (!hasSession || _disposed) return;
    final error = _capture.pollLastError();
    if (error != null) {
      _fail(UiError(type: UiErrorType.captureStopped, nativeError: error));
      return;
    }
    _captureStats = _capture.snapshot();
    if (_captureStats.running && _playbackStats != null) {
      _state = 2;
      _connectTimeout?.cancel();
    }
    final elapsedMs = _sessionClock.elapsedMilliseconds;
    final interval = elapsedMs - _lastSampleMs;
    final delta = _captureStats.sentBytes - _lastBytes;
    final rate = interval > 0 && delta >= 0 ? delta * 8 / interval : 0.0;
    if (_captureStats.running && _captureStats.sampleRate > 0) {
      _history.add(AudioHistorySample(
        elapsedSeconds: elapsedMs / 1000,
        kilobitsPerSecond: rate,
        capture: _captureStats,
        playback: _playbackStats?.isFresh == true ? _playbackStats : null,
      ));
      if (_history.length > 120) _history.removeAt(0);
    }
    _lastBytes = _captureStats.sentBytes;
    _lastSampleMs = elapsedMs;
    _notify();
  }

  void _endSession() {
    _session++;
    _connectTimeout?.cancel();
    _adb.stopServer();
    _capture.stop();
    _captureStats = _capture.snapshot();
    _playbackStats = null;
    if (_activeDeviceId != null && _socketName != null) {
      _removeReverse(_activeDeviceId!, _socketName!);
    }
    _socketName = null;
    _state = 0;
    _activeDeviceId = null;
    _sessionClock.stop();
  }

  void _removeReverse(String deviceId, String name) {
    late final Future<void> removal;
    removal = _adb.removeReverse(deviceId, name).whenComplete(() {
      _reverseRemovals.remove(removal);
    });
    _reverseRemovals.add(removal);
    unawaited(removal);
  }

  void _fail(UiError error) {
    _endSession();
    _pendingError = error;
    _notify();
  }

  Future<int> _findPort() async {
    final socket = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
    final port = socket.port;
    await socket.close();
    return port;
  }

  void connectDevice(String deviceId, {bool userInitiated = false}) {
    if (_disposed) return;
    _endSession();
    _lastAutoDeviceId = deviceId;
    if (Platform.isMacOS && !_capture.hasScreenCapturePermission) {
      if (!userInitiated) return;
      if (!_capture.requestScreenCapturePermission()) {
        _fail(UiError(
            type: UiErrorType.recordingPermissionRequired,
            nativeError: _capture.takeLastError(fallbackCode: 1002)));
        return;
      }
    }
    if (!_capture.initialize() || !_capture.configure(_settings)) {
      _fail(UiError(
          type: UiErrorType.captureInitializationFailed,
          nativeError: _capture.takeLastError(fallbackCode: 1301)));
      return;
    }
    _activeDeviceId = deviceId;
    _state = 1;
    _pendingError = null;
    _history.clear();
    _captureStats = const CaptureSnapshot();
    _playbackStats = null;
    _lastBytes = _lastSampleMs = 0;
    _missingDevicePolls = 0;
    _sessionClock
      ..reset()
      ..start();
    final session = _session;
    _connectTimeout = Timer(const Duration(seconds: 25), () {
      if (_session == session && _state == 1) {
        _fail(const UiError(
            type: UiErrorType.connectAndroidDeviceFailed,
            exception: 'Connection timed out'));
      }
    });
    _notify();
    late final Future<void> task;
    task = _connect(deviceId, session).whenComplete(() {
      _connectTasks.remove(task);
    });
    _connectTasks.add(task);
    unawaited(task);
  }

  Future<void> _connect(String deviceId, int session) async {
    String? name;
    try {
      final port = await _findPort();
      if (_disposed || session != _session) return;
      name = 'audioshare_${port}_$session';
      _socketName = name;
      if (!_capture.listenOnPort(port, (code) {
        if (_disposed || session != _session) return;
        if (code != deviceId || !_capture.start()) {
          _fail(UiError(
              type: UiErrorType.captureStartFailed,
              nativeError: _capture.takeLastError(fallbackCode: 1301)));
        }
      })) {
        _fail(UiError(
            type: UiErrorType.listenerStartFailed,
            nativeError: _capture.takeLastError(fallbackCode: 1100)));
        return;
      }
      await _adb.reverse(deviceId, name, port.toString());
      if (_disposed || session != _session) {
        return;
      }
      await _adb.pushServer(deviceId);
      if (_disposed || session != _session) return;
      await _adb.launchServer(deviceId, name, _settings);
      if (_disposed || session != _session) return;
      _lastDeviceId = deviceId;
      Prefs.setString('lastDeviceId', deviceId);
    } catch (error) {
      if (!_disposed && session == _session) {
        _fail(UiError(
            type: UiErrorType.connectAndroidDeviceFailed, exception: error));
      }
    } finally {
      // A cancelled adb command can have installed the tunnel before it exits.
      if (name != null && (_disposed || session != _session)) {
        _removeReverse(deviceId, name);
      }
    }
  }

  void disconnectDevice(String deviceId) {
    _lastAutoDeviceId = deviceId;
    _endSession();
    _notify();
  }

  void disconnectAllDevice() {
    _endSession();
    _notify();
  }

  Future<void> shutdown() async {
    final watch = Stopwatch()..start();
    dispose();
    // A connection may still be creating its reverse tunnel when close begins.
    await Future.wait(_connectTasks);
    await Future.wait(_reverseRemovals);
    debugPrint(
        'Audio session cleanup finished in ${watch.elapsedMilliseconds} ms');
  }

  @override
  void dispose() {
    if (_disposed) return;
    _disposed = true;
    _pollTimer?.cancel();
    _statsTimer?.cancel();
    _endSession();
    _capture.dispose();
    _adb.dispose();
    super.dispose();
  }
}
