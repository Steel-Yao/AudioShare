// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'AudioShare';

  @override
  String get ok => 'ОК';

  @override
  String get openSystemSettings => 'Открыть системные настройки';

  @override
  String get noDevices => 'Устройства не найдены';

  @override
  String get connect => 'Подключить';

  @override
  String get connecting => 'Подключение';

  @override
  String get disconnect => 'Отключить';

  @override
  String get autoConnectLastDevice =>
      'Автоматически подключаться к последнему использованному устройству';

  @override
  String get language => 'Язык';

  @override
  String get followSystem => 'Как в системе';

  @override
  String get noLanguageMatch => 'Нет подходящего языка';

  @override
  String deviceAndroidVersion(String version, String apiLevel) {
    return 'Android $version (API $apiLevel)';
  }

  @override
  String deviceNetworkAddress(String ip, String port) {
    return ' - $ip:$port';
  }

  @override
  String get recordingPermissionTitle => 'Требуется разрешение на запись';

  @override
  String get recordingPermissionDescription =>
      'В «Системных настройках» откройте «Конфиденциальность и безопасность» > «Запись экрана и системного звука» и разрешите AudioShare. Для применения нового разрешения macOS требует перезапуска приложения: закройте AudioShare, откройте его снова и повторите подключение.';

  @override
  String get connectionFailedTitle => 'Не удалось подключиться';

  @override
  String get captureInitializationFailed =>
      'Не удалось инициализировать захват системного звука.';

  @override
  String get captureStopped => 'Захват системного звука остановлен.';

  @override
  String get captureStartFailed => 'Не удалось начать захват системного звука.';

  @override
  String get listenerStartFailed =>
      'Не удалось запустить локальную службу потоковой передачи звука.';

  @override
  String get noAvailablePort => 'Нет доступных локальных портов прослушивания.';

  @override
  String get connectAndroidDeviceFailed =>
      'Произошла ошибка при подключении к устройству Android.';

  @override
  String get connectDeviceFailed =>
      'Произошла ошибка при подключении к устройству.';

  @override
  String nativeErrorDetails(String code) {
    return 'Код ошибки: $code';
  }

  @override
  String get nativeError1000 => 'Не удалось инициализировать захват звука.';

  @override
  String get nativeError1001 =>
      'Эта версия macOS не поддерживает захват системного звука.';

  @override
  String get nativeError1002 =>
      'Недоступно разрешение на запись экрана и системного звука.';

  @override
  String get nativeError1100 =>
      'Не удалось запустить локальный прослушиватель звука.';

  @override
  String get nativeError1101 =>
      'Не удалось создать локальный сокет прослушивания.';

  @override
  String get nativeError1102 =>
      'Не удалось привязать локальный сокет прослушивания.';

  @override
  String get nativeError1103 =>
      'Локальный сокет прослушивания не смог начать прослушивание.';

  @override
  String get nativeError1104 =>
      'Не удалось создать поток локального прослушивания.';

  @override
  String get nativeError1105 =>
      'Истекло время ожидания запуска локального прослушивателя.';

  @override
  String get nativeError1106 =>
      'Не удалось принять подключение от устройства Android.';

  @override
  String get nativeError1107 =>
      'Не удалось прочитать код подключения устройства Android.';

  @override
  String get nativeError1200 => 'Не удалось начать захват системного звука.';

  @override
  String get nativeError1201 =>
      'Не удалось получить содержимое общего доступа к экрану.';

  @override
  String get nativeError1202 =>
      'Нет доступных дисплеев для захвата системного звука.';

  @override
  String get nativeError1203 =>
      'Не удалось настроить аудиовыход ScreenCaptureKit.';

  @override
  String get nativeError1204 =>
      'Не удалось запустить захват звука ScreenCaptureKit.';

  @override
  String get nativeError1205 =>
      'Захват звука ScreenCaptureKit неожиданно остановился.';

  @override
  String get nativeError1206 =>
      'Истекло время ожидания запуска захвата звука ScreenCaptureKit.';

  @override
  String get nativeErrorUnknown =>
      'Произошла неизвестная ошибка захвата системного звука.';

  @override
  String exceptionDetails(String message) {
    return 'Диагностика: $message';
  }

  @override
  String get winMinimize => 'Свернуть';

  @override
  String get winClose => 'Закрыть';

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
