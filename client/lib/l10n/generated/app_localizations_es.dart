// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'AudioShare';

  @override
  String get ok => 'Aceptar';

  @override
  String get openSystemSettings => 'Abrir ajustes del sistema';

  @override
  String get noDevices => 'No se encontraron dispositivos';

  @override
  String get connect => 'Conectar';

  @override
  String get connecting => 'Conectando';

  @override
  String get disconnect => 'Desconectar';

  @override
  String get autoConnectLastDevice =>
      'Conectar automáticamente al último dispositivo usado';

  @override
  String get language => 'Idioma';

  @override
  String get followSystem => 'Seguir al sistema';

  @override
  String get noLanguageMatch => 'Ningún idioma coincide';

  @override
  String deviceAndroidVersion(String version, String apiLevel) {
    return 'Android $version (API $apiLevel)';
  }

  @override
  String deviceNetworkAddress(String ip, String port) {
    return ' - $ip:$port';
  }

  @override
  String get recordingPermissionTitle => 'Se requiere permiso de grabación';

  @override
  String get recordingPermissionDescription =>
      'En Ajustes del Sistema, ve a Privacidad y seguridad > Grabación de pantalla y audio del sistema y permite AudioShare. macOS requiere reiniciar la aplicación para que el nuevo permiso surta efecto: sal de AudioShare, vuelve a abrirla y conéctate de nuevo.';

  @override
  String get connectionFailedTitle => 'Error de conexión';

  @override
  String get captureInitializationFailed =>
      'No se pudo inicializar la captura de audio del sistema.';

  @override
  String get captureStopped => 'Se detuvo la captura de audio del sistema.';

  @override
  String get captureStartFailed =>
      'No se pudo iniciar la captura de audio del sistema.';

  @override
  String get listenerStartFailed =>
      'No se pudo iniciar el servicio local de transmisión de audio.';

  @override
  String get noAvailablePort =>
      'No hay ningún puerto de escucha local disponible.';

  @override
  String get connectAndroidDeviceFailed =>
      'Se produjo un error al conectar con el dispositivo Android.';

  @override
  String get connectDeviceFailed =>
      'Se produjo un error al conectar con el dispositivo.';

  @override
  String nativeErrorDetails(String code) {
    return 'Código de error: $code';
  }

  @override
  String get nativeError1000 => 'Error al inicializar la captura de audio.';

  @override
  String get nativeError1001 =>
      'Esta versión de macOS no admite la captura de audio del sistema.';

  @override
  String get nativeError1002 =>
      'El permiso de grabación de pantalla y audio del sistema no está disponible.';

  @override
  String get nativeError1100 =>
      'No se pudo iniciar el servicio local de escucha de audio.';

  @override
  String get nativeError1101 => 'No se pudo crear el socket de escucha local.';

  @override
  String get nativeError1102 =>
      'No se pudo enlazar el socket de escucha local.';

  @override
  String get nativeError1103 =>
      'El socket de escucha local no pudo comenzar a escuchar.';

  @override
  String get nativeError1104 => 'No se pudo crear el hilo de escucha local.';

  @override
  String get nativeError1105 =>
      'Se agotó el tiempo de espera al iniciar el servicio local de escucha.';

  @override
  String get nativeError1106 =>
      'No se pudo aceptar la conexión del dispositivo Android.';

  @override
  String get nativeError1107 =>
      'No se pudo leer el código de conexión del dispositivo Android.';

  @override
  String get nativeError1200 =>
      'No se pudo iniciar la captura de audio del sistema.';

  @override
  String get nativeError1201 =>
      'No se pudo obtener el contenido de la pantalla compartida.';

  @override
  String get nativeError1202 =>
      'No hay ninguna pantalla disponible para la captura de audio del sistema.';

  @override
  String get nativeError1203 =>
      'No se pudo configurar la salida de audio de ScreenCaptureKit.';

  @override
  String get nativeError1204 =>
      'No se pudo iniciar la captura de audio de ScreenCaptureKit.';

  @override
  String get nativeError1205 =>
      'La captura de audio de ScreenCaptureKit se detuvo inesperadamente.';

  @override
  String get nativeError1206 =>
      'Se agotó el tiempo de espera al iniciar la captura de audio de ScreenCaptureKit.';

  @override
  String get nativeErrorUnknown =>
      'Se produjo un error desconocido de captura de audio del sistema.';

  @override
  String exceptionDetails(String message) {
    return 'Diagnóstico: $message';
  }

  @override
  String get winMinimize => 'Minimizar';

  @override
  String get winClose => 'Cerrar';

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
