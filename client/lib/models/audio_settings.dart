enum AudioSource { systemOutput, recordingInput }

class AudioSettings {
  const AudioSettings({
    this.source = AudioSource.systemOutput,
    this.deviceId = '',
    this.floatOutput = false,
    this.bufferMs = 40,
    this.preRollMs = 10,
    this.readChunkMs = 5,
    this.queueMs = 60,
    this.lowLatency = true,
  });

  final AudioSource source;
  final String deviceId;
  final bool floatOutput;
  final int bufferMs;
  final int preRollMs;
  final int readChunkMs;
  final int queueMs;
  final bool lowLatency;

  factory AudioSettings.fromJson(Map<String, dynamic> json) {
    int bounded(String key, int fallback, int min, int max) =>
        json[key] is num && (json[key] as num).isFinite
            ? (json[key] as num).toInt().clamp(min, max)
            : fallback;
    final buffer = bounded('bufferMs', 40, 10, 500);
    return AudioSettings(
      source: json['source'] == 1
          ? AudioSource.recordingInput
          : AudioSource.systemOutput,
      deviceId: json['deviceId'] is String ? json['deviceId'] as String : '',
      floatOutput: json['floatOutput'] == true,
      bufferMs: buffer,
      preRollMs: bounded('preRollMs', 10, 0, 250).clamp(0, buffer),
      readChunkMs: bounded('readChunkMs', 5, 1, 40),
      queueMs: bounded('queueMs', 60, 10, 500),
      lowLatency: json['lowLatency'] != false,
    );
  }

  AudioSettings copyWith({
    AudioSource? source,
    String? deviceId,
    bool? floatOutput,
    int? bufferMs,
    int? preRollMs,
    int? readChunkMs,
    int? queueMs,
    bool? lowLatency,
  }) =>
      AudioSettings.fromJson({
        ...toJson(),
        'source': (source ?? this.source).index,
        'deviceId': deviceId ?? this.deviceId,
        'floatOutput': floatOutput ?? this.floatOutput,
        'bufferMs': bufferMs ?? this.bufferMs,
        'preRollMs': preRollMs ?? this.preRollMs,
        'readChunkMs': readChunkMs ?? this.readChunkMs,
        'queueMs': queueMs ?? this.queueMs,
        'lowLatency': lowLatency ?? this.lowLatency,
      });

  AudioSettings preset(String id) => copyWith(
        bufferMs: id == 'low'
            ? 20
            : id == 'stable'
                ? 100
                : 40,
        preRollMs: id == 'low'
            ? 10
            : id == 'stable'
                ? 40
                : 10,
        readChunkMs: id == 'low' ? 2 : (id == 'stable' ? 10 : 5),
        queueMs: id == 'low'
            ? 20
            : id == 'stable'
                ? 160
                : 60,
        lowLatency: true,
      );

  Map<String, dynamic> toJson() => {
        'source': source.index,
        'deviceId': deviceId,
        'floatOutput': floatOutput,
        'bufferMs': bufferMs,
        'preRollMs': preRollMs,
        'readChunkMs': readChunkMs,
        'queueMs': queueMs,
        'lowLatency': lowLatency,
      };

  @override
  bool operator ==(Object other) =>
      other is AudioSettings &&
      source == other.source &&
      deviceId == other.deviceId &&
      floatOutput == other.floatOutput &&
      bufferMs == other.bufferMs &&
      preRollMs == other.preRollMs &&
      readChunkMs == other.readChunkMs &&
      queueMs == other.queueMs &&
      lowLatency == other.lowLatency;

  @override
  int get hashCode => Object.hash(source, deviceId, floatOutput, bufferMs,
      preRollMs, readChunkMs, queueMs, lowLatency);
}

class AudioInputDevice {
  const AudioInputDevice(this.id, this.name, {this.isDefault = false});
  final String id;
  final String name;
  final bool isDefault;
}
