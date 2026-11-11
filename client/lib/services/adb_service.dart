import 'dart:async';
import 'dart:convert';
import 'dart:io';
import '../models/device_model.dart';
import '../models/audio_settings.dart';
import '../models/audio_stats.dart';

class AdbService {
  final Future<Process> Function(String, List<String>) _startProcess;
  final Set<Process> _commands = {};
  bool _disposed = false;
  String _adbPath = '';
  Process? _launchProcess;
  int _generation = 0;
  void Function(PlaybackSnapshot)? onStats;
  void Function(String)? onServerExit;
  String _serverDiagnostic = '';

  AdbService({Future<Process> Function(String, List<String>)? startProcess})
      : _startProcess = startProcess ?? Process.start {
    _initAdbPath();
  }

  Future<ProcessResult> _run(List<String> arguments,
      {bool cleanup = false}) async {
    if (_disposed && !cleanup) throw StateError('ADB service is disposed');
    final process = await _startProcess(_adbPath, arguments);
    if (!cleanup) _commands.add(process);
    final output = process.stdout
        .transform(const Utf8Decoder(allowMalformed: true))
        .join();
    final errors = process.stderr
        .transform(const Utf8Decoder(allowMalformed: true))
        .join();
    // Process creation may complete after dispose has already cancelled commands.
    if (_disposed && !cleanup) process.kill(ProcessSignal.sigkill);
    try {
      final exit = process.exitCode.timeout(
        cleanup ? const Duration(seconds: 2) : const Duration(seconds: 30),
        onTimeout: () {
          process.kill(ProcessSignal.sigkill);
          throw TimeoutException('ADB command timed out: ${arguments.first}');
        },
      );
      final result = await Future.wait<Object>([exit, output, errors]);
      return ProcessResult(process.pid, result[0] as int, result[1], result[2]);
    } finally {
      _commands.remove(process);
    }
  }

  void _initAdbPath() {
    final sep = Platform.pathSeparator;
    final exeDir = File(Platform.resolvedExecutable).parent.path;

    if (Platform.isWindows) {
      // Windows: copy adb.exe + Win32 DLLs to temp so the daemon persists
      // across restarts (the bundle dir may be read-only when installed).
      final tempDir =
          '${Directory.systemTemp.path}${sep}ysbing${sep}AudioShare${sep}adb';
      final tempAdb = '$tempDir${sep}adb.exe';
      try {
        Directory(tempDir).createSync(recursive: true);
        for (final name in ['adb.exe', 'AdbWinApi.dll', 'AdbWinUsbApi.dll']) {
          final src = File('$exeDir$sep$name');
          if (src.existsSync()) {
            try {
              src.copySync('$tempDir$sep$name');
            } catch (_) {}
          }
        }
        if (File(tempAdb).existsSync()) {
          _adbPath = tempAdb;
          return;
        }
      } catch (_) {}
      _adbPath = '$exeDir${sep}adb.exe';
      return;
    }

    // macOS / Linux: adb is bundled next to the executable by the build phase.
    _adbPath = '$exeDir${sep}adb';
  }

  Future<String> _exec(List<String> arguments, {bool cleanup = false}) async {
    try {
      final result = await _run(arguments, cleanup: cleanup);
      final stdout = result.stdout as String;
      final stderr = result.stderr as String;
      if (stdout.isNotEmpty) return stdout;
      if (stderr.isNotEmpty) return stderr;
      return '';
    } catch (_) {
      return '';
    }
  }

  /// Runs adb and throws a [ProcessException] when the process exits non-zero
  /// or fails to launch. Used for operations whose failure must reach the UI
  /// (e.g. pushing the Android server bundle) instead of being silently
  /// swallowed by [_exec].
  Future<void> _execOrThrow(List<String> arguments) async {
    ProcessResult result;
    try {
      result = await _run(arguments);
    } on ProcessException catch (e, stackTrace) {
      // Keep the OS error (e.g. "Access is denied") instead of replacing it, so
      // an unrelated launch failure is not always reported as a missing bundle.
      // The hint is appended because a package without the bundled adb is the
      // common cause of a failed push (issue #8).
      const hint =
          'Make sure the bundled adb executable is present next to the app.';
      Error.throwWithStackTrace(
        ProcessException(
          _adbPath,
          arguments,
          e.message.isEmpty ? hint : '${e.message} $hint',
          e.errorCode,
        ),
        stackTrace,
      );
    }
    if (result.exitCode != 0) {
      final stderr = (result.stderr as String).trim();
      final stdout = (result.stdout as String).trim();
      final detail = stderr.isNotEmpty ? stderr : stdout;
      throw ProcessException(
        _adbPath,
        arguments,
        detail.isNotEmpty ? detail : 'adb exited with code ${result.exitCode}',
        result.exitCode,
      );
    }
  }

  // Cache device properties: they never change while connected.
  final Map<String, DeviceModel> _deviceCache = {};

  Future<List<DeviceModel>> devices() async {
    var output = await _exec(['devices']);
    if (_disposed) return [];
    if (!output.contains('\tdevice')) {
      await Future.delayed(const Duration(milliseconds: 800));
      if (_disposed) return [];
      output = await _exec(['devices']);
    }
    final lines = LineSplitter().convert(output);
    final devices = <DeviceModel>[];

    for (int i = 1; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.isEmpty) continue;
      final parts = line.split(RegExp(r'\s+'));
      if (parts.length >= 2 && parts[1] == 'device') {
        final deviceId = parts[0];
        if (_deviceCache.containsKey(deviceId)) {
          devices.add(_deviceCache[deviceId]!);
          continue;
        }
        // Batch all getprop into one shell invocation with labeled output so
        // parsing is order-independent and robust against ADB daemon messages
        // or stray empty lines that would otherwise shift indices.
        final propsOut = await _exec([
          '-s',
          deviceId,
          'shell',
          'echo "sn:\$(getprop ro.serialno)"; '
              'echo "mo:\$(getprop ro.product.model)"; '
              'echo "mf:\$(getprop ro.product.manufacturer)"; '
              'echo "av:\$(getprop ro.build.version.release)"; '
              'echo "al:\$(getprop ro.build.version.sdk)"',
        ]);
        String tag(String t) {
          for (final raw in LineSplitter().convert(propsOut)) {
            final line = raw.trim();
            if (line.startsWith('$t:')) return line.substring(t.length + 1);
          }
          return '';
        }

        final ipPort = _getIpPort(deviceId);
        final model = DeviceModel(
          deviceId: deviceId,
          usb: ipPort.$1.isEmpty || ipPort.$2.isEmpty,
          serialNumber: tag('sn'),
          model: tag('mo'),
          manufacturer: tag('mf'),
          androidVersion: tag('av'),
          apiLevel: tag('al'),
          ip: ipPort.$1,
          port: ipPort.$2,
        );
        _deviceCache[deviceId] = model;
        devices.add(model);
      }
    }
    // Evict cache entries for devices no longer present.
    _deviceCache.removeWhere((id, _) => !devices.any((d) => d.deviceId == id));
    return devices;
  }

  (String, String) _getIpPort(String deviceId) {
    final regex = RegExp(r'(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}):(\d{1,5})');
    final match = regex.firstMatch(deviceId);
    if (match != null) {
      return (match.group(1)!, match.group(2)!);
    }
    return ('', '');
  }

  Future<void> removeAllReverse(String deviceId) async {
    await _exec(['-s', deviceId, 'reverse', '--remove-all']);
  }

  Future<void> reverse(String deviceId, String socketName, String port) async {
    await _execOrThrow(
        ['-s', deviceId, 'reverse', 'localabstract:$socketName', 'tcp:$port']);
  }

  Future<void> removeReverse(String deviceId, String socketName) async {
    await _exec(
        ['-s', deviceId, 'reverse', '--remove', 'localabstract:$socketName'],
        cleanup: true);
  }

  Future<void> pushServer(String deviceId) async {
    final exeDir = File(Platform.resolvedExecutable).parent.path;
    // macOS: server APK lives in Contents/Resources/ to avoid codesign failures.
    // Windows: server is placed next to the exe by CMakeLists.txt.
    final serverPath = Platform.isMacOS
        ? '$exeDir/../Resources/server'
        : '$exeDir${Platform.pathSeparator}server';
    final serverFile = File(serverPath);
    if (!serverFile.existsSync()) {
      // Reached when a release archive was packaged without the bundled
      // server asset (e.g. issue #8). Failing fast surfaces the problem
      // instead of letting the connection silently stall on Connecting.
      throw FileSystemException(
        'AudioShare server bundle not found alongside the executable.',
        serverPath,
      );
    }
    // adb runs as a separate process, so it cannot read a file that only exists
    // in a virtual file system (single-file exe built with Enigma Virtual Box,
    // issue #8). Push a real copy from the temp directory, the same way
    // _initAdbPath() handles adb itself.
    final tempDir = '${Directory.systemTemp.path}${Platform.pathSeparator}'
        'ysbing${Platform.pathSeparator}AudioShare';
    Directory(tempDir).createSync(recursive: true);
    final pushPath = '$tempDir${Platform.pathSeparator}server';
    serverFile.copySync(pushPath);
    await _execOrThrow(
        ['-s', deviceId, 'push', pushPath, '/data/local/tmp/audioshare']);
  }

  Future<void> launchServer(
      String deviceId, String socketName, AudioSettings settings) async {
    if (_disposed) return;
    stopServer();
    final generation = _generation;
    final process = await _startProcess(_adbPath, [
      '-s',
      deviceId,
      'shell',
      'app_process',
      '-Djava.class.path=/data/local/tmp/audioshare',
      '/data/local/tmp',
      'com.ysbing.audioshare.Main',
      'socketName=$socketName',
      'connectCode=$deviceId',
      'bufferMs=${settings.bufferMs}',
      'preRollMs=${settings.preRollMs}',
      'readChunkMs=${settings.readChunkMs}',
      'lowLatency=${settings.lowLatency}',
    ]);
    if (_disposed || generation != _generation) {
      process.kill();
      await Future.wait([
        process.stdout.drain<void>(),
        process.stderr.drain<void>(),
        process.exitCode.then<void>((_) {}),
      ]);
      return;
    }
    _launchProcess = process;
    _serverDiagnostic = '';
    void diagnostic(String line) {
      _serverDiagnostic = '$_serverDiagnostic$line\n';
      if (_serverDiagnostic.length > 4096) {
        _serverDiagnostic =
            _serverDiagnostic.substring(_serverDiagnostic.length - 4096);
      }
    }

    final stdoutDone = process.stdout
        .transform(const Utf8Decoder(allowMalformed: true))
        .transform(const LineSplitter())
        .forEach((line) {
      if (generation != _generation) return;
      if (line.startsWith('AUDIO_STATS ')) {
        try {
          final json = jsonDecode(line.substring(12));
          if (json is Map<String, dynamic>) {
            final snapshot = PlaybackSnapshot.parse(json);
            if (snapshot != null) onStats?.call(snapshot);
          }
        } on FormatException {
          diagnostic(line);
        }
      } else {
        diagnostic(line);
      }
    });
    final stderrDone = process.stderr
        .transform(const Utf8Decoder(allowMalformed: true))
        .transform(const LineSplitter())
        .forEach((line) {
      if (generation == _generation) diagnostic(line);
    });
    process.exitCode.then((code) async {
      await Future.wait([stdoutDone, stderrDone]);
      if (generation != _generation) return;
      _launchProcess = null;
      onServerExit?.call(_serverDiagnostic.isEmpty
          ? 'Android playback exited ($code)'
          : _serverDiagnostic.trim());
    });
  }

  void stopServer() {
    _generation++;
    if (_launchProcess != null) {
      _launchProcess!.kill(ProcessSignal.sigkill);
      _launchProcess = null;
    }
  }

  void dispose() {
    if (_disposed) return;
    _disposed = true;
    stopServer();
    for (final process in _commands) {
      process.kill(ProcessSignal.sigkill);
    }
    // ADB daemon runs from temp dir and intentionally persists between restarts.
    // No kill-server needed.
  }
}
