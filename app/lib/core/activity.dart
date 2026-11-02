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

/// Where something happened, saved as a code and put into words in the reader's language when shown.
enum ActivityPlace {
  thisApp,
  quickPick,
  browserExtension,
  phoneLink,
  backupFile,
  setupLinksFile,
  paperBackup,
  googleQrCodes;

  String get label => switch (this) {
        thisApp => l10n.activityPlaceThisApp,
        quickPick => l10n.quickPickTitle,
        browserExtension => l10n.serverBrowserExtension,
        phoneLink => l10n.phoneUiActivityWhere,
        backupFile => l10n.activityPlaceBackupFile,
        setupLinksFile => l10n.activityPlaceSetupLinks,
        paperBackup => l10n.activityPlacePaperBackup,
        googleQrCodes => l10n.activityPlaceGoogleQr,
      };
}

class ActivityEvent {
  ActivityEvent(this.kind, this.accountId, this.time, this.where, {this.place});
  final ActivityKind kind;
  /// Null for an export of many accounts.
  final String? accountId;
  final DateTime time;
  /// A known place ([where] is then empty), or null for a name that needs no translating (Raycast, a file name)
  /// and for entries saved before places were codes, whose English text in [where] is shown as it is.
  final ActivityPlace? place;
  final String where;

  /// What to show for where it happened, in the current language when it is a known place.
  String get whereText => place?.label ?? where;

  Map<String, Object?> toJson() =>
      {'k': kind.name, 'a': accountId, 't': time.toUtc().toIso8601String(), if (place != null) 'p': place!.name else 'w': where};

  static ActivityEvent? fromJson(Object? j) {
    if (j is! Map) return null;
    final kind = ActivityKind.values.where((k) => k.name == j['k']).firstOrNull;
    final time = DateTime.tryParse(j['t'] as String? ?? '');
    if (kind == null || time == null) return null;
    final place = ActivityPlace.values.where((p) => p.name == j['p']).firstOrNull;
    return ActivityEvent(kind, j['a'] as String?, time, j['w'] as String? ?? '', place: place);
  }
}

/// Adds an event to [v]'s history (the caller saves the vault). Does nothing without Premium. Pass [place] for a
/// known place, or [where] for a name that is the same in every language.
void logActivity(Vault v, ActivityKind kind, {String? accountId, ActivityPlace? place, String where = '', DateTime? now}) {
  if (!activityPremium()) return;
  final list = [
    ...(v.settings[activityKey] as List?) ?? const [],
    ActivityEvent(kind, accountId, now ?? DateTime.now(), where, place: place).toJson(),
  ];
  v.settings[activityKey] = list.length > maxActivity ? list.sublist(list.length - maxActivity) : list;
}

/// Newest first. Entries this version can't read are skipped rather than shown wrong.
List<ActivityEvent> activityOf(Vault v) =>
    [for (final j in ((v.settings[activityKey] as List?) ?? const []).reversed) ?ActivityEvent.fromJson(j)];

Future<void> clearActivity(Vault v) async {
  v.settings.remove(activityKey);
  await v.save();
}
