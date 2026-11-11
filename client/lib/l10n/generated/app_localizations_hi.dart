// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'AudioShare';

  @override
  String get ok => 'ठीक है';

  @override
  String get openSystemSettings => 'सिस्टम सेटिंग खोलें';

  @override
  String get noDevices => 'कोई डिवाइस नहीं मिला';

  @override
  String get connect => 'कनेक्ट करें';

  @override
  String get connecting => 'कनेक्ट हो रहा है';

  @override
  String get disconnect => 'डिस्कनेक्ट करें';

  @override
  String get autoConnectLastDevice =>
      'पिछली बार उपयोग किए गए डिवाइस से स्वतः कनेक्ट करें';

  @override
  String get language => 'भाषा';

  @override
  String get followSystem => 'सिस्टम के अनुसार';

  @override
  String get noLanguageMatch => 'कोई मेल खाती भाषा नहीं मिली';

  @override
  String deviceAndroidVersion(String version, String apiLevel) {
    return 'Android $version (API $apiLevel)';
  }

  @override
  String deviceNetworkAddress(String ip, String port) {
    return ' - $ip:$port';
  }

  @override
  String get recordingPermissionTitle => 'रिकॉर्डिंग की अनुमति आवश्यक है';

  @override
  String get recordingPermissionDescription =>
      'सिस्टम सेटिंग में Privacy & Security > Screen & System Audio Recording पर जाएँ और AudioShare को अनुमति दें। नई अनुमति लागू होने के लिए macOS को ऐप को फिर से शुरू करना पड़ता है; AudioShare से बाहर निकलें, उसे दोबारा खोलें, फिर कनेक्ट करें।';

  @override
  String get connectionFailedTitle => 'कनेक्ट करना विफल रहा';

  @override
  String get captureInitializationFailed =>
      'सिस्टम ऑडियो कैप्चर प्रारंभ नहीं किया जा सका।';

  @override
  String get captureStopped => 'सिस्टम ऑडियो कैप्चर रोक दिया गया।';

  @override
  String get captureStartFailed => 'सिस्टम ऑडियो कैप्चर शुरू नहीं किया जा सका।';

  @override
  String get listenerStartFailed =>
      'स्थानीय ऑडियो स्ट्रीमिंग सेवा शुरू नहीं की जा सकी।';

  @override
  String get noAvailablePort => 'कोई स्थानीय लिसनिंग पोर्ट उपलब्ध नहीं है।';

  @override
  String get connectAndroidDeviceFailed =>
      'Android डिवाइस से कनेक्ट करते समय एक त्रुटि हुई।';

  @override
  String get connectDeviceFailed => 'डिवाइस से कनेक्ट करते समय एक त्रुटि हुई।';

  @override
  String nativeErrorDetails(String code) {
    return 'त्रुटि कोड: $code';
  }

  @override
  String get nativeError1000 => 'ऑडियो कैप्चर प्रारंभ करना विफल रहा।';

  @override
  String get nativeError1001 =>
      'macOS का यह संस्करण सिस्टम ऑडियो कैप्चर का समर्थन नहीं करता।';

  @override
  String get nativeError1002 =>
      'स्क्रीन और सिस्टम ऑडियो रिकॉर्डिंग की अनुमति उपलब्ध नहीं है।';

  @override
  String get nativeError1100 => 'स्थानीय ऑडियो लिसनर शुरू नहीं किया जा सका।';

  @override
  String get nativeError1101 => 'स्थानीय लिसनिंग सॉकेट बनाया नहीं जा सका।';

  @override
  String get nativeError1102 =>
      'स्थानीय लिसनिंग सॉकेट को बाइंड नहीं किया जा सका।';

  @override
  String get nativeError1103 => 'स्थानीय लिसनिंग सॉकेट सुनना शुरू नहीं कर सका।';

  @override
  String get nativeError1104 => 'स्थानीय लिसनर थ्रेड बनाया नहीं जा सका।';

  @override
  String get nativeError1105 =>
      'स्थानीय लिसनर शुरू करने में समय समाप्त हो गया।';

  @override
  String get nativeError1106 =>
      'Android डिवाइस का कनेक्शन स्वीकार नहीं किया जा सका।';

  @override
  String get nativeError1107 =>
      'Android डिवाइस का कनेक्शन कोड पढ़ा नहीं जा सका।';

  @override
  String get nativeError1200 => 'सिस्टम ऑडियो कैप्चर शुरू नहीं किया जा सका।';

  @override
  String get nativeError1201 =>
      'स्क्रीन साझा करने की सामग्री प्राप्त नहीं की जा सकी।';

  @override
  String get nativeError1202 =>
      'सिस्टम ऑडियो कैप्चर के लिए कोई डिस्प्ले उपलब्ध नहीं है।';

  @override
  String get nativeError1203 =>
      'ScreenCaptureKit ऑडियो आउटपुट कॉन्फ़िगर नहीं किया जा सका।';

  @override
  String get nativeError1204 =>
      'ScreenCaptureKit ऑडियो कैप्चर शुरू नहीं किया जा सका।';

  @override
  String get nativeError1205 => 'ScreenCaptureKit ऑडियो कैप्चर अचानक रुक गया।';

  @override
  String get nativeError1206 =>
      'ScreenCaptureKit ऑडियो कैप्चर शुरू करने में समय समाप्त हो गया।';

  @override
  String get nativeErrorUnknown =>
      'सिस्टम ऑडियो कैप्चर की एक अज्ञात त्रुटि हुई।';

  @override
  String exceptionDetails(String message) {
    return 'निदान: $message';
  }

  @override
  String get winMinimize => 'छोटा करें';

  @override
  String get winClose => 'बंद करें';

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
