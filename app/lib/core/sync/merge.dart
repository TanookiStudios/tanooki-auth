// Sync merge: per account, last writer wins on the account's own updatedAt, with tombstones for accounts
// removed for good. Pure Dart, no I/O, so every rule is unit tested (test/sync_merge_test.dart).
import '../account.dart';

/// One decrypted sync record: an account, or a tombstone for an account removed for good.
/// (An account in Trash is still an account, with deletedAt set, so Trash and Restore sync too.)
class SyncItem {
  SyncItem.account(Account this.account)
      : id = account.id,
        time = account.updatedAt.millisecondsSinceEpoch;
  SyncItem.tombstone(this.id, this.time) : account = null;

  factory SyncItem.fromJson(Map<String, dynamic> j) => j['purgedAt'] != null
      ? SyncItem.tombstone(j['id'] as String, j['purgedAt'] as int)
      : SyncItem.account(Account.fromJson(j));

  final String id;
  final int time;
  final Account? account;
  bool get purged => account == null;

  Map<String, dynamic> toJson() => account?.toJson() ?? {'id': id, 'purgedAt': time};
}

/// True when [a] should replace [b], two versions of the same account. Later time wins. On a tie
/// (same millisecond on two devices) the result must not depend on which device runs this, so: a
/// tombstone beats an account, and between two accounts the larger content wins.
bool supersedes(SyncItem a, SyncItem b) {
  if (a.time != b.time) return a.time > b.time;
  if (a.purged != b.purged) return a.purged;
  if (a.purged) return false;
  return a.account!.syncContent.compareTo(b.account!.syncContent) > 0;
}

/// This device's current version of [id], if it has one.
SyncItem? localItem(List<Account> accounts, Map<String, int> tombstones, String id) {
  final a = accounts.where((x) => x.id == id).firstOrNull;
  if (a != null) return SyncItem.account(a);
  final t = tombstones[id];
  return t == null ? null : SyncItem.tombstone(id, t);
}

/// Every account and tombstone on this device, as sync records.
List<SyncItem> localItems(List<Account> accounts, Map<String, int> tombstones) => [
      for (final a in accounts) SyncItem.account(a),
      for (final e in tombstones.entries)
        if (!accounts.any((a) => a.id == e.key)) SyncItem.tombstone(e.key, e.value),
    ];

/// Merges [remote] into this device's [accounts] and [tombstones]. Returns true if anything changed.
///
/// Two devices that each add the same account (same secret) while offline end up with two ids for it.
/// Both devices keep the one with the smaller id and tombstone the other, so they agree without talking.
bool mergeRemote(List<Account> accounts, Map<String, int> tombstones, SyncItem remote) {
  final local = localItem(accounts, tombstones, remote.id);
  if (local != null && !supersedes(remote, local)) {
    // HOTP: a code once shown is spent, so the highest counter wins whichever copy is newer. The new
    // stamp makes this device push the raised counter on, so every device ends on the same one.
    final mine = local.account, theirs = remote.account;
    if (mine == null || theirs == null || theirs.counter <= mine.counter) return false;
    mine
      ..counter = theirs.counter
      ..updatedAt = _laterOf(mine.updatedAt, theirs.updatedAt).add(const Duration(milliseconds: 1));
    return true;
  }

  if (remote.purged) {
    accounts.removeWhere((a) => a.id == remote.id);
    tombstones[remote.id] = remote.time;
    return true;
  }

  final incoming = remote.account!;
  if (local == null && !incoming.trashed) {
    final twin = accounts.where((a) => !a.trashed && a.id != incoming.id && a.secret == incoming.secret).firstOrNull;
    if (twin != null) {
      if (twin.id.compareTo(incoming.id) < 0) {
        tombstones[incoming.id] = remote.time + 1; // keep ours; this tombstone tells the other device
        return true;
      }
      accounts.remove(twin);
      tombstones[twin.id] = twin.updatedAt.millisecondsSinceEpoch + 1;
    }
  }

  tombstones.remove(incoming.id);
  final at = accounts.indexWhere((a) => a.id == incoming.id);
  if (at < 0) {
    accounts.add(incoming);
  } else {
    // When this device last used the account is its own business; keep the later of the two.
    final mine = accounts[at].lastUsedAt;
    if (mine != null && (incoming.lastUsedAt == null || mine.isAfter(incoming.lastUsedAt!))) incoming.lastUsedAt = mine;
    // Highest HOTP counter wins (see above); restamped so the other device learns the higher one.
    if (accounts[at].counter > incoming.counter) {
      incoming
        ..counter = accounts[at].counter
        ..updatedAt = incoming.updatedAt.add(const Duration(milliseconds: 1));
    }
    accounts[at] = incoming;
  }
  return true;
}

DateTime _laterOf(DateTime a, DateTime b) => a.isAfter(b) ? a : b;
