// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'AudioShare';

  @override
  String get ok => 'OK';

  @override
  String get openSystemSettings => 'Abrir configurações do sistema';

  @override
  String get noDevices => 'Nenhum dispositivo encontrado';

  @override
  String get connect => 'Conectar';

  @override
  String get connecting => 'Conectando';

  @override
  String get disconnect => 'Desconectar';

  @override
  String get autoConnectLastDevice =>
      'Conectar automaticamente ao último dispositivo usado';

  @override
  String get language => 'Idioma';

  @override
  String get followSystem => 'Seguir o sistema';

  @override
  String get noLanguageMatch => 'Nenhum idioma corresponde';

  @override
  String deviceAndroidVersion(String version, String apiLevel) {
    return 'Android $version (API $apiLevel)';
  }

  @override
  String deviceNetworkAddress(String ip, String port) {
    return ' - $ip:$port';
  }

  @override
  String get recordingPermissionTitle => 'Permissão de gravação necessária';

  @override
  String get recordingPermissionDescription =>
      'Em Configurações do Sistema, acesse Privacidade e Segurança > Gravação de tela e áudio do sistema e permita o AudioShare. O macOS exige que o aplicativo seja reiniciado para que a nova permissão entre em vigor: saia do AudioShare, abra-o novamente e conecte-se outra vez.';

  @override
  String get connectionFailedTitle => 'Falha na conexão';

  @override
  String get captureInitializationFailed =>
      'Não foi possível inicializar a captura de áudio do sistema.';

  @override
  String get captureStopped =>
      'A captura de áudio do sistema foi interrompida.';

  @override
  String get captureStartFailed =>
      'Não foi possível iniciar a captura de áudio do sistema.';

  @override
  String get listenerStartFailed =>
      'Não foi possível iniciar o serviço local de transmissão de áudio.';

  @override
  String get noAvailablePort =>
      'Nenhuma porta de escuta local está disponível.';

  @override
  String get connectAndroidDeviceFailed =>
      'Ocorreu um erro ao conectar ao dispositivo Android.';

  @override
  String get connectDeviceFailed =>
      'Ocorreu um erro ao conectar ao dispositivo.';

  @override
  String nativeErrorDetails(String code) {
    return 'Código de erro: $code';
  }

  @override
  String get nativeError1000 => 'Falha na inicialização da captura de áudio.';

  @override
  String get nativeError1001 =>
      'Esta versão do macOS não oferece suporte à captura de áudio do sistema.';

  @override
  String get nativeError1002 =>
      'A permissão de gravação de tela e áudio do sistema não está disponível.';

  @override
  String get nativeError1100 =>
      'Não foi possível iniciar o serviço local de escuta de áudio.';

  @override
  String get nativeError1101 =>
      'Não foi possível criar o socket de escuta local.';

  @override
  String get nativeError1102 =>
      'Não foi possível vincular o socket de escuta local.';

  @override
  String get nativeError1103 =>
      'O socket de escuta local não conseguiu começar a escutar.';

  @override
  String get nativeError1104 =>
      'Não foi possível criar a thread de escuta local.';

  @override
  String get nativeError1105 => 'O início do serviço local de escuta expirou.';

  @override
  String get nativeError1106 =>
      'Não foi possível aceitar a conexão do dispositivo Android.';

  @override
  String get nativeError1107 =>
      'Não foi possível ler o código de conexão do dispositivo Android.';

  @override
  String get nativeError1200 =>
      'Não foi possível iniciar a captura de áudio do sistema.';

  @override
  String get nativeError1201 =>
      'Não foi possível obter o conteúdo do compartilhamento de tela.';

  @override
  String get nativeError1202 =>
      'Nenhuma tela está disponível para a captura de áudio do sistema.';

  @override
  String get nativeError1203 =>
      'Não foi possível configurar a saída de áudio do ScreenCaptureKit.';

  @override
  String get nativeError1204 =>
      'Não foi possível iniciar a captura de áudio do ScreenCaptureKit.';

  @override
  String get nativeError1205 =>
      'A captura de áudio do ScreenCaptureKit parou inesperadamente.';

  @override
  String get nativeError1206 =>
      'O início da captura de áudio do ScreenCaptureKit expirou.';

  @override
  String get nativeErrorUnknown =>
      'Ocorreu um erro desconhecido de captura de áudio do sistema.';

  @override
  String exceptionDetails(String message) {
    return 'Diagnóstico: $message';
  }

  @override
  String get winMinimize => 'Minimizar';

  @override
  String get winClose => 'Fechar';

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
