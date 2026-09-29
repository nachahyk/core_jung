/// Generic timing/layout tokens shared across mini-apps — not tied to any
/// one app's branding or copy (contrast with e.g. AimJung's own restaurant
/// name/hours, which stay local to that package).
class AppDurations {
  const AppDurations._();

  static const Duration splash = Duration(milliseconds: 1400);
  static const Duration toast = Duration(seconds: 2);
}

class AppLayout {
  const AppLayout._();

  static const double maxContentWidth = 480;
}
