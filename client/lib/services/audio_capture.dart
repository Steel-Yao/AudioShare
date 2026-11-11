import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';

import '../models/audio_settings.dart';
import '../models/audio_stats.dart';

final class NativeCaptureStats extends Struct {
  @Uint64()
  external int capturedFrames;
  @Uint64()
  external int sentFrames;
  @Uint64()
  external int sentBytes;
  @Uint64()
  external int droppedFrames;
  @Uint64()
  external int discontinuities;
  @Uint64()
  external int packets;
  @Uint32()
  external int sampleRate;
  @Uint32()
  external int channels;
  @Uint32()
  external int bits;
  @Uint32()
  external int queuedFrames;
  @Uint32()
  external int capacityFrames;
  @Uint32()
  external int running;
  @Uint32()
  external int inputChannels;
  @Uint32()
  external int inputBits;
  @Float()
  external double peakLeft;
  @Float()
  external double peakRight;
  @Float()
  external double rmsLeft;
  @Float()
  external double rmsRight;
  @Double()
  external double captureIntervalMs;
  @Double()
  external double sendTimeMs;
}

typedef ConfigureNative = Int32 Function(Pointer<Utf8>, Int32, Int32, Int32);
typedef ConfigureDart = int Function(Pointer<Utf8>, int, int, int);
typedef DeviceCountNative = Int32 Function(Int32);
typedef DeviceCountDart = int Function(int);
typedef DeviceTextNative = Pointer<Utf8> Function(Int32);
typedef DeviceTextDart = Pointer<Utf8> Function(int);
typedef GetStatsNative = Int32 Function(Pointer<NativeCaptureStats>);
typedef GetStatsDart = int Function(Pointer<NativeCaptureStats>);
typedef IsConnectedNative = Int32 Function(Pointer<Utf8>, Int32);
typedef IsConnectedDart = int Function(Pointer<Utf8>, int);

// Connect callback: void (*)(const char* connectCode)
typedef ConnectCallbackNative = Void Function(Pointer<Int8> connectCode);
typedef ConnectCallbackDart = void Function(Pointer<Int8> connectCode);

typedef AudioCaptureInitializeNative = Int32 Function();
typedef AudioCaptureInitializeDart = int Function();

typedef AudioCaptureListenNative = Int32 Function(
    Int32 port, Pointer<NativeFunction<ConnectCallbackNative>> callback);
typedef AudioCaptureListenDart = int Function(
    int port, Pointer<NativeFunction<ConnectCallbackNative>> callback);

typedef AudioCaptureStartNative = Int32 Function();
typedef AudioCaptureStartDart = int Function();

typedef AudioCaptureStopNative = Void Function();
typedef AudioCaptureStopDart = void Function();

typedef AudioCaptureCleanupNative = Void Function();
typedef AudioCaptureCleanupDart = void Function();

typedef AudioCaptureBoolNative = Int32 Function();
typedef AudioCaptureBoolDart = int Function();

typedef AudioCaptureGetErrorMessageNative = Pointer<Int8> Function();
typedef AudioCaptureGetErrorMessageDart = Pointer<Int8> Function();

class AudioCaptureError {
  const AudioCaptureError(this.code, this.message);

  final int code;
  final String message;
}

class AudioCaptureService {
  DynamicLibrary? _lib;
  AudioCaptureInitializeDart? _initialize;
  AudioCaptureListenDart? _listen;
  AudioCaptureStartDart? _start;
  AudioCaptureStopDart? _stop;
  AudioCaptureCleanupDart? _cleanup;
  AudioCaptureBoolDart? _hasPermission;
  AudioCaptureBoolDart? _requestPermission;
  AudioCaptureBoolDart? _getLastErrorCode;
  AudioCaptureGetErrorMessageDart? _getLastErrorMessage;
  AudioCaptureCleanupDart? _clearLastError;
  ConfigureDart? _configure;
  DeviceCountDart? _enumerateDevices;
  DeviceTextDart? _deviceId;
  DeviceTextDart? _deviceName;
  DeviceCountDart? _deviceIsDefault;
  GetStatsDart? _getStats;
  IsConnectedDart? _isConnected;

  bool _initialized = false;
  String? _libraryLoadError;
  Timer? _connectionPoll;

  AudioCaptureService() {
    _loadLibrary();
  }

  void _loadLibrary() {
    try {
      final exeDir = File(Platform.resolvedExecutable).parent.path;
      final libName =
          Platform.isMacOS ? 'audio_capture.dylib' : 'audio_capture.dll';
      final dllPath = '$exeDir${Platform.pathSeparator}$libName';
      _lib = DynamicLibrary.open(dllPath);
      _initialize = _lib!.lookupFunction<AudioCaptureInitializeNative,
          AudioCaptureInitializeDart>('AudioCapture_Initialize');
      _listen = _lib!
          .lookupFunction<AudioCaptureListenNative, AudioCaptureListenDart>(
              'AudioCapture_Listen');
      _start = _lib!
          .lookupFunction<AudioCaptureStartNative, AudioCaptureStartDart>(
              'AudioCapture_Start');
      _isConnected = _lib!.lookupFunction<IsConnectedNative, IsConnectedDart>(
          'AudioCapture_IsConnected');
      _stop = _lib!
          .lookupFunction<AudioCaptureStopNative, AudioCaptureStopDart>(
              'AudioCapture_Stop');
      _cleanup = _lib!
          .lookupFunction<AudioCaptureCleanupNative, AudioCaptureCleanupDart>(
              'AudioCapture_Cleanup');
      _configure = _lib!.lookupFunction<ConfigureNative, ConfigureDart>(
          'AudioCapture_Configure');
      _getStats = _lib!.lookupFunction<GetStatsNative, GetStatsDart>(
          'AudioCapture_GetStats');
      if (Platform.isWindows) {
        _enumerateDevices = _lib!
            .lookupFunction<DeviceCountNative, DeviceCountDart>(
                'AudioCapture_EnumerateDevices');
        _deviceId = _lib!.lookupFunction<DeviceTextNative, DeviceTextDart>(
            'AudioCapture_GetDeviceId');
        _deviceName = _lib!.lookupFunction<DeviceTextNative, DeviceTextDart>(
            'AudioCapture_GetDeviceName');
        _deviceIsDefault = _lib!
            .lookupFunction<DeviceCountNative, DeviceCountDart>(
                'AudioCapture_GetDeviceIsDefault');
      }
      _getLastErrorCode = _lib!
          .lookupFunction<AudioCaptureBoolNative, AudioCaptureBoolDart>(
              'AudioCapture_GetLastErrorCode');
      _getLastErrorMessage = _lib!.lookupFunction<
          AudioCaptureGetErrorMessageNative, AudioCaptureGetErrorMessageDart>(
        'AudioCapture_GetLastErrorMessage',
      );
      _clearLastError = _lib!
          .lookupFunction<AudioCaptureCleanupNative, AudioCaptureCleanupDart>(
              'AudioCapture_ClearLastError');
      if (Platform.isMacOS) {
        _hasPermission = _lib!
            .lookupFunction<AudioCaptureBoolNative, AudioCaptureBoolDart>(
                'AudioCapture_HasPermission');
        _requestPermission = _lib!
            .lookupFunction<AudioCaptureBoolNative, AudioCaptureBoolDart>(
                'AudioCapture_RequestPermission');
        _getLastErrorCode = _lib!
            .lookupFunction<AudioCaptureBoolNative, AudioCaptureBoolDart>(
                'AudioCapture_GetLastErrorCode');
        _getLastErrorMessage = _lib!.lookupFunction<
            AudioCaptureGetErrorMessageNative, AudioCaptureGetErrorMessageDart>(
          'AudioCapture_GetLastErrorMessage',
        );
        _clearLastError = _lib!
            .lookupFunction<AudioCaptureCleanupNative, AudioCaptureCleanupDart>(
                'AudioCapture_ClearLastError');
      }
    } catch (error) {
      _libraryLoadError = error.toString();
    }
  }

  bool configure(AudioSettings settings) {
    final id = settings.deviceId.toNativeUtf8();
    try {
      return _configure?.call(id, settings.source.index, settings.queueMs,
              settings.floatOutput ? 32 : 16) ==
          1;
    } finally {
      calloc.free(id);
    }
  }

  List<AudioInputDevice> devices(AudioSource source) {
    final count = _enumerateDevices?.call(source.index) ?? 0;
    return List.generate(
        count,
        (index) => AudioInputDevice(
              _deviceId!(index).toDartString(),
              _deviceName!(index).toDartString(),
              isDefault: _deviceIsDefault!(index) == 1,
            ));
  }

  CaptureSnapshot snapshot() {
    final pointer = calloc<NativeCaptureStats>();
    try {
      if (_getStats?.call(pointer) != 1) return const CaptureSnapshot();
      final stats = pointer.ref;
      return CaptureSnapshot(
        sampleRate: stats.sampleRate,
        channels: stats.channels,
        bits: stats.bits,
        inputChannels: stats.inputChannels,
        inputBits: stats.inputBits,
        capturedFrames: stats.capturedFrames,
        sentFrames: stats.sentFrames,
        sentBytes: stats.sentBytes,
        droppedFrames: stats.droppedFrames,
        discontinuities: stats.discontinuities,
        queuedFrames: stats.queuedFrames,
        capacityFrames: stats.capacityFrames,
        peakLeft: stats.peakLeft,
        peakRight: stats.peakRight,
        rmsLeft: stats.rmsLeft,
        rmsRight: stats.rmsRight,
        captureIntervalMs: stats.captureIntervalMs,
        sendTimeMs: stats.sendTimeMs,
        running: stats.running == 1,
      );
    } finally {
      calloc.free(pointer);
    }
  }

  bool get hasScreenCapturePermission {
    if (!Platform.isMacOS) return true;
    return _hasPermission?.call() == 1;
  }

  bool requestScreenCapturePermission() {
    if (!Platform.isMacOS) return true;
    return _requestPermission?.call() == 1;
  }

  /// Initialize system audio capture (WASAPI on Windows, ScreenCaptureKit on macOS).
  bool initialize() {
    if (_initialized) return true;
    if (_initialize == null) return false;
    _initialized = _initialize!() != 0;
    return _initialized;
  }

  /// Start listening for Android connection on given port.
  /// [onConnect] is called with the device connectCode when Android connects.
  bool listenOnPort(int port, void Function(String connectCode) onConnect) {
    if (!_initialized || _listen == null) return false;
    _connectionPoll?.cancel();
    if (_listen!(port, nullptr) == 0) return false;
    // Copy the handshake in a synchronous FFI call. A queued native callback
    // could otherwise outlive the string or the session that supplied it.
    _connectionPoll = Timer.periodic(const Duration(milliseconds: 25), (timer) {
      final code = calloc<Uint8>(256).cast<Utf8>();
      try {
        if (_isConnected?.call(code, 256) != 1) return;
        timer.cancel();
        _connectionPoll = null;
        onConnect(code.toDartString());
      } finally {
        calloc.free(code);
      }
    });
    return true;
  }

  /// Start audio capture stream (call after listenOnPort callback fires)
  bool start() {
    if (!_initialized || _start == null) return false;
    return _start!() != 0;
  }

  AudioCaptureError? takeLastError({
    int fallbackCode = -1,
    String fallbackMessage = 'Unknown audio capture error',
  }) {
    if (_libraryLoadError != null) {
      final message = _libraryLoadError!;
      _libraryLoadError = null;
      return AudioCaptureError(-1000, message);
    }

    final code = _getLastErrorCode?.call() ?? 0;
    var message = '';
    final messagePtr = _getLastErrorMessage?.call();
    if (messagePtr != null && messagePtr.address != 0) {
      final bytes = <int>[];
      for (var i = 0; i < 4096; i++) {
        final byte = (messagePtr + i).value;
        if (byte == 0) break;
        bytes.add(byte & 0xff);
      }
      message = utf8.decode(bytes, allowMalformed: true);
    }
    _clearLastError?.call();

    if (code == 0 && message.isEmpty) {
      return AudioCaptureError(fallbackCode, fallbackMessage);
    }
    return AudioCaptureError(
      code == 0 ? fallbackCode : code,
      message.isEmpty ? fallbackMessage : message,
    );
  }

  AudioCaptureError? pollLastError() {
    if ((_getLastErrorCode?.call() ?? 0) == 0) return null;
    return takeLastError();
  }

  void stop() {
    _connectionPoll?.cancel();
    _connectionPoll = null;
    if (!_initialized || _stop == null) return;
    _stop!();
  }

  void cleanup() {
    _connectionPoll?.cancel();
    _connectionPoll = null;
    _cleanup?.call();
    _initialized = false;
  }

  void dispose() {
    cleanup();
  }
}
