// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Romanian Moldavian Moldovan (`ro`).
class AppLocalizationsRo extends AppLocalizations {
  AppLocalizationsRo([String locale = 'ro']) : super(locale);

  @override
  String get appTitle => 'AudioShare';

  @override
  String get ok => 'OK';

  @override
  String get openSystemSettings => 'Deschide setările sistemului';

  @override
  String get noDevices => 'Nu s-a găsit niciun dispozitiv';

  @override
  String get connect => 'Conectare';

  @override
  String get connecting => 'Se conectează';

  @override
  String get disconnect => 'Deconectare';

  @override
  String get autoConnectLastDevice =>
      'Conectare automată la ultimul dispozitiv folosit';

  @override
  String get language => 'Limbă';

  @override
  String get followSystem => 'Ca în sistem';

  @override
  String get noLanguageMatch => 'Nicio limbă corespunzătoare nu a fost găsită';

  @override
  String deviceAndroidVersion(String version, String apiLevel) {
    return 'Android $version (API $apiLevel)';
  }

  @override
  String deviceNetworkAddress(String ip, String port) {
    return ' - $ip:$port';
  }

  @override
  String get recordingPermissionTitle =>
      'Este necesară permisiunea de înregistrare';

  @override
  String get recordingPermissionDescription =>
      'În Setările sistemului, mergeți la Confidențialitate și securitate > Înregistrarea ecranului și a sunetului sistemului și permiteți AudioShare. macOS necesită repornirea aplicației pentru ca noua permisiune să intre în vigoare; ieșiți din AudioShare, deschideți-l din nou și apoi reconectați-vă.';

  @override
  String get connectionFailedTitle => 'Conectare nereușită';

  @override
  String get captureInitializationFailed =>
      'Capturarea sunetului sistemului nu a putut fi inițializată.';

  @override
  String get captureStopped => 'Capturarea sunetului sistemului s-a oprit.';

  @override
  String get captureStartFailed =>
      'Capturarea sunetului sistemului nu a putut fi pornită.';

  @override
  String get listenerStartFailed =>
      'Serviciul local de streaming audio nu a putut fi pornit.';

  @override
  String get noAvailablePort =>
      'Nu există niciun port de ascultare local disponibil.';

  @override
  String get connectAndroidDeviceFailed =>
      'A apărut o eroare la conectarea la dispozitivul Android.';

  @override
  String get connectDeviceFailed =>
      'A apărut o eroare la conectarea la dispozitiv.';

  @override
  String nativeErrorDetails(String code) {
    return 'Cod de eroare: $code';
  }

  @override
  String get nativeError1000 => 'Inițializarea capturii audio a eșuat.';

  @override
  String get nativeError1001 =>
      'Această versiune de macOS nu acceptă capturarea sunetului sistemului.';

  @override
  String get nativeError1002 =>
      'Permisiunea de înregistrare a ecranului și a sunetului sistemului nu este disponibilă.';

  @override
  String get nativeError1100 =>
      'Ascultătorul local de audio nu a putut fi pornit.';

  @override
  String get nativeError1101 =>
      'Socketul local de ascultare nu a putut fi creat.';

  @override
  String get nativeError1102 =>
      'Socketul local de ascultare nu a putut fi asociat.';

  @override
  String get nativeError1103 =>
      'Socketul local de ascultare nu a putut începe să asculte.';

  @override
  String get nativeError1104 =>
      'Fireul local de ascultare nu a putut fi creat.';

  @override
  String get nativeError1105 => 'Pornirea ascultătorului local a expirat.';

  @override
  String get nativeError1106 =>
      'Conexiunea de la dispozitivul Android nu a putut fi acceptată.';

  @override
  String get nativeError1107 =>
      'Codul de conexiune al dispozitivului Android nu a putut fi citit.';

  @override
  String get nativeError1200 =>
      'Capturarea sunetului sistemului nu a putut fi pornită.';

  @override
  String get nativeError1201 =>
      'Conținutul partajării ecranului nu a putut fi obținut.';

  @override
  String get nativeError1202 =>
      'Nu există niciun afișaj disponibil pentru capturarea sunetului sistemului.';

  @override
  String get nativeError1203 =>
      'Ieșirea audio ScreenCaptureKit nu a putut fi configurată.';

  @override
  String get nativeError1204 =>
      'Captura audio ScreenCaptureKit nu a putut fi pornită.';

  @override
  String get nativeError1205 =>
      'Captura audio ScreenCaptureKit s-a oprit neașteptat.';

  @override
  String get nativeError1206 =>
      'Pornirea capturii audio ScreenCaptureKit a expirat.';

  @override
  String get nativeErrorUnknown =>
      'A apărut o eroare necunoscută la capturarea sunetului sistemului.';

  @override
  String exceptionDetails(String message) {
    return 'Diagnostic: $message';
  }

  @override
  String get winMinimize => 'Minimizare';

  @override
  String get winClose => 'Închidere';

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
