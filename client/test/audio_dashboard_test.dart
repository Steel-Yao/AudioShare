import 'dart:io';

import 'package:audioshare/data_source.dart';
import 'package:audioshare/l10n/generated/app_localizations.dart';
import 'package:audioshare/l10n/supported_languages.dart';
import 'package:audioshare/main.dart' show StartupFailureApp;
import 'package:audioshare/models/audio_settings.dart';
import 'package:audioshare/widgets/audio_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

class _DashboardSource extends DataSource {
  _DashboardSource() : super(startPolling: false);
  AudioSettings value = const AudioSettings();
  bool locked = false;
  @override
  AudioSettings get settings => value;
  @override
  int get deviceState => 1;
  @override
  bool get lastCheck => false;
  @override
  bool get settingsEnabled => !locked;
  @override
  List<AudioInputDevice> get inputDevices =>
      value.source == AudioSource.systemOutput
          ? [const AudioInputDevice('speaker', 'System speakers')]
          : [const AudioInputDevice('microphone', 'Recording microphone')];
  @override
  void updateSettings(AudioSettings settings) {
    value = settings;
    notifyListeners();
  }
}

void main() {
  testWidgets('startup failures show a diagnostic in a compact window',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(360, 520));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const StartupFailureApp(
        error: 'MissingPluginException: window_manager'));
    await tester.pumpAndSettle();
    expect(find.text('AudioShare'), findsOneWidget);
    expect(find.text('MissingPluginException: window_manager'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('source, format, presets, manual buffers, reset and session lock',
      (tester) async {
    final source = _DashboardSource();
    addTearDown(source.dispose);
    await tester.binding.setSurfaceSize(const Size(900, 720));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('en'),
      supportedLocales: supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Scaffold(
        body: ListenableBuilder(
          listenable: source,
          builder: (context, _) => AudioDashboard(source: source),
        ),
      ),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.tune));
    await tester.pumpAndSettle();
    if (Platform.isWindows) {
      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('System speakers').last);
      await tester.pumpAndSettle();
      expect(source.settings.deviceId, 'speaker');
      await tester.tap(find.byIcon(Icons.mic_none));
      await tester.pumpAndSettle();
      expect(source.settings.source, AudioSource.recordingInput);
      expect(source.settings.deviceId, isEmpty);
      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Recording microphone').last);
      await tester.pumpAndSettle();
      expect(source.settings.deviceId, 'microphone');
    }
    await tester.tap(find.byType(DropdownButtonFormField<bool>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Float 32-bit').last);
    await tester.pumpAndSettle();
    expect(source.settings.floatOutput, isTrue);
    await tester.ensureVisible(find.text('Low latency').first);
    await tester.tap(find.text('Low latency').first);
    await tester.pumpAndSettle();
    expect(source.settings.bufferMs, 20);
    expect(source.settings.preRollMs, 10);
    expect(source.settings.readChunkMs, 2);
    expect(source.settings.floatOutput, isTrue);
    await tester.tap(find.text('Stable'));
    await tester.pumpAndSettle();
    expect(source.settings.bufferMs, 100);
    expect(source.settings.queueMs, 160);
    await tester.ensureVisible(find.byType(Slider).first);
    await tester.drag(find.byType(Slider).first, const Offset(120, 0));
    await tester.pumpAndSettle();
    expect(source.settings.bufferMs, isNot(100));
    expect(find.text('Custom'), findsOneWidget);
    await tester.ensureVisible(find.byIcon(Icons.restart_alt));
    await tester.tap(find.byIcon(Icons.restart_alt));
    await tester.pumpAndSettle();
    expect(source.settings, const AudioSettings());
    source.locked = true;
    source.notifyListeners();
    await tester.pumpAndSettle();
    expect(tester.widget<Slider>(find.byType(Slider).first).onChanged, isNull);
    await tester.drag(find.byType(ListView).first, const Offset(0, 1800));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<DropdownButtonFormField<bool>>(
            find.byType(DropdownButtonFormField<bool>),
          )
          .onChanged,
      isNull,
    );
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });

  for (final locale in [
    const Locale('en'),
    const Locale('zh'),
    const Locale('ar')
  ]) {
    testWidgets('audio settings and monitor fit compact and desktop $locale',
        (tester) async {
      final source = _DashboardSource();
      addTearDown(source.dispose);
      for (final width in [360.0, 900.0]) {
        await tester.binding.setSurfaceSize(Size(width, 720));
        await tester.pumpWidget(MaterialApp(
          locale: locale,
          supportedLocales: supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: Scaffold(
              body: ListenableBuilder(
            listenable: source,
            builder: (context, _) => AudioDashboard(source: source),
          )),
        ));
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.tune));
        await tester.pumpAndSettle();
        expect(find.byType(DropdownButtonFormField<bool>), findsOneWidget);
        expect(tester.takeException(), isNull);
        await tester.tap(find.byIcon(Icons.monitor_heart_outlined));
        await tester.pumpAndSettle();
        expect(find.byIcon(Icons.pause), findsOneWidget);
        expect(tester.takeException(), isNull);
        await tester.tap(find.byIcon(Icons.pause));
        await tester.pump();
        expect(find.byIcon(Icons.play_arrow), findsOneWidget);
        await tester.tap(find.byIcon(Icons.delete_outline));
        await tester.pump();
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
      }
      await tester.binding.setSurfaceSize(null);
    });
  }
}
