import 'package:flutter/material.dart';

/// Builds a mini-app's [ThemeData] from its own [colorScheme] (and, optionally,
/// its own [textTheme]) on top of one shared Material 3 baseline.
///
/// This is the "custom theme support" every mini-app plugs into: the palette
/// and typography are supplied by the caller (e.g. AimJung's mid-century
/// rust/mustard scheme), never hardcoded here — this package owns the
/// mechanism, not any one app's visual identity.
ThemeData buildAppTheme({
  required ColorScheme colorScheme,
  TextTheme? textTheme,
}) {
  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    textTheme: textTheme,
    scaffoldBackgroundColor: colorScheme.surface,
  );
}
