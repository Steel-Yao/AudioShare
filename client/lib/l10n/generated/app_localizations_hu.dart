// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hungarian (`hu`).
class AppLocalizationsHu extends AppLocalizations {
  AppLocalizationsHu([String locale = 'hu']) : super(locale);

  @override
  String get appTitle => 'AudioShare';

  @override
  String get ok => 'OK';

  @override
  String get openSystemSettings => 'Rendszerbeállítások megnyitása';

  @override
  String get noDevices => 'Nem található eszköz';

  @override
  String get connect => 'Csatlakozás';

  @override
  String get connecting => 'Csatlakozás';

  @override
  String get disconnect => 'Leválasztás';

  @override
  String get autoConnectLastDevice =>
      'Automatikus csatlakozás az utoljára használt eszközhöz';

  @override
  String get language => 'Nyelv';

  @override
  String get followSystem => 'Rendszer szerint';

  @override
  String get noLanguageMatch => 'Nincs találat';

  @override
  String deviceAndroidVersion(String version, String apiLevel) {
    return 'Android $version (API $apiLevel)';
  }

  @override
  String deviceNetworkAddress(String ip, String port) {
    return ' - $ip:$port';
  }

  @override
  String get recordingPermissionTitle => 'Rögzítési engedély szükséges';

  @override
  String get recordingPermissionDescription =>
      'A Rendszerbeállításokban lépjen az Adatvédelem és biztonság > Képernyőrögzítés és rendszerhang rögzítése pontba, és engedélyezze az AudioShare alkalmazást. A macOS az új engedély érvénybelépéséhez újraindítja az alkalmazást: zárja be az AudioShare-t, nyissa meg újra, majd csatlakozzon ismét.';

  @override
  String get connectionFailedTitle => 'A csatlakozás nem sikerült';

  @override
  String get captureInitializationFailed =>
      'A rendszerhang rögzítése nem inicializálható.';

  @override
  String get captureStopped => 'A rendszerhang rögzítése leállt.';

  @override
  String get captureStartFailed => 'A rendszerhang rögzítése nem indítható el.';

  @override
  String get listenerStartFailed =>
      'A helyi hangfolyam-szolgáltatás nem indítható el.';

  @override
  String get noAvailablePort => 'Nincs elérhető helyi figyelő port.';

  @override
  String get connectAndroidDeviceFailed =>
      'Hiba történt az Android-eszközhöz való csatlakozáskor.';

  @override
  String get connectDeviceFailed =>
      'Hiba történt az eszközhöz való csatlakozáskor.';

  @override
  String nativeErrorDetails(String code) {
    return 'Hibakód: $code';
  }

  @override
  String get nativeError1000 => 'A hangrögzítés inicializálása nem sikerült.';

  @override
  String get nativeError1001 =>
      'A macOS ezen verziója nem támogatja a rendszerhang rögzítését.';

  @override
  String get nativeError1002 =>
      'A képernyőrögzítés és rendszerhang engedélye nem érhető el.';

  @override
  String get nativeError1100 => 'A helyi hangfigyelő nem indítható el.';

  @override
  String get nativeError1101 => 'A helyi figyelő foglaló nem hozható létre.';

  @override
  String get nativeError1102 => 'A helyi figyelő foglaló nem köthető le.';

  @override
  String get nativeError1103 =>
      'A helyi figyelő foglaló nem tudott figyelni kezdeni.';

  @override
  String get nativeError1104 => 'A helyi figyelő szál nem hozható létre.';

  @override
  String get nativeError1105 =>
      'A helyi figyelő indítása időtúllépést szenvedett.';

  @override
  String get nativeError1106 =>
      'Az Android-eszköz csatlakozása nem fogadható el.';

  @override
  String get nativeError1107 =>
      'Az Android-eszköz csatlakozási kódja nem olvasható.';

  @override
  String get nativeError1200 => 'A rendszerhang rögzítése nem indítható el.';

  @override
  String get nativeError1201 => 'A képernyőmegosztás tartalma nem kérhető le.';

  @override
  String get nativeError1202 =>
      'Nincs elérhető kijelző a rendszerhang rögzítéséhez.';

  @override
  String get nativeError1203 =>
      'A ScreenCaptureKit hangkimenete nem konfigurálható.';

  @override
  String get nativeError1204 =>
      'A ScreenCaptureKit hangrögzítése nem indítható el.';

  @override
  String get nativeError1205 =>
      'A ScreenCaptureKit hangrögzítése váratlanul leállt.';

  @override
  String get nativeError1206 =>
      'A ScreenCaptureKit hangrögzítésének indítása időtúllépést szenvedett.';

  @override
  String get nativeErrorUnknown =>
      'Ismeretlen rendszerhang-rögzítési hiba történt.';

  @override
  String exceptionDetails(String message) {
    return 'Diagnosztika: $message';
  }

  @override
  String get winMinimize => 'Kis méret';

  @override
  String get winClose => 'Bezárás';

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
