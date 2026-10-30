// Client-side crypto for the relay (relay/PROTOCOL.md): base64url, HKDF, AES-256-GCM, Ed25519, X25519,
// Argon2id. The relay never sees any of these keys.
import 'dart:convert';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart' as hash;
import 'package:cryptography/cryptography.dart';

const relayUrl = 'https://tanooki-auth-relay.kirbymail.workers.dev';

/// Base64url without padding (PROTOCOL.md section 0).
String b64u(List<int> bytes) => base64Url.encode(bytes).replaceAll('=', '');
Uint8List unb64u(String s) => base64Url.decode(s.padRight((s.length + 3) ~/ 4 * 4, '='));

final _rng = Random.secure();
Uint8List randomBytes(int n) => Uint8List.fromList(List.generate(n, (_) => _rng.nextInt(256)));

String sha256b64u(List<int> bytes) => b64u(hash.sha256.convert(bytes).bytes);

Future<Uint8List> hkdf(List<int> ikm, List<int> salt, String info, int length) async {
  final k = await Hkdf(hmac: Hmac.sha256(), outputLength: length)
      .deriveKey(secretKey: SecretKey(ikm), nonce: salt, info: utf8.encode(info));
  return Uint8List.fromList(await k.extractBytes());
}

final _gcm = AesGcm.with256bits();

/// base64url(nonce || ciphertext || tag) of [plaintext] JSON, bound to [aad].
Future<String> seal(List<int> key, Object plaintext, String aad) async {
  final box = await _gcm.encrypt(utf8.encode(jsonEncode(plaintext)),
      secretKey: SecretKey(key), nonce: randomBytes(12), aad: utf8.encode(aad));
  return b64u([...box.nonce, ...box.cipherText, ...box.mac.bytes]);
}

/// Opposite of [seal]. Throws [SecretBoxAuthenticationError] (or FormatException) on a wrong key or tampering.
Future<Map<String, dynamic>> open(List<int> key, String ciphertext, String aad) async {
  final all = unb64u(ciphertext);
  if (all.length < 28) throw const FormatException('ciphertext too short');
  final box = SecretBox(all.sublist(12, all.length - 16), nonce: all.sublist(0, 12), mac: Mac(all.sublist(all.length - 16)));
  final clear = await _gcm.decrypt(box, secretKey: SecretKey(key), aad: utf8.encode(aad));
  return jsonDecode(utf8.decode(clear)) as Map<String, dynamic>;
}

/// Sync root key from the sync passphrase: Argon2id, m=64 MiB, t=3, p=1 (PROTOCOL.md 1.1). Takes about
/// a second, so it runs off the UI thread.
Future<Uint8List> deriveSyncRoot(String passphrase, List<int> salt) => Isolate.run(() async {
      final k = await Argon2id(parallelism: 1, memory: 65536, iterations: 3, hashLength: 32)
          .deriveKeyFromPassword(password: passphrase, nonce: salt);
      return Uint8List.fromList(await k.extractBytes());
    });

/// The keys a sync group derives from its root (PROTOCOL.md 1.1).
class SyncKeys {
  SyncKeys._(this.root, this.groupId, this.recordKey);
  final List<int> root;
  final String groupId;
  final List<int> recordKey;

  static Future<SyncKeys> fromRoot(List<int> root) async => SyncKeys._(
        root,
        b64u(await hkdf(root, const [], 'TA-SYNC-GROUP-ID-1', 32)),
        await hkdf(root, const [], 'TA-SYNC-RECORD-KEY-1', 32),
      );

  final _ids = <String, String>{};
  Future<String> recordId(String accountId) async =>
      _ids[accountId] ??= b64u(await hkdf(root, utf8.encode(accountId), 'TA-SYNC-RECORD-ID-1', 32));

  String aad(String recordId) => 'TA-SYNC-1|$groupId|$recordId';
}

/// This device's Ed25519 identity in a sync group.
class DeviceKey {
  DeviceKey._(this.seed, this.publicKey, this._pair);
  final List<int> seed;
  final String publicKey;
  final SimpleKeyPair _pair;

  static Future<DeviceKey> fromSeed(List<int> seed) async {
    final pair = await Ed25519().newKeyPairFromSeed(seed);
    return DeviceKey._(seed, b64u((await pair.extractPublicKey()).bytes), pair);
  }

  static Future<DeviceKey> create() => fromSeed(randomBytes(32));

  Future<String> sign(String text) async => b64u((await Ed25519().sign(utf8.encode(text), keyPair: _pair)).bytes);
}

