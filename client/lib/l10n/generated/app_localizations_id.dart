// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'AudioShare';

  @override
  String get ok => 'OK';

  @override
  String get openSystemSettings => 'Buka Pengaturan Sistem';

  @override
  String get noDevices => 'Tidak ada perangkat ditemukan';

  @override
  String get connect => 'Hubungkan';

  @override
  String get connecting => 'Menghubungkan';

  @override
  String get disconnect => 'Putuskan';

  @override
  String get autoConnectLastDevice =>
      'Hubungkan otomatis ke perangkat terakhir yang digunakan';

  @override
  String get language => 'Bahasa';

  @override
  String get followSystem => 'Ikuti sistem';

  @override
  String get noLanguageMatch => 'Tidak ada bahasa yang cocok';

  @override
  String deviceAndroidVersion(String version, String apiLevel) {
    return 'Android $version (API $apiLevel)';
  }

  @override
  String deviceNetworkAddress(String ip, String port) {
    return ' - $ip:$port';
  }

  @override
  String get recordingPermissionTitle => 'Izin perekaman diperlukan';

  @override
  String get recordingPermissionDescription =>
      'Di Pengaturan Sistem, buka Privasi & Keamanan > Perekaman Layar & Audio Sistem dan izinkan AudioShare. macOS memerlukan aplikasi dimulai ulang agar izin baru berlaku; keluarlah dari AudioShare, buka kembali, lalu hubungkan lagi.';

  @override
  String get connectionFailedTitle => 'Koneksi gagal';

  @override
  String get captureInitializationFailed =>
      'Tidak dapat menginisialisasi perekaman audio sistem.';

  @override
  String get captureStopped => 'Perekaman audio sistem berhenti.';

  @override
  String get captureStartFailed =>
      'Tidak dapat memulai perekaman audio sistem.';

  @override
  String get listenerStartFailed =>
      'Tidak dapat memulai layanan streaming audio lokal.';

  @override
  String get noAvailablePort => 'Tidak ada porta listener lokal yang tersedia.';

  @override
  String get connectAndroidDeviceFailed =>
      'Terjadi kesalahan saat menghubungkan ke perangkat Android.';

  @override
  String get connectDeviceFailed =>
      'Terjadi kesalahan saat menghubungkan ke perangkat.';

  @override
  String nativeErrorDetails(String code) {
    return 'Kode kesalahan: $code';
  }

  @override
  String get nativeError1000 => 'Gagal menginisialisasi perekaman audio.';

  @override
  String get nativeError1001 =>
      'Versi macOS ini tidak mendukung perekaman audio sistem.';

  @override
  String get nativeError1002 =>
      'Izin perekaman layar dan audio sistem tidak tersedia.';

  @override
  String get nativeError1100 => 'Tidak dapat memulai listener audio lokal.';

  @override
  String get nativeError1101 => 'Tidak dapat membuat socket listener lokal.';

  @override
  String get nativeError1102 => 'Tidak dapat mengikat socket listener lokal.';

  @override
  String get nativeError1103 =>
      'Socket listener lokal tidak dapat mulai mendengarkan.';

  @override
  String get nativeError1104 => 'Tidak dapat membuat thread listener lokal.';

  @override
  String get nativeError1105 =>
      'Waktu tunggu untuk memulai listener lokal habis.';

  @override
  String get nativeError1106 =>
      'Tidak dapat menerima koneksi dari perangkat Android.';

  @override
  String get nativeError1107 =>
      'Tidak dapat membaca kode koneksi perangkat Android.';

  @override
  String get nativeError1200 => 'Tidak dapat memulai perekaman audio sistem.';

  @override
  String get nativeError1201 => 'Tidak dapat mengambil konten berbagi layar.';

  @override
  String get nativeError1202 =>
      'Tidak ada layar yang tersedia untuk perekaman audio sistem.';

  @override
  String get nativeError1203 =>
      'Tidak dapat mengonfigurasi output audio ScreenCaptureKit.';

  @override
  String get nativeError1204 =>
      'Tidak dapat memulai perekaman audio ScreenCaptureKit.';

  @override
  String get nativeError1205 =>
      'Perekaman audio ScreenCaptureKit berhenti secara tidak terduga.';

  @override
  String get nativeError1206 =>
      'Waktu tunggu untuk memulai perekaman audio ScreenCaptureKit habis.';

  @override
  String get nativeErrorUnknown =>
      'Terjadi kesalahan perekaman audio sistem yang tidak dikenal.';

  @override
  String exceptionDetails(String message) {
    return 'Diagnosis: $message';
  }

  @override
  String get winMinimize => 'Perkecil';

  @override
  String get winClose => 'Tutup';

  @override
  String get devicesTab => 'Devices';

  @override
  String get audioSettingsTab => 'Audio';

  @override
  String get monitorTab => 'Monitor';

  @override
  String get audioSource => 'Audio source';

  @override
  String get systemOutput => 'System output';

  @override
  String get recordingInput => 'Recording input';

  @override
  String get inputDevice => 'Capture device';

  @override
  String get defaultDevice => 'Follow system default';

  @override
  String get unavailableDevice => 'Saved device unavailable';

  @override
  String get refreshDevices => 'Refresh devices';

  @override
  String get audioFormat => 'Stream format';

  @override
  String get pcm16Format => 'PCM 16-bit';

  @override
  String get float32Format => 'Float 32-bit';

  @override
  String get latencyProfile => 'Buffer profile';

  @override
  String get lowLatencyProfile => 'Low latency';

  @override
  String get balancedProfile => 'Balanced';

  @override
  String get stableProfile => 'Stable';

  @override
  String get customProfile => 'Custom';

  @override
  String get playbackBuffer => 'Playback buffer target';

  @override
  String get preRoll => 'Startup prefill';

  @override
  String get captureQueue => 'Capture queue limit';

  @override
  String get receiveChunk => 'Receive block';

  @override
  String get requestLowLatency => 'Request low latency output';

  @override
  String get settingsLocked => 'Disconnect to change audio settings';

  @override
  String get settingsSaved => 'Settings apply on the next connection';

  @override
  String get resetSettings => 'Reset audio settings';

  @override
  String get activeFormat => 'Active format';

  @override
  String get waitingForAudio => 'Waiting for audio';

  @override
  String get monitoringOffline => 'Connect a device to start monitoring';

  @override
  String get feedbackStale => 'Playback feedback unavailable';

  @override
  String get channelLevels => 'Channel levels';

  @override
  String get channelLeft => 'Left';

  @override
  String get channelRight => 'Right';

  @override
  String get transferRate => 'Transfer rate';

  @override
  String get queueHistory => 'Queued audio';

  @override
  String get captureQueueShort => 'Capture';

  @override
  String get playbackQueueShort => 'Playback estimate';

  @override
  String get captureTiming => 'Capture interval';

  @override
  String get sendTiming => 'Send time';

  @override
  String get underruns => 'Playback underruns';

  @override
  String get droppedFrames => 'Dropped frames';

  @override
  String get discontinuities => 'Capture interruptions';

  @override
  String get effectiveBuffer => 'Effective playback buffer';

  @override
  String get playbackRoute => 'Playback route';

  @override
  String get performanceMode => 'Output mode';

  @override
  String get modeLowLatency => 'Low latency';

  @override
  String get modeStandard => 'Standard';

  @override
  String get unknownValue => 'Unavailable';

  @override
  String get clearHistory => 'Clear chart history';

  @override
  String get pauseCharts => 'Pause charts';

  @override
  String get resumeCharts => 'Resume charts';

  @override
  String get recentHistory => 'Recent 60 seconds';

  @override
  String get connectedStatus => 'Streaming';

  @override
  String get disconnectedStatus => 'Disconnected';

  @override
  String get connectionCancelled => 'Cancel connection';

  @override
  String get queueEstimateNote =>
      'Queue estimates exclude ADB, system output, and acoustic latency.';

  @override
  String get floatFormatNote =>
      'Uncompressed stereo; system mixing and playback can still change samples.';

  @override
  String get queueDropNote =>
      'When the capture queue fills, old audio is dropped to keep playback current.';

  @override
  String get macSystemOnly => 'System audio capture';

  @override
  String get timeAxis => 'Time (s)';

  @override
  String get msUnit => 'ms';

  @override
  String get winMaximize => 'Maximize';

  @override
  String get winRestore => 'Restore';

  @override
  String get heldCharts => 'Charts paused';

  @override
  String get sourceFormat => 'Capture format';

  @override
  String get noSampleData => 'No samples yet';
}
