import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tanooki_auth/core/backup.dart';
import 'package:tanooki_auth/core/otpauth_uri.dart';

void main() {
  final a = parseOtpauthUri('otpauth://totp/GitHub:me?secret=JBSWY3DPEHPK3PXP')..domains.add('github.com');
  final b = parseOtpauthUri('otpauth://hotp/Bank:me?secret=GEZDGNBVGY3TQOJQ&counter=4');

  test('round trip with the real iteration count; secret not in the file', () async {
    final file = await exportBackup([a, b], 'correct horse battery');
    expect(file.contains('JBSWY3DPEHPK3PXP'), isFalse);
    expect((jsonDecode(file) as Map)['kdf']['iterations'], 600000);
    final back = await importBackup(file, 'correct horse battery');
    expect(back.map((x) => x.toJson()).toList(), [a.toJson(), b.toJson()]);
  }, timeout: const Timeout(Duration(minutes: 2))); // 600k PBKDF2 rounds in pure Dart; ~25 s on an M-series Mac

  test('wrong passphrase and tampering fail with a message', () async {
    final file = await exportBackup([a], 'right', iterations: 1000);
    await expectLater(importBackup(file, 'wrong'), throwsA(isA<BackupException>()));

    final env = jsonDecode(file) as Map<String, dynamic>;
    final ct = base64.decode(env['ct'] as String)..[0] ^= 1;
    env['ct'] = base64.encode(ct);
    await expectLater(importBackup(jsonEncode(env), 'right'), throwsA(isA<BackupException>()));

    await expectLater(importBackup('hello', 'right'), throwsA(isA<BackupException>()));
    await expectLater(importBackup('{"format":"other"}', 'right'), throwsA(isA<BackupException>()));
  });

  test('merge skips accounts already present by id or secret', () {
    final existing = [a];
    final sameSecretNewId = parseOtpauthUri('otpauth://totp/GitHub:me?secret=JBSWY3DPEHPK3PXP');
    final (added, skipped) = mergeAccounts(existing, [a, sameSecretNewId, b]);
    expect((added, skipped), (1, 2));
    expect(existing.length, 2);
  });
}
