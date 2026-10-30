// One sync pass for each transport: pull what other devices wrote, merge it in (merge.dart), save, and
// write back whatever this device has that the others don't. State lives in vault.settings['sync'].
import 'dart:convert';

import '../vault.dart';
import 'merge.dart';
import 'relay_client.dart';
import 'relay_crypto.dart';

/// What one pass did, for the Sync screen.
class SyncReport {
  SyncReport({this.pulled = 0, this.pushed = 0, this.skipped = 0});
  int pulled;
  int pushed;
  /// Records that failed to decrypt (tampered, or written with another passphrase). Never treated as deletes.
  int skipped;
}

/// The sync settings map. Created by the Sync screen when sync is turned on.
Map<String, dynamic> syncState(Vault v) => (v.settings[Vault.syncKey] as Map).cast<String, dynamic>();

Map<String, int> _tombstones(Vault v) =>
    ((v.settings[Vault.tombstonesKey] as Map?) ?? {}).map((k, t) => MapEntry(k as String, t as int));

Map<String, int> _intMap(Object? m) => ((m as Map?) ?? {}).map((k, v) => MapEntry(k as String, v as int));

/// Decrypts one record and checks it is really the account its record id belongs to (so the server
/// can't swap two records around). Null when it doesn't decrypt or doesn't belong.
Future<SyncItem?> openRecord(SyncKeys keys, String recordId, String ciphertext) async {
  try {
    final item = SyncItem.fromJson(await open(keys.recordKey, ciphertext, keys.aad(recordId)));
    return await keys.recordId(item.id) == recordId ? item : null;
  } catch (_) {
    return null;
  }
}

/// Merges pulled items into the vault and saves once if anything changed.
Future<bool> _mergeAll(Vault vault, Iterable<SyncItem> items) async {
  final tombs = _tombstones(vault);
  var changed = false;
  for (final item in items) {
    if (mergeRemote(vault.accounts, tombs, item)) changed = true;
  }
  if (changed) vault.settings[Vault.tombstonesKey] = tombs;
  return changed;
}

// ---------------------------------------------------------------- relay

/// Relay transport (PROTOCOL.md section 1). State keys: relay, root, device, cursor, versions
/// (record id -> server version), known (account id -> the updatedAt the server holds).
class RelaySync {
  RelaySync(this.vault);
  final Vault vault;

  Future<SyncRelay> relay() async {
    final s = syncState(vault);
    final keys = await SyncKeys.fromRoot(unb64u(s['root'] as String));
    return SyncRelay(s['relay'] as String, keys.groupId, await DeviceKey.fromSeed(unb64u(s['device'] as String)));
  }

  Future<SyncReport> sync() async {
    final s = syncState(vault);
    final keys = await SyncKeys.fromRoot(unb64u(s['root'] as String));
    final relay = SyncRelay(s['relay'] as String, keys.groupId, await DeviceKey.fromSeed(unb64u(s['device'] as String)));
    final versions = _intMap(s['versions']);
    final known = _intMap(s['known']);
    final report = SyncReport();
    var cursor = s['cursor'] as int? ?? 0;

    Future<SyncItem?> take(Map<String, dynamic> rec) async {
      final id = rec['id'] as String;
      versions[id] = rec['version'] as int;
      final item = await openRecord(keys, id, rec['ciphertext'] as String);
      if (item == null) {
        report.skipped++;
        return null;
      }
      known[item.id] = item.time;
      report.pulled++;
      return item;
    }

    // 1. Pull everything since the cursor.
    final pulled = <SyncItem>[];
    for (var more = true; more;) {
      final page = await relay.changes(cursor);
      for (final r in page.records) {
        final item = await take(r);
        if (item != null) pulled.add(item);
      }
      cursor = page.cursor;
      more = page.more;
    }
    var dirty = await _mergeAll(vault, pulled);

    // 2. Push what the server doesn't have. A conflict means another device wrote first: merge theirs, retry.
    for (var round = 0; round < 5; round++) {
      final out = localItems(vault.accounts, _tombstones(vault)).where((i) => known[i.id] != i.time).toList();
      if (out.isEmpty) break;
      final conflicts = <SyncItem>[];
      for (var at = 0; at < out.length; at += 100) {
        final batch = out.skip(at).take(100).toList();
        final ids = [for (final i in batch) await keys.recordId(i.id)];
        final results = await relay.push([
          for (var n = 0; n < batch.length; n++)
            {
              'id': ids[n],
              'baseVersion': versions[ids[n]] ?? 0,
              'deleted': batch[n].purged,
              'ciphertext': await seal(keys.recordKey, batch[n].toJson(), keys.aad(ids[n])),
            },
        ]);
        for (var n = 0; n < results.length; n++) {
          final r = results[n];
          if (r['status'] == 'ok') {
            versions[ids[n]] = r['version'] as int;
            known[batch[n].id] = batch[n].time;
            report.pushed++;
          } else if (r['current'] == null) {
            versions.remove(ids[n]); // gone on the server: send it again as new
          } else {
            final item = await take((r['current'] as Map).cast<String, dynamic>());
            if (item != null) conflicts.add(item);
          }
        }
      }
      if (await _mergeAll(vault, conflicts)) dirty = true;
    }

    s
      ..['cursor'] = cursor
      ..['versions'] = versions
      ..['known'] = known
      ..['lastSync'] = DateTime.now().toUtc().toIso8601String()
      ..remove('error');
    vault.settings[Vault.syncKey] = s;
    if (dirty || report.pushed > 0 || report.pulled > 0) await vault.save();
    return report;
  }
}

// ---------------------------------------------------------------- iCloud (or any shared folder)

/// A folder every device can read and write: iCloud Drive's app container on Apple devices
/// (icloud_folder.dart), a temp directory in tests. Paths are relative to the folder.
abstract class SyncFolder {
  Future<List<String>> list(String dir);
  Future<String?> read(String path);
  Future<void> write(String path, String text);
  Future<void> delete(String path);
}

/// Shared-folder transport. Every device writes only its own file, `<group>/device-<id>.json`, holding
/// all its records encrypted exactly as for the relay; it reads everyone else's. With one writer per
/// file, iCloud never has two versions of a file to choose between. `salt.json` at the top holds the
/// passphrase salt, so another Apple device only needs the passphrase.
class FolderSync {
  FolderSync(this.vault, this.folder);
  final Vault vault;
  final SyncFolder folder;

  static const saltFile = 'salt.json';
  static String fileFor(String deviceId) => 'device-$deviceId.json';

  Future<SyncReport> sync() async {
    final s = syncState(vault);
    final keys = await SyncKeys.fromRoot(unb64u(s['root'] as String));
    final me = s['device'] as String;
    final report = SyncReport();
    final pulled = <SyncItem>[];
    for (final name in await folder.list(keys.groupId)) {
      if (!name.startsWith('device-') || name == fileFor(me)) continue;
      final text = await folder.read('${keys.groupId}/$name');
      if (text == null) continue;
      final Map<String, dynamic> records;
      try {
        records = ((jsonDecode(text) as Map)['records'] as Map).cast<String, dynamic>();
      } catch (_) {
        report.skipped++;
        continue;
      }
      for (final e in records.entries) {
        final item = await openRecord(keys, e.key, e.value as String);
        item == null ? report.skipped++ : pulled.add(item);
      }
    }
    final dirty = await _mergeAll(vault, pulled);

    // Rewrite this device's file only when its contents would change.
    final mine = localItems(vault.accounts, _tombstones(vault));
    final fingerprint = sha256b64u(utf8.encode(([for (final i in mine) '${i.id}:${i.time}']..sort()).join(',')));
    final write = fingerprint != s['written'];
    if (write) {
      await folder.write('${keys.groupId}/${fileFor(me)}', jsonEncode({
        'v': 1,
        'name': s['name'],
        'updated': DateTime.now().millisecondsSinceEpoch,
        'records': {
          for (final i in mine) await keys.recordId(i.id): await seal(keys.recordKey, i.toJson(), keys.aad(await keys.recordId(i.id))),
        },
      }));
      s['written'] = fingerprint;
      report.pushed = mine.length;
    }
    report.pulled = pulled.length;
    s
      ..['lastSync'] = DateTime.now().toUtc().toIso8601String()
      ..remove('error');
    vault.settings[Vault.syncKey] = s;
    if (dirty || write) await vault.save();
    return report;
  }

  /// Other devices' files: name and when each last wrote.
  Future<List<({String id, String name, DateTime? updated})>> devices() async {
    final s = syncState(vault);
    final groupId = (await SyncKeys.fromRoot(unb64u(s['root'] as String))).groupId;
    final out = <({String id, String name, DateTime? updated})>[];
    for (final f in await folder.list(groupId)) {
      if (!f.startsWith('device-')) continue;
      final id = f.substring(7, f.length - 5);
      Map? j;
      try {
        j = jsonDecode(await folder.read('$groupId/$f') ?? '{}') as Map;
      } catch (_) {}
      out.add((
        id: id,
        name: j?['name'] as String? ?? 'A device',
        updated: j?['updated'] is int ? DateTime.fromMillisecondsSinceEpoch(j!['updated'] as int) : null,
      ));
    }
    return out;
  }

  Future<void> removeDevice(String id) async {
    final groupId = (await SyncKeys.fromRoot(unb64u(syncState(vault)['root'] as String))).groupId;
    await folder.delete('$groupId/${fileFor(id)}');
  }
}
