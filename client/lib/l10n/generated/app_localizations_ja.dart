// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'AudioShare';

  @override
  String get ok => 'OK';

  @override
  String get openSystemSettings => 'システム設定を開く';

  @override
  String get noDevices => 'デバイスが見つかりません';

  @override
  String get connect => '接続';

  @override
  String get connecting => '接続中';

  @override
  String get disconnect => '切断';

  @override
  String get autoConnectLastDevice => '前回使用したデバイスに自動的に接続する';

  @override
  String get language => '言語';

  @override
  String get followSystem => 'システムに従う';

  @override
  String get noLanguageMatch => '一致する言語がありません';

  @override
  String deviceAndroidVersion(String version, String apiLevel) {
    return 'Android $version（API $apiLevel）';
  }

  @override
  String deviceNetworkAddress(String ip, String port) {
    return ' - $ip:$port';
  }

  @override
  String get recordingPermissionTitle => '録画の許可が必要です';

  @override
  String get recordingPermissionDescription =>
      '「システム設定」の「プライバシーとセキュリティ」>「スクリーンとシステムオーディオの記録」を開き、AudioShareを許可してください。macOSでは新しい許可を反映するためにアプリを再起動する必要があります。AudioShareを終了して開き直し、もう一度接続してください。';

  @override
  String get connectionFailedTitle => '接続に失敗しました';

  @override
  String get captureInitializationFailed => 'システムオーディオのキャプチャを初期化できませんでした。';

  @override
  String get captureStopped => 'システムオーディオのキャプチャが停止しました。';

  @override
  String get captureStartFailed => 'システムオーディオのキャプチャを開始できませんでした。';

  @override
  String get listenerStartFailed => 'ローカルの音声ストリーミングサービスを開始できませんでした。';

  @override
  String get noAvailablePort => '利用できるローカルリスニングポートがありません。';

  @override
  String get connectAndroidDeviceFailed => 'Androidデバイスへの接続中にエラーが発生しました。';

  @override
  String get connectDeviceFailed => 'デバイスへの接続中にエラーが発生しました。';

  @override
  String nativeErrorDetails(String code) {
    return 'エラーコード: $code';
  }

  @override
  String get nativeError1000 => 'オーディオキャプチャの初期化に失敗しました。';

  @override
  String get nativeError1001 => 'このバージョンのmacOSはシステムオーディオのキャプチャに対応していません。';

  @override
  String get nativeError1002 => 'スクリーンとシステムオーディオの記録の許可が利用できません。';

  @override
  String get nativeError1100 => 'ローカル音声リスナーを開始できませんでした。';

  @override
  String get nativeError1101 => 'ローカルリスニングソケットを作成できませんでした。';

  @override
  String get nativeError1102 => 'ローカルリスニングソケットをバインドできませんでした。';

  @override
  String get nativeError1103 => 'ローカルリスニングソケットの待受けを開始できませんでした。';

  @override
  String get nativeError1104 => 'ローカルリスナースレッドを作成できませんでした。';

  @override
  String get nativeError1105 => 'ローカルリスナーの起動がタイムアウトしました。';

  @override
  String get nativeError1106 => 'Androidデバイスからの接続を受け付けられませんでした。';

  @override
  String get nativeError1107 => 'Androidデバイスの接続コードを読み取れませんでした。';

  @override
  String get nativeError1200 => 'システムオーディオのキャプチャを開始できませんでした。';

  @override
  String get nativeError1201 => '画面共有のコンテンツを取得できませんでした。';

  @override
  String get nativeError1202 => 'システムオーディオのキャプチャに使えるディスプレイがありません。';

  @override
  String get nativeError1203 => 'ScreenCaptureKitのオーディオ出力を構成できませんでした。';

  @override
  String get nativeError1204 => 'ScreenCaptureKitのオーディオキャプチャを開始できませんでした。';

  @override
  String get nativeError1205 => 'ScreenCaptureKitのオーディオキャプチャが予期せず停止しました。';

  @override
  String get nativeError1206 => 'ScreenCaptureKitのオーディオキャプチャの起動がタイムアウトしました。';

  @override
  String get nativeErrorUnknown => '不明なシステムオーディオキャプチャエラーが発生しました。';

  @override
  String exceptionDetails(String message) {
    return '診断情報: $message';
  }

  @override
  String get winMinimize => '最小化';

  @override
  String get winClose => '閉じる';

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
