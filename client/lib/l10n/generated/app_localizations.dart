import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_cs.dart';
import 'app_localizations_da.dart';
import 'app_localizations_de.dart';
import 'app_localizations_el.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fi.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_he.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_hu.dart';
import 'app_localizations_id.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ro.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_sv.dart';
import 'app_localizations_th.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_uk.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('cs'),
    Locale('da'),
    Locale('de'),
    Locale('el'),
    Locale('en'),
    Locale('es'),
    Locale('fi'),
    Locale('fr'),
    Locale('he'),
    Locale('hi'),
    Locale('hu'),
    Locale('id'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('nl'),
    Locale('pl'),
    Locale('pt'),
    Locale('ro'),
    Locale('ru'),
    Locale('sv'),
    Locale('th'),
    Locale('tr'),
    Locale('uk'),
    Locale('vi'),
    Locale('zh'),
    Locale('zh', 'TW')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'AudioShare'**
  String get appTitle;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @openSystemSettings.
  ///
  /// In en, this message translates to:
  /// **'Open System Settings'**
  String get openSystemSettings;

  /// No description provided for @noDevices.
  ///
  /// In en, this message translates to:
  /// **'No devices found'**
  String get noDevices;

  /// No description provided for @connect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connect;

  /// No description provided for @connecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting'**
  String get connecting;

  /// No description provided for @disconnect.
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get disconnect;

  /// No description provided for @autoConnectLastDevice.
  ///
  /// In en, this message translates to:
  /// **'Automatically connect to the last used device'**
  String get autoConnectLastDevice;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @followSystem.
  ///
  /// In en, this message translates to:
  /// **'Follow system'**
  String get followSystem;

  /// No description provided for @noLanguageMatch.
  ///
  /// In en, this message translates to:
  /// **'No matching language'**
  String get noLanguageMatch;

  /// No description provided for @deviceAndroidVersion.
  ///
  /// In en, this message translates to:
  /// **'Android {version} (API {apiLevel})'**
  String deviceAndroidVersion(String version, String apiLevel);

  /// No description provided for @deviceNetworkAddress.
  ///
  /// In en, this message translates to:
  /// **' - {ip}:{port}'**
  String deviceNetworkAddress(String ip, String port);

  /// No description provided for @recordingPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Recording permission required'**
  String get recordingPermissionTitle;

  /// No description provided for @recordingPermissionDescription.
  ///
  /// In en, this message translates to:
  /// **'In System Settings, go to Privacy & Security > Screen & System Audio Recording and allow AudioShare. macOS requires the app to restart before the new permission takes effect; quit and reopen AudioShare, then connect again.'**
  String get recordingPermissionDescription;

  /// No description provided for @connectionFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Connection failed'**
  String get connectionFailedTitle;

  /// No description provided for @captureInitializationFailed.
  ///
  /// In en, this message translates to:
  /// **'System audio capture could not be initialized.'**
  String get captureInitializationFailed;

  /// No description provided for @captureStopped.
  ///
  /// In en, this message translates to:
  /// **'System audio capture stopped.'**
  String get captureStopped;

  /// No description provided for @captureStartFailed.
  ///
  /// In en, this message translates to:
  /// **'System audio capture could not be started.'**
  String get captureStartFailed;

  /// No description provided for @listenerStartFailed.
  ///
  /// In en, this message translates to:
  /// **'The local audio streaming service could not be started.'**
  String get listenerStartFailed;

  /// No description provided for @noAvailablePort.
  ///
  /// In en, this message translates to:
  /// **'No local listening port is available.'**
  String get noAvailablePort;

  /// No description provided for @connectAndroidDeviceFailed.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while connecting to the Android device.'**
  String get connectAndroidDeviceFailed;

  /// No description provided for @connectDeviceFailed.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while connecting to the device.'**
  String get connectDeviceFailed;

  /// No description provided for @nativeErrorDetails.
  ///
  /// In en, this message translates to:
  /// **'Error code: {code}'**
  String nativeErrorDetails(String code);

  /// No description provided for @nativeError1000.
  ///
  /// In en, this message translates to:
  /// **'Audio capture initialization failed.'**
  String get nativeError1000;

  /// No description provided for @nativeError1001.
  ///
  /// In en, this message translates to:
  /// **'This macOS version does not support system audio capture.'**
  String get nativeError1001;

  /// No description provided for @nativeError1002.
  ///
  /// In en, this message translates to:
  /// **'Screen and system audio recording permission is unavailable.'**
  String get nativeError1002;

  /// No description provided for @nativeError1100.
  ///
  /// In en, this message translates to:
  /// **'The local audio listener could not be started.'**
  String get nativeError1100;

  /// No description provided for @nativeError1101.
  ///
  /// In en, this message translates to:
  /// **'The local listening socket could not be created.'**
  String get nativeError1101;

  /// No description provided for @nativeError1102.
  ///
  /// In en, this message translates to:
  /// **'The local listening socket could not be bound.'**
  String get nativeError1102;

  /// No description provided for @nativeError1103.
  ///
  /// In en, this message translates to:
  /// **'The local listening socket could not start listening.'**
  String get nativeError1103;

  /// No description provided for @nativeError1104.
  ///
  /// In en, this message translates to:
  /// **'The local listener thread could not be created.'**
  String get nativeError1104;

  /// No description provided for @nativeError1105.
  ///
  /// In en, this message translates to:
  /// **'Starting the local listener timed out.'**
  String get nativeError1105;

  /// No description provided for @nativeError1106.
  ///
  /// In en, this message translates to:
  /// **'The Android connection could not be accepted.'**
  String get nativeError1106;

  /// No description provided for @nativeError1107.
  ///
  /// In en, this message translates to:
  /// **'The Android connection code could not be read.'**
  String get nativeError1107;

  /// No description provided for @nativeError1200.
  ///
  /// In en, this message translates to:
  /// **'System audio capture could not be started.'**
  String get nativeError1200;

  /// No description provided for @nativeError1201.
  ///
  /// In en, this message translates to:
  /// **'Screen sharing content could not be obtained.'**
  String get nativeError1201;

  /// No description provided for @nativeError1202.
  ///
  /// In en, this message translates to:
  /// **'No display is available for system audio capture.'**
  String get nativeError1202;

  /// No description provided for @nativeError1203.
  ///
  /// In en, this message translates to:
  /// **'ScreenCaptureKit audio output could not be configured.'**
  String get nativeError1203;

  /// No description provided for @nativeError1204.
  ///
  /// In en, this message translates to:
  /// **'ScreenCaptureKit audio capture could not be started.'**
  String get nativeError1204;

  /// No description provided for @nativeError1205.
  ///
  /// In en, this message translates to:
  /// **'ScreenCaptureKit audio capture stopped unexpectedly.'**
  String get nativeError1205;

  /// No description provided for @nativeError1206.
  ///
  /// In en, this message translates to:
  /// **'Starting ScreenCaptureKit audio capture timed out.'**
  String get nativeError1206;

  /// No description provided for @nativeErrorUnknown.
  ///
  /// In en, this message translates to:
  /// **'An unknown system audio capture error occurred.'**
  String get nativeErrorUnknown;

  /// No description provided for @exceptionDetails.
  ///
  /// In en, this message translates to:
  /// **'Diagnostic: {message}'**
  String exceptionDetails(String message);

  /// No description provided for @winMinimize.
  ///
  /// In en, this message translates to:
  /// **'Minimize'**
  String get winMinimize;

  /// No description provided for @winClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get winClose;

  /// No description provided for @devicesTab.
  ///
  /// In en, this message translates to:
  /// **'Devices'**
  String get devicesTab;

  /// No description provided for @audioSettingsTab.
  ///
  /// In en, this message translates to:
  /// **'Audio'**
  String get audioSettingsTab;

  /// No description provided for @monitorTab.
  ///
  /// In en, this message translates to:
  /// **'Monitor'**
  String get monitorTab;

  /// No description provided for @audioSource.
  ///
  /// In en, this message translates to:
  /// **'Audio source'**
  String get audioSource;

  /// No description provided for @systemOutput.
  ///
  /// In en, this message translates to:
  /// **'System output'**
  String get systemOutput;

  /// No description provided for @recordingInput.
  ///
  /// In en, this message translates to:
  /// **'Recording input'**
  String get recordingInput;

  /// No description provided for @inputDevice.
  ///
  /// In en, this message translates to:
  /// **'Capture device'**
  String get inputDevice;

  /// No description provided for @defaultDevice.
  ///
  /// In en, this message translates to:
  /// **'Follow system default'**
  String get defaultDevice;

  /// No description provided for @unavailableDevice.
  ///
  /// In en, this message translates to:
  /// **'Saved device unavailable'**
  String get unavailableDevice;

  /// No description provided for @refreshDevices.
  ///
  /// In en, this message translates to:
  /// **'Refresh devices'**
  String get refreshDevices;

  /// No description provided for @audioFormat.
  ///
  /// In en, this message translates to:
  /// **'Stream format'**
  String get audioFormat;

  /// No description provided for @pcm16Format.
  ///
  /// In en, this message translates to:
  /// **'PCM 16-bit'**
  String get pcm16Format;

  /// No description provided for @float32Format.
  ///
  /// In en, this message translates to:
  /// **'Float 32-bit'**
  String get float32Format;

  /// No description provided for @latencyProfile.
  ///
  /// In en, this message translates to:
  /// **'Buffer profile'**
  String get latencyProfile;

  /// No description provided for @lowLatencyProfile.
  ///
  /// In en, this message translates to:
  /// **'Low latency'**
  String get lowLatencyProfile;

  /// No description provided for @balancedProfile.
  ///
  /// In en, this message translates to:
  /// **'Balanced'**
  String get balancedProfile;

  /// No description provided for @stableProfile.
  ///
  /// In en, this message translates to:
  /// **'Stable'**
  String get stableProfile;

  /// No description provided for @customProfile.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get customProfile;

  /// No description provided for @playbackBuffer.
  ///
  /// In en, this message translates to:
  /// **'Playback buffer target'**
  String get playbackBuffer;

  /// No description provided for @preRoll.
  ///
  /// In en, this message translates to:
  /// **'Startup prefill'**
  String get preRoll;

  /// No description provided for @captureQueue.
  ///
  /// In en, this message translates to:
  /// **'Capture queue limit'**
  String get captureQueue;

  /// No description provided for @receiveChunk.
  ///
  /// In en, this message translates to:
  /// **'Receive block'**
  String get receiveChunk;

  /// No description provided for @requestLowLatency.
  ///
  /// In en, this message translates to:
  /// **'Request low latency output'**
  String get requestLowLatency;

  /// No description provided for @settingsLocked.
  ///
  /// In en, this message translates to:
  /// **'Disconnect to change audio settings'**
  String get settingsLocked;

  /// No description provided for @settingsSaved.
  ///
  /// In en, this message translates to:
  /// **'Settings apply on the next connection'**
  String get settingsSaved;

  /// No description provided for @resetSettings.
  ///
  /// In en, this message translates to:
  /// **'Reset audio settings'**
  String get resetSettings;

  /// No description provided for @activeFormat.
  ///
  /// In en, this message translates to:
  /// **'Active format'**
  String get activeFormat;

  /// No description provided for @waitingForAudio.
  ///
  /// In en, this message translates to:
  /// **'Waiting for audio'**
  String get waitingForAudio;

  /// No description provided for @monitoringOffline.
  ///
  /// In en, this message translates to:
  /// **'Connect a device to start monitoring'**
  String get monitoringOffline;

  /// No description provided for @feedbackStale.
  ///
  /// In en, this message translates to:
  /// **'Playback feedback unavailable'**
  String get feedbackStale;

  /// No description provided for @channelLevels.
  ///
  /// In en, this message translates to:
  /// **'Channel levels'**
  String get channelLevels;

  /// No description provided for @channelLeft.
  ///
  /// In en, this message translates to:
  /// **'Left'**
  String get channelLeft;

  /// No description provided for @channelRight.
  ///
  /// In en, this message translates to:
  /// **'Right'**
  String get channelRight;

  /// No description provided for @transferRate.
  ///
  /// In en, this message translates to:
  /// **'Transfer rate'**
  String get transferRate;

  /// No description provided for @queueHistory.
  ///
  /// In en, this message translates to:
  /// **'Queued audio'**
  String get queueHistory;

  /// No description provided for @captureQueueShort.
  ///
  /// In en, this message translates to:
  /// **'Capture'**
  String get captureQueueShort;

  /// No description provided for @playbackQueueShort.
  ///
  /// In en, this message translates to:
  /// **'Playback estimate'**
  String get playbackQueueShort;

  /// No description provided for @captureTiming.
  ///
  /// In en, this message translates to:
  /// **'Capture interval'**
  String get captureTiming;

  /// No description provided for @sendTiming.
  ///
  /// In en, this message translates to:
  /// **'Send time'**
  String get sendTiming;

  /// No description provided for @underruns.
  ///
  /// In en, this message translates to:
  /// **'Playback underruns'**
  String get underruns;

  /// No description provided for @droppedFrames.
  ///
  /// In en, this message translates to:
  /// **'Dropped frames'**
  String get droppedFrames;

  /// No description provided for @discontinuities.
  ///
  /// In en, this message translates to:
  /// **'Capture interruptions'**
  String get discontinuities;

  /// No description provided for @effectiveBuffer.
  ///
  /// In en, this message translates to:
  /// **'Effective playback buffer'**
  String get effectiveBuffer;

  /// No description provided for @playbackRoute.
  ///
  /// In en, this message translates to:
  /// **'Playback route'**
  String get playbackRoute;

  /// No description provided for @performanceMode.
  ///
  /// In en, this message translates to:
  /// **'Output mode'**
  String get performanceMode;

  /// No description provided for @modeLowLatency.
  ///
  /// In en, this message translates to:
  /// **'Low latency'**
  String get modeLowLatency;

  /// No description provided for @modeStandard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get modeStandard;

  /// No description provided for @unknownValue.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get unknownValue;

  /// No description provided for @clearHistory.
  ///
  /// In en, this message translates to:
  /// **'Clear chart history'**
  String get clearHistory;

  /// No description provided for @pauseCharts.
  ///
  /// In en, this message translates to:
  /// **'Pause charts'**
  String get pauseCharts;

  /// No description provided for @resumeCharts.
  ///
  /// In en, this message translates to:
  /// **'Resume charts'**
  String get resumeCharts;

  /// No description provided for @recentHistory.
  ///
  /// In en, this message translates to:
  /// **'Recent 60 seconds'**
  String get recentHistory;

  /// No description provided for @connectedStatus.
  ///
  /// In en, this message translates to:
  /// **'Streaming'**
  String get connectedStatus;

  /// No description provided for @disconnectedStatus.
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get disconnectedStatus;

  /// No description provided for @connectionCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancel connection'**
  String get connectionCancelled;

  /// No description provided for @queueEstimateNote.
  ///
  /// In en, this message translates to:
  /// **'Queue estimates exclude ADB, system output, and acoustic latency.'**
  String get queueEstimateNote;

  /// No description provided for @floatFormatNote.
  ///
  /// In en, this message translates to:
  /// **'Uncompressed stereo; system mixing and playback can still change samples.'**
  String get floatFormatNote;

  /// No description provided for @queueDropNote.
  ///
  /// In en, this message translates to:
  /// **'When the capture queue fills, old audio is dropped to keep playback current.'**
  String get queueDropNote;

  /// No description provided for @macSystemOnly.
  ///
  /// In en, this message translates to:
  /// **'System audio capture'**
  String get macSystemOnly;

  /// No description provided for @timeAxis.
  ///
  /// In en, this message translates to:
  /// **'Time (s)'**
  String get timeAxis;

  /// No description provided for @msUnit.
  ///
  /// In en, this message translates to:
  /// **'ms'**
  String get msUnit;

  /// No description provided for @winMaximize.
  ///
  /// In en, this message translates to:
  /// **'Maximize'**
  String get winMaximize;

  /// No description provided for @winRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get winRestore;

  /// No description provided for @heldCharts.
  ///
  /// In en, this message translates to:
  /// **'Charts paused'**
  String get heldCharts;

  /// No description provided for @sourceFormat.
  ///
  /// In en, this message translates to:
  /// **'Capture format'**
  String get sourceFormat;

  /// No description provided for @noSampleData.
  ///
  /// In en, this message translates to:
  /// **'No samples yet'**
  String get noSampleData;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'ar',
        'cs',
        'da',
        'de',
        'el',
        'en',
        'es',
        'fi',
        'fr',
        'he',
        'hi',
        'hu',
        'id',
        'it',
        'ja',
        'ko',
        'nl',
        'pl',
        'pt',
        'ro',
        'ru',
        'sv',
        'th',
        'tr',
        'uk',
        'vi',
        'zh'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'TW':
            return AppLocalizationsZhTw();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'cs':
      return AppLocalizationsCs();
    case 'da':
      return AppLocalizationsDa();
    case 'de':
      return AppLocalizationsDe();
    case 'el':
      return AppLocalizationsEl();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fi':
      return AppLocalizationsFi();
    case 'fr':
      return AppLocalizationsFr();
    case 'he':
      return AppLocalizationsHe();
    case 'hi':
      return AppLocalizationsHi();
    case 'hu':
      return AppLocalizationsHu();
    case 'id':
      return AppLocalizationsId();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'nl':
      return AppLocalizationsNl();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ro':
      return AppLocalizationsRo();
    case 'ru':
      return AppLocalizationsRu();
    case 'sv':
      return AppLocalizationsSv();
    case 'th':
      return AppLocalizationsTh();
    case 'tr':
      return AppLocalizationsTr();
    case 'uk':
      return AppLocalizationsUk();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
