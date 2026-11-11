import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

const Size kDesktopInitialWindowSize = Size(900, 720);
const Size kDesktopMinimumWindowSize = Size(360, 520);

const double kTitleBarHeight = 44;
const double kCaptionButtonWidth = 46;
const double kCaptionButtonHeight = kTitleBarHeight;

/// Prepares the resizable desktop window before anything is drawn.
///
/// Both runners show the window on Flutter's first frame, so applying the
/// borderless options here — right before runApp — means the user never
/// catches the native system title bar mid-transition.
///
/// Windows hides the system title bar entirely and draws its own caption row
/// (see window/window_chrome.dart). macOS also hides the title bar but keeps
/// the native traffic lights, inset as a leading empty zone in the caption
/// row.
///
Future<void> configureDesktopWindow() async {
  if (!Platform.isWindows && !Platform.isLinux && !Platform.isMacOS) {
    return;
  }

  await windowManager.ensureInitialized();
  if (Platform.isMacOS) {
    await windowManager.setTitleBarStyle(
      TitleBarStyle.hidden,
      windowButtonVisibility: true,
    );
    await windowManager.setMinimumSize(kDesktopMinimumWindowSize);
    await windowManager.setResizable(true);
    await windowManager.setMaximizable(true);
    return;
  }

  final windowOptions = WindowOptions(
    title: 'AudioShare',
    size: kDesktopInitialWindowSize,
    minimumSize: kDesktopMinimumWindowSize,
    center: true,
    titleBarStyle: TitleBarStyle.hidden,
    windowButtonVisibility: Platform.isWindows ? false : null,
    backgroundColor: Platform.isWindows ? Colors.transparent : null,
  );

  if (Platform.isWindows) {
    // The runner shows the window after Flutter's first frame, so no show()
    // callback is needed — applying the options alone is enough.
    await windowManager.waitUntilReadyToShow(windowOptions);
    await windowManager.setResizable(true);
    await windowManager.setMaximizable(true);
    await windowManager.setPreventClose(true);
    return;
  }

  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
}
