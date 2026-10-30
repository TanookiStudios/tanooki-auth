// Security key unlock (Premium): a YubiKey or other FIDO2 key opens the app. The key's PRF output (WebAuthn
// "prf", CTAP "hmac-secret") is a secret only that key can make, and it wraps the vault key. Unlocking asks the
// key for the same output, unwraps, and checks the result is this vault's key.
//
// Native halves: Apple in packages/tanooki_cloud (SecurityKey.swift), Windows in windows/runner
// (security_key.cpp). Android and Linux say "not available on this device yet".
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';

import 'sync/relay_crypto.dart';
import 'vault.dart';
import '../l10n/l10n.dart';

/// Settings keys: the added keys, and the PRF input every key on this device is asked with.
const securityKeysKey = 'securityKeys', securityKeySaltKey = 'securityKeySalt';

/// The WebAuthn relying party the keys are made for (the app's website).
const securityKeyRp = 'auth.tanookistudios.com';

const _info = 'TA-SECKEY-1';

class SecurityKeyException implements Exception {
  SecurityKeyException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// One added key: its credential id, the name the user gave it, and the vault key sealed under its PRF output.
typedef SecurityKeyEntry = ({String id, String name, String wrapped, DateTime added});

List<SecurityKeyEntry> securityKeysOf(Map<String, dynamic> s) => [
      for (final j in (s[securityKeysKey] as List?) ?? const [])
        if (j is Map)
          (id: j['id'] as String, name: j['name'] as String? ?? l10n.securityKeyDefaultName, wrapped: j['wrapped'] as String, added: DateTime.parse(j['added'] as String)),
    ];

Future<List<int>> _wrapKey(List<int> prf) => hkdf(prf, const [], _info, 32);

/// Seals [vaultKey] under [prf] (the key's PRF output), bound to the credential [id].
Future<String> wrapVaultKey(List<int> vaultKey, List<int> prf, String id) async =>
    seal(await _wrapKey(prf), {'k': b64u(vaultKey)}, '$_info|$id');

/// The vault key from [wrapped], or a [SecurityKeyException] when [prf] is from a different key.
Future<List<int>> unwrapVaultKey(String wrapped, List<int> prf, String id) async {
  try {
    return unb64u((await open(await _wrapKey(prf), wrapped, '$_info|$id'))['k'] as String);
  } catch (_) {
    throw SecurityKeyException(l10n.securityKeyNotYours);
  }
}

/// What the native side reports after touching a key.
typedef KeyTouch = ({String id, Uint8List prf});

/// The platform half. Tests replace [SecurityKeys.platform] with a fake.
abstract class SecurityKeyPlatform {
  /// Null when this device can use security keys, otherwise why not, in plain words.
  Future<String?> unavailable();
  /// Makes a new credential on a key and returns its id, plus the PRF output if the key gave it straight away.
  Future<({String id, Uint8List? prf})> register({required List<int> userId, required String name, required List<int> salt});
  /// Asks one of [ids] for its PRF output for [salt].
  Future<KeyTouch> touch({required List<String> ids, required List<int> salt});
}

class ChannelSecurityKeyPlatform implements SecurityKeyPlatform {
  static const _channel = MethodChannel('tanooki/securitykey');

  @override
  Future<String?> unavailable() async {
    if (Platform.isAndroid || Platform.isLinux) return l10n.securityKeyNotAvailable;
    try {
      return switch (await _channel.invokeMethod<String>('available')) {
        'ok' => null,
        'osTooOld' => Platform.isWindows
            ? l10n.securityKeyWindowsTooOld
            : Platform.isIOS
                ? l10n.securityKeyIosTooOld
                : l10n.securityKeyMacTooOld,
        _ => l10n.securityKeyNotAvailable,
      };
    } on MissingPluginException {
      return l10n.securityKeyNotAvailable;
    }
  }

  @override
  Future<({String id, Uint8List? prf})> register({required List<int> userId, required String name, required List<int> salt}) async {
    final r = await _run('register', {'rp': securityKeyRp, 'userId': Uint8List.fromList(userId), 'name': name, 'salt': Uint8List.fromList(salt)});
    return (id: b64u(r['id'] as Uint8List), prf: r['prf'] as Uint8List?);
  }

  @override
  Future<KeyTouch> touch({required List<String> ids, required List<int> salt}) async {
    final r = await _run('assert', {'rp': securityKeyRp, 'ids': [for (final i in ids) unb64u(i)], 'salt': Uint8List.fromList(salt)});
    final prf = r['prf'] as Uint8List?;
    if (prf == null) throw SecurityKeyException(_messages['noPrf']!());
    return (id: b64u(r['id'] as Uint8List), prf: prf);
  }

  Future<Map> _run(String method, Map<String, Object> args) async {
    try {
      return (await _channel.invokeMethod<Map>(method, args))!;
    } on PlatformException catch (e) {
      throw SecurityKeyException(_messages[e.code]?.call() ?? (e.message == null ? l10n.securityKeyDidntWork : l10n.securityKeyDidntWorkWhy(e.message!)));
    } on MissingPluginException {
      throw SecurityKeyException(l10n.securityKeyNotAvailable);
    }
  }
}

// One plain sentence per way it can fail (the native halves send these codes).
final _messages = <String, String Function()>{
  'canceled': () => l10n.securityKeyCanceled,
  'noPrf': () => l10n.securityKeyNoPrf,
  'notAllowed': () => l10n.securityKeyNotAllowed,
  'notAssociated': () => l10n.securityKeyNotAssociated,
  'exists': () => l10n.securityKeyExists,
  'pin': () => l10n.securityKeyPin,
};

class SecurityKeys {
  static SecurityKeyPlatform platform = ChannelSecurityKeyPlatform();

  static List<int> _salt(Vault v) {
    final s = v.settings[securityKeySaltKey];
    if (s is String) return unb64u(s);
    final fresh = randomBytes(32);
    v.settings[securityKeySaltKey] = b64u(fresh);
    return fresh;
  }

  static Future<List<int>> _vaultKey(Vault v) async {
    final k = await v.keyStore.read();
    if (k == null) throw SecurityKeyException(l10n.securityKeyVaultKeyMissing);
    return base64.decode(k);
  }

  /// Adds a key: makes a credential on it, gets its PRF output, wraps the vault key, saves. Returns the entry.
  static Future<SecurityKeyEntry> add(Vault v, String name) async {
    final why = await platform.unavailable();
    if (why != null) throw SecurityKeyException(why);
    final salt = _salt(v);
    final made = await platform.register(userId: randomBytes(16), name: name, salt: salt);
    // Most keys only give a PRF output when asked to sign in, so ask once more right away.
    final prf = made.prf ?? (await platform.touch(ids: [made.id], salt: salt)).prf;
    final entry = (id: made.id, name: name.trim().isEmpty ? l10n.securityKeyDefaultName : name.trim(), wrapped: await wrapVaultKey(await _vaultKey(v), prf, made.id), added: DateTime.now().toUtc());
    v.settings[securityKeysKey] = [
      for (final e in securityKeysOf(v.settings)) _json(e),
      _json(entry),
    ];
    await v.save();
    return entry;
  }

  static Map<String, String> _json(SecurityKeyEntry e) => {'id': e.id, 'name': e.name, 'wrapped': e.wrapped, 'added': e.added.toIso8601String()};

  static Future<void> remove(Vault v, String id) async {
    v.settings[securityKeysKey] = [
      for (final e in securityKeysOf(v.settings))
        if (e.id != id) _json(e),
    ];
    await v.save();
  }

  /// Asks for one of the added keys and checks it opens this vault. Throws [SecurityKeyException] otherwise.
  static Future<void> unlock(Vault v) async {
    final keys = securityKeysOf(v.settings);
    if (keys.isEmpty) throw SecurityKeyException(l10n.securityKeyNoneAdded);
    final touched = await platform.touch(ids: [for (final k in keys) k.id], salt: _salt(v));
    final entry = keys.where((k) => k.id == touched.id).firstOrNull;
    if (entry == null) throw SecurityKeyException(l10n.securityKeyNotYours);
    if (!_same(await unwrapVaultKey(entry.wrapped, touched.prf, entry.id), await _vaultKey(v))) {
      // Sealed for an older vault key (the vault was reset since): it can't open this one.
      throw SecurityKeyException(l10n.securityKeyBeforeReset);
    }
  }

  static bool _same(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    var d = 0;
    for (var i = 0; i < a.length; i++) {
      d |= a[i] ^ b[i];
    }
    return d == 0;
  }
}
