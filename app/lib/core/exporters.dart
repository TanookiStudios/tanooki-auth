// Exports for moving to another authenticator app. Each is read back by our own importers in
// test/exporters_test.dart, so what we write is what Aegis and 2FAS read.
import 'dart:convert';
import 'dart:isolate';
import 'dart:math';

import 'package:cryptography/cryptography.dart';

import 'account.dart';
import 'scrypt.dart';

/// A random version-4 UUID, as Aegis uses for entries, groups and key slots.
String uuidV4() {
  final r = Random.secure();
  final b = List.generate(16, (_) => r.nextInt(256));
  b[6] = (b[6] & 0x0f) | 0x40;
  b[8] = (b[8] & 0x3f) | 0x80;
  final h = b.map((x) => x.toRadixString(16).padLeft(2, '0')).join();
  return '${h.substring(0, 8)}-${h.substring(8, 12)}-${h.substring(12, 16)}-${h.substring(16, 20)}-${h.substring(20)}';
}

String _algo(Account a) => a.algorithm.name.toUpperCase();

// ---------- Aegis ----------
// Format: https://github.com/beemdevelopment/Aegis/blob/master/docs/vault.md (vault version 1, database version 3).

Map<String, dynamic> _aegisDb(List<Account> accounts) {
  final groups = {for (final f in accounts.map((a) => a.folder).whereType<String>().toSet()) f: uuidV4()};
  return {
    'version': 3,
    'entries': [
      for (final a in accounts)
        {
          'type': a.type.name,
          'uuid': uuidV4(),
          'name': a.label,
          'issuer': a.issuer,
          'note': a.notes,
          'favorite': a.favorite,
          'icon': null,
          'info': {
            'secret': a.secret,
            'algo': _algo(a),
            'digits': a.digits,
            if (a.timeBased) 'period': a.period,
            if (a.type == OtpType.hotp) 'counter': a.counter,
          },
          'groups': [if (a.folder != null) groups[a.folder]],
        },
    ],
    'groups': [for (final e in groups.entries) {'uuid': e.value, 'name': e.key}],
  };
}

/// Aegis "unencrypted" export: every setup key in plain JSON.
String exportAegisPlain(List<Account> accounts) => const JsonEncoder.withIndent('    ').convert({
      'version': 1,
      'header': {'slots': null, 'params': null},
      'db': _aegisDb(accounts),
    });

/// Aegis password-protected export: a random master key seals the database with AES-256-GCM; the password,
/// through scrypt (N=32768, r=8, p=1, Aegis's own settings), seals the master key in a "password slot".
/// [scryptN] is lowered only by tests, to keep them fast.
Future<String> exportAegisEncrypted(List<Account> accounts, String password, {int scryptN = 32768}) async {
  final r = Random.secure();
  List<int> random(int n) => List.generate(n, (_) => r.nextInt(256));
  final masterKey = random(32), salt = random(32);
  final pw = utf8.encode(password);
  final slotKey = await Isolate.run(() => scrypt(pw, salt, n: scryptN, r: 8, p: 1));
  final gcm = AesGcm.with256bits();
  final keyBox = await gcm.encrypt(masterKey, secretKey: SecretKey(slotKey), nonce: random(12));
  final dbBox = await gcm.encrypt(utf8.encode(jsonEncode(_aegisDb(accounts))), secretKey: SecretKey(masterKey), nonce: random(12));
  String hex(List<int> b) => b.map((x) => x.toRadixString(16).padLeft(2, '0')).join();
  return const JsonEncoder.withIndent('    ').convert({
    'version': 1,
    'header': {
      'slots': [
        {
          'type': 1,
          'uuid': uuidV4(),
          'key': hex(keyBox.cipherText),
          'key_params': {'nonce': hex(keyBox.nonce), 'tag': hex(keyBox.mac.bytes)},
          'n': scryptN,
          'r': 8,
          'p': 1,
          'salt': hex(salt),
          'repaired': true,
          'is_backup': false,
        },
      ],
      'params': {'nonce': hex(dbBox.nonce), 'tag': hex(dbBox.mac.bytes)},
    },
    'db': base64.encode(dbBox.cipherText),
  });
}

// ---------- 2FAS ----------

/// 2FAS ".2fas" backup without a password (schema version 4, as the 2FAS app writes it).
String export2fas(List<Account> accounts, {DateTime? now}) {
  final ms = (now ?? DateTime.now()).millisecondsSinceEpoch;
  return const JsonEncoder.withIndent('  ').convert({
    'services': [
      for (var i = 0; i < accounts.length; i++)
        {
          'name': accounts[i].issuer.isEmpty ? accounts[i].label : accounts[i].issuer,
          'secret': accounts[i].secret,
          'updatedAt': ms,
          'otp': {
            'label': accounts[i].issuer.isEmpty ? accounts[i].label : '${accounts[i].issuer}:${accounts[i].label}',
            'account': accounts[i].label,
            'issuer': accounts[i].issuer,
            'digits': accounts[i].digits,
            'period': accounts[i].period,
            'algorithm': _algo(accounts[i]),
            'tokenType': accounts[i].type.name.toUpperCase(),
            if (accounts[i].type == OtpType.hotp) 'counter': accounts[i].counter,
            'source': 'Manual',
          },
          'order': {'position': i},
          'icon': {'selected': 'Label', 'label': {'text': _initials(accounts[i]), 'backgroundColor': 'Default'}},
        },
    ],
    'groups': <Object>[],
    'updatedAt': ms,
    'schemaVersion': 4,
    'appVersionCode': 5000000,
    'appVersionName': '5.0.0',
    'appOrigin': 'export',
  });
}

String _initials(Account a) {
  final n = (a.issuer.isEmpty ? a.label : a.issuer).trim();
  return n.isEmpty ? '?' : n.substring(0, min(2, n.length)).toUpperCase();
}
