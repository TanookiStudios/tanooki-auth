import 'dart:math';

import 'account.dart';
import 'totp.dart';

/// "https://www.GitHub.com/login" -> "github.com".
String normalizeDomain(String s) {
  var d = s.trim().toLowerCase();
  d = d.replaceFirst(RegExp(r'^[a-z]+://'), '');
  d = d.split(RegExp(r'[/?#:]')).first;
  if (d.startsWith('www.')) d = d.substring(4);
  return d;
}

String newId() {
  final r = Random.secure();
  return List.generate(16, (_) => r.nextInt(256).toRadixString(16).padLeft(2, '0')).join();
}

/// Parses otpauth://totp/Issuer:label?secret=...&issuer=...&algorithm=...&digits=...&period=...
/// Throws [FormatException] with a user-readable message.
/// Also takes `steam://SECRET` (how Steam Desktop Authenticator and password managers write Steam Guard keys).
Account parseOtpauthUri(String input) {
  final Uri uri;
  try {
    uri = Uri.parse(input.trim());
  } on FormatException {
    throw const FormatException('That is not an otpauth:// link.');
  }
  if (uri.scheme == 'steam') {
    final secret = input.trim().substring('steam://'.length).toUpperCase().replaceAll(RegExp(r'[\s=-]'), '');
    if (secret.isEmpty) throw const FormatException('The link has no secret.');
    base32Decode(secret);
    return Account(id: newId(), type: OtpType.steam, issuer: 'Steam', secret: secret, digits: 5);
  }
  if (uri.scheme != 'otpauth') throw const FormatException('That is not an otpauth:// link.');
  var type = switch (uri.host.toLowerCase()) {
    'totp' => OtpType.totp,
    'hotp' => OtpType.hotp,
    _ => throw FormatException('Unsupported code type "${uri.host}".'),
  };
  final q = uri.queryParameters;
  final secret = q['secret'];
  if (secret == null || secret.isEmpty) throw const FormatException('The link has no secret.');
  base32Decode(secret); // validates

  // Path is "/Issuer:label" or "/label"; the spec allows the colon as ":" or "%3A".
  final rawPath = uri.path.startsWith('/') ? uri.path.substring(1) : uri.path;
  final path = rawPath.replaceAll('%3A', ':').replaceAll('%3a', ':');
  String labelIssuer = '', label = path;
  final colon = path.indexOf(':');
  if (colon >= 0) {
    labelIssuer = path.substring(0, colon);
    label = path.substring(colon + 1);
  }
  labelIssuer = Uri.decodeComponent(labelIssuer).trim();
  label = Uri.decodeComponent(label).trim();

  final algorithm = switch ((q['algorithm'] ?? 'SHA1').toUpperCase()) {
    'SHA1' => OtpAlgorithm.sha1,
    'SHA256' => OtpAlgorithm.sha256,
    'SHA512' => OtpAlgorithm.sha512,
    final a => throw FormatException('Unsupported algorithm "$a".'),
  };
  final issuer = (q['issuer']?.trim().isNotEmpty ?? false) ? q['issuer']!.trim() : labelIssuer;
  // Steam Guard: Aegis and others write encoder=steam; nobody else uses issuer "Steam" with plain codes.
  if (type == OtpType.totp && (q['encoder']?.toLowerCase() == 'steam' || issuer.toLowerCase() == 'steam')) type = OtpType.steam;
  final steam = type == OtpType.steam;
  final digits = steam ? 5 : int.tryParse(q['digits'] ?? '6');
  if (!steam && (digits == null || digits < 6 || digits > 8)) throw const FormatException('Digits must be 6, 7 or 8.');
  final period = int.tryParse(q['period'] ?? '30');
  if (period == null || period <= 0) throw const FormatException('Period must be a positive number.');
  final counter = int.tryParse(q['counter'] ?? '0');
  if (counter == null || counter < 0) throw const FormatException('Counter must be zero or more.');

  return Account(
    id: newId(),
    type: type,
    issuer: issuer,
    label: label,
    secret: secret.toUpperCase().replaceAll(RegExp(r'[\s=-]'), ''),
    algorithm: steam ? OtpAlgorithm.sha1 : algorithm,
    digits: digits!,
    period: period,
    counter: counter,
  );
}

String toOtpauthUri(Account a) {
  final name = a.issuer.isEmpty ? a.label : '${a.issuer}:${a.label}';
  final params = {
    'secret': a.secret,
    if (a.issuer.isNotEmpty) 'issuer': a.issuer,
    'algorithm': a.algorithm.name.toUpperCase(),
    'digits': '${a.digits}',
    if (a.timeBased) 'period': '${a.period}',
    if (a.type == OtpType.hotp) 'counter': '${a.counter}',
    if (a.type == OtpType.steam) 'encoder': 'steam',
  };
  return Uri(scheme: 'otpauth', host: a.type == OtpType.hotp ? 'hotp' : 'totp', path: '/$name', queryParameters: params).toString();
}
