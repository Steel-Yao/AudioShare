import 'package:flutter/widgets.dart';

/// The size the interface is designed for.
///
/// The desktop windows are created at this size. Every dimension in the app
/// is expressed against it and scaled to the viewport the app actually gets.
const Size designSize = Size(360, 540);

/// Existing dialogs use logical pixels so resizing the desktop window does
/// not enlarge their text or controls.
extension AdaptiveSize on num {
  double get w => toDouble();

  double get h => toDouble();

  double get sp => toDouble();
}
