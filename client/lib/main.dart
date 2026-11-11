import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' show ScreenUtilInit;
import 'package:window_manager/window_manager.dart';

import 'data_source.dart';
import 'l10n/app_localizations_extensions.dart';
import 'l10n/generated/app_localizations.dart';
import 'l10n/language_dialog.dart';
import 'l10n/supported_languages.dart';
import 'utils/prefs.dart';
import 'utils/size.dart';
import 'window/window_chrome.dart';
import 'window/window_configuration.dart';
import 'widgets/audio_dashboard.dart';

const _languagePreferenceKey = 'locale';

void main() {
  runZonedGuarded(
    () async {
      // The binding must be created and runApp called inside this same
      // zone: the framework raises a zone mismatch when the lifecycle is
      // split between zones.
      WidgetsFlutterBinding.ensureInitialized();
      Prefs.load();
      // Apply the borderless window style before anything is drawn: the
      // runner shows the window on Flutter's first frame, so configuring it
      // any later would briefly flash the native title bar.
      try {
        await configureDesktopWindow();
      } catch (error, stack) {
        debugPrint('Desktop window initialization failed: $error\n$stack');
        runApp(StartupFailureApp(error: error));
        return;
      }

      runApp(const ScreenUtilInit(
        designSize: designSize,
        child: AudioShareApp(),
      ));
    },
    (error, stack) {
      debugPrint('Uncaught error: $error\n$stack');
    },
  );
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
  };
}

class StartupFailureApp extends StatelessWidget {
  const StartupFailureApp({super.key, required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'AudioShare',
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('AudioShare',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 16),
                    const Text(
                        'Desktop window initialization failed. Rebuild or reinstall the complete application bundle.'),
                    const SizedBox(height: 16),
                    SelectableText(error.toString()),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}

class AudioShareApp extends StatefulWidget {
  const AudioShareApp({super.key});

  @override
  State<AudioShareApp> createState() => _AudioShareAppState();
}

class _AudioShareAppState extends State<AudioShareApp> {
  /// Whether the app follows the device language instead of a fixed one.
  late bool _followSystem;

  /// The language currently in use.
  late AppLanguage _language;

  @override
  void initState() {
    super.initState();
    final savedLanguage = Prefs.getString(_languagePreferenceKey);
    final pinned = savedLanguage == followSystemLanguageId
        ? null
        : languageById(savedLanguage);
    _followSystem = pinned == null;
    _language = pinned ?? _deviceLanguage;
  }

  /// The language the device reports, or English when the app has no
  /// translation for it.
  AppLanguage get _deviceLanguage =>
      resolveLanguage(WidgetsBinding.instance.platformDispatcher.locale) ??
      fallbackLanguage;

  /// The id of the selected language entry.
  String get _currentLanguageId =>
      _followSystem ? followSystemLanguageId : _language.id;

  void _setLanguage(String id) {
    final pinned = id == followSystemLanguageId ? null : languageById(id);
    if (pinned == null && id != followSystemLanguageId) return;
    Prefs.setString(_languagePreferenceKey, id);
    setState(() {
      _followSystem = pinned == null;
      _language = pinned ?? _deviceLanguage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AudioShare',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF147D64)),
        scaffoldBackgroundColor: const Color(0xFFFAFBFC),
        cardTheme: const CardThemeData(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(6))),
        ),
      ),
      locale: _language.locale,
      supportedLocales: supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: DesktopWindowFrame(
        child: AudioShareHomePage(
          onLanguageChanged: _setLanguage,
          currentLanguageId: _currentLanguageId,
          deviceLanguage: _deviceLanguage,
        ),
      ),
    );
  }
}

class AudioShareHomePage extends StatefulWidget {
  const AudioShareHomePage({
    super.key,
    required this.onLanguageChanged,
    required this.currentLanguageId,
    required this.deviceLanguage,
  });

  final ValueChanged<String> onLanguageChanged;

  /// The id of the selected language entry.
  final String currentLanguageId;

  /// The language the device reports.
  final AppLanguage deviceLanguage;

  @override
  State<AudioShareHomePage> createState() => _AudioShareHomePageState();
}

class _AudioShareHomePageState extends State<AudioShareHomePage>
    with WidgetsBindingObserver, WindowListener {
  late final DataSource _dataSource;
  Future<void>? _dataSourceCleanup;
  bool _closingWindow = false;
  bool _showingError = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (Platform.isWindows) windowManager.addListener(this);
    _dataSource = DataSource();
    _dataSource.addListener(_onDataSourceChanged);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      unawaited(_cleanupDataSource());
    }
  }

  Future<void> _cleanupDataSource() {
    if (_dataSourceCleanup != null) return _dataSourceCleanup!;
    _dataSource.removeListener(_onDataSourceChanged);
    return _dataSourceCleanup = _dataSource.shutdown();
  }

  @override
  void onWindowClose() async {
    if (_closingWindow) return;
    _closingWindow = true;
    try {
      await _cleanupDataSource().timeout(const Duration(seconds: 5));
    } catch (error, stack) {
      debugPrint('Audio session cleanup failed: $error\n$stack');
    } finally {
      await windowManager.destroy();
    }
  }

  void _onDataSourceChanged() {
    if (!mounted) return;
    setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((_) => _showPendingError());
  }

  String _errorDescription(AppLocalizations l10n, UiError error) {
    final description = switch (error.type) {
      UiErrorType.recordingPermissionRequired =>
        l10n.recordingPermissionDescription,
      UiErrorType.captureInitializationFailed =>
        l10n.captureInitializationFailed,
      UiErrorType.captureStopped => l10n.captureStopped,
      UiErrorType.captureStartFailed => l10n.captureStartFailed,
      UiErrorType.listenerStartFailed => l10n.listenerStartFailed,
      UiErrorType.noAvailablePort => l10n.noAvailablePort,
      UiErrorType.connectAndroidDeviceFailed => l10n.connectAndroidDeviceFailed,
      UiErrorType.connectDeviceFailed => l10n.connectDeviceFailed,
    };
    if (error.nativeError case final nativeError?) {
      final nativeDetails =
          '${l10n.nativeErrorDescription(nativeError.code)}\n\n${l10n.nativeErrorDetailsFormatted(nativeError.code)}';
      if (error.type == UiErrorType.recordingPermissionRequired) {
        return '$description\n\n$nativeDetails';
      }
      return nativeError.message.isEmpty
          ? nativeDetails
          : '$nativeDetails\n\n${l10n.exceptionDetails(nativeError.message)}';
    }
    if (error.exception case final exception?) {
      return '$description\n\n${l10n.exceptionDetails(exception.toString())}';
    }
    return description;
  }

  Future<void> _openScreenRecordingSettings() async {
    if (!Platform.isMacOS) return;
    const screenRecordingSettings =
        'x-apple.systempreferences:com.apple.preference.security?Privacy_ScreenCapture';
    const privacySettings =
        'x-apple.systempreferences:com.apple.preference.security';
    final result =
        await Process.run('/usr/bin/open', [screenRecordingSettings]);
    if (result.exitCode != 0) {
      await Process.run('/usr/bin/open', [privacySettings]);
    }
  }

  Future<void> _showPendingError() async {
    if (!mounted || _showingError) return;
    _showingError = true;
    try {
      while (mounted) {
        final error = _dataSource.takePendingError();
        if (error == null) break;
        if (!mounted) break;
        final l10n = AppLocalizations.of(context);
        await showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(error.type == UiErrorType.recordingPermissionRequired
                ? l10n.recordingPermissionTitle
                : l10n.connectionFailedTitle),
            content: SelectableText(_errorDescription(l10n, error)),
            actions: [
              if (error.type == UiErrorType.recordingPermissionRequired)
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    unawaited(_openScreenRecordingSettings());
                  },
                  child: Text(l10n.openSystemSettings),
                ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.ok),
              ),
            ],
          ),
        );
      }
    } finally {
      _showingError = false;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (Platform.isWindows) windowManager.removeListener(this);
    unawaited(_cleanupDataSource());
    super.dispose();
  }

  /// Opens the language dialog; its result goes back to [AudioShareApp].
  ///
  /// Lives outside the title bar so [TitleBar] stays stateless, and outside
  /// the button callbacks so every caller shares the mounted handling.
  Future<void> _openLanguageDialog() async {
    final selected = await LanguageDialog.show(
      context,
      currentId: widget.currentLanguageId,
      deviceLanguage: widget.deviceLanguage,
    );
    if (!mounted || selected == null) return;
    widget.onLanguageChanged(selected);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The borderless window draws its own caption row (title, languages,
      // minimize/maximize/close) instead of the system AppBar.
      appBar: TitleBar(onLanguagePressed: _openLanguageDialog),
      body: AudioDashboard(source: _dataSource),
    );
  }
}
