import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'account.dart';

enum VaultFailure { fileMissing, keyMissing, decryptFailed, badJson }

/// One message per failure mode. A vault that can't be read is never treated as empty.
class VaultException implements Exception {
  VaultException(this.failure, [this.detail]);
  final VaultFailure failure;
  final Object? detail;

  String get message => switch (failure) {
        VaultFailure.fileMissing =>
          'Your accounts file is missing. If you have a backup, restore it. Otherwise you can start a new, empty vault.',
        VaultFailure.keyMissing =>
          'The key that unlocks your accounts is missing from this device\'s secure storage. Restore a backup to get your accounts back.',
        VaultFailure.decryptFailed =>
          'Your accounts file could not be unlocked. It may be damaged or was changed outside the app. Restore a backup.',
        VaultFailure.badJson =>
          'Your accounts file unlocked but its contents are damaged. Restore a backup.',
      };

  @override
  String toString() => 'VaultException($failure): $message';
}

/// Where the vault key lives. Production uses the OS secure store; tests use memory.
abstract class KeyStore {
  Future<String?> read();
  Future<void> write(String value);
}

class SecureKeyStore implements KeyStore {
  SecureKeyStore([this._name = 'vault_key_v1']);
  final String _name;
  // Classic macOS keychain: the data-protection keychain needs a provisioning profile,
  // which a Developer ID download can't carry.
  final _storage = const FlutterSecureStorage(mOptions: MacOsOptions(usesDataProtectionKeychain: false));
  @override
  Future<String?> read() => _storage.read(key: _name);
  @override
  Future<void> write(String value) => _storage.write(key: _name, value: value);
}

class Vault {
  Vault(this.file, this.keyStore);

  final File file;
  final KeyStore keyStore;
  final List<Account> accounts = [];
  /// Non-secret app settings (lock on/off etc.), stored encrypted alongside the accounts.
  final Map<String, dynamic> settings = {};

  static final _aes = AesGcm.with256bits();
  static final _aad = utf8.encode('tanooki-auth-vault-v1');

  /// Loads the vault. On a true first run (no file, no key) creates a fresh key and empty vault.
  Future<void> load() async {
    final keyB64 = await keyStore.read();
    final exists = await file.exists();
    if (!exists && keyB64 == null) {
      await _createKey();
      accounts.clear();
      await save();
      return;
    }
    if (!exists) throw VaultException(VaultFailure.fileMissing);
    if (keyB64 == null) throw VaultException(VaultFailure.keyMissing);

    final List<int> clear;
    try {
      final env = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
      final box = SecretBox(
        base64.decode(env['ct'] as String),
        nonce: base64.decode(env['nonce'] as String),
        mac: Mac(base64.decode(env['mac'] as String)),
      );
      clear = await _aes.decrypt(box, secretKey: SecretKey(base64.decode(keyB64)), aad: _aad);
    } catch (e) {
      throw VaultException(VaultFailure.decryptFailed, e);
    }
    try {
      final body = jsonDecode(utf8.decode(clear)) as Map<String, dynamic>;
      final list = (body['accounts'] as List)
          .map((j) => Account.fromJson(j as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => a.order.compareTo(b.order));
      final stored = body['settings'] as Map<String, dynamic>? ?? {};
      accounts
        ..clear()
        ..addAll(list);
      settings
        ..clear()
        ..addAll(stored);
    } catch (e) {
      throw VaultException(VaultFailure.badJson, e);
    }
  }

  /// Throws away whatever is there and starts empty. Only for an explicit user choice.
  Future<void> resetToEmpty() async {
    await _createKey();
    accounts.clear();
    settings.clear();
    await save();
  }

  Future<void> _createKey() async {
    final r = Random.secure();
    await keyStore.write(base64.encode(List.generate(32, (_) => r.nextInt(256))));
  }

  /// The on-disk envelope: AES-256-GCM over [clear], as JSON.
  static Future<String> seal(List<int> key, List<int> clear) async {
    final box = await _aes.encrypt(clear, secretKey: SecretKey(key), aad: _aad);
    return jsonEncode({
      'v': 1,
      'nonce': base64.encode(box.nonce),
      'ct': base64.encode(box.cipherText),
      'mac': base64.encode(box.mac.bytes),
    });
  }

  /// Encrypts and writes atomically: temp file, flush, rename over the old one.
  Future<void> save() async {
    final keyB64 = await keyStore.read();
    if (keyB64 == null) throw VaultException(VaultFailure.keyMissing);
    for (var i = 0; i < accounts.length; i++) {
      accounts[i].order = i;
    }
    final clear = utf8.encode(jsonEncode({
      'accounts': accounts.map((a) => a.toJson()).toList(),
      'settings': settings,
    }));
    final env = await seal(base64.decode(keyB64), clear);
    await file.parent.create(recursive: true);
    final tmp = File('${file.path}.tmp');
    await tmp.writeAsString(env, flush: true);
    await tmp.rename(file.path);
  }
}
