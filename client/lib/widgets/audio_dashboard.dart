import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../data_source.dart';
import '../l10n/app_localizations_extensions.dart';
import '../l10n/generated/app_localizations.dart';
import '../models/audio_settings.dart';
import '../models/audio_stats.dart';

class AudioDashboard extends StatelessWidget {
  const AudioDashboard({super.key, required this.source});
  final DataSource source;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          TabBar(tabs: [
            Tab(
                icon: const Icon(Icons.devices, size: 20),
                text: l10n.devicesTab),
            Tab(
                icon: const Icon(Icons.tune, size: 20),
                text: l10n.audioSettingsTab),
            Tab(
                icon: const Icon(Icons.monitor_heart_outlined, size: 20),
                text: l10n.monitorTab),
          ]),
          Expanded(
            child: TabBarView(children: [
              _Devices(source: source),
              _AudioSettings(source: source),
              _Monitor(source: source),
            ]),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(children: [
              Checkbox(
                value: source.lastCheck,
                onChanged: (value) => source.lastCheck = value ?? false,
              ),
              Expanded(
                  child: Text(l10n.autoConnectLastDevice,
                      style: Theme.of(context).textTheme.bodySmall)),
              if (source.captureStats.running)
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(_format(source.captureStats),
                      style: Theme.of(context).textTheme.bodySmall),
                ),
            ]),
          ),
        ],
      ),
    );
  }
}

String _format(CaptureSnapshot stats) =>
    '${(stats.sampleRate / 1000).toStringAsFixed(stats.sampleRate % 1000 == 0 ? 0 : 1)} kHz'
    ' / ${stats.bits == 32 ? 'Float32' : 'PCM16'} / ${stats.channels} ch';

class _Devices extends StatelessWidget {
  const _Devices({required this.source});
  final DataSource source;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (source.deviceState == 0) {
      return const Center(child: CircularProgressIndicator());
    }
    if (source.devices.isEmpty) {
      return Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.usb_off_outlined,
            size: 40, color: Theme.of(context).colorScheme.onSurfaceVariant),
        const SizedBox(height: 16),
        Text(l10n.noDevices),
      ]));
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: source.devices.length,
      separatorBuilder: (_, __) => const Divider(height: 32),
      itemBuilder: (context, index) {
        final device = source.devices[index];
        final state = source.getConnectState(device.deviceId);
        final label = state == 1
            ? l10n.connectionCancelled
            : state == 2
                ? l10n.disconnect
                : l10n.connect;
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.only(top: 4, right: 12),
              child: Icon(device.usb ? Icons.usb : Icons.wifi, size: 28),
            ),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text('${device.manufacturer} ${device.model}',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(l10n.deviceAndroidVersionFormatted(device.androidVersion,
                      int.tryParse(device.apiLevel) ?? 0)),
                  if (!device.usb) Text('${device.ip}:${device.port}'),
                ])),
          ]),
          const SizedBox(height: 16),
          Wrap(
              spacing: 16,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                FilledButton.icon(
                  onPressed: source.getConnectEnable(device.deviceId)
                      ? () {
                          if (state == 0) {
                            source.connectDevice(device.deviceId,
                                userInitiated: true);
                          } else {
                            source.disconnectDevice(device.deviceId);
                          }
                        }
                      : null,
                  icon: state == 1
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : Icon(state == 2 ? Icons.stop : Icons.play_arrow,
                          size: 20),
                  label: Text(label),
                ),
                Text(
                    state == 1
                        ? l10n.connecting
                        : state == 2
                            ? l10n.connectedStatus
                            : l10n.disconnectedStatus,
                    style: TextStyle(
                        color: state == 2
                            ? Theme.of(context).colorScheme.primary
                            : null)),
              ]),
          if (state == 2) ...[
            const SizedBox(height: 24),
            _Metric(
                label: l10n.activeFormat, value: _format(source.captureStats)),
            if (source.playbackStats case final playback?)
              _Metric(
                  label: l10n.playbackRoute,
                  value:
                      playback.isFresh ? playback.route : l10n.feedbackStale),
          ],
        ]);
      },
    );
  }
}

class _AudioSettings extends StatelessWidget {
  const _AudioSettings({required this.source});
  final DataSource source;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final settings = source.settings;
    final enabled = source.settingsEnabled;
    final available =
        source.inputDevices.any((device) => device.id == settings.deviceId);
    String profile = 'custom';
    for (final id in ['low', 'balanced', 'stable']) {
      if (settings == settings.preset(id)) profile = id;
    }
    return ListView(padding: const EdgeInsets.all(20), children: [
      Text(enabled ? l10n.settingsSaved : l10n.settingsLocked,
          style:
              TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
      const SizedBox(height: 20),
      if (Platform.isWindows) ...[
        Text(l10n.audioSource, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        LayoutBuilder(builder: (context, constraints) {
          return SegmentedButton<AudioSource>(
            showSelectedIcon: false,
            segments: [
              ButtonSegment(
                  value: AudioSource.systemOutput,
                  icon: const Icon(Icons.volume_up_outlined),
                  label: Text(l10n.systemOutput)),
              ButtonSegment(
                  value: AudioSource.recordingInput,
                  icon: const Icon(Icons.mic_none),
                  label: Text(l10n.recordingInput)),
            ],
            selected: {settings.source},
            onSelectionChanged: enabled
                ? (value) => source.updateSettings(
                    settings.copyWith(source: value.first, deviceId: ''))
                : null,
          );
        }),
        const SizedBox(height: 20),
        Row(children: [
          Expanded(
              child: DropdownButtonFormField<String>(
            key: ValueKey(
                '${settings.source}-${settings.deviceId}-${source.inputDevices.length}'),
            initialValue: settings.deviceId,
            isExpanded: true,
            decoration: InputDecoration(
                labelText: l10n.inputDevice,
                border: const OutlineInputBorder()),
            items: [
              DropdownMenuItem(
                  value: '',
                  child: Text(l10n.defaultDevice,
                      overflow: TextOverflow.ellipsis)),
              if (settings.deviceId.isNotEmpty && !available)
                DropdownMenuItem(
                    value: settings.deviceId,
                    child: Text(l10n.unavailableDevice,
                        overflow: TextOverflow.ellipsis)),
              ...source.inputDevices.map((device) => DropdownMenuItem(
                    value: device.id,
                    child: Text('${device.name}${device.isDefault ? ' *' : ''}',
                        overflow: TextOverflow.ellipsis),
                  )),
            ],
            onChanged: enabled
                ? (id) =>
                    source.updateSettings(settings.copyWith(deviceId: id ?? ''))
                : null,
          )),
          const SizedBox(width: 8),
          IconButton(
              tooltip: l10n.refreshDevices,
              onPressed: source.refreshAudioDevices,
              icon: const Icon(Icons.refresh)),
        ]),
      ] else
        _Metric(label: l10n.audioSource, value: l10n.macSystemOnly),
      const SizedBox(height: 24),
      DropdownButtonFormField<bool>(
        initialValue: settings.floatOutput,
        key: ValueKey(settings.floatOutput),
        decoration: InputDecoration(
            labelText: l10n.audioFormat, border: const OutlineInputBorder()),
        items: [
          DropdownMenuItem(value: false, child: Text(l10n.pcm16Format)),
          DropdownMenuItem(value: true, child: Text(l10n.float32Format)),
        ],
        onChanged: enabled
            ? (value) =>
                source.updateSettings(settings.copyWith(floatOutput: value))
            : null,
      ),
      const SizedBox(height: 8),
      Text(l10n.floatFormatNote, style: Theme.of(context).textTheme.bodySmall),
      const Divider(height: 40),
      Text(l10n.latencyProfile, style: Theme.of(context).textTheme.titleSmall),
      const SizedBox(height: 8),
      SegmentedButton<String>(
        segments: [
          ButtonSegment(value: 'low', label: Text(l10n.lowLatencyProfile)),
          ButtonSegment(value: 'balanced', label: Text(l10n.balancedProfile)),
          ButtonSegment(value: 'stable', label: Text(l10n.stableProfile)),
        ],
        selected: profile == 'custom' ? <String>{} : {profile},
        emptySelectionAllowed: true,
        showSelectedIcon: false,
        onSelectionChanged: enabled
            ? (selected) {
                if (selected.isNotEmpty) {
                  source.updateSettings(settings.preset(selected.first));
                }
              }
            : null,
      ),
      if (profile == 'custom')
        Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(l10n.customProfile,
                style: Theme.of(context).textTheme.bodySmall)),
      const SizedBox(height: 16),
      _BufferControl(
          label: l10n.playbackBuffer,
          value: settings.bufferMs,
          min: 10,
          max: 500,
          step: 5,
          enabled: enabled,
          onChanged: (value) =>
              source.updateSettings(settings.copyWith(bufferMs: value))),
      _BufferControl(
          label: l10n.preRoll,
          value: settings.preRollMs,
          min: 0,
          max: math.min(settings.bufferMs, 250),
          step: 1,
          enabled: enabled,
          onChanged: (value) =>
              source.updateSettings(settings.copyWith(preRollMs: value))),
      _BufferControl(
          label: l10n.receiveChunk,
          value: settings.readChunkMs,
          min: 1,
          max: 40,
          step: 1,
          enabled: enabled,
          onChanged: (value) =>
              source.updateSettings(settings.copyWith(readChunkMs: value))),
      _BufferControl(
          label: l10n.captureQueue,
          value: settings.queueMs,
          min: 10,
          max: 500,
          step: 5,
          enabled: enabled,
          onChanged: (value) =>
              source.updateSettings(settings.copyWith(queueMs: value))),
      Text(l10n.queueDropNote, style: Theme.of(context).textTheme.bodySmall),
      const SizedBox(height: 12),
      SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(l10n.requestLowLatency),
        value: settings.lowLatency,
        onChanged: enabled
            ? (value) =>
                source.updateSettings(settings.copyWith(lowLatency: value))
            : null,
      ),
      Align(
          alignment: AlignmentDirectional.centerStart,
          child: TextButton.icon(
            onPressed: enabled
                ? () => source.updateSettings(const AudioSettings())
                : null,
            icon: const Icon(Icons.restart_alt),
            label: Text(l10n.resetSettings),
          )),
    ]);
  }
}

class _BufferControl extends StatelessWidget {
  const _BufferControl(
      {required this.label,
      required this.value,
      required this.min,
      required this.max,
      required this.step,
      required this.enabled,
      required this.onChanged});
  final String label;
  final int value, min, max, step;
  final bool enabled;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(children: [
        Row(children: [
          Expanded(child: Text(label)),
          const SizedBox(width: 12),
          SizedBox(
              width: 76,
              child: Text('${l10n.formatNumber(value)} ${l10n.msUnit}',
                  textAlign: TextAlign.end)),
        ]),
        Slider(
          value: value.toDouble(),
          min: min.toDouble(),
          max: max.toDouble(),
          divisions: ((max - min) / step).round(),
          label: '${l10n.formatNumber(value)} ${l10n.msUnit}',
          onChanged: enabled ? (value) => onChanged(value.round()) : null,
        ),
      ]),
    );
  }
}

class _Monitor extends StatefulWidget {
  const _Monitor({required this.source});
  final DataSource source;
  @override
  State<_Monitor> createState() => _MonitorState();
}

class _MonitorState extends State<_Monitor> {
  List<AudioHistorySample>? _held;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final source = widget.source;
    final samples = _held ?? source.history;
    final stats = source.captureStats;
    final playback = source.playbackStats;
    final live = source.hasSession && stats.running;
    final freshPlayback = live && playback?.isFresh == true ? playback : null;
    final colors = Theme.of(context).colorScheme;
    return ListView(padding: const EdgeInsets.all(20), children: [
      Row(children: [
        Expanded(
            child: Text(
                _held != null
                    ? l10n.heldCharts
                    : live
                        ? l10n.connectedStatus
                        : l10n.monitoringOffline,
                style: Theme.of(context).textTheme.titleMedium)),
        IconButton(
          tooltip: _held == null ? l10n.pauseCharts : l10n.resumeCharts,
          icon: Icon(_held == null ? Icons.pause : Icons.play_arrow),
          onPressed: () =>
              setState(() => _held = _held == null ? source.history : null),
        ),
        IconButton(
            tooltip: l10n.clearHistory,
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              source.clearHistory();
              setState(() {
                if (_held != null) _held = [];
              });
            }),
      ]),
      const SizedBox(height: 12),
      _Metric(
          label: l10n.activeFormat,
          value: live ? _format(stats) : l10n.waitingForAudio),
      if (live)
        _Metric(
            label: l10n.sourceFormat,
            value: '${stats.inputBits} bit / ${stats.inputChannels} ch'),
      const SizedBox(height: 20),
      Text(l10n.channelLevels, style: Theme.of(context).textTheme.titleSmall),
      const SizedBox(height: 12),
      _LevelMeter(
          label: l10n.channelLeft,
          peak: live ? stats.peakLeft : 0,
          rms: live ? stats.rmsLeft : 0,
          color: colors.primary),
      _LevelMeter(
          label: l10n.channelRight,
          peak: live ? stats.peakRight : 0,
          rms: live ? stats.rmsRight : 0,
          color: const Color(0xFF3574BE)),
      const Divider(height: 36),
      _HistoryChart(
        title: l10n.transferRate,
        unit: 'kb/s',
        samples: samples,
        series: [
          (
            l10n.transferRate,
            colors.primary,
            (AudioHistorySample value) => value.kilobitsPerSecond
          )
        ],
        minimumMax: 1600,
      ),
      const SizedBox(height: 28),
      _HistoryChart(
        title: l10n.queueHistory,
        unit: l10n.msUnit,
        samples: samples,
        series: [
          (
            l10n.captureQueueShort,
            colors.primary,
            (AudioHistorySample s) => s.capture.queueMs
          ),
          (
            l10n.playbackQueueShort,
            const Color(0xFF3574BE),
            (AudioHistorySample s) => s.playback?.queueMs
          ),
        ],
        minimumMax: 50,
      ),
      const SizedBox(height: 8),
      Text(l10n.queueEstimateNote,
          style: Theme.of(context).textTheme.bodySmall),
      const Divider(height: 36),
      _Metric(
          label: l10n.captureTiming,
          value:
              live ? '${stats.captureIntervalMs.toStringAsFixed(1)} ms' : '-'),
      _Metric(
          label: l10n.sendTiming,
          value: live ? '${stats.sendTimeMs.toStringAsFixed(1)} ms' : '-'),
      _Metric(
          label: l10n.droppedFrames,
          value: l10n.formatNumber(stats.droppedFrames)),
      _Metric(
          label: l10n.discontinuities,
          value: l10n.formatNumber(stats.discontinuities)),
      _Metric(
          label: l10n.underruns,
          value: freshPlayback != null && freshPlayback.underruns >= 0
              ? l10n.formatNumber(freshPlayback.underruns)
              : l10n.unknownValue),
      _Metric(
          label: l10n.effectiveBuffer,
          value: freshPlayback != null
              ? '${freshPlayback.bufferMs.toStringAsFixed(1)} ms'
              : l10n.unknownValue),
      _Metric(
          label: l10n.performanceMode,
          value: freshPlayback == null
              ? l10n.unknownValue
              : freshPlayback.performanceMode == 1
                  ? l10n.modeLowLatency
                  : freshPlayback.performanceMode == 0
                      ? l10n.modeStandard
                      : l10n.unknownValue),
      _Metric(
          label: l10n.playbackRoute,
          value: freshPlayback?.route.isNotEmpty == true
              ? freshPlayback!.route
              : l10n.unknownValue),
      if (live && freshPlayback == null)
        Text(l10n.feedbackStale, style: TextStyle(color: colors.error)),
    ]);
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});
  final String label, value;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: LayoutBuilder(
            builder: (context, constraints) => constraints.maxWidth < 420
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Text(label,
                            style: Theme.of(context).textTheme.bodySmall),
                        const SizedBox(height: 3),
                        Text(value),
                      ])
                : Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(
                        child: Text(label,
                            style: Theme.of(context).textTheme.bodyMedium)),
                    const SizedBox(width: 20),
                    Flexible(child: Text(value, textAlign: TextAlign.end)),
                  ])),
      );
}

class _LevelMeter extends StatelessWidget {
  const _LevelMeter(
      {required this.label,
      required this.peak,
      required this.rms,
      required this.color});
  final String label;
  final double peak, rms;
  final Color color;
  double _db(double value) =>
      value <= 0 ? -60 : (20 * math.log(value) / math.ln10).clamp(-60, 6);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(children: [
          SizedBox(
              width: 76, child: Text(label, overflow: TextOverflow.ellipsis)),
          Expanded(
              child: Semantics(
            label: '$label ${_db(rms).toStringAsFixed(1)} dBFS',
            child: SizedBox(
                height: 12,
                child: LayoutBuilder(builder: (context, bounds) {
                  return Stack(children: [
                    Positioned.fill(
                        child: ColoredBox(
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest)),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                            width: bounds.maxWidth *
                                ((_db(rms) + 60) / 60).clamp(0, 1),
                            height: 12,
                            child: ColoredBox(color: color))),
                    Positioned(
                        left: (bounds.maxWidth *
                                    ((_db(peak) + 60) / 60).clamp(0, 1) -
                                2)
                            .clamp(0, math.max(0, bounds.maxWidth - 2)),
                        width: 2,
                        top: 0,
                        bottom: 0,
                        child:
                            ColoredBox(color: peak >= 1 ? Colors.red : color)),
                  ]);
                })),
          )),
          const SizedBox(width: 8),
          SizedBox(
              width: 94,
              child: Text('${_db(peak).toStringAsFixed(1)} dBFS',
                  textAlign: TextAlign.end,
                  style: Theme.of(context).textTheme.bodySmall)),
        ]),
      );
}

typedef _Series = (String, Color, double? Function(AudioHistorySample));

class _HistoryChart extends StatefulWidget {
  const _HistoryChart(
      {required this.title,
      required this.unit,
      required this.samples,
      required this.series,
      required this.minimumMax});
  final String title, unit;
  final List<AudioHistorySample> samples;
  final List<_Series> series;
  final double minimumMax;
  @override
  State<_HistoryChart> createState() => _HistoryChartState();
}

class _HistoryChartState extends State<_HistoryChart> {
  int? _hovered;
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    double maxValue = widget.minimumMax;
    for (final sample in widget.samples) {
      for (final series in widget.series) {
        maxValue = math.max(maxValue, (series.$3(sample) ?? 0) * 1.1);
      }
    }
    final hovered = _hovered != null && widget.samples.isNotEmpty
        ? widget.samples[_hovered!.clamp(0, widget.samples.length - 1)]
        : null;
    final latest = widget.samples.isEmpty ? null : widget.samples.last;
    final colors = Theme.of(context).colorScheme;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Wrap(
          alignment: WrapAlignment.spaceBetween,
          spacing: 24,
          runSpacing: 6,
          children: [
            Text(widget.title, style: Theme.of(context).textTheme.titleSmall),
            Text(l10n.recentHistory,
                style: Theme.of(context).textTheme.bodySmall),
          ]),
      const SizedBox(height: 10),
      Wrap(
          spacing: 20,
          runSpacing: 6,
          children: widget.series.map((series) {
            final value = (hovered ?? latest) == null
                ? null
                : series.$3((hovered ?? latest)!);
            return Row(mainAxisSize: MainAxisSize.min, children: [
              SizedBox(
                  width: 12, height: 3, child: ColoredBox(color: series.$2)),
              const SizedBox(width: 6),
              Text(
                  '${series.$1}: ${value?.toStringAsFixed(1) ?? '-'} ${widget.unit}',
                  style: Theme.of(context).textTheme.bodySmall),
            ]);
          }).toList()),
      const SizedBox(height: 12),
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
            width: 46,
            height: 128,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(maxValue.toStringAsFixed(0)),
                Text((maxValue / 2).toStringAsFixed(0)),
                const Text('0')
              ],
            )),
        Expanded(
            child: Column(children: [
          MouseRegion(
            onExit: (_) => setState(() => _hovered = null),
            child: LayoutBuilder(builder: (context, bounds) {
              return MouseRegion(
                  onHover: (event) {
                    if (widget.samples.isEmpty) return;
                    final last = widget.samples.last.elapsedSeconds;
                    final time = last -
                        60 +
                        (event.localPosition.dx / bounds.maxWidth).clamp(0, 1) *
                            60;
                    int best = 0;
                    for (int i = 1; i < widget.samples.length; ++i) {
                      if ((widget.samples[i].elapsedSeconds - time).abs() <
                          (widget.samples[best].elapsedSeconds - time).abs()) {
                        best = i;
                      }
                    }
                    setState(() => _hovered = best);
                  },
                  child: Semantics(
                      label: widget.title,
                      child: SizedBox(
                        width: double.infinity,
                        height: 128,
                        child: Stack(children: [
                          Positioned.fill(
                              child: CustomPaint(
                                  painter: _ChartPainter(
                            samples: widget.samples,
                            series: widget.series,
                            maxValue: maxValue,
                            gridColor: colors.outlineVariant,
                            hovered: hovered,
                          ))),
                          if (widget.samples.isEmpty)
                            Center(
                                child: Text(l10n.noSampleData,
                                    style:
                                        Theme.of(context).textTheme.bodySmall)),
                        ]),
                      )));
            }),
          ),
          const SizedBox(height: 6),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('-60'),
            const Text('-30'),
            Text(l10n.timeAxis),
          ]),
        ])),
      ]),
    ]);
  }
}

class _ChartPainter extends CustomPainter {
  const _ChartPainter(
      {required this.samples,
      required this.series,
      required this.maxValue,
      required this.gridColor,
      this.hovered});
  final List<AudioHistorySample> samples;
  final List<_Series> series;
  final double maxValue;
  final Color gridColor;
  final AudioHistorySample? hovered;
  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = gridColor
      ..strokeWidth = 1;
    for (int i = 0; i <= 2; i++) {
      final y = (size.height - 1) * i / 2;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
    if (samples.isEmpty) return;
    final start = samples.last.elapsedSeconds - 60;
    double x(double time) =>
        ((time - start) / 60 * size.width).clamp(0, size.width);
    for (final line in series) {
      final path = Path();
      bool first = true;
      for (final sample in samples) {
        final value = line.$3(sample);
        if (value == null) {
          first = true;
          continue;
        }
        final point = Offset(x(sample.elapsedSeconds),
            size.height - (value / maxValue).clamp(0, 1) * size.height);
        if (first) {
          path.moveTo(point.dx, point.dy);
          first = false;
        } else {
          path.lineTo(point.dx, point.dy);
        }
      }
      canvas.drawPath(
          path,
          Paint()
            ..color = line.$2
            ..strokeWidth = 2
            ..style = PaintingStyle.stroke);
    }
    if (hovered case final value?) {
      final position = x(value.elapsedSeconds);
      canvas.drawLine(Offset(position, 0), Offset(position, size.height), grid);
    }
  }

  @override
  bool shouldRepaint(covariant _ChartPainter oldDelegate) => true;
}
