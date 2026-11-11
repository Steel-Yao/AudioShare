class CaptureSnapshot {
  const CaptureSnapshot({
    this.sampleRate = 0,
    this.channels = 2,
    this.bits = 16,
    this.inputChannels = 0,
    this.inputBits = 0,
    this.capturedFrames = 0,
    this.sentFrames = 0,
    this.sentBytes = 0,
    this.droppedFrames = 0,
    this.discontinuities = 0,
    this.queuedFrames = 0,
    this.capacityFrames = 0,
    this.peakLeft = 0,
    this.peakRight = 0,
    this.rmsLeft = 0,
    this.rmsRight = 0,
    this.captureIntervalMs = 0,
    this.sendTimeMs = 0,
    this.running = false,
  });

  final int sampleRate, channels, bits, inputChannels, inputBits;
  final int capturedFrames, sentFrames, sentBytes;
  final int droppedFrames, discontinuities, queuedFrames, capacityFrames;
  final double peakLeft, peakRight, rmsLeft, rmsRight;
  final double captureIntervalMs, sendTimeMs;
  final bool running;

  double get queueMs => sampleRate == 0 ? 0 : queuedFrames * 1000 / sampleRate;
}

class PlaybackSnapshot {
  const PlaybackSnapshot({
    required this.sampleRate,
    required this.bits,
    required this.queuedFrames,
    required this.bufferFrames,
    required this.capacityFrames,
    required this.underruns,
    required this.performanceMode,
    required this.route,
    required this.receivedAt,
  });

  final int sampleRate, bits, queuedFrames, bufferFrames, capacityFrames;
  final int underruns, performanceMode;
  final String route;
  final DateTime receivedAt;

  static PlaybackSnapshot? parse(Map<String, dynamic> json) {
    int? number(String name) =>
        json[name] is num && (json[name] as num).isFinite
            ? (json[name] as num).toInt()
            : null;
    final rate = number('sampleRate');
    final bits = number('bits');
    final queued = number('queuedFrames');
    final buffer = number('bufferFrames');
    final capacity = number('capacityFrames');
    if (json['version'] != 1 ||
        rate == null ||
        rate < 8000 ||
        rate > 192000 ||
        (bits != 16 && bits != 32) ||
        queued == null ||
        queued < 0 ||
        buffer == null ||
        buffer <= 0 ||
        capacity == null ||
        capacity < buffer) {
      return null;
    }
    return PlaybackSnapshot(
      sampleRate: rate,
      bits: bits!,
      queuedFrames: queued,
      bufferFrames: buffer,
      capacityFrames: capacity,
      underruns: number('underruns') ?? -1,
      performanceMode: number('performanceMode') ?? -1,
      route: json['route'] is String ? json['route'] as String : '',
      receivedAt: DateTime.now(),
    );
  }

  double get queueMs => queuedFrames * 1000 / sampleRate;
  double get bufferMs => bufferFrames * 1000 / sampleRate;
  bool get isFresh => DateTime.now().difference(receivedAt).inSeconds < 3;
}

class AudioHistorySample {
  const AudioHistorySample({
    required this.elapsedSeconds,
    required this.kilobitsPerSecond,
    required this.capture,
    this.playback,
  });
  final double elapsedSeconds;
  final double kilobitsPerSecond;
  final CaptureSnapshot capture;
  final PlaybackSnapshot? playback;
}
