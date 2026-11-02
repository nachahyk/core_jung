import 'package:flutter/material.dart';

/// A mini-app's launch screen: its logo as an app-icon tile over its name,
/// easing in. Pure UI — the page that shows it decides how long it stays and
/// where to go next. Colors come from the ambient theme, so each mini-app's
/// own (light or dark) theme drives it.
class MiniAppSplash extends StatelessWidget {
  const MiniAppSplash({super.key, required this.logo, required this.title});

  /// The app's logo artwork — e.g. `AssetImage('assets/logo.png', package: ...)`.
  final ImageProvider logo;
  final String title;

  static const _logoSize = 144.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    return Scaffold(
      body: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: reduceMotion ? 1 : 0, end: 1),
          duration: const Duration(milliseconds: 520),
          curve: Curves.easeOutBack,
          builder: (context, t, child) => Opacity(
            opacity: t.clamp(0.0, 1.0),
            child: Transform.scale(scale: 0.86 + 0.14 * t, child: child),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(36),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.16), blurRadius: 24, offset: const Offset(0, 10)),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(36),
                  child: Image(
                    image: logo,
                    width: _logoSize,
                    height: _logoSize,
                    fit: BoxFit.cover,
                    semanticLabel: title,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -0.3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
