// Emergency access (Premium), app side. The relay part is relay/src/emergency.js; PROTOCOL.md section 3.
//
// The contact makes a contact code (two public keys) in their own Tanooki Auth and gives it to the owner. The
// owner's app seals a copy of the accounts to the contact's X25519 key and leaves it on the relay, then gives
// the contact a grant code (the grant's id). The contact can ask for the copy; the relay hands it over only if
// the owner didn't deny within 7 days. The relay never has a key that opens the copy.
import 'dart:async';
import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:flutter/foundation.dart';

import 'account.dart';
import 'sync/relay_client.dart';
import 'sync/relay_crypto.dart';
import 'vault.dart';

const contactPrefix = 'tanookiauth-contact:';
const grantPrefix = 'tanookiauth-emergency:';
const emergencyWait = Duration(days: 7);

/// Settings keys. [meKey]: this device's own contact keys. [grantKey]: the copy this owner left for someone.
/// [fromKey]: copies other people left for this device to ask for.
const meKey = 'emergencyMe', grantKey = 'emergencyGrant', fromKey = 'emergencyFrom';
const _aad = 'TA-EMERGENCY-1';

class EmergencyException implements Exception {
  EmergencyException(this.message);
  final String message;
  @override
  String toString() => message;
}

String _pack(String prefix, Map<String, Object?> j) => '$prefix${b64u(utf8.encode(jsonEncode(j)))}';
Map<String, dynamic>? _unpack(String prefix, String text) {
  final t = text.trim();
  if (!t.startsWith(prefix)) return null;
  try {
    final j = jsonDecode(utf8.decode(unb64u(t.substring(prefix.length)))) as Map<String, dynamic>;
    return j['v'] == 1 ? j : null;
  } catch (_) {
    return null;
  }
}

// ---------------------------------------------------------------- contact side: keys and code

/// This device's keys as an emergency contact, made the first time they're needed (the caller saves).
Future<({DeviceKey sign, SimpleKeyPair box})> myContactKeys(Vault v) async {
  var me = (v.settings[meKey] as Map?)?.cast<String, dynamic>();
  if (me == null) {
    me = {'sign': b64u(randomBytes(32)), 'box': b64u(randomBytes(32))};
    v.settings[meKey] = me;
  }
  return (
    sign: await DeviceKey.fromSeed(unb64u(me['sign'] as String)),
    box: await X25519().newKeyPairFromSeed(unb64u(me['box'] as String)),
  );
}

/// The code this person gives to someone who wants them as their emergency contact.
Future<String> myContactCode(Vault v, String name) async {
  final k = await myContactKeys(v);
  return _pack(contactPrefix, {'v': 1, 'k': k.sign.publicKey, 'x': b64u((await k.box.extractPublicKey()).bytes), 'n': name.trim()});
}

typedef ContactCode = ({String signKey, String boxKey, String name});

ContactCode parseContactCode(String text) {
  final j = _unpack(contactPrefix, text);
  final k = j?['k'], x = j?['x'];
  if (k is! String || x is! String || k.length != 43 || x.length != 43) {
    throw EmergencyException('That isn\'t a Tanooki Auth contact code. Ask them to open Tanooki Auth, go to Settings > Emergency access, and share their contact code.');
  }
  return (signKey: k, boxKey: x, name: (j!['n'] as String? ?? '').trim());
}

// ---------------------------------------------------------------- sealing

/// Seals [accounts] so only the holder of [boxKey]'s private half can open them:
/// base64url(ephemeral X25519 public key || nonce || AES-256-GCM ciphertext and tag).
Future<String> sealSnapshot(List<Account> accounts, String boxKey) async {
  final eph = await X25519().newKeyPair();
  final shared = await X25519().sharedSecretKey(keyPair: eph, remotePublicKey: SimplePublicKey(unb64u(boxKey), type: KeyPairType.x25519));
  final key = await hkdf(await shared.extractBytes(), const [], _aad, 32);
  final sealed = unb64u(await seal(key, {'v': 1, 'accounts': [for (final a in accounts) a.toJson()]}, _aad));
  return b64u([...(await eph.extractPublicKey()).bytes, ...sealed]);
}

/// Opens a copy made by [sealSnapshot] with this device's box key.
Future<List<Account>> openSnapshot(String blob, SimpleKeyPair box) async {
  try {
    final all = unb64u(blob);
    final shared = await X25519().sharedSecretKey(keyPair: box, remotePublicKey: SimplePublicKey(all.sublist(0, 32), type: KeyPairType.x25519));
    final key = await hkdf(await shared.extractBytes(), const [], _aad, 32);
    final body = await open(key, b64u(all.sublist(32)), _aad);
    return [for (final j in body['accounts'] as List) Account.fromJson(j as Map<String, dynamic>)];
  } catch (_) {
    throw EmergencyException('The emergency copy couldn\'t be opened with this device\'s key. It was made for a different device, or it is damaged.');
  }
}

// ---------------------------------------------------------------- relay

/// One grant's state on the relay (PROTOCOL.md 3.2).
class GrantStatus {
  GrantStatus(this.json);
  final Map<String, dynamic> json;
  String get state => json['state'] as String? ?? 'idle'; // idle, waiting, released
  DateTime? _t(String k) => json[k] is int ? DateTime.fromMillisecondsSinceEpoch(json[k] as int) : null;
  DateTime? get requestedAt => _t('requestedAt');
  DateTime? get releaseAt => _t('releaseAt');
  DateTime? get updatedAt => _t('updatedAt');
}

/// Signed calls for one grant. Each refusal comes back as a plain sentence.
class EmergencyRelay {
  EmergencyRelay(this.grantId, this.device, {this.base = relayUrl});
  final String grantId;
  final DeviceKey device;
  final String base;
  late final _relay = SyncRelay(base, grantId, device);
  String get _path => '/v1/emergency/$grantId';

  Future<Map<String, dynamic>> _call(String method, String sub, List<int> ok, [Object? body]) async {
    final r = await _relay.call(method, '$_path$sub', body ?? (method == 'POST' ? {} : null));
    if (ok.contains(r.status)) return r.body;
    final said = r.body['error'] as String? ?? '';
    throw EmergencyException(switch ((r.status, said)) {
      (404, _) => 'This emergency copy doesn\'t exist any more. The owner removed it.',
      (403, 'the waiting period has not ended') => 'The 7-day wait isn\'t over yet.',
      (403, _) => 'This device isn\'t the owner or the contact for that emergency copy.',
      (409, 'there is no request to deny') => 'There is no request to deny any more.',
      (409, _) => 'Ask for access first.',
      (413, _) => 'Your accounts are too big to leave as an emergency copy (the limit is about 500 KB).',
      (429, _) => 'Too many tries in a minute. Wait a minute and try again.',
      _ => 'The sync server said no (HTTP ${r.status}${said.isEmpty ? '' : ': $said'}).',
    });
  }

  Future<GrantStatus> upload(String contactKey, String blob) async =>
      GrantStatus(await _call('POST', '', [200, 201], {'contactKey': contactKey, 'blob': blob}));
  Future<GrantStatus> status() async => GrantStatus(await _call('GET', '', [200]));
  /// [testDelaySeconds] only matters to a local test relay (TEST_MODE); the real one always waits 7 days.
  Future<GrantStatus> request({int? testDelaySeconds}) async =>
      GrantStatus(await _call('POST', '/request', [200, 201], {'delaySeconds': ?testDelaySeconds}));
  Future<GrantStatus> deny() async => GrantStatus(await _call('POST', '/deny', [200]));
  Future<String> blob() async => (await _call('GET', '/blob', [200]))['blob'] as String;
  Future<void> delete() => _call('DELETE', '', [200]);
  Future<void> registerPush(String platform, String token, String environment) =>
      _call('POST', '/push', [200], {'platform': platform, 'token': token, 'environment': environment});
}

// ---------------------------------------------------------------- owner side

String grantCode(String grantId, String ownerName) => _pack(grantPrefix, {'v': 1, 'g': grantId, 'n': ownerName.trim()});

Map<String, dynamic>? grantOf(Vault v) => (v.settings[grantKey] as Map?)?.cast<String, dynamic>();

/// Keeps the owner's emergency copy on the relay and its status for the app to show.
class EmergencyService {
  EmergencyService({this.base = relayUrl});
  static final instance = EmergencyService();
  final String base;

  /// The owner's grant as the relay last reported it (null until checked).
  final status = ValueNotifier<GrantStatus?>(null);
  /// Why the last upload or check failed, in plain words; null when it worked.
  final problem = ValueNotifier<String?>(null);
  /// Whether Premium is unlocked; set by the app (main.dart). Without it the copy isn't kept up to date.
  bool Function() isPremium = () => false;
  Timer? _debounce;

  Future<EmergencyRelay> _owner(Map<String, dynamic> g) async =>
      EmergencyRelay(g['id'] as String, await DeviceKey.fromSeed(unb64u(g['seed'] as String)), base: base);

  /// Makes a new grant for [contact], uploads the first copy, saves, and returns the grant code to give them.
  Future<String> setUp(Vault v, ContactCode contact, String ownerName) async {
    final g = {
      'id': b64u(randomBytes(32)),
      'seed': b64u(randomBytes(32)),
      'contactKey': contact.signKey,
      'contactBox': contact.boxKey,
      'contactName': contact.name,
      'ownerName': ownerName.trim(),
    };
    await _upload(v, g);
    v.settings[grantKey] = g;
    await v.save();
    return grantCode(g['id']!, ownerName);
  }

  Future<void> _upload(Vault v, Map<String, dynamic> g) async {
    final relay = await _owner(g);
    status.value = await relay.upload(g['contactKey'] as String, await sealSnapshot(v.live, g['contactBox'] as String));
    g['sealedAt'] = DateTime.now().toUtc().toIso8601String();
    problem.value = null;
  }

  /// After a save: refreshes the copy a few seconds later, so a burst of edits uploads once.
  void vaultChanged(Vault v, {Duration delay = const Duration(seconds: 5)}) {
    if (grantOf(v) == null || !isPremium()) return;
    _debounce?.cancel();
    _debounce = Timer(delay, () => updateNow(v));
  }

  /// Uploads a fresh copy now. Returns false (with [problem] set) when it couldn't.
  Future<bool> updateNow(Vault v) async {
    final g = grantOf(v);
    if (g == null) return false;
    try {
      // Not saved here (a save would call vaultChanged again): the new sealedAt rides along with the next save.
      await _upload(v, g);
      return true;
    } on EmergencyException catch (e) {
      problem.value = e.message;
    } on RelayException catch (e) {
      problem.value = e.message;
    }
    return false;
  }

  /// Asks the relay whether the contact has asked. Call when the app opens: a notification can be missed.
  Future<GrantStatus?> check(Vault v) async {
    final g = grantOf(v);
    if (g == null) return status.value = null;
    try {
      status.value = await (await _owner(g)).status();
      problem.value = null;
    } on EmergencyException catch (e) {
      problem.value = e.message;
    } on RelayException catch (e) {
      problem.value = e.message;
    }
    return status.value;
  }

  Future<void> deny(Vault v) async {
    final g = grantOf(v);
    if (g == null) return;
    status.value = await (await _owner(g)).deny();
  }

  Future<void> registerPush(Vault v, String platform, String token, String environment) async {
    final g = grantOf(v);
    if (g != null) await (await _owner(g)).registerPush(platform, token, environment);
  }

  /// Deletes the copy from the relay, then forgets the grant here.
  Future<void> remove(Vault v) async {
    final g = grantOf(v);
    if (g == null) return;
    try {
      await (await _owner(g)).delete();
    } on EmergencyException catch (_) {
      // Already gone from the relay (404): nothing left to delete there.
    }
    v.settings.remove(grantKey);
    status.value = null;
    problem.value = null;
    await v.save();
  }
}

// ---------------------------------------------------------------- contact side: copies left for me

typedef EmergencyFrom = ({String grantId, String ownerName});

List<EmergencyFrom> copiesForMe(Vault v) => [
      for (final j in (v.settings[fromKey] as List?) ?? const [])
        if (j is Map && j['g'] is String) (grantId: j['g'] as String, ownerName: j['n'] as String? ?? ''),
    ];

/// Remembers a grant code someone gave this device. Throws [EmergencyException] for anything else.
Future<EmergencyFrom> addGrantCode(Vault v, String text) async {
  final j = _unpack(grantPrefix, text);
  final g = j?['g'];
  if (g is! String || g.length != 43) {
    throw EmergencyException('That isn\'t a Tanooki Auth emergency code. Ask the person who chose you to send it again from Settings > Emergency access.');
  }
  final from = (grantId: g, ownerName: (j!['n'] as String? ?? '').trim());
  v.settings[fromKey] = [
    for (final f in copiesForMe(v))
      if (f.grantId != g) {'g': f.grantId, 'n': f.ownerName},
    {'g': g, 'n': from.ownerName},
  ];
  await myContactKeys(v);
  await v.save();
  return from;
}

Future<void> forgetGrant(Vault v, String grantId) async {
  v.settings[fromKey] = [
    for (final f in copiesForMe(v))
      if (f.grantId != grantId) {'g': f.grantId, 'n': f.ownerName},
  ];
  await v.save();
}

Future<EmergencyRelay> contactRelay(Vault v, String grantId, {String base = relayUrl}) async =>
    EmergencyRelay(grantId, (await myContactKeys(v)).sign, base: base);

/// Downloads and opens the copy (only works after the wait), without adding anything yet.
Future<List<Account>> fetchEmergencyCopy(Vault v, String grantId, {String base = relayUrl}) async {
  final keys = await myContactKeys(v);
  final blob = await EmergencyRelay(grantId, keys.sign, base: base).blob();
  return openSnapshot(blob, keys.box);
}

/// "6 days 4 hours", "3 hours", "less than a minute": what's left of the wait.
String waitLeft(DateTime releaseAt, DateTime now) {
  final d = releaseAt.difference(now);
  if (d.inMinutes < 1) return 'less than a minute';
  String n(int x, String unit) => '$x $unit${x == 1 ? '' : 's'}';
  if (d.inDays >= 1) return d.inHours % 24 == 0 ? n(d.inDays, 'day') : '${n(d.inDays, 'day')} ${n(d.inHours % 24, 'hour')}';
  if (d.inHours >= 1) return n(d.inHours, 'hour');
  return n(d.inMinutes, 'minute');
}
