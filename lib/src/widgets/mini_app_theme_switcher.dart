import 'package:flutter/material.dart';

/// The user's light/dark/system appearance choice, provided once near the
/// app root by the shell so every [MiniAppThemeSwitcher] below it follows
/// the same choice. Plain data — the shell owns the state (and persisting
/// it); this package stays free of any Cubit dependency.
class MiniAppThemeMode extends InheritedWidget {
  const MiniAppThemeMode({super.key, required this.mode, required super.child});

  final ThemeMode mode;

  /// [ThemeMode.system] when no [MiniAppThemeMode] is above [context].
  static ThemeMode of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<MiniAppThemeMode>()?.mode ?? ThemeMode.system;

  @override
  bool updateShouldNotify(MiniAppThemeMode oldWidget) => mode != oldWidget.mode;
}

/// Wraps a mini-app's page in its own light/dark theme, independent of
/// whatever theme the shell (or another installed mini-app) applies
/// globally — following the user's [MiniAppThemeMode] choice, or the
/// platform brightness when that's [ThemeMode.system]. Extracted after Tiaw
/// Jung's `TjTheme` and Ruay Jung's `RjTheme` turned out to be byte-for-byte
/// identical — each is now a couple of lines forwarding its own
/// `AppTheme.light`/`.dark` into this.
class MiniAppThemeSwitcher extends StatelessWidget {
  const MiniAppThemeSwitcher({super.key, required this.light, required this.dark, required this.child});

  final ThemeData light;
  final ThemeData dark;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = switch (MiniAppThemeMode.of(context)) {
      ThemeMode.light => false,
      ThemeMode.dark => true,
      ThemeMode.system => MediaQuery.platformBrightnessOf(context) == Brightness.dark,
    };
    return Theme(data: isDark ? dark : light, child: child);
  }
}
