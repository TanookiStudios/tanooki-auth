import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tanooki_auth/core/account.dart';
import 'package:tanooki_auth/core/otpauth_uri.dart';
import 'package:tanooki_auth/core/security.dart';
import 'package:tanooki_auth/core/vault.dart';

import 'vault_test.dart' show MemoryKeyStore;

void main() {
  late Directory dir;
  late Vault real;
  const pin = '482916', decoyPin = '730514';

  Future<Map<String, Object>> fastHash(String p) => hashPasscode(p, iterations: 1000);

  setUp(() async {
    dir = Directory.systemTemp.createTempSync('security_test');
    real = Vault(File('${dir.path}/vault.json'), MemoryKeyStore());
    await real.load();
    real.accounts.add(parseOtpauthUri('otpauth://totp/GitHub:me?secret=JBSWY3DPEHPK3PXP&issuer=GitHub'));
    real.settings[passcodeKey] = await fastHash(pin);
    await real.save();
  });
  tearDown(() => dir.deleteSync(recursive: true));

  group('passcode', () {
    test('stored as a salted hash, never the digits', () async {
      final rec = await hashPasscode(pin);
      expect(jsonEncode(rec).contains(pin), isFalse);
      expect(rec['iter'], greaterThanOrEqualTo(100000));
      expect(await verifyPasscode(pin, rec), isTrue);
      expect(await verifyPasscode('482917', rec), isFalse);
      expect(await verifyPasscode(pin, null), isFalse);
      final again = await hashPasscode(pin);
      expect(again['hash'], isNot(rec['hash']), reason: 'random salt');
      expect(File(real.file.path).readAsStringSync().contains(pin), isFalse);
    });

    test('rules: 6+ digits, no repeats or runs', () {
      expect(passcodeProblem('12345'), isNotNull);
      expect(passcodeProblem('12a456'), isNotNull);
      expect(passcodeProblem('111111'), isNotNull);
      expect(passcodeProblem('123456'), isNotNull);
      expect(passcodeProblem('654321'), isNotNull);
      expect(passcodeProblem(pin), isNull);
      expect(passcodeProblem('4829160'), isNull);
    });
  });

  group('auto-lock timer', () {
    test('immediately / 30 s / 1 min / 5 min', () {
      final s = <String, dynamic>{lockKey: true};
      expect(shouldRelock(s, const Duration(seconds: 29)), isFalse, reason: 'default is 30 s');
      expect(shouldRelock(s, const Duration(seconds: 30)), isTrue);
      s[lockAfterKey] = 0;
      expect(shouldRelock(s, Duration.zero), isTrue);
      s[lockAfterKey] = 60;
      expect(shouldRelock(s, const Duration(seconds: 59)), isFalse);
      expect(shouldRelock(s, const Duration(seconds: 60)), isTrue);
      s[lockAfterKey] = 300;
      expect(shouldRelock(s, const Duration(minutes: 4)), isFalse);
      expect(shouldRelock(s, const Duration(minutes: 5)), isTrue);
      expect(shouldRelock({lockAfterKey: 0}, const Duration(hours: 1)), isFalse, reason: 'no lock, nothing to relock');
      expect(shouldRelock({passcodeKey: {}}, const Duration(minutes: 1)), isTrue, reason: 'passcode alone is a lock');
    });
  });

  group('panic wipe', () {
    var decoyWiped = false;
    Future<void> wipeDecoy() async => decoyWiped = true;
    setUp(() => decoyWiped = false);

    test('refuses to turn on without a passcode or a backup in the last 30 days', () {
      final now = DateTime.utc(2026, 10, 30);
      expect(panicWipeBlocker({}, now), contains('passcode'));
      final s = <String, dynamic>{passcodeKey: {}};
      expect(panicWipeBlocker(s, now), contains('backup'));
      s[lastBackupKey] = DateTime.utc(2026, 9, 29).toIso8601String();
      expect(panicWipeBlocker(s, now), contains('backup'), reason: '31 days old');
      s[lastBackupKey] = DateTime.utc(2026, 10, 1).toIso8601String();
      expect(panicWipeBlocker(s, now), isNull);
    });

    test('off: wrong passcodes are counted but nothing is erased', () async {
      for (var i = 0; i < 12; i++) {
        expect(await tryPasscode(real, '000001', wipeDecoy: wipeDecoy), Unlock.wrong);
      }
      expect(failedPasscodes(real.settings), 12);
      expect(real.live, hasLength(1));
      expect(await tryPasscode(real, pin, wipeDecoy: wipeDecoy), Unlock.real);
      expect(failedPasscodes(real.settings), 0, reason: 'a right passcode resets the count');
    });

    test('on: the 10th wrong passcode in a row erases everything; the 9th does not', () async {
      real.settings[panicWipeKey] = true;
      for (var i = 0; i < panicWipeAttempts - 1; i++) {
        expect(await tryPasscode(real, '000001', wipeDecoy: wipeDecoy), Unlock.wrong);
      }
      final reloaded = Vault(real.file, real.keyStore);
      await reloaded.load();
      expect(failedPasscodes(reloaded.settings), 9, reason: 'the count survives an app restart');
      expect(reloaded.live, hasLength(1));
      expect(decoyWiped, isFalse);

      expect(await tryPasscode(real, '000001', wipeDecoy: wipeDecoy), Unlock.wiped);
      final after = Vault(real.file, real.keyStore);
      await after.load();
      expect(after.accounts, isEmpty);
      expect(after.settings, isEmpty, reason: 'passcode and decoy passcode are gone too');
      expect(File(real.file.path).readAsStringSync().contains('JBSWY3DPEHPK3PXP'), isFalse);
      expect(decoyWiped, isTrue);
    });

    test('on: a right passcode in between starts the count again', () async {
      real.settings[panicWipeKey] = true;
      for (var i = 0; i < 9; i++) {
        await tryPasscode(real, '000001', wipeDecoy: wipeDecoy);
      }
      expect(await tryPasscode(real, pin, wipeDecoy: wipeDecoy), Unlock.real);
      for (var i = 0; i < 9; i++) {
        expect(await tryPasscode(real, '000001', wipeDecoy: wipeDecoy), Unlock.wrong);
      }
      expect(real.live, hasLength(1));
    });
  });

  group('decoy vault', () {
    test('decoy passcode opens a separate vault; the real one is untouched', () async {
      real.settings[decoyPasscodeKey] = await fastHash(decoyPin);
      await real.save();
      final realBytes = real.file.readAsBytesSync();

      expect(await tryPasscode(real, decoyPin, wipeDecoy: () async {}), Unlock.decoy);
      expect(real.file.readAsBytesSync(), realBytes, reason: 'opening the decoy writes nothing to the real vault');

      final decoy = Vault(File('${dir.path}/vault-b.json'), MemoryKeyStore());
      await decoy.load();
      expect(decoy.accounts, isEmpty, reason: 'starts empty');
      decoy.accounts.add(parseOtpauthUri('otpauth://totp/Decoy:me?secret=MFRGGZDFMZTWQ2LK&issuer=Decoy'));
      decoy.settings['theme'] = 'pink';
      await decoy.save();
      decoy.accounts.first.issuer = 'Changed';
      await decoy.save();

      expect(real.file.readAsBytesSync(), realBytes, reason: 'using the decoy never touches the real file');
      final again = Vault(real.file, real.keyStore);
      await again.load();
      expect(again.live.map((a) => a.issuer), ['GitHub']);
      expect(again.settings.containsKey('theme'), isFalse);
    });

    test('without a decoy passcode set, the decoy can never open', () async {
      expect(await tryPasscode(real, decoyPin, wipeDecoy: () async {}), Unlock.wrong);
      expect(await tryPasscode(real, '', wipeDecoy: () async {}), Unlock.wrong);
    });

    test('the real passcode still opens the real vault when a decoy exists', () async {
      real.settings[decoyPasscodeKey] = await fastHash(decoyPin);
      expect(await tryPasscode(real, pin, wipeDecoy: () async {}), Unlock.real);
    });
  });

  group('security check-up', () {
    test('flags lock off, no passcode, no recent backup, accounts without recovery codes', () {
      final now = DateTime.utc(2026, 10, 30);
      real.settings.remove(passcodeKey);
      var f = securityCheckup(real, now).map((x) => x.issue);
      expect(f, [CheckupIssue.lockOff, CheckupIssue.noPasscode, CheckupIssue.noBackup, CheckupIssue.noRecoveryCodes]);
      expect(securityCheckup(real, now).last.accounts.single.issuer, 'GitHub');

      real.settings[lockKey] = true;
      real.settings[passcodeKey] = {};
      real.settings[lastBackupKey] = now.subtract(const Duration(days: 3)).toIso8601String();
      real.accounts.first.recoveryCodes.add(RecoveryCode('abcd-efgh'));
      real.accounts.add(Account(id: 'x', issuer: 'Trashed', secret: 'JBSWY3DPEHPK3PXP', deletedAt: now));
      expect(securityCheckup(real, now), isEmpty, reason: 'trashed accounts are not counted');
    });
  });
}
