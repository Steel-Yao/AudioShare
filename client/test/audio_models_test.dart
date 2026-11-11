import 'dart:convert';

import 'package:audioshare/models/audio_settings.dart';
import 'package:audioshare/models/audio_stats.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('settings survive persistence and constrain invalid saved values', () {
    final settings = const AudioSettings().copyWith(
      source: AudioSource.recordingInput,
      deviceId: 'endpoint',
      floatOutput: true,
      bufferMs: 20,
      preRollMs: 100,
      queueMs: 10,
    );
    expect(settings.preRollMs, 20);
    expect(
        AudioSettings.fromJson(
            jsonDecode(jsonEncode(settings.toJson())) as Map<String, dynamic>),
        settings);
    final invalid = AudioSettings.fromJson({
      'bufferMs': -8,
      'queueMs': 10000,
      'readChunkMs': 'bad',
      'deviceId': 3,
    });
    expect(invalid.bufferMs, 10);
    expect(invalid.queueMs, 500);
    expect(invalid.readChunkMs, 5);
    expect(invalid.deviceId, '');
  });

  test('preset changes buffers while preserving the selected source and format',
      () {
    final settings =
        const AudioSettings(deviceId: 'speakers', floatOutput: true);
    final low = settings.preset('low');
    expect(low.deviceId, 'speakers');
    expect(low.floatOutput, isTrue);
    expect(low.bufferMs, 20);
    expect(low.preRollMs, lessThanOrEqualTo(low.bufferMs));
    expect(settings.preset('stable').bufferMs, greaterThan(low.bufferMs));
  });

  test(
      'playback feedback rejects bad formats and reports queue separately from capacity',
      () {
    final json = <String, dynamic>{
      'version': 1,
      'sampleRate': 48000,
      'bits': 32,
      'queuedFrames': 480,
      'bufferFrames': 1920,
      'capacityFrames': 3840,
      'underruns': 3,
      'performanceMode': 1,
      'route': 'Speaker',
    };
    final playback = PlaybackSnapshot.parse(json)!;
    expect(playback.queueMs, 10);
    expect(playback.bufferMs, 40);
    expect(playback.underruns, 3);
    expect(playback.isFresh, isTrue);
    expect(PlaybackSnapshot.parse({...json, 'sampleRate': 0}), isNull);
    expect(PlaybackSnapshot.parse({...json, 'bits': 24}), isNull);
    expect(PlaybackSnapshot.parse({...json, 'capacityFrames': 100}), isNull);
    expect(PlaybackSnapshot.parse({...json, 'version': 2}), isNull);
  });
}
