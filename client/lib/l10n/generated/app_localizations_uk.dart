// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appTitle => 'AudioShare';

  @override
  String get ok => 'Гаразд';

  @override
  String get openSystemSettings => 'Відкрити системні параметри';

  @override
  String get noDevices => 'Пристроїв не знайдено';

  @override
  String get connect => 'Підключити';

  @override
  String get connecting => 'Підключення';

  @override
  String get disconnect => 'Відключити';

  @override
  String get autoConnectLastDevice =>
      'Автоматично підключатися до останнього використаного пристрою';

  @override
  String get language => 'Мова';

  @override
  String get followSystem => 'Як у системі';

  @override
  String get noLanguageMatch => 'Відповідної мови не знайдено';

  @override
  String deviceAndroidVersion(String version, String apiLevel) {
    return 'Android $version (API $apiLevel)';
  }

  @override
  String deviceNetworkAddress(String ip, String port) {
    return ' - $ip:$port';
  }

  @override
  String get recordingPermissionTitle => 'Потрібен дозвіл на запис';

  @override
  String get recordingPermissionDescription =>
      'У «Системних параметрах» відкрийте «Конфіденційність і безпека» > «Запис екрана та системного звуку» і дозвольте AudioShare. Щоб новий дозвіл набув чинності, macOS потребує перезапуску застосунку: закрийте AudioShare, відкрийте його знову та повторіть підключення.';

  @override
  String get connectionFailedTitle => 'Не вдалося підключитися';

  @override
  String get captureInitializationFailed =>
      'Не вдалося ініціалізувати захоплення системного звуку.';

  @override
  String get captureStopped => 'Захоплення системного звуку зупинено.';

  @override
  String get captureStartFailed =>
      'Не вдалося почати захоплення системного звуку.';

  @override
  String get listenerStartFailed =>
      'Не вдалося запустити локальну службу трансляції звуку.';

  @override
  String get noAvailablePort =>
      'Немає доступних локальних портів прослуховування.';

  @override
  String get connectAndroidDeviceFailed =>
      'Під час підключення до пристрою Android сталася помилка.';

  @override
  String get connectDeviceFailed =>
      'Під час підключення до пристрою сталася помилка.';

  @override
  String nativeErrorDetails(String code) {
    return 'Код помилки: $code';
  }

  @override
  String get nativeError1000 => 'Не вдалося ініціалізувати захоплення звуку.';

  @override
  String get nativeError1001 =>
      'Ця версія macOS не підтримує захоплення системного звуку.';

  @override
  String get nativeError1002 =>
      'Дозвіл на запис екрана та системного звуку недоступний.';

  @override
  String get nativeError1100 =>
      'Не вдалося запустити локальний прослуховувач звуку.';

  @override
  String get nativeError1101 =>
      'Не вдалося створити локальний сокет прослуховування.';

  @override
  String get nativeError1102 =>
      'Не вдалося прив\'язати локальний сокет прослуховування.';

  @override
  String get nativeError1103 =>
      'Локальний сокет прослуховування не зміг почати прослуховування.';

  @override
  String get nativeError1104 =>
      'Не вдалося створити потік локального прослуховування.';

  @override
  String get nativeError1105 =>
      'Час очікування запуску локального прослуховувача вичерпано.';

  @override
  String get nativeError1106 =>
      'Не вдалося прийняти підключення від пристрою Android.';

  @override
  String get nativeError1107 =>
      'Не вдалося прочитати код підключення пристрою Android.';

  @override
  String get nativeError1200 =>
      'Не вдалося почати захоплення системного звуку.';

  @override
  String get nativeError1201 =>
      'Не вдалося отримати вміст спільного доступу до екрана.';

  @override
  String get nativeError1202 =>
      'Немає доступних дисплеїв для захоплення системного звуку.';

  @override
  String get nativeError1203 =>
      'Не вдалося налаштувати аудіовивід ScreenCaptureKit.';

  @override
  String get nativeError1204 =>
      'Не вдалося запустити захоплення звуку ScreenCaptureKit.';

  @override
  String get nativeError1205 =>
      'Захоплення звуку ScreenCaptureKit несподівано зупинилося.';

  @override
  String get nativeError1206 =>
      'Час очікування запуску захоплення звуку ScreenCaptureKit вичерпано.';

  @override
  String get nativeErrorUnknown =>
      'Сталася невідома помилка захоплення системного звуку.';

  @override
  String exceptionDetails(String message) {
    return 'Діагностика: $message';
  }

  @override
  String get winMinimize => 'Згорнути';

  @override
  String get winClose => 'Закрити';

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
