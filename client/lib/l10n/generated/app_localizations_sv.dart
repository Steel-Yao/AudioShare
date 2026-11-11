// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String get appTitle => 'AudioShare';

  @override
  String get ok => 'OK';

  @override
  String get openSystemSettings => 'Öppna systeminställningar';

  @override
  String get noDevices => 'Inga enheter hittades';

  @override
  String get connect => 'Anslut';

  @override
  String get connecting => 'Ansluter';

  @override
  String get disconnect => 'Koppla ner';

  @override
  String get autoConnectLastDevice =>
      'Anslut automatiskt till den senast använda enheten';

  @override
  String get language => 'Språk';

  @override
  String get followSystem => 'Följ systemet';

  @override
  String get noLanguageMatch => 'Inget matchande språk hittades';

  @override
  String deviceAndroidVersion(String version, String apiLevel) {
    return 'Android $version (API $apiLevel)';
  }

  @override
  String deviceNetworkAddress(String ip, String port) {
    return ' - $ip:$port';
  }

  @override
  String get recordingPermissionTitle => 'Inspelningsbehörighet krävs';

  @override
  String get recordingPermissionDescription =>
      'I Systeminställningar går du till Säkerhet och sekretess > Skärminspelning och systemljud och tillåter AudioShare. macOS kräver att appen startas om för att den nya behörigheten ska gälla: avsluta AudioShare, öppna det igen och anslut sedan på nytt.';

  @override
  String get connectionFailedTitle => 'Anslutningen misslyckades';

  @override
  String get captureInitializationFailed =>
      'Det gick inte att initiera upptagningen av systemljud.';

  @override
  String get captureStopped => 'Upptagningen av systemljud har stoppats.';

  @override
  String get captureStartFailed =>
      'Det gick inte att starta upptagningen av systemljud.';

  @override
  String get listenerStartFailed =>
      'Det gick inte att starta den lokala ljudströmmingstjänsten.';

  @override
  String get noAvailablePort => 'Ingen lokal lyssningsport är tillgänglig.';

  @override
  String get connectAndroidDeviceFailed =>
      'Ett fel uppstod vid anslutning till Android-enheten.';

  @override
  String get connectDeviceFailed =>
      'Ett fel uppstod vid anslutning till enheten.';

  @override
  String nativeErrorDetails(String code) {
    return 'Felkod: $code';
  }

  @override
  String get nativeError1000 => 'Det gick inte att initiera ljudupptagningen.';

  @override
  String get nativeError1001 =>
      'Den här versionen av macOS stöder inte upptagning av systemljud.';

  @override
  String get nativeError1002 =>
      'Behörigheten för skärminspelning och systemljud är inte tillgänglig.';

  @override
  String get nativeError1100 =>
      'Det gick inte att starta den lokala ljudlyssnaren.';

  @override
  String get nativeError1101 =>
      'Det gick inte att skapa den lokala lyssningssocketen.';

  @override
  String get nativeError1102 =>
      'Det gick inte att binda den lokala lyssningssocketen.';

  @override
  String get nativeError1103 =>
      'Den lokala lyssningssocketen kunde inte börja lyssna.';

  @override
  String get nativeError1104 =>
      'Det gick inte att skapa den lokala lyssningstråden.';

  @override
  String get nativeError1105 =>
      'Tidsgränsen för att starta den lokala lyssnaren överskreds.';

  @override
  String get nativeError1106 =>
      'Det gick inte att acceptera anslutningen från Android-enheten.';

  @override
  String get nativeError1107 =>
      'Det gick inte att läsa Android-enhetens anslutningskod.';

  @override
  String get nativeError1200 =>
      'Det gick inte att starta upptagningen av systemljud.';

  @override
  String get nativeError1201 =>
      'Det gick inte att hämta innehållet i skärmdelningen.';

  @override
  String get nativeError1202 =>
      'Ingen skärm är tillgänglig för upptagning av systemljud.';

  @override
  String get nativeError1203 =>
      'Det gick inte att konfigurera ljudutgången för ScreenCaptureKit.';

  @override
  String get nativeError1204 =>
      'Det gick inte att starta ljudupptagningen i ScreenCaptureKit.';

  @override
  String get nativeError1205 =>
      'Ljudupptagningen i ScreenCaptureKit stoppades oväntat.';

  @override
  String get nativeError1206 =>
      'Tidsgränsen för att starta ljudupptagningen i ScreenCaptureKit överskreds.';

  @override
  String get nativeErrorUnknown =>
      'Ett okänt fel uppstod vid upptagning av systemljud.';

  @override
  String exceptionDetails(String message) {
    return 'Diagnostik: $message';
  }

  @override
  String get winMinimize => 'Minimera';

  @override
  String get winClose => 'Stäng';

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
