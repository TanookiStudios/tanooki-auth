import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tanooki_auth/core/account.dart';
import 'package:tanooki_auth/core/otpauth_uri.dart';
import 'package:tanooki_auth/core/sync/merge.dart';
import 'package:tanooki_auth/core/sync/relay_crypto.dart';
import 'package:tanooki_auth/core/sync/sync_engine.dart';
import 'package:tanooki_auth/core/vault.dart';

class MemoryKeyStore implements KeyStore {
  String? value;
  @override
  Future<String?> read() async => value;
  @override
  Future<void> write(String v) async => value = v;
}

/// Stand-in for the iCloud container: a plain directory both "devices" share.
class DirFolder implements SyncFolder {
  DirFolder(this.root);
  final Directory root;
  @override
  Future<List<String>> list(String dir) async {
    final d = Directory('${root.path}/$dir');
    return d.existsSync() ? [for (final f in d.listSync()) f.uri.pathSegments.last] : [];
  }

  @override
  Future<String?> read(String path) async {
    final f = File('${root.path}/$path');
    return f.existsSync() ? f.readAsStringSync() : null;
  }

  @override
  Future<void> write(String path, String text) async => (File('${root.path}/$path')..createSync(recursive: true)).writeAsStringSync(text);
  @override
  Future<void> delete(String path) async => File('${root.path}/$path').deleteSync();
}

Account acct(String id, String secret, {String issuer = 'GitHub', int at = 1000}) => Account(
      id: id,
      issuer: issuer,
      label: 'me',
      secret: secret,
      createdAt: DateTime.fromMillisecondsSinceEpoch(at, isUtc: true),
    );

void main() {
  group('merge rules', () {
    test('a newer remote edit replaces the local copy; an older one is ignored', () {
      final local = [acct('a', 'AAAA', at: 1000)];
      final tombs = <String, int>{};
      final newer = acct('a', 'AAAA', issuer: 'GitHub (work)')..updatedAt = DateTime.fromMillisecondsSinceEpoch(2000, isUtc: true);
      expect(mergeRemote(local, tombs, SyncItem.account(newer)), isTrue);
      expect(local.single.issuer, 'GitHub (work)');
      final older = acct('a', 'AAAA', issuer: 'stale')..updatedAt = DateTime.fromMillisecondsSinceEpoch(1500, isUtc: true);
      expect(mergeRemote(local, tombs, SyncItem.account(older)), isFalse);
      expect(local.single.issuer, 'GitHub (work)');
    });

    test('delete vs edit: whichever happened later wins', () {
      final local = [acct('a', 'AAAA', at: 1000)];
      final tombs = <String, int>{};
      expect(mergeRemote(local, tombs, SyncItem.tombstone('a', 900)), isFalse, reason: 'delete older than the edit loses');
      expect(local, hasLength(1));
      expect(mergeRemote(local, tombs, SyncItem.tombstone('a', 1100)), isTrue);
      expect(local, isEmpty);
      expect(tombs['a'], 1100);
      final editAfterDelete = acct('a', 'AAAA', issuer: 'back')..updatedAt = DateTime.fromMillisecondsSinceEpoch(1200, isUtc: true);
      expect(mergeRemote(local, tombs, SyncItem.account(editAfterDelete)), isTrue, reason: 'an edit after the delete brings it back');
      expect(local.single.issuer, 'back');
      expect(tombs.containsKey('a'), isFalse);
    });

    test('ties are broken the same way on every device', () {
      final x = acct('a', 'AAAA', issuer: 'X');
      final y = acct('a', 'AAAA', issuer: 'Y');
      expect(supersedes(SyncItem.account(x), SyncItem.account(y)), isNot(supersedes(SyncItem.account(y), SyncItem.account(x))));
      expect(supersedes(SyncItem.tombstone('a', 1000), SyncItem.account(x)), isTrue);
      expect(supersedes(SyncItem.account(x), SyncItem.tombstone('a', 1000)), isFalse);
    });

    test('the same account added on two devices keeps one copy, the same one on both', () {
      final onA = [acct('id-1', 'SAME')];
      final onB = [acct('id-2', 'SAME')];
      final tombsA = <String, int>{}, tombsB = <String, int>{};
      mergeRemote(onA, tombsA, SyncItem.account(acct('id-2', 'SAME')));
      mergeRemote(onB, tombsB, SyncItem.account(acct('id-1', 'SAME')));
      expect(onA.map((a) => a.id), ['id-1']);
      expect(onB.map((a) => a.id), ['id-1']);
      expect(tombsA.keys, ['id-2']);
      expect(tombsB.keys, ['id-2']);
    });

    test('this device keeps its own "last used" time when a remote edit lands', () {
      final mine = acct('a', 'AAAA')..lastUsedAt = DateTime.utc(2026, 10, 1);
      final local = [mine];
      final remote = acct('a', 'AAAA', issuer: 'new')..updatedAt = DateTime.utc(2026, 10, 2);
      mergeRemote(local, {}, SyncItem.account(remote));
      expect(local.single.lastUsedAt, DateTime.utc(2026, 10, 1));
    });
  });

  group('vault stamps edits for sync', () {
    late Directory dir;
    setUp(() => dir = Directory.systemTemp.createTempSync('sync_stamp'));
    tearDown(() => dir.deleteSync(recursive: true));

    test('old vault JSON without updatedAt loads, using createdAt', () {
      final j = acct('a', 'AAAA').toJson()..remove('updatedAt');
      final a = Account.fromJson(j);
      expect(a.updatedAt, a.createdAt);
    });

    test('an edit gets a new stamp; an untouched account and a "last used" change do not', () async {
      final v = Vault(File('${dir.path}/v.json'), MemoryKeyStore());
      await v.load();
      v.accounts.addAll([acct('a', 'AAAA'), acct('b', 'BBBB')]);
      await v.save();
      final before = v.accounts[1].updatedAt;
      v.accounts[0].issuer = 'Changed';
      v.accounts[1].lastUsedAt = DateTime.now().toUtc();
      await v.save();
      expect(v.accounts[0].updatedAt.isAfter(DateTime.fromMillisecondsSinceEpoch(1000)), isTrue);
      expect(v.accounts[1].updatedAt, before);
    });

    test('an edit is stamped later than the copy it edits, even if this clock is behind', () async {
      final v = Vault(File('${dir.path}/v.json'), MemoryKeyStore());
      await v.load();
      final future = DateTime.now().toUtc().add(const Duration(hours: 1));
      v.accounts.add(acct('a', 'AAAA')..updatedAt = future); // arrived from a device whose clock is fast
      await v.save();
      v.accounts[0].notes = 'edited here';
      await v.save();
      expect(v.accounts[0].updatedAt.isAfter(future), isTrue);
    });

    test('removing an account for good leaves a tombstone, only while sync is on', () async {
      final v = Vault(File('${dir.path}/v.json'), MemoryKeyStore());
      await v.load();
      v.accounts.addAll([acct('a', 'AAAA'), acct('b', 'BBBB')]);
      await v.save();
      v.accounts.removeWhere((a) => a.id == 'a');
      await v.save();
      expect(v.settings[Vault.tombstonesKey], isNull);
      v.settings[Vault.syncKey] = {'on': true};
      v.accounts.clear();
      await v.save();
      expect((v.settings[Vault.tombstonesKey] as Map).keys, ['b']);
    });
  });

  group('two devices syncing through a shared folder', () {
    late Directory dir;
    late DirFolder cloud;
    late List<int> root;
    setUpAll(() async => root = randomBytes(32));
    setUp(() {
      dir = Directory.systemTemp.createTempSync('sync_two');
      cloud = DirFolder(Directory('${dir.path}/cloud'));
    });
    tearDown(() => dir.deleteSync(recursive: true));

    Future<(Vault, FolderSync)> device(String name) async {
      final v = Vault(File('${dir.path}/$name.json'), MemoryKeyStore());
      await v.load();
      v.settings[Vault.syncKey] = {'transport': 'icloud', 'root': b64u(root), 'device': name, 'name': name};
      await v.save();
      return (v, FolderSync(v, cloud));
    }

    List<String> titles(Vault v) => [for (final a in v.live) a.issuer]..sort();

    test('offline edits on both devices all arrive; a later edit of the same account wins', () async {
      final (a, syncA) = await device('A');
      final (b, syncB) = await device('B');
      a.accounts.add(parseOtpauthUri('otpauth://totp/GitHub:me?secret=JBSWY3DPEHPK3PXP'));
      await a.save();
      await syncA.sync();
      await syncB.sync();
      expect(titles(b), ['GitHub']);

      // Both offline: A adds Discord and renames GitHub; B renames GitHub a little later.
      a.accounts.add(parseOtpauthUri('otpauth://totp/Discord:me?secret=KRUGKIDROVUWG2ZA'));
      a.accounts.firstWhere((x) => x.issuer == 'GitHub').issuer = 'GitHub A';
      await a.save();
      await Future<void>.delayed(const Duration(milliseconds: 5));
      b.accounts.single.issuer = 'GitHub B';
      await b.save();

      await syncA.sync();
      await syncB.sync();
      await syncA.sync();
      expect(titles(a), ['Discord', 'GitHub B']);
      expect(titles(b), ['Discord', 'GitHub B']);
    });

    test('trash, restore and delete-forever travel; a delete loses to a later edit', () async {
      final (a, syncA) = await device('A');
      final (b, syncB) = await device('B');
      a.accounts.add(parseOtpauthUri('otpauth://totp/GitHub:me?secret=JBSWY3DPEHPK3PXP'));
      await a.save();
      await syncA.sync();
      await syncB.sync();

      a.accounts.single.deletedAt = DateTime.now().toUtc(); // to Trash
      await a.save();
      await syncA.sync();
      await syncB.sync();
      expect(b.trash, hasLength(1));

      await Future<void>.delayed(const Duration(milliseconds: 5));
      b.accounts.single.deletedAt = null; // restored on B
      await b.save();
      await syncB.sync();
      await syncA.sync();
      expect(a.live, hasLength(1));

      // A deletes it for good, then B (offline, a moment later) edits it: the edit wins.
      a.accounts.clear();
      await a.save();
      await Future<void>.delayed(const Duration(milliseconds: 5));
      b.accounts.single.notes = 'still need this';
      await b.save();
      await syncA.sync();
      await syncB.sync();
      await syncA.sync();
      expect(a.live.single.notes, 'still need this');

      // Now B deletes it for good with nothing newer anywhere: gone on both.
      b.accounts.clear();
      await b.save();
      await syncB.sync();
      await syncA.sync();
      expect(a.accounts, isEmpty);
      expect(b.accounts, isEmpty);
    });

    test('the same account added on both devices offline ends up once', () async {
      final (a, syncA) = await device('A');
      final (b, syncB) = await device('B');
      a.accounts.add(parseOtpauthUri('otpauth://totp/GitHub:me?secret=JBSWY3DPEHPK3PXP'));
      await a.save();
      b.accounts.add(parseOtpauthUri('otpauth://totp/GitHub:me?secret=JBSWY3DPEHPK3PXP'));
      await b.save();
      await syncA.sync();
      await syncB.sync();
      await syncA.sync();
      expect(a.live, hasLength(1));
      expect(b.live, hasLength(1));
      expect(a.live.single.id, b.live.single.id);
    });

    test('a tampered record is skipped, never treated as a delete', () async {
      final (a, syncA) = await device('A');
      final (b, syncB) = await device('B');
      a.accounts.add(parseOtpauthUri('otpauth://totp/GitHub:me?secret=JBSWY3DPEHPK3PXP'));
      await a.save();
      await syncA.sync();
      await syncB.sync();
      final groupDir = Directory('${cloud.root.path}/${(await SyncKeys.fromRoot(root)).groupId}');
      final f = File('${groupDir.path}/device-A.json');
      final j = jsonDecode(f.readAsStringSync()) as Map<String, dynamic>;
      final records = (j['records'] as Map).cast<String, dynamic>();
      final ct = records.values.first as String;
      records[records.keys.first] = '${ct.substring(0, 30)}${ct[30] == 'A' ? 'B' : 'A'}${ct.substring(31)}';
      f.writeAsStringSync(jsonEncode(j));
      final report = await syncB.sync();
      expect(report.skipped, 1);
      expect(b.live, hasLength(1));
    });

    test('a different passphrase cannot read anything', () async {
      final (a, syncA) = await device('A');
      a.accounts.add(parseOtpauthUri('otpauth://totp/GitHub:me?secret=JBSWY3DPEHPK3PXP'));
      await a.save();
      await syncA.sync();
      final raw = cloud.root.listSync(recursive: true).whereType<File>().map((f) => f.readAsStringSync()).join();
      expect(raw.contains('JBSWY3DPEHPK3PXP'), isFalse);
      expect(raw.contains('GitHub'), isFalse);
    });
  });
}
