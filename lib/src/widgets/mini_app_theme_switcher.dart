import 'package:flutter/material.dart';

/// Wraps a mini-app's page in its own light/dark theme, independent of
/// whatever theme the shell (or another installed mini-app) applies
/// globally, following the platform brightness. Extracted after Tiaw Jung's
/// `TjTheme` and Ruay Jung's `RjTheme` turned out to be byte-for-byte
/// identical — each is now a couple of lines forwarding its own
/// `AppTheme.light`/`.dark` into this.
class MiniAppThemeSwitcher extends StatelessWidget {
  const MiniAppThemeSwitcher({super.key, required this.light, required this.dark, required this.child});

  final ThemeData light;
  final ThemeData dark;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    return Theme(data: isDark ? dark : light, child: child);
  }
}
