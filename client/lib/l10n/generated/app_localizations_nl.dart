// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appTitle => 'AudioShare';

  @override
  String get ok => 'OK';

  @override
  String get openSystemSettings => 'Systeeminstellingen openen';

  @override
  String get noDevices => 'Geen apparaten gevonden';

  @override
  String get connect => 'Verbinden';

  @override
  String get connecting => 'Verbinden';

  @override
  String get disconnect => 'Verbinding verbreken';

  @override
  String get autoConnectLastDevice =>
      'Automatisch verbinden met het laatst gebruikte apparaat';

  @override
  String get language => 'Taal';

  @override
  String get followSystem => 'Systeeminstelling volgen';

  @override
  String get noLanguageMatch => 'Geen overeenkomende taal gevonden';

  @override
  String deviceAndroidVersion(String version, String apiLevel) {
    return 'Android $version (API $apiLevel)';
  }

  @override
  String deviceNetworkAddress(String ip, String port) {
    return ' - $ip:$port';
  }

  @override
  String get recordingPermissionTitle => 'Opnametoestemming vereist';

  @override
  String get recordingPermissionDescription =>
      'Ga in Systeeminstellingen naar Privacy en beveiliging > Scherm- en systeemaudio opnemen en geef AudioShare toestemming. macOS vereist dat de app opnieuw wordt gestart voordat de nieuwe toestemming geldt: sluit AudioShare af, open het opnieuw en verbind daarna opnieuw.';

  @override
  String get connectionFailedTitle => 'Verbinding mislukt';

  @override
  String get captureInitializationFailed =>
      'De opname van systeemaudio kon niet worden geïnitialiseerd.';

  @override
  String get captureStopped => 'De opname van systeemaudio is gestopt.';

  @override
  String get captureStartFailed =>
      'De opname van systeemaudio kon niet worden gestart.';

  @override
  String get listenerStartFailed =>
      'De lokale audiostreamingservice kon niet worden gestart.';

  @override
  String get noAvailablePort => 'Er is geen lokale luisterpoort beschikbaar.';

  @override
  String get connectAndroidDeviceFailed =>
      'Er is een fout opgetreden bij het verbinden met het Android-apparaat.';

  @override
  String get connectDeviceFailed =>
      'Er is een fout opgetreden bij het verbinden met het apparaat.';

  @override
  String nativeErrorDetails(String code) {
    return 'Foutcode: $code';
  }

  @override
  String get nativeError1000 => 'Initialisatie van de audio-opname is mislukt.';

  @override
  String get nativeError1001 =>
      'Deze macOS-versie ondersteunt geen opname van systeemaudio.';

  @override
  String get nativeError1002 =>
      'Toestemming voor het opnemen van scherm en systeemaudio is niet beschikbaar.';

  @override
  String get nativeError1100 =>
      'De lokale audioluister kon niet worden gestart.';

  @override
  String get nativeError1101 =>
      'De lokale luister-socket kon niet worden aangemaakt.';

  @override
  String get nativeError1102 =>
      'De lokale luister-socket kon niet worden gebonden.';

  @override
  String get nativeError1103 =>
      'De lokale luister-socket kon niet beginnen met luisteren.';

  @override
  String get nativeError1104 => 'De luisterthread kon niet worden aangemaakt.';

  @override
  String get nativeError1105 =>
      'Het starten van de lokale luister is verlopen.';

  @override
  String get nativeError1106 =>
      'De verbinding van het Android-apparaat kon niet worden geaccepteerd.';

  @override
  String get nativeError1107 =>
      'De verbindingscode van het Android-apparaat kon niet worden gelezen.';

  @override
  String get nativeError1200 =>
      'De opname van systeemaudio kon niet worden gestart.';

  @override
  String get nativeError1201 =>
      'De inhoud van de schermdeling kon niet worden opgehaald.';

  @override
  String get nativeError1202 =>
      'Er is geen scherm beschikbaar voor de opname van systeemaudio.';

  @override
  String get nativeError1203 =>
      'De audio-uitvoer van ScreenCaptureKit kon niet worden geconfigureerd.';

  @override
  String get nativeError1204 =>
      'De audio-opname van ScreenCaptureKit kon niet worden gestart.';

  @override
  String get nativeError1205 =>
      'De audio-opname van ScreenCaptureKit is onverwacht gestopt.';

  @override
  String get nativeError1206 =>
      'Het starten van de audio-opname van ScreenCaptureKit is verlopen.';

  @override
  String get nativeErrorUnknown =>
      'Er is een onbekende fout opgetreden bij de opname van systeemaudio.';

  @override
  String exceptionDetails(String message) {
    return 'Diagnose: $message';
  }

  @override
  String get winMinimize => 'Minimaliseren';

  @override
  String get winClose => 'Sluiten';

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
