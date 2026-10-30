import 'vault.dart';
import '../l10n/l10n.dart';

/// Activity history (Premium): what happened to which code, when and where. Kept in the vault's settings on
/// this device only (settings never sync), newest last, at most [maxActivity] events.
const activityKey = 'activity';
const maxActivity = 500;

/// Whether Premium is unlocked; set by the app (main.dart). Without it nothing is recorded.
bool Function() activityPremium = () => false;

enum ActivityKind {
  copied,
  filled,
  typed,
  shownQr,
  exported;

  String get label => switch (this) {
        copied => l10n.activityCopied,
        filled => l10n.activityFilled,
        typed => l10n.activityTyped,
        shownQr => l10n.activityShownQr,
        exported => l10n.activityExported,
      };
}

class ActivityEvent {
  ActivityEvent(this.kind, this.accountId, this.time, this.where);
  final ActivityKind kind;
  /// Null for an export of many accounts.
  final String? accountId;
  final DateTime time;
  /// Where it happened, in plain words: "This app", "Browser extension", "Quick pick", "Backup file"...
  final String where;

  Map<String, Object?> toJson() => {'k': kind.name, 'a': accountId, 't': time.toUtc().toIso8601String(), 'w': where};

  static ActivityEvent? fromJson(Object? j) {
    if (j is! Map) return null;
    final kind = ActivityKind.values.where((k) => k.name == j['k']).firstOrNull;
    final time = DateTime.tryParse(j['t'] as String? ?? '');
    if (kind == null || time == null) return null;
    return ActivityEvent(kind, j['a'] as String?, time, j['w'] as String? ?? '');
  }
}

/// Adds an event to [v]'s history (the caller saves the vault). Does nothing without Premium.
void logActivity(Vault v, ActivityKind kind, {String? accountId, required String where, DateTime? now}) {
  if (!activityPremium()) return;
  final list = [...(v.settings[activityKey] as List?) ?? const [], ActivityEvent(kind, accountId, now ?? DateTime.now(), where).toJson()];
  v.settings[activityKey] = list.length > maxActivity ? list.sublist(list.length - maxActivity) : list;
}

/// Newest first. Entries this version can't read are skipped rather than shown wrong.
List<ActivityEvent> activityOf(Vault v) =>
    [for (final j in ((v.settings[activityKey] as List?) ?? const []).reversed) ?ActivityEvent.fromJson(j)];

Future<void> clearActivity(Vault v) async {
  v.settings.remove(activityKey);
  await v.save();
}
