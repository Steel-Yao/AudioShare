// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'AudioShare';

  @override
  String get ok => 'OK';

  @override
  String get openSystemSettings => 'Apri le impostazioni di sistema';

  @override
  String get noDevices => 'Nessun dispositivo trovato';

  @override
  String get connect => 'Connetti';

  @override
  String get connecting => 'Connessione in corso';

  @override
  String get disconnect => 'Disconnetti';

  @override
  String get autoConnectLastDevice =>
      'Connetti automaticamente all\'ultimo dispositivo utilizzato';

  @override
  String get language => 'Lingua';

  @override
  String get followSystem => 'Segui il sistema';

  @override
  String get noLanguageMatch => 'Nessuna lingua corrispondente';

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
      'È richiesta l\'autorizzazione alla registrazione';

  @override
  String get recordingPermissionDescription =>
      'In Impostazioni di sistema apri Privacy e sicurezza > Registrazione schermo e audio di sistema e consenti AudioShare. macOS richiede il riavvio dell\'app perché la nuova autorizzazione venga applicata: esci da AudioShare, riaprilo e poi ricollegati.';

  @override
  String get connectionFailedTitle => 'Connessione non riuscita';

  @override
  String get captureInitializationFailed =>
      'Non è stato possibile inizializzare l\'acquisizione dell\'audio di sistema.';

  @override
  String get captureStopped =>
      'L\'acquisizione dell\'audio di sistema si è interrotta.';

  @override
  String get captureStartFailed =>
      'Non è stato possibile avviare l\'acquisizione dell\'audio di sistema.';

  @override
  String get listenerStartFailed =>
      'Non è stato possibile avviare il servizio locale di streaming audio.';

  @override
  String get noAvailablePort => 'Nessuna porta di ascolto locale disponibile.';

  @override
  String get connectAndroidDeviceFailed =>
      'Si è verificato un errore durante la connessione al dispositivo Android.';

  @override
  String get connectDeviceFailed =>
      'Si è verificato un errore durante la connessione al dispositivo.';

  @override
  String nativeErrorDetails(String code) {
    return 'Codice di errore: $code';
  }

  @override
  String get nativeError1000 =>
      'Inizializzazione dell\'acquisizione audio non riuscita.';

  @override
  String get nativeError1001 =>
      'Questa versione di macOS non supporta l\'acquisizione dell\'audio di sistema.';

  @override
  String get nativeError1002 =>
      'L\'autorizzazione alla registrazione di schermo e audio di sistema non è disponibile.';

  @override
  String get nativeError1100 =>
      'Non è stato possibile avviare l\'ascolto audio locale.';

  @override
  String get nativeError1101 =>
      'Non è stato possibile creare il socket di ascolto locale.';

  @override
  String get nativeError1102 =>
      'Non è stato possibile associare il socket di ascolto locale.';

  @override
  String get nativeError1103 =>
      'Il socket di ascolto locale non è riuscito a iniziare l\'ascolto.';

  @override
  String get nativeError1104 =>
      'Non è stato possibile creare il thread di ascolto locale.';

  @override
  String get nativeError1105 => 'L\'avvio dell\'ascolto locale è scaduto.';

  @override
  String get nativeError1106 =>
      'Non è stato possibile accettare la connessione dal dispositivo Android.';

  @override
  String get nativeError1107 =>
      'Non è stato possibile leggere il codice di connessione del dispositivo Android.';

  @override
  String get nativeError1200 =>
      'Non è stato possibile avviare l\'acquisizione dell\'audio di sistema.';

  @override
  String get nativeError1201 =>
      'Non è stato possibile ottenere il contenuto della condivisione schermo.';

  @override
  String get nativeError1202 =>
      'Nessuno schermo disponibile per l\'acquisizione dell\'audio di sistema.';

  @override
  String get nativeError1203 =>
      'Non è stato possibile configurare l\'uscita audio di ScreenCaptureKit.';

  @override
  String get nativeError1204 =>
      'Non è stato possibile avviare l\'acquisizione audio di ScreenCaptureKit.';

  @override
  String get nativeError1205 =>
      'L\'acquisizione audio di ScreenCaptureKit si è interrotta inaspettatamente.';

  @override
  String get nativeError1206 =>
      'L\'avvio dell\'acquisizione audio di ScreenCaptureKit è scaduto.';

  @override
  String get nativeErrorUnknown =>
      'Si è verificato un errore sconosciuto nell\'acquisizione dell\'audio di sistema.';

  @override
  String exceptionDetails(String message) {
    return 'Diagnostica: $message';
  }

  @override
  String get winMinimize => 'Riduci';

  @override
  String get winClose => 'Chiudi';

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
