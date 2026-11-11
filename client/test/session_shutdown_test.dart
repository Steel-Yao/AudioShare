import 'dart:async';
import 'dart:io';

import 'package:audioshare/data_source.dart';
import 'package:audioshare/models/audio_settings.dart';
import 'package:audioshare/services/adb_service.dart';
import 'package:audioshare/services/audio_capture.dart';
import 'package:flutter_test/flutter_test.dart';

class _Capture extends AudioCaptureService {
  int cleanups = 0;
  @override
  bool initialize() => true;
  @override
  bool configure(AudioSettings settings) => true;
  @override
  List<AudioInputDevice> devices(AudioSource source) => [];
  @override
  bool listenOnPort(int port, void Function(String) onConnect) => true;
  @override
  void stop() {}
  @override
  void cleanup() => cleanups++;
}

class _Adb extends AdbService {
  final reverseStarted = Completer<void>();
  final reverseFinished = Completer<void>();
  final events = <String>[];
  final removed = <String>[];
  String? tunnel;

  @override
  Future<void> reverse(String deviceId, String socketName, String port) {
    tunnel = socketName;
    reverseStarted.complete();
    return reverseFinished.future;
  }

  @override
  Future<void> removeReverse(String deviceId, String socketName) async {
    removed.add(socketName);
    events.add('remove');
  }

  @override
  void dispose() {
    super.dispose();
    events.add('cancel');
    reverseFinished.completeError(ProcessException('adb', [], 'cancelled'));
  }
}

void main() {
  test('shutdown removes a late cancelled tunnel and is safe to repeat',
      () async {
    final adb = _Adb();
    final capture = _Capture();
    final source = DataSource(startPolling: false, adb: adb, capture: capture);
    source.connectDevice('device');
    await adb.reverseStarted.future.timeout(const Duration(seconds: 2));
    await source.shutdown();
    expect(adb.events, ['remove', 'cancel', 'remove']);
    expect(adb.removed, everyElement(adb.tunnel));
    expect(source.hasSession, isFalse);
    expect(capture.cleanups, 1);
    await source.shutdown();
    expect(capture.cleanups, 1);
  });
}
