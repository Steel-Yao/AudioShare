// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'AudioShare';

  @override
  String get ok => 'OK';

  @override
  String get openSystemSettings => 'Open System Settings';

  @override
  String get noDevices => 'No devices found';

  @override
  String get connect => 'Connect';

  @override
  String get connecting => 'Connecting';

  @override
  String get disconnect => 'Disconnect';

  @override
  String get autoConnectLastDevice =>
      'Automatically connect to the last used device';

  @override
  String get language => 'Language';

  @override
  String get followSystem => 'Follow system';

  @override
  String get noLanguageMatch => 'No matching language';

  @override
  String deviceAndroidVersion(String version, String apiLevel) {
    return 'Android $version (API $apiLevel)';
  }

  @override
  String deviceNetworkAddress(String ip, String port) {
    return ' - $ip:$port';
  }

  @override
  String get recordingPermissionTitle => 'Recording permission required';

  @override
  String get recordingPermissionDescription =>
      'In System Settings, go to Privacy & Security > Screen & System Audio Recording and allow AudioShare. macOS requires the app to restart before the new permission takes effect; quit and reopen AudioShare, then connect again.';

  @override
  String get connectionFailedTitle => 'Connection failed';

  @override
  String get captureInitializationFailed =>
      'System audio capture could not be initialized.';

  @override
  String get captureStopped => 'System audio capture stopped.';

  @override
  String get captureStartFailed => 'System audio capture could not be started.';

  @override
  String get listenerStartFailed =>
      'The local audio streaming service could not be started.';

  @override
  String get noAvailablePort => 'No local listening port is available.';

  @override
  String get connectAndroidDeviceFailed =>
      'An error occurred while connecting to the Android device.';

  @override
  String get connectDeviceFailed =>
      'An error occurred while connecting to the device.';

  @override
  String nativeErrorDetails(String code) {
    return 'Error code: $code';
  }

  @override
  String get nativeError1000 => 'Audio capture initialization failed.';

  @override
  String get nativeError1001 =>
      'This macOS version does not support system audio capture.';

  @override
  String get nativeError1002 =>
      'Screen and system audio recording permission is unavailable.';

  @override
  String get nativeError1100 =>
      'The local audio listener could not be started.';

  @override
  String get nativeError1101 =>
      'The local listening socket could not be created.';

  @override
  String get nativeError1102 =>
      'The local listening socket could not be bound.';

  @override
  String get nativeError1103 =>
      'The local listening socket could not start listening.';

  @override
  String get nativeError1104 =>
      'The local listener thread could not be created.';

  @override
  String get nativeError1105 => 'Starting the local listener timed out.';

  @override
  String get nativeError1106 => 'The Android connection could not be accepted.';

  @override
  String get nativeError1107 =>
      'The Android connection code could not be read.';

  @override
  String get nativeError1200 => 'System audio capture could not be started.';

  @override
  String get nativeError1201 => 'Screen sharing content could not be obtained.';

  @override
  String get nativeError1202 =>
      'No display is available for system audio capture.';

  @override
  String get nativeError1203 =>
      'ScreenCaptureKit audio output could not be configured.';

  @override
  String get nativeError1204 =>
      'ScreenCaptureKit audio capture could not be started.';

  @override
  String get nativeError1205 =>
      'ScreenCaptureKit audio capture stopped unexpectedly.';

  @override
  String get nativeError1206 =>
      'Starting ScreenCaptureKit audio capture timed out.';

  @override
  String get nativeErrorUnknown =>
      'An unknown system audio capture error occurred.';

  @override
  String exceptionDetails(String message) {
    return 'Diagnostic: $message';
  }

  @override
  String get winMinimize => 'Minimize';

  @override
  String get winClose => 'Close';

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
