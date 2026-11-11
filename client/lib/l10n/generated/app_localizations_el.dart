// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Modern Greek (`el`).
class AppLocalizationsEl extends AppLocalizations {
  AppLocalizationsEl([String locale = 'el']) : super(locale);

  @override
  String get appTitle => 'AudioShare';

  @override
  String get ok => 'OK';

  @override
  String get openSystemSettings => 'Άνοιγμα ρυθμίσεων συστήματος';

  @override
  String get noDevices => 'Δεν βρέθηκαν συσκευές';

  @override
  String get connect => 'Σύνδεση';

  @override
  String get connecting => 'Σύνδεση σε εξέλιξη';

  @override
  String get disconnect => 'Αποσύνδεση';

  @override
  String get autoConnectLastDevice =>
      'Αυτόματη σύνδεση στην τελευταία χρησιμοποιημένη συσκευή';

  @override
  String get language => 'Γλώσσα';

  @override
  String get followSystem => 'Ακολουθεί το σύστημα';

  @override
  String get noLanguageMatch => 'Δεν βρέθηκε αντίστοιχη γλώσσα';

  @override
  String deviceAndroidVersion(String version, String apiLevel) {
    return 'Android $version (API $apiLevel)';
  }

  @override
  String deviceNetworkAddress(String ip, String port) {
    return ' - $ip:$port';
  }

  @override
  String get recordingPermissionTitle => 'Απαιτείται άδεια εγγραφής';

  @override
  String get recordingPermissionDescription =>
      'Στις Ρυθμίσεις συστήματος μεταβείτε στο Απόρρητο και ασφάλεια > Εγγραφή οθόνης και ήχου συστήματος και επιτρέψτε το AudioShare. Το macOS απαιτεί επανεκκίνηση της εφαρμογής για να ισχύσει η νέα άδεια: κλείστε το AudioShare, ανοίξτε το ξανά και συνδεθείτε ξανά.';

  @override
  String get connectionFailedTitle => 'Η σύνδεση απέτυχε';

  @override
  String get captureInitializationFailed =>
      'Δεν ήταν δυνατή η αρχικοποίηση της λήψης ήχου συστήματος.';

  @override
  String get captureStopped => 'Η λήψη ήχου συστήματος διακόπηκε.';

  @override
  String get captureStartFailed =>
      'Δεν ήταν δυνατη η έναρξη της λήψης ήχου συστήματος.';

  @override
  String get listenerStartFailed =>
      'Δεν ήταν δυνατη η εκκίνηση της τοπικής υπηρεσίας ροής ήχου.';

  @override
  String get noAvailablePort => 'Δεν υπάρχει διαθέσιμη τοπική θύρα ακρόασης.';

  @override
  String get connectAndroidDeviceFailed =>
      'Παρουσιάστηκε σφάλμα κατά τη σύνδεση στη συσκευή Android.';

  @override
  String get connectDeviceFailed =>
      'Παρουσιάστηκε σφάλμα κατά τη σύνδεση στη συσκευή.';

  @override
  String nativeErrorDetails(String code) {
    return 'Κωδικός σφάλματος: $code';
  }

  @override
  String get nativeError1000 => 'Η αρχικοποίηση της λήψης ήχου απέτυχε.';

  @override
  String get nativeError1001 =>
      'Αυτή η έκδοση του macOS δεν υποστηρίζει τη λήψη ήχου συστήματος.';

  @override
  String get nativeError1002 =>
      'Η άδεια εγγραφής οθόνης και ήχου συστήματος δεν είναι διαθέσιμη.';

  @override
  String get nativeError1100 =>
      'Δεν ήταν δυνατη η εκκίνηση του τοπικού ακροατή ήχου.';

  @override
  String get nativeError1101 =>
      'Δεν ήταν δυνατη η δημιουργία της τοπικής υποδοχής ακρόασης.';

  @override
  String get nativeError1102 =>
      'Δεν ήταν δυνατη η σύνδεση της τοπικής υποδοχής ακρόασης.';

  @override
  String get nativeError1103 =>
      'Η τοπική υποδοχή ακρόασης δεν μπόρεσε να αρχίσει να ακούει.';

  @override
  String get nativeError1104 =>
      'Δεν ήταν δυνατη η δημιουργία του νήματος τοπικής ακρόασης.';

  @override
  String get nativeError1105 =>
      'Η εκκίνηση του τοπικού ακροατή έληξε με timeout.';

  @override
  String get nativeError1106 =>
      'Δεν ήταν δυνατη η αποδοχή της σύνδεσης από τη συσκευή Android.';

  @override
  String get nativeError1107 =>
      'Δεν ήταν δυνατη η ανάγνωση του κωδικού σύνδεσης της συσκευής Android.';

  @override
  String get nativeError1200 =>
      'Δεν ήταν δυνατη η έναρξη της λήψης ήχου συστήματος.';

  @override
  String get nativeError1201 =>
      'Δεν ήταν δυνατη η λήψη του περιεχομένου της κοινής χρήσης οθόνης.';

  @override
  String get nativeError1202 =>
      'Δεν υπάρχει διαθέσιμη οθόνη για τη λήψη ήχου συστήματος.';

  @override
  String get nativeError1203 =>
      'Δεν ήταν δυνατη η ρύθμιση της εξόδου ήχου του ScreenCaptureKit.';

  @override
  String get nativeError1204 =>
      'Δεν ήταν δυνατη η έναρξη της λήψης ήχου του ScreenCaptureKit.';

  @override
  String get nativeError1205 =>
      'Η λήψη ήχου του ScreenCaptureKit διακόπηκε απροσδόκητα.';

  @override
  String get nativeError1206 =>
      'Η έναρξη της λήψης ήχου του ScreenCaptureKit έληξε με timeout.';

  @override
  String get nativeErrorUnknown =>
      'Παρουσιάστηκε άγνωστο σφάλμα λήψης ήχου συστήματος.';

  @override
  String exceptionDetails(String message) {
    return 'Διαγνωστικά: $message';
  }

  @override
  String get winMinimize => 'Ελαχιστοποίηση';

  @override
  String get winClose => 'Κλείσιμο';

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
