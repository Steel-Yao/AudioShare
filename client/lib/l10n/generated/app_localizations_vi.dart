// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'AudioShare';

  @override
  String get ok => 'OK';

  @override
  String get openSystemSettings => 'Mở Cài đặt hệ thống';

  @override
  String get noDevices => 'Không tìm thấy thiết bị nào';

  @override
  String get connect => 'Kết nối';

  @override
  String get connecting => 'Đang kết nối';

  @override
  String get disconnect => 'Ngắt kết nối';

  @override
  String get autoConnectLastDevice =>
      'Tự động kết nối với thiết bị đã dùng gần nhất';

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get followSystem => 'Theo hệ thống';

  @override
  String get noLanguageMatch => 'Không có ngôn ngữ phù hợp';

  @override
  String deviceAndroidVersion(String version, String apiLevel) {
    return 'Android $version (API $apiLevel)';
  }

  @override
  String deviceNetworkAddress(String ip, String port) {
    return ' - $ip:$port';
  }

  @override
  String get recordingPermissionTitle => 'Cần quyền ghi hình';

  @override
  String get recordingPermissionDescription =>
      'Trong Cài đặt hệ thống, vào Quyền riêng tư & Bảo mật > Ghi hình màn hình và âm thanh hệ thống, rồi cho phép AudioShare. macOS cần khởi động lại ứng dụng để quyền mới có hiệu lực; hãy thoát AudioShare, mở lại rồi kết nối lại lần nữa.';

  @override
  String get connectionFailedTitle => 'Kết nối thất bại';

  @override
  String get captureInitializationFailed =>
      'Không thể khởi tạo việc thu âm thanh hệ thống.';

  @override
  String get captureStopped => 'Việc thu âm thanh hệ thống đã dừng.';

  @override
  String get captureStartFailed => 'Không thể bắt đầu thu âm thanh hệ thống.';

  @override
  String get listenerStartFailed =>
      'Không thể khởi động dịch vụ truyền âm thanh cục bộ.';

  @override
  String get noAvailablePort => 'Không có cổng lắng nghe cục bộ nào khả dụng.';

  @override
  String get connectAndroidDeviceFailed =>
      'Đã xảy ra lỗi khi kết nối với thiết bị Android.';

  @override
  String get connectDeviceFailed => 'Đã xảy ra lỗi khi kết nối với thiết bị.';

  @override
  String nativeErrorDetails(String code) {
    return 'Mã lỗi: $code';
  }

  @override
  String get nativeError1000 => 'Khởi tạo thu âm thanh thất bại.';

  @override
  String get nativeError1001 =>
      'Phiên bản macOS này không hỗ trợ thu âm thanh hệ thống.';

  @override
  String get nativeError1002 =>
      'Không có quyền ghi hình màn hình và âm thanh hệ thống.';

  @override
  String get nativeError1100 =>
      'Không thể khởi động bộ lắng nghe âm thanh cục bộ.';

  @override
  String get nativeError1101 => 'Không thể tạo socket lắng nghe cục bộ.';

  @override
  String get nativeError1102 => 'Không thể liên kết socket lắng nghe cục bộ.';

  @override
  String get nativeError1103 =>
      'Socket lắng nghe cục bộ không thể bắt đầu lắng nghe.';

  @override
  String get nativeError1104 => 'Không thể tạo luồng lắng nghe cục bộ.';

  @override
  String get nativeError1105 =>
      'Khởi động bộ lắng nghe cục bộ đã hết thời gian chờ.';

  @override
  String get nativeError1106 =>
      'Không thể chấp nhận kết nối từ thiết bị Android.';

  @override
  String get nativeError1107 =>
      'Không thể đọc mã kết nối của thiết bị Android.';

  @override
  String get nativeError1200 => 'Không thể bắt đầu thu âm thanh hệ thống.';

  @override
  String get nativeError1201 => 'Không thể lấy nội dung chia sẻ màn hình.';

  @override
  String get nativeError1202 =>
      'Không có màn hình nào khả dụng để thu âm thanh hệ thống.';

  @override
  String get nativeError1203 =>
      'Không thể cấu hình âm thanh đầu ra của ScreenCaptureKit.';

  @override
  String get nativeError1204 =>
      'Không thể bắt đầu thu âm thanh của ScreenCaptureKit.';

  @override
  String get nativeError1205 =>
      'Việc thu âm thanh của ScreenCaptureKit đã dừng đột ngột.';

  @override
  String get nativeError1206 =>
      'Bắt đầu thu âm thanh của ScreenCaptureKit đã hết thời gian chờ.';

  @override
  String get nativeErrorUnknown =>
      'Đã xảy ra lỗi thu âm thanh hệ thống không xác định.';

  @override
  String exceptionDetails(String message) {
    return 'Chẩn đoán: $message';
  }

  @override
  String get winMinimize => 'Thu nhỏ';

  @override
  String get winClose => 'Đóng';

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
