// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'AudioShare';

  @override
  String get ok => 'OK';

  @override
  String get openSystemSettings => 'Otwórz Ustawienia systemowe';

  @override
  String get noDevices => 'Nie znaleziono urządzeń';

  @override
  String get connect => 'Połącz';

  @override
  String get connecting => 'Łączenie';

  @override
  String get disconnect => 'Odłącz';

  @override
  String get autoConnectLastDevice =>
      'Automatycznie łącz z ostatnio używanym urządzeniem';

  @override
  String get language => 'Język';

  @override
  String get followSystem => 'Zgodnie z systemem';

  @override
  String get noLanguageMatch => 'Brak pasującego języka';

  @override
  String deviceAndroidVersion(String version, String apiLevel) {
    return 'Android $version (API $apiLevel)';
  }

  @override
  String deviceNetworkAddress(String ip, String port) {
    return ' - $ip:$port';
  }

  @override
  String get recordingPermissionTitle => 'Wymagane uprawnienia do nagrywania';

  @override
  String get recordingPermissionDescription =>
      'W Ustawieniach systemowych przejdź do Prywatności i bezpieczeństwa > Nagrywanie ekranu i dźwięku systemowego i zezwól na AudioShare. macOS wymaga ponownego uruchomienia aplikacji, aby nowe uprawnienie zaczęło obowiązywać; zamknij AudioShare, otwórz go ponownie, a następnie połącz się jeszcze raz.';

  @override
  String get connectionFailedTitle => 'Połączenie nieudane';

  @override
  String get captureInitializationFailed =>
      'Nie udało się zainicjalizować przechwytywania dźwięku systemowego.';

  @override
  String get captureStopped =>
      'Przechwytywanie dźwięku systemowego zostało zatrzymane.';

  @override
  String get captureStartFailed =>
      'Nie udało się rozpocząć przechwytywania dźwięku systemowego.';

  @override
  String get listenerStartFailed =>
      'Nie udało się uruchomić lokalnej usługi strumieniowania dźwięku.';

  @override
  String get noAvailablePort => 'Brak dostępnych lokalnych portów nasłuchu.';

  @override
  String get connectAndroidDeviceFailed =>
      'Podczas łączenia z urządzeniem z systemem Android wystąpił błąd.';

  @override
  String get connectDeviceFailed =>
      'Podczas łączenia z urządzeniem wystąpił błąd.';

  @override
  String nativeErrorDetails(String code) {
    return 'Kod błędu: $code';
  }

  @override
  String get nativeError1000 =>
      'Nie udało się zainicjalizować przechwytywania dźwięku.';

  @override
  String get nativeError1001 =>
      'Ta wersja systemu macOS nie obsługuje przechwytywania dźwięku systemowego.';

  @override
  String get nativeError1002 =>
      'Uprawnienie do nagrywania ekranu i dźwięku systemowego jest niedostępne.';

  @override
  String get nativeError1100 =>
      'Nie udało się uruchomić lokalnego nasłuchu dźwięku.';

  @override
  String get nativeError1101 =>
      'Nie udało się utworzyć lokalnego gniazda nasłuchowego.';

  @override
  String get nativeError1102 =>
      'Nie udało się powiązać lokalnego gniazda nasłuchowego.';

  @override
  String get nativeError1103 =>
      'Lokalne gniazdo nasłuchowe nie mogło rozpocząć nasłuchu.';

  @override
  String get nativeError1104 =>
      'Nie udało się utworzyć wątku nasłuchu lokalnego.';

  @override
  String get nativeError1105 =>
      'Uruchamianie nasłuchu lokalnego przekroczyło limit czasu.';

  @override
  String get nativeError1106 =>
      'Nie udało się przyjąć połączenia z urządzenia z systemem Android.';

  @override
  String get nativeError1107 =>
      'Nie udało się odczytać kodu połączenia urządzenia z systemem Android.';

  @override
  String get nativeError1200 =>
      'Nie udało się rozpocząć przechwytywania dźwięku systemowego.';

  @override
  String get nativeError1201 =>
      'Nie udało się pobrać zawartości udostępniania ekranu.';

  @override
  String get nativeError1202 =>
      'Brak wyświetlaczy dostępnych do przechwytywania dźwięku systemowego.';

  @override
  String get nativeError1203 =>
      'Nie udało się skonfigurować wyjścia audio ScreenCaptureKit.';

  @override
  String get nativeError1204 =>
      'Nie udało się rozpocząć przechwytywania dźwięku w ScreenCaptureKit.';

  @override
  String get nativeError1205 =>
      'Przechwytywanie dźwięku w ScreenCaptureKit zakończyło się niespodziewanie.';

  @override
  String get nativeError1206 =>
      'Uruchamianie przechwytywania dźwięku w ScreenCaptureKit przekroczyło limit czasu.';

  @override
  String get nativeErrorUnknown =>
      'Wystąpił nieznany błąd przechwytywania dźwięku systemowego.';

  @override
  String exceptionDetails(String message) {
    return 'Diagnostyka: $message';
  }

  @override
  String get winMinimize => 'Minimalizuj';

  @override
  String get winClose => 'Zamknij';

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
