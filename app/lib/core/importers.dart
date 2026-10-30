import 'dart:convert';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';

import 'account.dart';
import 'google_migration.dart';
import 'otpauth_uri.dart';
import 'scrypt.dart';
import 'tidy.dart';
import 'totp.dart';

/// Other authenticator apps and password managers we can read an export from.
enum ImportSource { authy, aegis, twoFas, bitwarden, onePassword, applePasswords }

/// What came out of a file or a pasted list: the accounts, plus one plain reason per thing left out.
class ImportResult {
  ImportResult(this.accounts, this.problems);
  final List<Account> accounts;
  final List<String> problems;
}

/// Thrown when the file can't be read at all. [needsPassword] means: ask for the export's password and retry.
class ImportException implements Exception {
  ImportException(this.message, {this.needsPassword = false});
  final String message;
  final bool needsPassword;
  @override
  String toString() => message;
}

/// Reads [text] exported from [source]. Password-protected Aegis and 2FAS files need [password].
/// Names are tidied ([tidyName]) on the way in; [brandName] looks up a website's proper name.
Future<ImportResult> parseImport(ImportSource source, String text, {String? password, String? Function(String domain)? brandName}) async {
  text = text.trim().replaceFirst('\uFEFF', '');
  final r = await switch (source) {
    ImportSource.authy => Future.value(_authy(text)),
    ImportSource.aegis => _aegis(_json(text, 'Aegis'), password),
    ImportSource.twoFas => _twoFas(_json(text, '2FAS'), password),
    ImportSource.bitwarden || ImportSource.onePassword || ImportSource.applePasswords => Future.value(_passwordManager(text, source)),
  };
  tidyAll(r.accounts, brandName: brandName);
  return r;
}

Object? _json(String text, String app) {
  try {
    return jsonDecode(text);
  } catch (_) {
    throw ImportException('That file isn\'t a $app export.');
  }
}

/// One otpauth:// (or Google Authenticator otpauth-migration://) link per line. Blank lines are ignored.
ImportResult parseOtpauthLines(String text, {String? Function(String domain)? brandName}) {
  final accounts = <Account>[], problems = <String>[];
  final lines = text.split(RegExp(r'\r?\n'));
  for (var i = 0; i < lines.length; i++) {
    final line = lines[i].trim();
    if (line.isEmpty) continue;
    try {
      if (line.startsWith('otpauth-migration://')) {
        accounts.addAll(parseGoogleMigration(line));
      } else {
        accounts.add(parseOtpauthUri(line));
      }
    } on FormatException catch (e) {
      problems.add('Line ${i + 1}: ${e.message}');
    }
  }
  tidyAll(accounts, brandName: brandName);
  return ImportResult(accounts, problems);
}

// ---------- Authy ----------
// Authy has no export button. Community tools pull the accounts out of Authy Desktop and write either
// a list of otpauth:// links, or JSON like [{"name", "secret" | "decryptedSeed", "digits", "uri"}],
// sometimes wrapped in {"authenticator_tokens": [...]} or {"tokens": [...]}.
ImportResult _authy(String text) {
  if (!text.startsWith('[') && !text.startsWith('{')) {
    final r = parseOtpauthLines(text);
    if (r.accounts.isEmpty && r.problems.isEmpty) throw ImportException('That file is empty.');
    return r;
  }
  final root = _json(text, 'Authy');
  final items = root is List
      ? root
      : root is Map
          ? (root['authenticator_tokens'] ?? root['tokens'] ?? root['accounts']) as List?
          : null;
  if (items == null) throw ImportException('That file isn\'t an Authy export.');
  final accounts = <Account>[], problems = <String>[];
  for (final item in items) {
    final m = item is Map ? item : const {};
    final name = '${m['name'] ?? m['original_name'] ?? ''}'.trim();
    final what = name.isEmpty ? 'An account' : '"$name"';
    try {
      final uri = m['uri'] ?? m['otpauth'];
      if (uri is String && uri.startsWith('otpauth://')) {
        accounts.add(parseOtpauthUri(uri));
        continue;
      }
      var secret = (m['secret'] ?? m['decryptedSeed'] ?? m['decrypted_seed']) as String?;
      final hexSeed = (m['secretSeed'] ?? m['secret_seed']) as String?;
      var period = (m['period'] as num?)?.toInt() ?? 30;
      if ((secret == null || secret.isEmpty) && hexSeed != null && RegExp(r'^[0-9a-fA-F]+$').hasMatch(hexSeed)) {
        secret = base32Encode(_hex(hexSeed));
        period = (m['period'] as num?)?.toInt() ?? 10; // Authy's own app tokens (Twitch etc.) change every 10 s
      }
      if (secret == null || secret.isEmpty) throw const FormatException('has no secret');
      final (issuer, label) = _splitName('${m['issuer'] ?? ''}', name);
      accounts.add(_make(
        issuer: issuer,
        label: label,
        secret: secret,
        digits: (m['digits'] as num?)?.toInt() ?? 6,
        period: period,
      ));
    } on FormatException catch (e) {
      problems.add('$what: ${e.message}');
    }
  }
  return ImportResult(accounts, problems);
}

// ---------- Aegis ----------
// Format: https://github.com/beemdevelopment/Aegis/blob/master/docs/vault.md
// {"version":1,"header":{"slots":null|[...],"params":null|{nonce,tag}},"db":{entries:[...]} | "base64"}
Future<ImportResult> _aegis(Object? root, String? password) async {
  if (root is! Map || root['header'] is! Map || root['db'] == null) throw ImportException('That file isn\'t an Aegis export.');
  final header = root['header'] as Map;
  Object? db = root['db'];
  if (db is String) {
    if (password == null || password.isEmpty) {
      throw ImportException('This Aegis export is protected with a password.', needsPassword: true);
    }
    final slots = (header['slots'] as List? ?? []).whereType<Map>().where((s) => s['type'] == 1).toList();
    if (slots.isEmpty) throw ImportException('This Aegis export can only be opened with a fingerprint on the phone that made it. In Aegis, export again and choose a password.');
    List<int>? masterKey;
    for (final s in slots) {
      final params = s['key_params'] as Map;
      final keyBytes = await Isolate.run(() => scrypt(utf8.encode(password), _hex(s['salt'] as String),
          n: s['n'] as int, r: s['r'] as int, p: s['p'] as int));
      try {
        masterKey = await _gcmOpen(keyBytes, _hex(params['nonce'] as String), _hex(s['key'] as String), _hex(params['tag'] as String));
        break;
      } on SecretBoxAuthenticationError {
        continue;
      }
    }
    if (masterKey == null) throw ImportException('Wrong password for this Aegis export.', needsPassword: true);
    final params = header['params'] as Map;
    try {
      final clear = await _gcmOpen(masterKey, _hex(params['nonce'] as String), base64.decode(db), _hex(params['tag'] as String));
      db = jsonDecode(utf8.decode(clear));
    } catch (_) {
      throw ImportException('The Aegis export unlocked but its contents are damaged.');
    }
  }
  final entries = (db as Map)['entries'];
  if (entries is! List) throw ImportException('That file isn\'t an Aegis export.');
  // Aegis groups become folders (an account sits in one folder, so the first group wins).
  final groupNames = {
    for (final g in ((db['groups'] as List?) ?? const []).whereType<Map>()) '${g['uuid']}': '${g['name'] ?? ''}'.trim(),
  };
  final accounts = <Account>[], problems = <String>[];
  for (final e in entries.whereType<Map>()) {
    final name = '${e['name'] ?? ''}', issuer = '${e['issuer'] ?? ''}';
    final what = '"${[issuer, name].where((s) => s.isNotEmpty).join(' ')}"';
    final type = '${e['type']}'.toLowerCase();
    final info = e['info'] as Map? ?? const {};
    try {
      if (type != 'totp' && type != 'hotp' && type != 'steam') {
        throw FormatException('uses $type codes, which Tanooki Auth doesn\'t support');
      }
      final a = _make(
        type: OtpType.values.byName(type),
        issuer: issuer,
        label: name,
        secret: '${info['secret'] ?? ''}',
        algorithm: '${info['algo'] ?? 'SHA1'}',
        digits: (info['digits'] as num?)?.toInt() ?? 6,
        period: (info['period'] as num?)?.toInt() ?? 30,
        counter: (info['counter'] as num?)?.toInt() ?? 0,
      )
        ..favorite = e['favorite'] == true
        ..notes = '${e['note'] ?? ''}'.trim()
        ..folder = [for (final g in (e['groups'] as List?) ?? const []) groupNames['$g']]
            .whereType<String>()
            .where((n) => n.isNotEmpty)
            .firstOrNull;
      accounts.add(a);
    } on FormatException catch (err) {
      problems.add('$what ${err.message}');
    }
  }
  return ImportResult(accounts, problems);
}

// ---------- 2FAS ----------
// .2fas backup: {"services":[{name, secret, otp:{account, issuer, digits, period, algorithm, tokenType, counter}}],
// "servicesEncrypted": "base64(ciphertext+tag):base64(salt):base64(iv)"} when protected. The key is
// PBKDF2-HMAC-SHA256(password, salt, 10000 rounds, 256 bits); the cipher is AES-GCM with a 128-bit tag.
Future<ImportResult> _twoFas(Object? root, String? password) async {
  if (root is! Map || (root['services'] == null && root['servicesEncrypted'] == null)) {
    throw ImportException('That file isn\'t a 2FAS backup.');
  }
  var services = root['services'] as List? ?? [];
  final sealed = root['servicesEncrypted'];
  if (sealed is String && sealed.isNotEmpty) {
    if (password == null || password.isEmpty) {
      throw ImportException('This 2FAS backup is protected with a password.', needsPassword: true);
    }
    final parts = sealed.split(':');
    if (parts.length < 3) throw ImportException('This 2FAS backup is damaged.');
    final data = base64.decode(parts[0]), salt = base64.decode(parts[1]), iv = base64.decode(parts[2]);
    final key = await (await Pbkdf2(macAlgorithm: Hmac.sha256(), iterations: 10000, bits: 256)
            .deriveKeyFromPassword(password: password, nonce: salt))
        .extractBytes();
    try {
      final clear = await _gcmOpen(key, iv, data.sublist(0, data.length - 16), data.sublist(data.length - 16));
      services = jsonDecode(utf8.decode(clear)) as List;
    } on SecretBoxAuthenticationError {
      throw ImportException('Wrong password for this 2FAS backup.', needsPassword: true);
    }
  }
  final accounts = <Account>[], problems = <String>[];
  for (final s in services.whereType<Map>()) {
    final otp = s['otp'] as Map? ?? const {};
    final issuer = '${otp['issuer'] ?? s['name'] ?? ''}'.trim();
    final label = '${otp['account'] ?? otp['label'] ?? ''}'.trim();
    final what = '"${[issuer, label].where((x) => x.isNotEmpty).join(' ')}"';
    final type = '${otp['tokenType'] ?? 'TOTP'}'.toUpperCase();
    try {
      if (type != 'TOTP' && type != 'HOTP' && type != 'STEAM') {
        throw FormatException('uses $type codes, which Tanooki Auth doesn\'t support');
      }
      accounts.add(_make(
        type: OtpType.values.byName(type.toLowerCase()),
        issuer: issuer,
        label: label,
        secret: '${s['secret'] ?? ''}',
        algorithm: '${otp['algorithm'] ?? 'SHA1'}',
        digits: (otp['digits'] as num?)?.toInt() ?? 6,
        period: (otp['period'] as num?)?.toInt() ?? 30,
        counter: (otp['counter'] as num?)?.toInt() ?? 0,
      ));
    } on FormatException catch (err) {
      problems.add('$what ${err.message}');
    }
  }
  return ImportResult(accounts, problems);
}

// ---------- Bitwarden and 1Password ----------
// Bitwarden JSON: {"encrypted":false,"items":[{"name","login":{"username","totp","uris":[{"uri"}]}}]}
// Bitwarden CSV:  folder,favorite,type,name,notes,fields,reprompt,login_uri,login_username,login_password,login_totp
// 1Password CSV:  Title,Url,Username,Password,OTPAuth,Favorite,Archived,Tags,Notes
// Apple Passwords CSV (Passwords app / Safari "Export All Passwords"): Title,URL,Username,Password,Notes,OTPAuth
// Only rows with a one-time-code secret become accounts; ordinary logins are not "skipped", just not codes.
ImportResult _passwordManager(String text, ImportSource source) {
  final app = switch (source) {
    ImportSource.bitwarden => 'Bitwarden',
    ImportSource.applePasswords => 'Apple Passwords',
    _ => '1Password',
  };
  final rows = <({String name, String user, String totp, String url})>[];
  if (text.startsWith('{')) {
    final root = _json(text, app);
    if (root is! Map) throw ImportException('That file isn\'t a $app export.');
    if (root['encrypted'] == true) {
      throw ImportException('That Bitwarden export is encrypted. In Bitwarden, export again and choose the ".json" format (not "encrypted").');
    }
    final items = root['items'];
    if (items is! List) throw ImportException('That file isn\'t a $app export.');
    for (final i in items.whereType<Map>()) {
      final login = i['login'] as Map? ?? const {};
      final uris = login['uris'] as List? ?? const [];
      rows.add((
        name: '${i['name'] ?? ''}',
        user: '${login['username'] ?? ''}',
        totp: '${login['totp'] ?? ''}',
        url: uris.isEmpty ? '' : '${(uris.first as Map)['uri'] ?? ''}',
      ));
    }
  } else if (text.startsWith('PK')) {
    throw ImportException('That looks like a 1Password .1pux file. In 1Password, export again and choose CSV.');
  } else {
    final table = parseCsv(text);
    if (table.isEmpty) throw ImportException('That file is empty.');
    final head = [for (final h in table.first) h.trim().toLowerCase()];
    int col(List<String> names) => head.indexWhere(names.contains);
    final totpCol = col(['login_totp', 'otpauth', 'one-time password', 'totp', 'otp']);
    if (totpCol < 0) throw ImportException('That file has no one-time code column, so it isn\'t a $app export with codes in it.');
    final nameCol = col(['name', 'title']), userCol = col(['login_username', 'username']), urlCol = col(['login_uri', 'url', 'website']);
    String at(List<String> r, int c) => c >= 0 && c < r.length ? r[c] : '';
    for (final r in table.skip(1)) {
      rows.add((name: at(r, nameCol), user: at(r, userCol), totp: at(r, totpCol), url: at(r, urlCol)));
    }
  }
  final accounts = <Account>[], problems = <String>[];
  for (final r in rows) {
    final totp = r.totp.trim();
    if (totp.isEmpty) continue;
    final what = '"${r.name.isEmpty ? r.user : r.name}"';
    try {
      final a = totp.startsWith('otpauth://') || totp.startsWith('steam://')
          ? parseOtpauthUri(totp)
          : _make(issuer: '', label: '', secret: totp);
      // The vault item's own name and login are better labels than the link's (tidyName cleans them up after).
      if (r.name.trim().isNotEmpty && a.type != OtpType.steam) a.issuer = r.name.trim();
      if (a.label.isEmpty || a.label == a.issuer) a.label = r.user.trim();
      final domain = normalizeDomain(r.url.split(RegExp(r'[,\s]')).first);
      if (domain.contains('.')) a.domains.add(domain);
      accounts.add(a);
    } on FormatException catch (e) {
      problems.add('$what ${e.message.startsWith('uses') ? e.message : 'has a one-time code Tanooki Auth can\'t read (${e.message})'}');
    }
  }
  return ImportResult(accounts, problems);
}

/// RFC 4180 CSV: commas, quoted fields, doubled quotes, newlines inside quotes.
List<List<String>> parseCsv(String text) {
  final rows = <List<String>>[];
  var row = <String>[];
  final field = StringBuffer();
  var quoted = false;
  for (var i = 0; i < text.length; i++) {
    final c = text[i];
    if (quoted) {
      if (c == '"' && i + 1 < text.length && text[i + 1] == '"') {
        field.write('"');
        i++;
      } else if (c == '"') {
        quoted = false;
      } else {
        field.write(c);
      }
    } else if (c == '"') {
      quoted = true;
    } else if (c == ',') {
      row.add(field.toString());
      field.clear();
    } else if (c == '\n' || c == '\r') {
      if (c == '\r' && i + 1 < text.length && text[i + 1] == '\n') i++;
      row.add(field.toString());
      field.clear();
      if (row.any((f) => f.isNotEmpty)) rows.add(row);
      row = <String>[];
    } else {
      field.write(c);
    }
  }
  row.add(field.toString());
  if (row.any((f) => f.isNotEmpty)) rows.add(row);
  return rows;
}

// ---------- helpers ----------

/// Builds an account from loose fields, with the same checks as an otpauth:// link.
Account _make({
  OtpType type = OtpType.totp,
  required String issuer,
  required String label,
  required String secret,
  String algorithm = 'SHA1',
  int digits = 6,
  int period = 30,
  int counter = 0,
}) {
  final clean = secret.toUpperCase().replaceAll(RegExp(r'[\s=-]'), '');
  if (clean.isEmpty) throw const FormatException('has no secret');
  try {
    base32Decode(clean);
  } on FormatException {
    throw const FormatException('has a secret that isn\'t valid');
  }
  final steam = type == OtpType.steam;
  if (!steam && (digits < 6 || digits > 8)) throw FormatException('uses $digits-digit codes, which Tanooki Auth doesn\'t support');
  if (period <= 0) throw const FormatException('has a broken time period');
  return Account(
    id: newId(),
    type: type,
    issuer: issuer.trim(),
    label: label.trim(),
    secret: clean,
    algorithm: steam ? OtpAlgorithm.sha1 : switch (algorithm.toUpperCase().replaceAll('-', '')) {
      'SHA1' => OtpAlgorithm.sha1,
      'SHA256' => OtpAlgorithm.sha256,
      'SHA512' => OtpAlgorithm.sha512,
      final a => throw FormatException('uses the $a algorithm, which Tanooki Auth doesn\'t support'),
    },
    digits: steam ? 5 : digits,
    period: steam ? 30 : period,
    counter: counter,
  );
}

/// "GitHub: octo" -> ("GitHub", "octo"), unless [issuer] is already known.
(String, String) _splitName(String issuer, String name) {
  final colon = name.indexOf(':');
  if (colon < 0) return (issuer.isEmpty ? name : issuer, issuer.isEmpty ? '' : name);
  return (issuer.isEmpty ? name.substring(0, colon) : issuer, name.substring(colon + 1));
}

Uint8List _hex(String s) =>
    Uint8List.fromList([for (var i = 0; i + 1 < s.length; i += 2) int.parse(s.substring(i, i + 2), radix: 16)]);

Future<List<int>> _gcmOpen(List<int> key, List<int> nonce, List<int> cipherText, List<int> tag) =>
    AesGcm.with256bits(nonceLength: nonce.length)
        .decrypt(SecretBox(cipherText, nonce: nonce, mac: Mac(tag)), secretKey: SecretKey(key));
