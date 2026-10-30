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

/// Why Google Authenticator can't take [a], or null if it can. Google only knows 6 or 8 digits,
/// 30-second codes, and plain time or counter codes.
String? googleCantTake(Account a) {
  if (a.type == OtpType.steam) return 'Steam codes';
  if (a.digits != 6 && a.digits != 8) return '${a.digits}-digit codes';
  if (a.type == OtpType.totp && a.period != 30) return 'codes that change every ${a.period} seconds';
  return null;
}

/// Writes Google Authenticator "Transfer accounts" QR links, [perCode] accounts each (Google's own app
/// puts about 10 in one code so phone cameras can still read it). The reverse of [parseGoogleMigration].
/// Accounts [googleCantTake] are left out; callers must tell the user which.
List<String> buildGoogleMigration(List<Account> accounts, {int perCode = 10, int? batchId}) {
  final ok = accounts.where((a) => googleCantTake(a) == null).toList();
  final batches = [for (var i = 0; i < ok.length; i += perCode) ok.sublist(i, (i + perCode).clamp(0, ok.length))];
  final id = batchId ?? DateTime.now().millisecondsSinceEpoch & 0x7fffffff;
  return [
    for (var b = 0; b < batches.length; b++)
      'otpauth-migration://offline?data=${Uri.encodeQueryComponent(base64.encode(_payload(batches[b], batches.length, b, id)))}',
  ];
}

Uint8List _payload(List<Account> accounts, int size, int index, int id) {
  final out = BytesBuilder();
  for (final a in accounts) {
    final p = BytesBuilder();
    _bytes(p, 1, base32Decode(a.secret));
    _bytes(p, 2, utf8.encode(a.issuer.isEmpty ? a.label : '${a.issuer}:${a.label}'));
    _bytes(p, 3, utf8.encode(a.issuer));
    _varintField(p, 4, switch (a.algorithm) { OtpAlgorithm.sha1 => 1, OtpAlgorithm.sha256 => 2, OtpAlgorithm.sha512 => 3 });
    _varintField(p, 5, a.digits == 8 ? 2 : 1);
    _varintField(p, 6, a.type == OtpType.hotp ? 1 : 2);
    if (a.type == OtpType.hotp) _varintField(p, 7, a.counter);
    _bytes(out, 1, p.toBytes());
  }
  _varintField(out, 2, 1); // version
  _varintField(out, 3, size);
  _varintField(out, 4, index);
  _varintField(out, 5, id);
  return out.toBytes();
}

void _varint(BytesBuilder b, int v) {
  while (v >= 0x80) {
    b.addByte((v & 0x7f) | 0x80);
    v >>= 7;
  }
  b.addByte(v);
}

void _varintField(BytesBuilder b, int field, int v) {
  _varint(b, field << 3);
  _varint(b, v);
}

void _bytes(BytesBuilder b, int field, List<int> data) {
  _varint(b, (field << 3) | 2);
  _varint(b, data.length);
  b.add(data);
}
