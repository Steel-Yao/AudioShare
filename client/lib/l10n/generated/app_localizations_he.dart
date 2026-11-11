// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hebrew (`he`).
class AppLocalizationsHe extends AppLocalizations {
  AppLocalizationsHe([String locale = 'he']) : super(locale);

  @override
  String get appTitle => 'AudioShare';

  @override
  String get ok => 'אישור';

  @override
  String get openSystemSettings => 'פתיחת הגדרות המערכת';

  @override
  String get noDevices => 'לא נמצאו מכשירים';

  @override
  String get connect => 'התחברות';

  @override
  String get connecting => 'מתחבר';

  @override
  String get disconnect => 'ניתוק';

  @override
  String get autoConnectLastDevice => 'התחברות אוטומטית למכשיר ששימש לאחרונה';

  @override
  String get language => 'שפה';

  @override
  String get followSystem => 'בהתאם למערכת';

  @override
  String get noLanguageMatch => 'לא נמצאה שפה מתאימה';

  @override
  String deviceAndroidVersion(String version, String apiLevel) {
    return 'Android $version (API $apiLevel)';
  }

  @override
  String deviceNetworkAddress(String ip, String port) {
    return ' - $ip:$port';
  }

  @override
  String get recordingPermissionTitle => 'נדרשת הרשאת הקלטה';

  @override
  String get recordingPermissionDescription =>
      'בהגדרות המערכת עברו אל Privacy & Security > Screen & System Audio Recording ואשרו ל-AudioShare. ב-macOS נדרשת הפעלה מחדש של היישום כדי שההרשאה החדשה תיכנס לתוקף; סגרו את AudioShare, פתחו אותו מחדש ולאחר מכן התחברו שוב.';

  @override
  String get connectionFailedTitle => 'ההתחברות נכשלה';

  @override
  String get captureInitializationFailed =>
      'לא ניתן לאתחל את לכידת השמע המערכת.';

  @override
  String get captureStopped => 'לכידת השמע המערכת נעצרה.';

  @override
  String get captureStartFailed => 'לא ניתן להתחיל את לכידת השמע המערכת.';

  @override
  String get listenerStartFailed =>
      'לא ניתן להפעיל את שירות הזרימת השמע המקומי.';

  @override
  String get noAvailablePort => 'אין פורט האזנה מקומי זמין.';

  @override
  String get connectAndroidDeviceFailed =>
      'אירעה שגיאה בעת ההתחברות למכשיר Android.';

  @override
  String get connectDeviceFailed => 'אירעה שגיאה בעת ההתחברות למכשיר.';

  @override
  String nativeErrorDetails(String code) {
    return 'קוד שגיאה: $code';
  }

  @override
  String get nativeError1000 => 'אתחול לכידת השמע נכשל.';

  @override
  String get nativeError1001 => 'גרסת macOS זו אינה תומכת בלכידת שמע מערכת.';

  @override
  String get nativeError1002 => 'הרשאת הקלטת מסך ושמע מערכת אינה זמינה.';

  @override
  String get nativeError1100 => 'לא ניתן להפעיל את מאזין השמע המקומי.';

  @override
  String get nativeError1101 => 'לא ניתן ליצור את שק ההאזנה המקומי.';

  @override
  String get nativeError1102 => 'לא ניתן לקשור את שק ההאזנה המקומי.';

  @override
  String get nativeError1103 => 'שק ההאזנה המקומי לא הצליח להתחיל להאזין.';

  @override
  String get nativeError1104 => 'לא ניתן ליצור את תת ההאזנה המקומי.';

  @override
  String get nativeError1105 => 'הפעלת המאזין המקומי התמהמהה.';

  @override
  String get nativeError1106 => 'לא ניתן לקבל את החיבור ממכשיר Android.';

  @override
  String get nativeError1107 => 'לא ניתן לקרוא את קוד החיבור של מכשיר Android.';

  @override
  String get nativeError1200 => 'לא ניתן להתחיל את לכידת השמע המערכת.';

  @override
  String get nativeError1201 => 'לא ניתן לקבל את תוכן שיתוף המסך.';

  @override
  String get nativeError1202 => 'אין תצוגה זמינה ללכידת שמע מערכת.';

  @override
  String get nativeError1203 =>
      'לא ניתן להגדיר את פלט השמע של ScreenCaptureKit.';

  @override
  String get nativeError1204 =>
      'לא ניתן להתחיל את לכידת השמע של ScreenCaptureKit.';

  @override
  String get nativeError1205 =>
      'לכידת השמע של ScreenCaptureKit נעצרה באופן לא צפוי.';

  @override
  String get nativeError1206 => 'הפעלת לכידת השמע של ScreenCaptureKit התמהמהה.';

  @override
  String get nativeErrorUnknown => 'אירעה שגיאה לא ידועה בלכידת שמע המערכת.';

  @override
  String exceptionDetails(String message) {
    return 'אבחון: $message';
  }

  @override
  String get winMinimize => 'מזער';

  @override
  String get winClose => 'סגור';

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
