import 'dart:convert';
import 'dart:typed_data';

import 'account.dart';
import 'otpauth_uri.dart';
import 'totp.dart';

/// Decodes Google Authenticator's "Transfer accounts" QR:
/// `otpauth-migration://offline?data=` followed by a base64 MigrationPayload protobuf.
/// Only the fields we need are read: OtpParameters { 1 secret, 2 name, 3 issuer,
/// 4 algorithm, 5 digits, 6 type, 7 counter }, repeated as field 1 of the payload.
List<Account> parseGoogleMigration(String uri) {
  final Uint8List data;
  try {
    final raw = Uri.parse(uri.trim()).queryParameters['data'] ?? '';
    // queryParameters turns a literal '+' into a space.
    data = base64.decode(base64.normalize(raw.replaceAll(' ', '+')));
  } catch (_) {
    throw const FormatException('That Google Authenticator code couldn\'t be read.');
  }
  final accounts = <Account>[];
  try {
    for (final (field, value) in _fields(data)) {
      if (field == 1 && value is Uint8List) accounts.add(_otp(value));
    }
  } on FormatException {
    rethrow;
  } catch (_) {
    throw const FormatException('That Google Authenticator code is damaged.');
  }
  if (accounts.isEmpty) throw const FormatException('That Google Authenticator code has no accounts in it.');
  return accounts;
}

Account _otp(Uint8List msg) {
  Uint8List? secret;
  var name = '', issuer = '';
  var algorithm = 1, digits = 1, type = 2, counter = 0;
  for (final (field, value) in _fields(msg)) {
    switch (field) {
      case 1:
        secret = value as Uint8List;
      case 2:
        name = utf8.decode(value as Uint8List);
      case 3:
        issuer = utf8.decode(value as Uint8List);
      case 4:
        algorithm = value as int;
      case 5:
        digits = value as int;
      case 6:
        type = value as int;
      case 7:
        counter = value as int;
    }
  }
  if (secret == null || secret.isEmpty) throw const FormatException('An account in that code has no secret.');
  // Name is often "Issuer:label"; the issuer field wins when both are present.
  var label = name;
  final colon = name.indexOf(':');
  if (colon >= 0) {
    if (issuer.isEmpty) issuer = name.substring(0, colon);
    label = name.substring(colon + 1);
  }
  return Account(
    id: newId(),
    type: type == 1 ? OtpType.hotp : OtpType.totp,
    issuer: issuer.trim(),
    label: label.trim(),
    secret: base32Encode(secret),
    algorithm: switch (algorithm) {
      2 => OtpAlgorithm.sha256,
      3 => OtpAlgorithm.sha512,
      4 => throw const FormatException('An account in that code uses MD5, which Tanooki Auth doesn\'t support.'),
      _ => OtpAlgorithm.sha1,
    },
    digits: digits == 2 ? 8 : 6,
    counter: counter,
  );
}

/// Minimal protobuf reader: yields (field number, int for varints / bytes for length-delimited).
Iterable<(int, Object)> _fields(Uint8List b) sync* {
  var i = 0;
  int varint() {
    var result = 0, shift = 0;
    while (true) {
      final byte = b[i++];
      result |= (byte & 0x7f) << shift;
      if (byte & 0x80 == 0) return result;
      shift += 7;
    }
  }

  while (i < b.length) {
    final tag = varint();
    switch (tag & 7) {
      case 0:
        yield (tag >> 3, varint());
      case 2:
        final len = varint();
        yield (tag >> 3, Uint8List.sublistView(b, i, i + len));
        i += len;
      case 1:
        i += 8;
      case 5:
        i += 4;
      default:
        throw const FormatException('That Google Authenticator code is damaged.');
    }
  }
}
