import 'dart:convert';
import 'dart:isolate';
import 'dart:math';

import 'package:cryptography/cryptography.dart';

import 'account.dart';

const backupExtension = 'tanookiauth';
const _format = 'tanooki-auth-backup';
const _iterations = 600000; // OWASP 2023 figure for PBKDF2-HMAC-SHA256
final _aad = utf8.encode('$_format-v1');

/// Wrong passphrase and damaged file look the same to AES-GCM, so the message covers both.
class BackupException implements Exception {
  BackupException(this.message);
  final String message;
  @override
  String toString() => message;
}

Future<List<int>> _deriveKey(String passphrase, List<int> salt, int iterations) =>
    // Runs off the UI thread: 600k rounds take a few seconds.
    Isolate.run(() async {
      final key = await Pbkdf2(macAlgorithm: Hmac.sha256(), iterations: iterations, bits: 256)
          .deriveKeyFromPassword(password: passphrase, nonce: salt);
      return key.extractBytes();
    });

/// Encrypts [accounts] into a backup file's text. Settings (like extension pairing) are not included.
Future<String> exportBackup(List<Account> accounts, String passphrase, {int iterations = _iterations}) async {
  final r = Random.secure();
  final salt = List.generate(16, (_) => r.nextInt(256));
  final key = await _deriveKey(passphrase, salt, iterations);
  final clear = utf8.encode(jsonEncode({'accounts': accounts.map((a) => a.toJson()).toList()}));
  final box = await AesGcm.with256bits().encrypt(clear, secretKey: SecretKey(key), aad: _aad);
  return const JsonEncoder.withIndent(' ').convert({
    'format': _format,
    'v': 1,
    'kdf': {'name': 'pbkdf2-hmac-sha256', 'iterations': iterations, 'salt': base64.encode(salt)},
    'nonce': base64.encode(box.nonce),
    'ct': base64.encode(box.cipherText),
    'mac': base64.encode(box.mac.bytes),
  });
}

Future<List<Account>> importBackup(String text, String passphrase) async {
  final Map<String, dynamic> env;
  try {
    env = jsonDecode(text) as Map<String, dynamic>;
  } catch (_) {
    throw BackupException('That file isn\'t a Tanooki Auth backup.');
  }
  if (env['format'] != _format) throw BackupException('That file isn\'t a Tanooki Auth backup.');
  if (env['v'] != 1) throw BackupException('This backup was made by a newer version of Tanooki Auth. Update the app and try again.');

  final List<int> clear;
  try {
    final kdf = env['kdf'] as Map<String, dynamic>;
    final key = await _deriveKey(passphrase, base64.decode(kdf['salt'] as String), kdf['iterations'] as int);
    clear = await AesGcm.with256bits().decrypt(
      SecretBox(base64.decode(env['ct'] as String),
          nonce: base64.decode(env['nonce'] as String), mac: Mac(base64.decode(env['mac'] as String))),
      secretKey: SecretKey(key),
      aad: _aad,
    );
  } catch (_) {
    throw BackupException('Wrong passphrase, or the backup file is damaged.');
  }
  try {
    final body = jsonDecode(utf8.decode(clear)) as Map<String, dynamic>;
    return (body['accounts'] as List).map((j) => Account.fromJson(j as Map<String, dynamic>)).toList();
  } catch (_) {
    throw BackupException('The backup unlocked but its contents are damaged.');
  }
}

/// Adds [incoming] to [into], skipping any already present (same id or same secret).
/// Returns (added, skipped).
(int, int) mergeAccounts(List<Account> into, Iterable<Account> incoming) {
  var added = 0, skipped = 0;
  for (final a in incoming) {
    if (into.any((x) => x.id == a.id || x.secret == a.secret)) {
      skipped++;
    } else {
      into.add(a);
      added++;
    }
  }
  return (added, skipped);
}
