// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'AudioShare';

  @override
  String get ok => '确定';

  @override
  String get openSystemSettings => '打开系统设置';

  @override
  String get noDevices => '未找到设备';

  @override
  String get connect => '连接';

  @override
  String get connecting => '连接中';

  @override
  String get disconnect => '断开';

  @override
  String get autoConnectLastDevice => '自动连接上次使用的设备';

  @override
  String get language => '语言';

  @override
  String get followSystem => '跟随系统';

  @override
  String get noLanguageMatch => '没有匹配的语言';

  @override
  String deviceAndroidVersion(String version, String apiLevel) {
    return 'Android $version（API $apiLevel）';
  }

  @override
  String deviceNetworkAddress(String ip, String port) {
    return ' - $ip:$port';
  }

  @override
  String get recordingPermissionTitle => '需要录制权限';

  @override
  String get recordingPermissionDescription =>
      '请在“系统设置 > 隐私与安全性 > 屏幕与系统音频录制”中允许 AudioShare。macOS 需要重新启动应用才能让新权限生效；授权后请退出并重新打开 AudioShare，然后再次连接。';

  @override
  String get connectionFailedTitle => '连接失败';

  @override
  String get captureInitializationFailed => '无法初始化系统音频捕获。';

  @override
  String get captureStopped => '系统音频捕获已停止。';

  @override
  String get captureStartFailed => '无法开始捕获系统音频。';

  @override
  String get listenerStartFailed => '无法启动本地音频传输服务。';

  @override
  String get noAvailablePort => '没有可用的本地监听端口。';

  @override
  String get connectAndroidDeviceFailed => '连接 Android 设备时发生错误。';

  @override
  String get connectDeviceFailed => '连接设备时发生错误。';

  @override
  String nativeErrorDetails(String code) {
    return '错误码：$code';
  }

  @override
  String get nativeError1000 => '系统音频捕获初始化失败。';

  @override
  String get nativeError1001 => '当前 macOS 版本不支持系统音频捕获。';

  @override
  String get nativeError1002 => '屏幕与系统音频录制权限不可用。';

  @override
  String get nativeError1100 => '本地音频监听服务无法启动。';

  @override
  String get nativeError1101 => '无法创建本地监听套接字。';

  @override
  String get nativeError1102 => '无法绑定本地监听套接字。';

  @override
  String get nativeError1103 => '本地监听套接字无法开始监听。';

  @override
  String get nativeError1104 => '无法创建本地监听线程。';

  @override
  String get nativeError1105 => '启动本地监听服务超时。';

  @override
  String get nativeError1106 => '无法接受 Android 设备连接。';

  @override
  String get nativeError1107 => '无法读取 Android 设备连接码。';

  @override
  String get nativeError1200 => '无法开始系统音频捕获。';

  @override
  String get nativeError1201 => '无法获取屏幕共享内容。';

  @override
  String get nativeError1202 => '没有可用于系统音频捕获的显示器。';

  @override
  String get nativeError1203 => '无法配置 ScreenCaptureKit 音频输出。';

  @override
  String get nativeError1204 => '无法启动 ScreenCaptureKit 音频捕获。';

  @override
  String get nativeError1205 => 'ScreenCaptureKit 音频捕获意外停止。';

  @override
  String get nativeError1206 => '启动 ScreenCaptureKit 音频捕获超时。';

  @override
  String get nativeErrorUnknown => '发生未知系统音频捕获错误。';

  @override
  String exceptionDetails(String message) {
    return '诊断信息：$message';
  }

  @override
  String get winMinimize => '最小化';

  @override
  String get winClose => '关闭';

  @override
  String get devicesTab => '设备';

  @override
  String get audioSettingsTab => '音频设置';

  @override
  String get monitorTab => '实时监控';

  @override
  String get audioSource => '音频来源';

  @override
  String get systemOutput => '系统输出回环';

  @override
  String get recordingInput => '录音输入';

  @override
  String get inputDevice => '采集设备';

  @override
  String get defaultDevice => '跟随系统默认';

  @override
  String get unavailableDevice => '已保存的设备不可用';

  @override
  String get refreshDevices => '刷新设备';

  @override
  String get audioFormat => '传输格式';

  @override
  String get pcm16Format => 'PCM 16 位';

  @override
  String get float32Format => 'Float 32 位';

  @override
  String get latencyProfile => '缓冲档位';

  @override
  String get lowLatencyProfile => '低延迟';

  @override
  String get balancedProfile => '均衡';

  @override
  String get stableProfile => '稳定';

  @override
  String get customProfile => '自定义';

  @override
  String get playbackBuffer => '播放缓冲目标';

  @override
  String get preRoll => '启动预填充';

  @override
  String get captureQueue => '采集队列上限';

  @override
  String get receiveChunk => '接收数据块';

  @override
  String get requestLowLatency => '请求低延迟输出';

  @override
  String get settingsLocked => '断开连接后可修改音频设置';

  @override
  String get settingsSaved => '设置将在下次连接时生效';

  @override
  String get resetSettings => '重置音频设置';

  @override
  String get activeFormat => '实际传输格式';

  @override
  String get waitingForAudio => '等待音频';

  @override
  String get monitoringOffline => '连接设备后开始监控';

  @override
  String get feedbackStale => '播放反馈不可用';

  @override
  String get channelLevels => '声道电平';

  @override
  String get channelLeft => '左声道';

  @override
  String get channelRight => '右声道';

  @override
  String get transferRate => '传输速率';

  @override
  String get queueHistory => '音频排队时长';

  @override
  String get captureQueueShort => '采集队列';

  @override
  String get playbackQueueShort => '播放队列估计';

  @override
  String get captureTiming => '采集间隔';

  @override
  String get sendTiming => '发送耗时';

  @override
  String get underruns => '播放欠载次数';

  @override
  String get droppedFrames => '丢弃帧数';

  @override
  String get discontinuities => '采集中断次数';

  @override
  String get effectiveBuffer => '实际播放缓冲';

  @override
  String get playbackRoute => '播放设备';

  @override
  String get performanceMode => '输出模式';

  @override
  String get modeLowLatency => '低延迟';

  @override
  String get modeStandard => '标准';

  @override
  String get unknownValue => '不可用';

  @override
  String get clearHistory => '清空图表历史';

  @override
  String get pauseCharts => '暂停图表';

  @override
  String get resumeCharts => '继续图表';

  @override
  String get recentHistory => '最近 60 秒';

  @override
  String get connectedStatus => '传输中';

  @override
  String get disconnectedStatus => '未连接';

  @override
  String get connectionCancelled => '取消连接';

  @override
  String get queueEstimateNote => '队列估计不含 ADB、系统输出和声学延迟。';

  @override
  String get floatFormatNote => '未压缩立体声；系统混音和播放仍可能改变采样。';

  @override
  String get queueDropNote => '采集队列满时丢弃旧音频，以避免延迟持续累积。';

  @override
  String get macSystemOnly => '系统音频采集';

  @override
  String get timeAxis => '时间（秒）';

  @override
  String get msUnit => '毫秒';

  @override
  String get winMaximize => '最大化';

  @override
  String get winRestore => '还原';

  @override
  String get heldCharts => '图表已暂停';

  @override
  String get sourceFormat => '采集格式';

  @override
  String get noSampleData => '暂无采样数据';
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw() : super('zh_TW');

  @override
  String get appTitle => 'AudioShare';

  @override
  String get ok => '確定';

  @override
  String get openSystemSettings => '打開系統設定';

  @override
  String get noDevices => '找不到裝置';

  @override
  String get connect => '連線';

  @override
  String get connecting => '連線中';

  @override
  String get disconnect => '中斷連線';

  @override
  String get autoConnectLastDevice => '自動連線到上次使用的裝置';

  @override
  String get language => '語言';

  @override
  String get followSystem => '跟隨系統';

  @override
  String get noLanguageMatch => '沒有符合的語言';

  @override
  String deviceAndroidVersion(String version, String apiLevel) {
    return 'Android $version（API $apiLevel）';
  }

  @override
  String deviceNetworkAddress(String ip, String port) {
    return ' - $ip:$port';
  }

  @override
  String get recordingPermissionTitle => '需要錄製權限';

  @override
  String get recordingPermissionDescription =>
      '請在「系統設定 > 隱私權與安全性 > 螢幕與系統音訊錄製」中允許 AudioShare。macOS 需要重新啟動應用程式才能讓新權限生效；請結束 AudioShare，重新開啟後再連線一次。';

  @override
  String get connectionFailedTitle => '連線失敗';

  @override
  String get captureInitializationFailed => '無法初始化系統音訊擷取。';

  @override
  String get captureStopped => '系統音訊擷取已停止。';

  @override
  String get captureStartFailed => '無法開始擷取系統音訊。';

  @override
  String get listenerStartFailed => '無法啟動本機音訊串流服務。';

  @override
  String get noAvailablePort => '沒有可用的本機監聽連接埠。';

  @override
  String get connectAndroidDeviceFailed => '連線 Android 裝置時發生錯誤。';

  @override
  String get connectDeviceFailed => '連線裝置時發生錯誤。';

  @override
  String nativeErrorDetails(String code) {
    return '錯誤碼：$code';
  }

  @override
  String get nativeError1000 => '系統音訊擷取初始化失敗。';

  @override
  String get nativeError1001 => '目前的 macOS 版本不支援系統音訊擷取。';

  @override
  String get nativeError1002 => '螢幕與系統音訊錄製權限無法使用。';

  @override
  String get nativeError1100 => '本機音訊監聽服務無法啟動。';

  @override
  String get nativeError1101 => '無法建立本機監聽通訊端。';

  @override
  String get nativeError1102 => '無法繫結本機監聽通訊端。';

  @override
  String get nativeError1103 => '本機監聽通訊端無法開始監聽。';

  @override
  String get nativeError1104 => '無法建立本機監聽執行緒。';

  @override
  String get nativeError1105 => '啟動本機監聽服務逾時。';

  @override
  String get nativeError1106 => '無法接受 Android 裝置連線。';

  @override
  String get nativeError1107 => '無法讀取 Android 裝置連線碼。';

  @override
  String get nativeError1200 => '無法開始擷取系統音訊。';

  @override
  String get nativeError1201 => '無法取得螢幕分享內容。';

  @override
  String get nativeError1202 => '沒有可用於系統音訊擷取的顯示器。';

  @override
  String get nativeError1203 => '無法設定 ScreenCaptureKit 音訊輸出。';

  @override
  String get nativeError1204 => '無法啟動 ScreenCaptureKit 音訊擷取。';

  @override
  String get nativeError1205 => 'ScreenCaptureKit 音訊擷取意外停止。';

  @override
  String get nativeError1206 => '啟動 ScreenCaptureKit 音訊擷取逾時。';

  @override
  String get nativeErrorUnknown => '發生未知的系統音訊擷取錯誤。';

  @override
  String exceptionDetails(String message) {
    return '診斷資訊：$message';
  }

  @override
  String get winMinimize => '最小化';

  @override
  String get winClose => '關閉';

  @override
  String get devicesTab => '裝置';

  @override
  String get audioSettingsTab => '音訊設定';

  @override
  String get monitorTab => '即時監控';

  @override
  String get audioSource => '音訊來源';

  @override
  String get systemOutput => '系統輸出回環';

  @override
  String get recordingInput => '錄音輸入';

  @override
  String get inputDevice => '擷取裝置';

  @override
  String get defaultDevice => '跟隨系統預設';

  @override
  String get unavailableDevice => '已儲存的裝置不可用';

  @override
  String get refreshDevices => '重新整理裝置';

  @override
  String get audioFormat => '傳輸格式';

  @override
  String get pcm16Format => 'PCM 16 位元';

  @override
  String get float32Format => 'Float 32 位元';

  @override
  String get latencyProfile => '緩衝設定';

  @override
  String get lowLatencyProfile => '低延遲';

  @override
  String get balancedProfile => '均衡';

  @override
  String get stableProfile => '穩定';

  @override
  String get customProfile => '自訂';

  @override
  String get playbackBuffer => '播放緩衝目標';

  @override
  String get preRoll => '啟動預填充';

  @override
  String get captureQueue => '擷取佇列上限';

  @override
  String get receiveChunk => '接收資料區塊';

  @override
  String get requestLowLatency => '請求低延遲輸出';

  @override
  String get settingsLocked => '中斷連線後可修改音訊設定';

  @override
  String get settingsSaved => '設定將於下次連線時生效';

  @override
  String get resetSettings => '重設音訊設定';

  @override
  String get activeFormat => '實際傳輸格式';

  @override
  String get waitingForAudio => '等待音訊';

  @override
  String get monitoringOffline => '連線裝置後開始監控';

  @override
  String get feedbackStale => '播放回饋不可用';

  @override
  String get channelLevels => '聲道電平';

  @override
  String get channelLeft => '左聲道';

  @override
  String get channelRight => '右聲道';

  @override
  String get transferRate => '傳輸速率';

  @override
  String get queueHistory => '音訊排隊時間';

  @override
  String get captureQueueShort => '擷取佇列';

  @override
  String get playbackQueueShort => '播放佇列估計';

  @override
  String get captureTiming => '擷取間隔';

  @override
  String get sendTiming => '傳送耗時';

  @override
  String get underruns => '播放欠載次數';

  @override
  String get droppedFrames => '捨棄影格數';

  @override
  String get discontinuities => '擷取中斷次數';

  @override
  String get effectiveBuffer => '實際播放緩衝';

  @override
  String get playbackRoute => '播放裝置';

  @override
  String get performanceMode => '輸出模式';

  @override
  String get modeLowLatency => '低延遲';

  @override
  String get modeStandard => '標準';

  @override
  String get unknownValue => '不可用';

  @override
  String get clearHistory => '清除圖表歷程';

  @override
  String get pauseCharts => '暫停圖表';

  @override
  String get resumeCharts => '繼續圖表';

  @override
  String get recentHistory => '最近 60 秒';

  @override
  String get connectedStatus => '傳輸中';

  @override
  String get disconnectedStatus => '未連線';

  @override
  String get connectionCancelled => '取消連線';

  @override
  String get queueEstimateNote => '佇列估計不含 ADB、系統輸出和聲學延遲。';

  @override
  String get floatFormatNote => '未壓縮立體聲；系統混音和播放仍可能改變取樣。';

  @override
  String get queueDropNote => '擷取佇列滿時捨棄舊音訊，以避免延遲持續累積。';

  @override
  String get macSystemOnly => '系統音訊擷取';

  @override
  String get timeAxis => '時間（秒）';

  @override
  String get msUnit => '毫秒';

  @override
  String get winMaximize => '最大化';

  @override
  String get winRestore => '還原';

  @override
  String get heldCharts => '圖表已暫停';

  @override
  String get sourceFormat => '擷取格式';

  @override
  String get noSampleData => '暫無取樣資料';
}
