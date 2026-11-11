// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'AudioShare';

  @override
  String get ok => 'Tamam';

  @override
  String get openSystemSettings => 'Sistem Ayarları\'nı Aç';

  @override
  String get noDevices => 'Cihaz bulunamadı';

  @override
  String get connect => 'Bağlan';

  @override
  String get connecting => 'Bağlanıyor';

  @override
  String get disconnect => 'Bağlantıyı Kes';

  @override
  String get autoConnectLastDevice =>
      'En son kullanılan cihaza otomatik olarak bağlan';

  @override
  String get language => 'Dil';

  @override
  String get followSystem => 'Sistemi izle';

  @override
  String get noLanguageMatch => 'Eşleşen dil yok';

  @override
  String deviceAndroidVersion(String version, String apiLevel) {
    return 'Android $version (API $apiLevel)';
  }

  @override
  String deviceNetworkAddress(String ip, String port) {
    return ' - $ip:$port';
  }

  @override
  String get recordingPermissionTitle => 'Kayıt izni gerekli';

  @override
  String get recordingPermissionDescription =>
      'Sistem Ayarları\'nda Gizlilik ve Güvenlik > Ekran ve Sistem Sesi Kaydı yolunu izleyin ve AudioShare\'e izin verin. Yeni izin etkin olabilmesi için macOS uygulamanın yeniden başlatılmasını gerektirir; AudioShare\'den çıkıp yeniden açın, ardından yeniden bağlanın.';

  @override
  String get connectionFailedTitle => 'Bağlantı başarısız oldu';

  @override
  String get captureInitializationFailed =>
      'Sistem sesi yakalama başlatılamadı.';

  @override
  String get captureStopped => 'Sistem sesi yakalama durdu.';

  @override
  String get captureStartFailed => 'Sistem sesi yakalama başlatılamadı.';

  @override
  String get listenerStartFailed => 'Yerel ses akışı hizmeti başlatılamadı.';

  @override
  String get noAvailablePort =>
      'Kullanılabilir yerel dinleme bağlantı noktası yok.';

  @override
  String get connectAndroidDeviceFailed =>
      'Android cihazına bağlanırken bir hata oluştu.';

  @override
  String get connectDeviceFailed => 'Cihaza bağlanırken bir hata oluştu.';

  @override
  String nativeErrorDetails(String code) {
    return 'Hata kodu: $code';
  }

  @override
  String get nativeError1000 => 'Ses yakalama başlatılamadı.';

  @override
  String get nativeError1001 =>
      'Bu macOS sürümü sistem sesi yakalamayı desteklemiyor.';

  @override
  String get nativeError1002 =>
      'Ekran ve sistem sesi kaydı izni kullanılamıyor.';

  @override
  String get nativeError1100 => 'Yerel ses dinleyici başlatılamadı.';

  @override
  String get nativeError1101 => 'Yerel dinleme yuvası oluşturulamadı.';

  @override
  String get nativeError1102 => 'Yerel dinleme yuvası bağlanamadı.';

  @override
  String get nativeError1103 => 'Yerel dinleme yuvası dinlemeye başlayamadı.';

  @override
  String get nativeError1104 => 'Yerel dinleyici iş parçacığı oluşturulamadı.';

  @override
  String get nativeError1105 =>
      'Yerel dinleyici başlatılırken zaman aşımına uğradı.';

  @override
  String get nativeError1106 => 'Android cihazının bağlantısı kabul edilemedi.';

  @override
  String get nativeError1107 => 'Android cihazının bağlantı kodu okunamadı.';

  @override
  String get nativeError1200 => 'Sistem sesi yakalama başlatılamadı.';

  @override
  String get nativeError1201 => 'Ekran paylaşımı içeriği alınamadı.';

  @override
  String get nativeError1202 =>
      'Sistem sesi yakalama için kullanılabilir ekran yok.';

  @override
  String get nativeError1203 =>
      'ScreenCaptureKit ses çıkışı yapılandırılamadı.';

  @override
  String get nativeError1204 => 'ScreenCaptureKit ses yakalama başlatılamadı.';

  @override
  String get nativeError1205 =>
      'ScreenCaptureKit ses yakalama beklenmedik şekilde durdu.';

  @override
  String get nativeError1206 =>
      'ScreenCaptureKit ses yakalama başlatılırken zaman aşımına uğradı.';

  @override
  String get nativeErrorUnknown =>
      'Bilinmeyen bir sistem sesi yakalama hatası oluştu.';

  @override
  String exceptionDetails(String message) {
    return 'Tanılama: $message';
  }

  @override
  String get winMinimize => 'Simge durumuna küçült';

  @override
  String get winClose => 'Kapat';

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
