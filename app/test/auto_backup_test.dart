import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tanooki_auth/core/auto_backup.dart';
import 'package:tanooki_auth/core/backup.dart';
import 'package:tanooki_auth/core/otpauth_uri.dart';
import 'package:tanooki_auth/core/security.dart';
import 'package:tanooki_auth/core/vault.dart';

class MemoryKeyStore implements KeyStore {
  String? value;
  @override
  Future<String?> read() async => value;
  @override
  Future<void> write(String v) async => value = v;
}

/// Refs are plain paths here; [fail] makes the next open throw like a native folder error would.
class TestOpener implements FolderOpener {
  AutoBackupException? fail;
  int opened = 0;
  @override
  Future<void> use(String ref, Future<void> Function(BackupFolder folder) body, {void Function(String newRef)? onNewRef}) async {
    opened++;
    if (fail != null) throw fail!;
    await body(IoBackupFolder(Directory(ref)));
  }
}

void main() {
  late Directory tmp, folder;
  late Vault vault;
  late TestOpener opener;
  late DateTime now;
  const pass = 'correct horse battery';

  AutoBackupRunner runner({Duration debounce = const Duration(milliseconds: 50)}) =>
      AutoBackupRunner(opener: opener, debounce: debounce, iterations: 1000, clock: () => now)..isPremium = () => true;

  setUp(() async {
    tmp = Directory.systemTemp.createTempSync('auto_backup_test');
    folder = Directory('${tmp.path}/My Drive')..createSync();
    vault = Vault(File('${tmp.path}/vault.json'), MemoryKeyStore());
    await vault.load();
    vault.accounts
      ..add(parseOtpauthUri('otpauth://totp/GitHub:me?secret=JBSWY3DPEHPK3PXP&issuer=GitHub'))
      ..add(parseOtpauthUri('otpauth://hotp/Bank:me?secret=GEZDGNBVGY3TQOJQ&counter=4'));
    vault.settings[autoBackupKey] = {'folder': folder.path, 'folderName': 'My Drive', 'passphrase': pass};
    await vault.save();
    opener = TestOpener();
    now = DateTime(2026, 10, 30, 9);
  });
  tearDown(() => tmp.deleteSync(recursive: true));

  List<String> files() => folder.listSync().map((e) => e.uri.pathSegments.last).toList()..sort();

  group('names', () {
    test('only our exact pattern counts', () {
      expect(autoBackupName(DateTime(2026, 1, 2)), 'Tanooki Auth backup 2026-01-02.tanookiauth');
      expect(isAutoBackupName('Tanooki Auth backup 2026-01-02.tanookiauth'), isTrue);
      for (final other in [
        'Tanooki Auth backup 2026-01-02 (1).tanookiauth',
        'Tanooki Auth backup 2026-01-02.tanookiauth.txt',
        'tanooki auth backup 2026-01-02.tanookiauth',
        'My Tanooki Auth backup 2026-01-02.tanookiauth',
        'Tanooki Auth backup 2026-1-2.tanookiauth',
        'Tanooki Auth setup links 2026-01-02.txt',
        'Tanooki Auth backup 2026-01-02xtanookiauth',
      ]) {
        expect(isAutoBackupName(other), isFalse, reason: other);
      }
    });
  });

  group('scheduling', () {
    test('once per day: app open backs up, a second open the same day does not, the next day does', () async {
      final r = runner();
      await r.appOpened(vault);
      expect(r.written, 1);
      await r.appOpened(vault);
      expect(r.written, 1, reason: 'already done today');
      now = DateTime(2026, 10, 31, 0, 5);
      await r.appOpened(vault);
      expect(r.written, 2);
      expect(files(), ['Tanooki Auth backup 2026-10-30.tanookiauth', 'Tanooki Auth backup 2026-10-31.tanookiauth']);
    });

    test('vault changes are debounced into one backup, and our own save does not retrigger', () async {
      final r = runner();
      for (var i = 0; i < 5; i++) {
        r.vaultChanged(vault);
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }
      expect(r.written, 0, reason: 'still inside the debounce window');
      await Future<void>.delayed(const Duration(milliseconds: 300));
      expect(r.written, 1);
      // A change after today's backup (including the save that recorded it) does nothing more today.
      r.vaultChanged(vault);
      await Future<void>.delayed(const Duration(milliseconds: 150));
      expect(r.written, 1);
    });

    test('Back up now always runs and replaces today\'s file', () async {
      final r = runner();
      await r.appOpened(vault);
      expect(await r.runNow(vault), isTrue);
      expect(r.written, 2);
      expect(files(), ['Tanooki Auth backup 2026-10-30.tanookiauth']);
    });

    test('nothing happens without Premium, or with the feature off', () async {
      final r = runner()..isPremium = () => false;
      await r.appOpened(vault);
      r.vaultChanged(vault);
      await Future<void>.delayed(const Duration(milliseconds: 150));
      expect(r.written, 0);
      expect(opener.opened, 0);
      final on = runner();
      vault.settings.remove(autoBackupKey);
      await on.appOpened(vault);
      expect(on.written, 0);
    });

    test('success records the last-backup date used by panic wipe and the check-up', () async {
      expect(backupIsRecent(vault.settings, now), isFalse);
      await runner().appOpened(vault);
      expect(backupIsRecent(vault.settings, now), isTrue);
      expect(lastAutoBackup(vault), now);
      final reloaded = Vault(vault.file, vault.keyStore);
      await reloaded.load();
      expect(reloaded.settings[lastBackupKey], now.toUtc().toIso8601String(), reason: 'saved to disk, not just memory');
    });
  });

  group('retention', () {
    test('keeps the newest 10 of ours and never touches anything else', () async {
      for (var d = 1; d <= 12; d++) {
        File('${folder.path}/${autoBackupName(DateTime(2026, 10, d))}').writeAsStringSync('old $d');
      }
      const others = [
        'notes.txt',
        'Tanooki Auth backup 2026-01-01 (1).tanookiauth',
        'Tanooki Auth backup 2020-01-01.tanookiauth.txt',
        'Tanooki Auth setup links 2026-10-01.txt',
      ];
      for (final o in others) {
        File('${folder.path}/$o').writeAsStringSync('keep me');
      }
      Directory('${folder.path}/Tanooki Auth backup 2001-01-01.tanookiauth').createSync(); // a folder, not a file
      await runner().runNow(vault);
      final ours = files().where(isAutoBackupName).toList();
      expect(ours.length, autoBackupsKept);
      expect(ours.first, autoBackupName(DateTime(2026, 10, 4)), reason: 'the oldest three went: 1st, 2nd, 3rd');
      expect(ours.last, autoBackupName(now));
      for (final o in others) {
        expect(File('${folder.path}/$o').readAsStringSync(), 'keep me', reason: o);
      }
      expect(Directory('${folder.path}/Tanooki Auth backup 2001-01-01.tanookiauth').existsSync(), isTrue);
    });
  });

  group('round trip', () {
    test('the automatic file imports back to the same accounts with the passphrase', () async {
      await runner().runNow(vault);
      final text = File('${folder.path}/${autoBackupName(now)}').readAsStringSync();
      expect(text.contains('JBSWY3DPEHPK3PXP'), isFalse);
      final back = await importBackup(text, pass);
      expect(back.map((a) => a.toJson()).toList(), vault.live.map((a) => a.toJson()).toList());
      await expectLater(importBackup(text, 'wrong passphrase'), throwsA(isA<BackupException>().having((e) => e.message, 'message', startsWith('Wrong passphrase'))));
    });

    test('trashed accounts are left out, like Export backup', () async {
      vault.accounts.first.deletedAt = DateTime.now().toUtc();
      await runner().runNow(vault);
      final back = await importBackup(File('${folder.path}/${autoBackupName(now)}').readAsStringSync(), pass);
      expect(back.single.issuer, 'Bank');
    });
  });

  group('failures', () {
    Future<String> vaultBytes() => vault.file.readAsString();

    test('each failure mode is reported with its own message, and the vault file is not touched', () async {
      final seen = <String>{};
      for (final f in AutoBackupFailure.values) {
        final r = runner();
        opener.fail = AutoBackupException(f, 'detail');
        final before = await vaultBytes();
        expect(await r.runNow(vault), isFalse);
        expect(r.failure.value!.failure, f);
        seen.add(r.failure.value!.message);
        expect(await vaultBytes(), before, reason: 'a failed backup never writes the vault');
        expect(vault.settings[lastBackupKey], isNull);
      }
      expect(seen.length, AutoBackupFailure.values.length, reason: 'one message per failure mode');
    });

    test('a folder that vanished is reported as gone (real dart:io path)', () async {
      folder.deleteSync(recursive: true);
      final r = runner();
      expect(await r.runNow(vault), isFalse);
      expect(r.failure.value!.failure, AutoBackupFailure.folderGone);
    });

    test('OS errors map to the right failure', () {
      FileSystemException err(int code) => FileSystemException('x', 'p', OSError('m', code));
      if (!Platform.isWindows) {
        expect(classifyIoError(err(2)).failure, AutoBackupFailure.folderGone);
        expect(classifyIoError(err(13)).failure, AutoBackupFailure.permissionLost);
        expect(classifyIoError(err(28)).failure, AutoBackupFailure.diskFull);
        expect(classifyIoError(err(5)).failure, AutoBackupFailure.other);
      }
    });

    test('after a failure: no automatic retry for an hour, Back up now still runs, success clears it', () async {
      final r = runner();
      opener.fail = AutoBackupException(AutoBackupFailure.permissionLost);
      await r.appOpened(vault);
      expect(opener.opened, 1);
      await r.appOpened(vault);
      expect(opener.opened, 1, reason: 'cooling down');
      opener.fail = null;
      expect(await r.runNow(vault), isTrue);
      expect(r.failure.value, isNull);
    });

    test('a failure shows in the security check-up while automatic backups are on', () async {
      autoBackup.isPremium = () => true;
      autoBackup.failure.value = AutoBackupException(AutoBackupFailure.diskFull);
      expect(securityCheckup(vault, now).map((f) => f.issue), contains(CheckupIssue.autoBackupFailed));
      vault.settings.remove(autoBackupKey);
      expect(securityCheckup(vault, now).map((f) => f.issue), isNot(contains(CheckupIssue.autoBackupFailed)));
      autoBackup.failure.value = null;
      autoBackup.isPremium = () => false;
    });
  });
}
