// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get appTitle => 'AudioShare';

  @override
  String get ok => 'ตกลง';

  @override
  String get openSystemSettings => 'เปิดการตั้งค่าระบบ';

  @override
  String get noDevices => 'ไม่พบอุปกรณ์';

  @override
  String get connect => 'เชื่อมต่อ';

  @override
  String get connecting => 'กำลังเชื่อมต่อ';

  @override
  String get disconnect => 'ตัดการเชื่อมต่อ';

  @override
  String get autoConnectLastDevice =>
      'เชื่อมต่ออุปกรณ์ที่ใช้ล่าสุดโดยอัตโนมัติ';

  @override
  String get language => 'ภาษา';

  @override
  String get followSystem => 'ตามระบบ';

  @override
  String get noLanguageMatch => 'ไม่พบภาษาที่ตรงกัน';

  @override
  String deviceAndroidVersion(String version, String apiLevel) {
    return 'Android $version (API $apiLevel)';
  }

  @override
  String deviceNetworkAddress(String ip, String port) {
    return ' - $ip:$port';
  }

  @override
  String get recordingPermissionTitle => 'ต้องได้รับสิทธิ์บันทึก';

  @override
  String get recordingPermissionDescription =>
      'ในการตั้งค่าระบบ ให้ไปที่ ความเป็นส่วนตัวและความปลอดภัย > การบันทึกหน้าจอและเสียงระบบ แล้วอนุญาตให้ AudioShare เมื่อเปลี่ยนสิทธิ์ใหม่ macOS ต้องให้รีสตาร์ตแอปเพื่อให้มีผล จึงออกจาก AudioShare เปิดใหม่ แล้วเชื่อมต่ออีกครั้ง';

  @override
  String get connectionFailedTitle => 'เชื่อมต่อไม่สำเร็จ';

  @override
  String get captureInitializationFailed =>
      'ไม่สามารถเริ่มต้นการจับเสียงระบบได้';

  @override
  String get captureStopped => 'การจับเสียงระบบหยุดแล้ว';

  @override
  String get captureStartFailed => 'ไม่สามารถเริ่มการจับเสียงระบบได้';

  @override
  String get listenerStartFailed =>
      'ไม่สามารถเริ่มบริการสตรีมเสียงในเครื่องได้';

  @override
  String get noAvailablePort => 'ไม่มีพอร์ตฟังในเครื่องที่ใช้ได้';

  @override
  String get connectAndroidDeviceFailed =>
      'เกิดข้อผิดพลาดขณะเชื่อมต่อกับอุปกรณ์ Android';

  @override
  String get connectDeviceFailed => 'เกิดข้อผิดพลาดขณะเชื่อมต่อกับอุปกรณ์';

  @override
  String nativeErrorDetails(String code) {
    return 'รหัสข้อผิดพลาด: $code';
  }

  @override
  String get nativeError1000 => 'การเริ่มต้นการจับเสียงล้มเหลว';

  @override
  String get nativeError1001 => 'macOS เวอร์ชันนี้ไม่รองรับการจับเสียงระบบ';

  @override
  String get nativeError1002 => 'ไม่มีสิทธิ์บันทึกหน้าจอและเสียงระบบ';

  @override
  String get nativeError1100 => 'ไม่สามารถเริ่มตัวฟังเสียงในเครื่องได้';

  @override
  String get nativeError1101 => 'ไม่สามารถสร้างซ็อกเก็ตฟังในเครื่องได้';

  @override
  String get nativeError1102 => 'ไม่สามารถผูกซ็อกเก็ตฟังในเครื่องได้';

  @override
  String get nativeError1103 => 'ซ็อกเก็ตฟังในเครื่องไม่สามารถเริ่มฟังได้';

  @override
  String get nativeError1104 => 'ไม่สามารถสร้างเธรดตัวฟังในเครื่องได้';

  @override
  String get nativeError1105 => 'การเริ่มตัวฟังในเครื่องหมดเวลา';

  @override
  String get nativeError1106 =>
      'ไม่สามารถยอมรับการเชื่อมต่อจากอุปกรณ์ Android ได้';

  @override
  String get nativeError1107 =>
      'ไม่สามารถอ่านรหัสการเชื่อมต่อของอุปกรณ์ Android ได้';

  @override
  String get nativeError1200 => 'ไม่สามารถเริ่มการจับเสียงระบบได้';

  @override
  String get nativeError1201 => 'ไม่สามารถรับเนื้อหาการแชร์หน้าจอได้';

  @override
  String get nativeError1202 => 'ไม่มีจอแสดงผลที่ใช้ได้สำหรับการจับเสียงระบบ';

  @override
  String get nativeError1203 =>
      'ไม่สามารถกำหนดค่าเอาต์พุตเสียงของ ScreenCaptureKit ได้';

  @override
  String get nativeError1204 =>
      'ไม่สามารถเริ่มการจับเสียงของ ScreenCaptureKit ได้';

  @override
  String get nativeError1205 =>
      'การจับเสียงของ ScreenCaptureKit หยุดโดยไม่คาดคิด';

  @override
  String get nativeError1206 =>
      'การเริ่มการจับเสียงของ ScreenCaptureKit หมดเวลา';

  @override
  String get nativeErrorUnknown =>
      'เกิดข้อผิดพลาดที่ไม่รู้จักในการจับเสียงระบบ';

  @override
  String exceptionDetails(String message) {
    return 'การวินิจฉัย: $message';
  }

  @override
  String get winMinimize => 'ย่อ';

  @override
  String get winClose => 'ปิด';

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
