// Team vault (feature 42), app side. The relay part is relay/src/team.js; PROTOCOL.md section 4.
//
// Up to 10 devices share a team key. The admin's app makes the key, wraps it for each member's X25519 box key,
// and makes a new one (a new "epoch") whenever someone leaves. Team accounts are encrypted with the team key
// and live in vault.settings['team'], never in vault.accounts, so personal sync never sees them.
import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';

import 'account.dart';
import 'otpauth_uri.dart' show newId;
import 'sync/relay_client.dart';
import 'sync/relay_crypto.dart';
import 'vault.dart';
import '../l10n/l10n.dart';

const teamStateKey = 'team';
const teamLinkPrefix = 'tanookiauth://team?';
const teamMaxMembers = 10;

class TeamException implements Exception {
  TeamException(this.message);
  final String message;
  @override
  String toString() => message;
}

// ---------------------------------------------------------------- crypto (PROTOCOL.md 4.1)

final _gcm = AesGcm.with256bits();
const _wrapInfo = 'TA-TEAM-WRAP-1';

/// Wraps [teamKey] for one member: base64url(ephemeral X25519 public key || nonce || AES-256-GCM ciphertext and tag).
Future<String> wrapTeamKey(List<int> teamKey, String boxKey) async {
  final eph = await X25519().newKeyPair();
  final shared = await X25519()
      .sharedSecretKey(keyPair: eph, remotePublicKey: SimplePublicKey(unb64u(boxKey), type: KeyPairType.x25519));
  final key = await hkdf(await shared.extractBytes(), const [], _wrapInfo, 32);
  final box = await _gcm.encrypt(teamKey, secretKey: SecretKey(key), nonce: randomBytes(12));
  return b64u([...(await eph.extractPublicKey()).bytes, ...box.nonce, ...box.cipherText, ...box.mac.bytes]);
}

/// Opposite of [wrapTeamKey], with this device's box key pair.
Future<Uint8List> unwrapTeamKey(String wrapped, SimpleKeyPair box) async {
  try {
    final all = unb64u(wrapped);
    final shared = await X25519()
        .sharedSecretKey(keyPair: box, remotePublicKey: SimplePublicKey(all.sublist(0, 32), type: KeyPairType.x25519));
    final key = await hkdf(await shared.extractBytes(), const [], _wrapInfo, 32);
    final clear = await _gcm.decrypt(
      SecretBox(all.sublist(44, all.length - 16), nonce: all.sublist(32, 44), mac: Mac(all.sublist(all.length - 16))),
      secretKey: SecretKey(key),
    );
    return Uint8List.fromList(clear);
  } catch (_) {
    throw TeamException(l10n.teamKeyUnopenable);
  }
}

String teamAad(String teamId, String entryId, int epoch) => 'TA-TEAM-1|$teamId|$entryId|$epoch';

// ---------------------------------------------------------------- local state

/// vault.settings['team']: relay, teamId, role ('admin' or 'member'), device and box (seeds), keys (epoch -> team
/// key), cursor, license (admin), and entries: id -> {u: updatedAt ms, d: deleted, a: account JSON, e: epoch the
/// relay holds it under (0 = never sent), dirty: changed here and not yet sent}.
Map<String, dynamic>? teamState(Vault v) => (v.settings[teamStateKey] as Map?)?.cast<String, dynamic>();
bool inTeam(Vault v) => teamState(v) != null;
bool isTeamAdmin(Vault v) => teamState(v)?['role'] == 'admin';

Map<String, dynamic> _entries(Map<String, dynamic> s) =>
    (s['entries'] as Map? ?? {}).map((k, e) => MapEntry(k as String, (e as Map).cast<String, dynamic>()));

/// The team's accounts (not deleted), by name.
List<Account> teamAccounts(Vault v) {
  final s = teamState(v);
  if (s == null) return const [];
  return [
    for (final e in _entries(s).values)
      if (e['d'] != true && e['a'] is Map) Account.fromJson((e['a'] as Map).cast<String, dynamic>()),
  ]..sort((a, b) => '${a.issuer} ${a.label}'.toLowerCase().compareTo('${b.issuer} ${b.label}'.toLowerCase()));
}

/// A copy of [a] for the team: a new id, without this person's folder, favorite, Trash or last-used details.
Account teamCopyOf(Account a) => Account.fromJson({
      ...a.toJson(),
      'id': newId(),
      'folder': null,
      'favorite': false,
      'lastUsedAt': null,
      'deletedAt': null,
      'travelHidden': false,
      'order': 0,
    });

void _writeEntry(Vault v, String id, Account? a) {
  final s = teamState(v)!;
  final entries = _entries(s);
  final before = entries[id]?['u'] as int? ?? 0;
  final now = DateTime.now().millisecondsSinceEpoch;
  entries[id] = {
    'u': now > before ? now : before + 1, // an edit always beats what it was based on
    'd': a == null,
    'a': a?.toJson(),
    'e': entries[id]?['e'] ?? 0,
    'dirty': true,
  };
  s['entries'] = entries;
  v.settings[teamStateKey] = s;
}

/// Adds or changes a team account on this device; the next [TeamClient.sync] sends it. The caller saves.
void putTeamAccount(Vault v, Account a) => _writeEntry(v, a.id, a);

/// Removes a team account for everyone (on the next sync). The caller saves.
void removeTeamAccount(Vault v, String id) => _writeEntry(v, id, null);

// ---------------------------------------------------------------- invite links

typedef TeamInvite = ({String relay, String teamId, String invite});

String teamInviteLink(String relay, String teamId, String invite) =>
    '${teamLinkPrefix}v=1&relay=${Uri.encodeComponent(relay)}&team=$teamId&invite=${Uri.encodeComponent(invite)}';

TeamInvite parseTeamInvite(String link) {
  final t = link.trim();
  final q = t.startsWith(teamLinkPrefix) ? Uri.splitQueryString(t.substring(teamLinkPrefix.length)) : const <String, String>{};
  final relay = q['relay'], team = q['team'], invite = q['invite'];
  if (q['v'] != '1' || relay == null || !relay.startsWith('https://') && !relay.startsWith('http://') ||
      team == null || team.length != 43 || invite == null || invite.isEmpty) {
    throw TeamException(l10n.teamNotAnInvite);
  }
  return (relay: relay, teamId: team, invite: invite);
}

// ---------------------------------------------------------------- relay

class TeamMember {
  TeamMember(this.json);
  final Map<String, dynamic> json;
  String get key => json['key'] as String;
  String get boxKey => json['boxKey'] as String;
  bool get admin => json['role'] == 'admin';
  bool get hasKey => json['hasKey'] == true;
  DateTime get added => DateTime.fromMillisecondsSinceEpoch(json['added'] as int);
}

class TeamStatus {
  TeamStatus(this.json);
  final Map<String, dynamic> json;
  int get epoch => json['epoch'] as int;
  bool get needsRotation => json['needsRotation'] == true;
  DateTime get licenseEnd => DateTime.fromMillisecondsSinceEpoch(json['licenseEnd'] as int? ?? 0);
  List<TeamMember> get members => [for (final m in json['members'] as List) TeamMember((m as Map).cast<String, dynamic>())];
}

class TeamReport {
  int pulled = 0, pushed = 0, skipped = 0;
  /// True while the admin's app hasn't given this device the team key yet.
  bool waitingForKey = false;
}

/// Renews the admin's team license with the Premium worker. Returns the new token, or null when it can't
/// right now (the old one keeps working for 14 days past its end). Set by the app (store.dart); tests fake it.
typedef TeamLicenseRefresher = Future<String?> Function(String token);

/// Signed calls for this device's team, and the sync pass.
class TeamClient {
  TeamClient(this.vault, {this.refreshLicense});
  final Vault vault;
  final TeamLicenseRefresher? refreshLicense;

  Map<String, dynamic> get _s => teamState(vault) ?? (throw TeamException(l10n.teamNotInTeam));
  String get teamId => _s['teamId'] as String;
  String get _path => '/v1/team/$teamId';

  Future<SyncRelay> _relay() async => SyncRelay(_s['relay'] as String, teamId, await DeviceKey.fromSeed(unb64u(_s['device'] as String)));
  Future<SimpleKeyPair> _box() => X25519().newKeyPairFromSeed(unb64u(_s['box'] as String));
  Future<String> myKey() async => (await DeviceKey.fromSeed(unb64u(_s['device'] as String))).publicKey;

  Future<Map<String, dynamic>> _call(String method, String path, List<int> ok, [Object? body]) async {
    final r = await (await _relay()).call(method, path, body);
    if (r.status == 403 && r.body['error'] == 'device is not in this team' || r.status == 404 && r.body['error'] == 'team not found') {
      throw TeamGoneException(r.status == 404
          ? l10n.teamDeletedByAdmin
          : l10n.teamDeviceRemoved);
    }
    return expectStatus(r, ok);
  }

  /// Makes a team with this device as admin. [license] is the TT1 team license from the purchase page.
  static Future<void> create(Vault v, String license, {String relay = relayUrl}) async {
    if (inTeam(v)) throw TeamException(l10n.teamAlreadyInTeam);
    final lic = license.trim();
    if (!lic.startsWith('TT1.')) {
      throw TeamException(l10n.teamNotALicense);
    }
    final teamId = b64u(randomBytes(32)), device = randomBytes(32), box = randomBytes(32);
    final key = randomBytes(32);
    final me = await DeviceKey.fromSeed(device);
    final pair = await X25519().newKeyPairFromSeed(box);
    final boxPub = b64u((await pair.extractPublicKey()).bytes);
    final api = SyncRelay(relay, teamId, me);
    expectStatus(await api.call('POST', '/v1/team/$teamId/create', {'license': lic, 'boxKey': boxPub}), [201]);
    expectStatus(await api.call('POST', '/v1/team/$teamId/keys', {'epoch': 1, 'keys': {me.publicKey: await wrapTeamKey(key, boxPub)}}), [200]);
    v.settings[teamStateKey] = {
      'relay': relay,
      'teamId': teamId,
      'role': 'admin',
      'device': b64u(device),
      'box': b64u(box),
      'keys': {'1': b64u(key)},
      'epoch': 1,
      'cursor': 0,
      'license': lic,
      'licenseCheckedAt': DateTime.now().millisecondsSinceEpoch,
      'entries': <String, dynamic>{},
    };
    await v.save();
  }

  /// Joins the team in an invite link. The team key arrives once the admin's app next syncs.
  static Future<void> join(Vault v, String link) async {
    if (inTeam(v)) throw TeamException(l10n.teamAlreadyInTeamLeaveFirst);
    final inv = parseTeamInvite(link);
    final device = randomBytes(32), box = randomBytes(32);
    final me = await DeviceKey.fromSeed(device);
    final boxPub = b64u((await (await X25519().newKeyPairFromSeed(box)).extractPublicKey()).bytes);
    final r = await SyncRelay(inv.relay, inv.teamId, me)
        .call('POST', '/v1/team/${inv.teamId}/join', {'invite': inv.invite, 'boxKey': boxPub});
    if (r.status == 404) throw TeamException(l10n.teamGone);
    if (r.status == 403) throw TeamException(l10n.teamInviteUsed);
    if (r.status == 507) throw TeamException(l10n.teamFull);
    expectStatus(r, [201]);
    v.settings[teamStateKey] = {
      'relay': inv.relay,
      'teamId': inv.teamId,
      'role': 'member',
      'device': b64u(device),
      'box': b64u(box),
      'keys': <String, dynamic>{},
      'epoch': 0,
      'cursor': 0,
      'entries': <String, dynamic>{},
    };
    await v.save();
  }

  Future<TeamStatus> status() async => TeamStatus(await _call('GET', _path, [200]));

  /// A single-use invite link (valid 7 days). Admin only.
  Future<String> inviteLink() async {
    final b = await _call('POST', '$_path/invites', [201]);
    return teamInviteLink(_s['relay'] as String, teamId, b['invite'] as String);
  }

  /// Admin: removes [memberKey] at once, then gives everyone left a new team key.
  Future<void> removeMember(String memberKey) async {
    await _call('DELETE', '$_path/members/$memberKey', [200]);
    await _rotate(await status());
  }

  /// Member: leaves the team and forgets it on this device.
  Future<void> leave() async {
    try {
      await _call('DELETE', '$_path/members/${await myKey()}', [200]);
    } on TeamGoneException {
      // already out
    }
    await forget();
  }

  /// Admin: deletes the team and everything in it, for everyone.
  Future<void> deleteTeam() async {
    try {
      await _call('DELETE', _path, [200]);
    } on TeamGoneException {
      // already gone
    }
    await forget();
  }

  /// Drops the team and its accounts from this device only.
  Future<void> forget() async {
    vault.settings.remove(teamStateKey);
    await vault.save();
  }

  /// New team key (next epoch), wrapped for every member.
  Future<void> _rotate(TeamStatus st) async {
    final key = randomBytes(32);
    final epoch = st.epoch + 1;
    final b = await _call('POST', '$_path/keys', [200], {
      'epoch': epoch,
      'keys': {for (final m in st.members) m.key: await wrapTeamKey(key, m.boxKey)},
    });
    final s = _s;
    s['keys'] = {...(s['keys'] as Map), '$epoch': b64u(key)};
    s['epoch'] = b['epoch'] as int;
    vault.settings[teamStateKey] = s;
    await vault.save();
  }

  Uint8List? _keyFor(Map<String, dynamic> s, int epoch) {
    final k = (s['keys'] as Map)['$epoch'];
    return k is String ? unb64u(k) : null;
  }

  /// One pass: admin chores (rotation, keys for new members, license renewal), then pull, re-encrypt old-epoch
  /// entries, and push this device's changes. Throws [TeamGoneException] when the team is gone for this device.
  Future<TeamReport> sync() async {
    final report = TeamReport();
    TeamStatus st;
    try {
      st = await status();
    } on TeamGoneException {
      await forget();
      rethrow;
    }
    var s = _s;
    final admin = s['role'] == 'admin';

    if (admin) {
      if (st.needsRotation) {
        await _rotate(st);
        st = await status();
      }
      final current = _keyFor(_s, st.epoch);
      final missing = st.members.where((m) => !m.hasKey).toList();
      if (current != null && missing.isNotEmpty) {
        await _call('POST', '$_path/keys', [200], {
          'epoch': st.epoch,
          'keys': {for (final m in missing) m.key: await wrapTeamKey(current, m.boxKey)},
        });
      }
      await _renewLicense(st);
      s = _s;
    }

    // This device's key for the current epoch.
    if (_keyFor(s, st.epoch) == null) {
      final r = await (await _relay()).call('GET', '$_path/key');
      if (r.status == 404) {
        report.waitingForKey = true;
      } else {
        final b = expectStatus(r, [200]);
        s['keys'] = {...(s['keys'] as Map), '${b['epoch']}': b64u(await unwrapTeamKey(b['wrapped'] as String, await _box()))};
      }
    }
    s['epoch'] = st.epoch;

    final entries = _entries(s);
    // Takes a relay entry when it is newer than ours (or ours was never changed here).
    Future<void> take(Map<String, dynamic> e) async {
      final id = e['id'] as String, epoch = e['epoch'] as int, u = e['updatedAt'] as int;
      final mine = entries[id];
      if (mine != null && (mine['u'] as int) > u) return; // ours is newer; it goes out in the push below
      final key = _keyFor(s, epoch);
      Map<String, dynamic>? body;
      if (key != null) {
        try {
          body = await open(key, e['ciphertext'] as String, teamAad(teamId, id, epoch));
        } catch (_) {}
      }
      if (body == null) {
        report.skipped++; // a key this device never had (it joined after a rotation) or tampering: keep ours
        return;
      }
      final deleted = e['deleted'] == true;
      Map<String, dynamic>? account;
      if (!deleted) {
        try {
          account = Account.fromJson({...(body['account'] as Map).cast<String, dynamic>(), 'id': id}).toJson();
        } catch (_) {
          report.skipped++;
          return;
        }
      }
      entries[id] = {'u': u, 'd': deleted, 'a': account, 'e': epoch, 'dirty': false};
      report.pulled++;
    }

    var cursor = s['cursor'] as int? ?? 0;
    for (var more = true; more;) {
      final b = await _call('GET', '$_path/entries?since=$cursor', [200]);
      for (final e in b['entries'] as List) {
        await take((e as Map).cast<String, dynamic>());
      }
      cursor = b['cursor'] as int;
      more = b['more'] == true;
    }

    // Push: changes made here, plus entries still under an old key (same time, new epoch: PROTOCOL.md 4.4).
    final key = _keyFor(s, st.epoch);
    if (key != null) {
      for (var round = 0; round < 3; round++) {
        final out = entries.entries.where((x) => x.value['dirty'] == true || ((x.value['e'] as int? ?? 0) > 0 && x.value['e'] != st.epoch)).toList();
        if (out.isEmpty) break;
        for (var at = 0; at < out.length; at += 100) {
          final batch = out.skip(at).take(100).toList();
          final b = await _call('POST', '$_path/entries', [200], {
            'entries': [
              for (final x in batch)
                {
                  'id': x.key,
                  'updatedAt': x.value['u'],
                  'deleted': x.value['d'] == true,
                  'epoch': st.epoch,
                  'ciphertext': await seal(key, {'v': 1, 'account': x.value['a']}, teamAad(teamId, x.key, st.epoch)),
                },
            ],
          });
          for (final r in (b['results'] as List).cast<Map>()) {
            final id = r['id'] as String;
            if (r['status'] == 'ok') {
              entries[id]!
                ..['dirty'] = false
                ..['e'] = st.epoch;
              report.pushed++;
            } else {
              final cur = (r['current'] as Map).cast<String, dynamic>();
              entries[id]!['dirty'] = false;
              await take(cur);
            }
          }
        }
      }
    }

    s
      ..['entries'] = entries
      ..['cursor'] = cursor
      ..['lastSync'] = DateTime.now().toUtc().toIso8601String()
      ..['waitingForKey'] = report.waitingForKey;
    vault.settings[teamStateKey] = s;
    await vault.save();
    return report;
  }

  /// Admin: about once a day, ask the Premium worker for a renewed license and hand it to the relay.
  Future<void> _renewLicense(TeamStatus st) async {
    final s = _s;
    final token = s['license'] as String?;
    final last = s['licenseCheckedAt'] as int? ?? 0;
    if (refreshLicense == null || token == null || DateTime.now().millisecondsSinceEpoch - last < const Duration(hours: 20).inMilliseconds) return;
    final fresh = await refreshLicense!(token);
    s['licenseCheckedAt'] = DateTime.now().millisecondsSinceEpoch;
    if (fresh != null && fresh != token) {
      await _call('POST', '$_path/license', [200], {'license': fresh});
      s['license'] = fresh;
    }
    vault.settings[teamStateKey] = s;
  }
}

/// The team was deleted, or this device was removed from it. The team has already been forgotten here.
class TeamGoneException extends TeamException {
  TeamGoneException(super.message);
}

/// What the license on this device says, for the Team screen. Null when it can't be read.
DateTime? teamLicenseEnd(String token) {
  try {
    final parts = utf8.decode(unb64u(token.split('.')[1])).split('|');
    return DateTime.fromMillisecondsSinceEpoch(int.parse(parts[2]) * 1000);
  } catch (_) {
    return null;
  }
}
