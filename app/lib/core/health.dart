import 'phone_link.dart' show phoneLinksKey;
import 'security.dart';
import 'sync/sync_engine.dart' show syncState;
import 'sync/sync_service.dart' show syncOn;
import 'vault.dart';

/// The rows of the health check screen, in order.
enum HealthKind { sync, backup, clock, phoneLink, lock, recoveryCodes }

/// One row: green ([ok]) or yellow, with what the screen needs to say why.
class HealthItem {
  const HealthItem(this.kind, {required this.ok, this.when, this.count = 0, this.total = 0, this.set = true});
  final HealthKind kind;
  final bool ok;
  /// Last sync, last backup, or last clock check.
  final DateTime? when;
  /// Paired browsers (phone link), or accounts with recovery codes.
  final int count;
  /// Accounts that could have recovery codes.
  final int total;
  /// False when the thing isn't set up at all (sync off, never backed up, clock not checked yet).
  final bool set;
}

/// Sync older than this turns yellow.
const syncStaleAfter = Duration(days: 3);

/// Everything the health check shows. [clockWarning] / [clockCheckedAt] come from the clock check (null
/// [clockCheckedAt] means it hasn't run yet). [phone]: the phone link row only exists on phones.
List<HealthItem> healthCheck(Vault v, DateTime now, {required bool phone, String? clockWarning, DateTime? clockCheckedAt}) {
  final s = v.settings;
  final synced = syncOn(v) ? DateTime.tryParse(syncState(v)['lastSync'] as String? ?? '') : null;
  final backup = DateTime.tryParse(s[lastBackupKey] as String? ?? '');
  final links = (s[phoneLinksKey] as List?)?.length ?? 0;
  final accounts = v.visible;
  final covered = accounts.where((a) => a.recoveryCodes.any((r) => !r.used)).length;
  return [
    HealthItem(HealthKind.sync,
        ok: synced != null && now.difference(synced) < syncStaleAfter, when: synced, set: syncOn(v)),
    HealthItem(HealthKind.backup, ok: backupIsRecent(s, now), when: backup, set: backup != null),
    HealthItem(HealthKind.clock, ok: clockCheckedAt != null && clockWarning == null, when: clockCheckedAt, set: clockCheckedAt != null),
    if (phone) HealthItem(HealthKind.phoneLink, ok: links > 0, count: links, set: links > 0),
    HealthItem(HealthKind.lock, ok: isLockOn(s), set: isLockOn(s)),
    HealthItem(HealthKind.recoveryCodes, ok: covered == accounts.length, count: covered, total: accounts.length),
  ];
}
