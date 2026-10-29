import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tanooki_auth/core/otpauth_uri.dart';
import 'package:tanooki_auth/core/vault.dart';

class MemoryKeyStore implements KeyStore {
  String? value;
  @override
  Future<String?> read() async => value;
  @override
  Future<void> write(String v) async => value = v;
}

void main() {
  late Directory dir;
  late File file;
  late MemoryKeyStore keys;

  setUp(() {
    dir = Directory.systemTemp.createTempSync('vault_test');
    file = File('${dir.path}/vault.json');
    keys = MemoryKeyStore();
  });
  tearDown(() => dir.deleteSync(recursive: true));

  test('first run creates key and empty vault; round trip', () async {
    final v = Vault(file, keys);
    await v.load();
    expect(v.accounts, isEmpty);
    expect(keys.value, isNotNull);
    expect(file.existsSync(), isTrue);

    v.accounts.add(parseOtpauthUri('otpauth://totp/GitHub:me?secret=JBSWY3DPEHPK3PXP')..domains.add('github.com'));
    v.settings['lock'] = true;
    await v.save();
    expect(file.readAsStringSync().contains('JBSWY3DPEHPK3PXP'), isFalse, reason: 'secret must not be in plain text');
    expect(File('${file.path}.tmp').existsSync(), isFalse);

    final v2 = Vault(file, keys);
    await v2.load();
    expect(v2.accounts.single.issuer, 'GitHub');
    expect(v2.accounts.single.secret, 'JBSWY3DPEHPK3PXP');
    expect(v2.accounts.single.domains, ['github.com']);
    expect(v2.settings['lock'], isTrue);
  });

  Future<VaultFailure> failureOf(Vault v) async {
    try {
      await v.load();
    } on VaultException catch (e) {
      return e.failure;
    }
    fail('load succeeded but should have failed');
  }

  test('tampered file fails loudly, never empty', () async {
    final v = Vault(file, keys);
    await v.load();
    v.accounts.add(parseOtpauthUri('otpauth://totp/x?secret=JBSWY3DPEHPK3PXP'));
    await v.save();

    final env = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
    final ct = base64.decode(env['ct'] as String);
    ct[0] ^= 1;
    env['ct'] = base64.encode(ct);
    file.writeAsStringSync(jsonEncode(env));

    final v2 = Vault(file, keys);
    expect(await failureOf(v2), VaultFailure.decryptFailed);
    expect(v2.accounts, isEmpty);
  });

  test('each failure mode is distinct', () async {
    final v = Vault(file, keys);
    await v.load();

    // Wrong key.
    final good = keys.value;
    keys.value = base64.encode(List.filled(32, 7));
    expect(await failureOf(Vault(file, keys)), VaultFailure.decryptFailed);
    keys.value = good;

    // Key missing, file present.
    keys.value = null;
    expect(await failureOf(Vault(file, keys)), VaultFailure.keyMissing);
    keys.value = good;

    // Garbage file.
    final saved = file.readAsStringSync();
    file.writeAsStringSync('not json');
    expect(await failureOf(Vault(file, keys)), VaultFailure.decryptFailed);
    file.writeAsStringSync(saved);

    // File missing, key present.
    file.deleteSync();
    expect(await failureOf(Vault(file, keys)), VaultFailure.fileMissing);
    expect(file.existsSync(), isFalse, reason: 'must not silently recreate');
  });

  test('decrypts but contents bad -> badJson', () async {
    await Vault(file, keys).load();
    file.writeAsStringSync(await Vault.seal(base64.decode(keys.value!), utf8.encode('{"accounts": 5}')));
    expect(await failureOf(Vault(file, keys)), VaultFailure.badJson);
  });
}
