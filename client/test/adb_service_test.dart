import 'dart:async';
import 'dart:io';

import 'package:audioshare/models/audio_settings.dart';
import 'package:audioshare/services/adb_service.dart';
import 'package:flutter_test/flutter_test.dart';

class _AdbProcess implements Process {
  final _exit = Completer<int>();
  final _stdout = StreamController<List<int>>();
  final _stderr = StreamController<List<int>>();
  bool killed = false;

  void finish(int code) {
    if (_exit.isCompleted) return;
    _stdout.close();
    _stderr.close();
    _exit.complete(code);
  }

  @override
  Future<int> get exitCode => _exit.future;
  @override
  int get pid => 1;
  @override
  Stream<List<int>> get stdout => _stdout.stream;
  @override
  Stream<List<int>> get stderr => _stderr.stream;
  @override
  IOSink get stdin => throw UnimplementedError();
  @override
  bool kill([ProcessSignal signal = ProcessSignal.sigterm]) {
    killed = true;
    finish(-9);
    return true;
  }
}

void main() {
  test('closing cancels an in-flight ADB operation', () async {
    final process = _AdbProcess();
    final service = AdbService(startProcess: (_, __) async => process);
    final command = service.reverse('device', 'audioshare_test', '1234');
    final checked = expectLater(command, throwsA(isA<ProcessException>()));
    await Future<void>.delayed(Duration.zero);
    service.dispose();
    await checked;
    expect(process.killed, isTrue);
  });

  test('closing also cancels a process whose creation is still pending',
      () async {
    final starting = Completer<Process>();
    final service = AdbService(startProcess: (_, __) => starting.future);
    final command = service.reverse('device', 'audioshare_test', '1234');
    final checked = expectLater(command, throwsA(isA<ProcessException>()));
    service.dispose();
    final process = _AdbProcess();
    starting.complete(process);
    await checked;
    expect(process.killed, isTrue);
  });

  test('session tunnel removal is allowed after cancellation', () async {
    final calls = <List<String>>[];
    final process = _AdbProcess();
    final service = AdbService(startProcess: (_, args) async {
      calls.add(args);
      scheduleMicrotask(() => process.finish(0));
      return process;
    });
    service.dispose();
    await service.removeReverse('device', 'audioshare_test');
    expect(calls.single, [
      '-s',
      'device',
      'reverse',
      '--remove',
      'localabstract:audioshare_test'
    ]);
    expect(process.killed, isFalse);
  });

  test('cancelled device polling does not retry', () async {
    final process = _AdbProcess();
    var starts = 0;
    final service = AdbService(startProcess: (_, __) async {
      starts++;
      return process;
    });
    final devices = service.devices();
    await Future<void>.delayed(Duration.zero);
    service.dispose();
    expect(await devices, isEmpty);
    expect(starts, 1);
    expect(process.killed, isTrue);
  });

  test('closing preserves an already running session tunnel removal', () async {
    final process = _AdbProcess();
    final service = AdbService(startProcess: (_, __) async => process);
    final removal = service.removeReverse('device', 'audioshare_test');
    await Future<void>.delayed(Duration.zero);
    service.dispose();
    expect(process.killed, isFalse);
    process.finish(0);
    await removal;
  });

  test('a late Android launch cannot survive session shutdown', () async {
    final starting = Completer<Process>();
    final service = AdbService(startProcess: (_, __) => starting.future);
    final launch = service.launchServer(
        'device', 'audioshare_test', const AudioSettings());
    service.dispose();
    final process = _AdbProcess();
    starting.complete(process);
    await launch;
    expect(process.killed, isTrue);
  });
}
