/// Generic "time ago" bucketing with no localization dependency of its own —
/// the caller supplies its own translated strings/builders (e.g. AimJung's
/// `Formatters.timeAgo` passes its generated `AppLocalizations` strings
/// through). Keeping this common instead of coupled to one app's l10n class
/// is what actually makes it reusable by a second mini-app with its own
/// translations.
class RelativeTimeFormatter {
  const RelativeTimeFormatter._();

  static String format(
    DateTime time, {
    required String justNow,
    required String Function(int minutes) minutesAgo,
    required String Function(int hours) hoursAgo,
    required String Function(int days) daysAgo,
    DateTime? now,
  }) {
    final diff = (now ?? DateTime.now()).difference(time);
    if (diff.inSeconds < 60) return justNow;
    if (diff.inMinutes < 60) return minutesAgo(diff.inMinutes);
    if (diff.inHours < 24) return hoursAgo(diff.inHours);
    return daysAgo(diff.inDays);
  }
}
