// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'AudioShare';

  @override
  String get ok => 'OK';

  @override
  String get openSystemSettings => 'Systemeinstellungen öffnen';

  @override
  String get noDevices => 'Keine Geräte gefunden';

  @override
  String get connect => 'Verbinden';

  @override
  String get connecting => 'Verbinden';

  @override
  String get disconnect => 'Trennen';

  @override
  String get autoConnectLastDevice =>
      'Automatisch mit dem zuletzt verwendeten Gerät verbinden';

  @override
  String get language => 'Sprache';

  @override
  String get followSystem => 'Systemeinstellungen folgen';

  @override
  String get noLanguageMatch => 'Keine passende Sprache';

  @override
  String deviceAndroidVersion(String version, String apiLevel) {
    return 'Android $version (API $apiLevel)';
  }

  @override
  String deviceNetworkAddress(String ip, String port) {
    return ' - $ip:$port';
  }

  @override
  String get recordingPermissionTitle => 'Aufnahmeberechtigung erforderlich';

  @override
  String get recordingPermissionDescription =>
      'Öffne in den Systemeinstellungen Datenschutz & Sicherheit > Bildschirm- und Systemaudioaufnahme und erlaube AudioShare. macOS verlangt einen Neustart der App, damit die neue Berechtigung wirksam wird. Beende AudioShare, öffne es erneut und stelle anschließend die Verbindung noch einmal her.';

  @override
  String get connectionFailedTitle => 'Verbindung fehlgeschlagen';

  @override
  String get captureInitializationFailed =>
      'Die Systemaudioaufnahme konnte nicht initialisiert werden.';

  @override
  String get captureStopped => 'Die Systemaudioaufnahme wurde beendet.';

  @override
  String get captureStartFailed =>
      'Die Systemaudioaufnahme konnte nicht gestartet werden.';

  @override
  String get listenerStartFailed =>
      'Der lokale Audio-Streamingdienst konnte nicht gestartet werden.';

  @override
  String get noAvailablePort => 'Es ist kein lokaler Listening-Port verfügbar.';

  @override
  String get connectAndroidDeviceFailed =>
      'Beim Verbinden mit dem Android-Gerät ist ein Fehler aufgetreten.';

  @override
  String get connectDeviceFailed =>
      'Beim Verbinden mit dem Gerät ist ein Fehler aufgetreten.';

  @override
  String nativeErrorDetails(String code) {
    return 'Fehlercode: $code';
  }

  @override
  String get nativeError1000 =>
      'Audioaufnahme konnte nicht initialisiert werden.';

  @override
  String get nativeError1001 =>
      'Diese macOS-Version unterstützt keine Systemaudioaufnahme.';

  @override
  String get nativeError1002 =>
      'Die Berechtigung für Bildschirm- und Systemaudioaufnahme ist nicht verfügbar.';

  @override
  String get nativeError1100 =>
      'Der lokale Audio-Listener konnte nicht gestartet werden.';

  @override
  String get nativeError1101 =>
      'Der lokale Listening-Socket konnte nicht erstellt werden.';

  @override
  String get nativeError1102 =>
      'Der lokale Listening-Socket konnte nicht gebunden werden.';

  @override
  String get nativeError1103 =>
      'Der lokale Listening-Socket konnte nicht mit dem Lauschen beginnen.';

  @override
  String get nativeError1104 =>
      'Der lokale Listener-Thread konnte nicht erstellt werden.';

  @override
  String get nativeError1105 =>
      'Zeitüberschreitung beim Starten des lokalen Listeners.';

  @override
  String get nativeError1106 =>
      'Die Verbindung des Android-Geräts konnte nicht angenommen werden.';

  @override
  String get nativeError1107 =>
      'Der Verbindungscode des Android-Geräts konnte nicht gelesen werden.';

  @override
  String get nativeError1200 =>
      'Die Systemaudioaufnahme konnte nicht gestartet werden.';

  @override
  String get nativeError1201 =>
      'Der Inhalt der Bildschirmfreigabe konnte nicht abgerufen werden.';

  @override
  String get nativeError1202 =>
      'Es ist kein Display für die Systemaudioaufnahme verfügbar.';

  @override
  String get nativeError1203 =>
      'Die ScreenCaptureKit-Audioausgabe konnte nicht konfiguriert werden.';

  @override
  String get nativeError1204 =>
      'Die ScreenCaptureKit-Audioaufnahme konnte nicht gestartet werden.';

  @override
  String get nativeError1205 =>
      'Die ScreenCaptureKit-Audioaufnahme wurde unerwartet beendet.';

  @override
  String get nativeError1206 =>
      'Zeitüberschreitung beim Starten der ScreenCaptureKit-Audioaufnahme.';

  @override
  String get nativeErrorUnknown =>
      'Ein unbekannter Fehler bei der Systemaudioaufnahme ist aufgetreten.';

  @override
  String exceptionDetails(String message) {
    return 'Diagnose: $message';
  }

  @override
  String get winMinimize => 'Minimieren';

  @override
  String get winClose => 'Schließen';

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
