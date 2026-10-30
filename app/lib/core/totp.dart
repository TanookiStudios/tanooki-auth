import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import '../l10n/l10n.dart';

enum OtpAlgorithm { sha1, sha256, sha512 }

/// Decodes RFC 4648 base32. Accepts lowercase, spaces, dashes and missing padding.
Uint8List base32Decode(String input) {
  const alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';
  final clean = input.toUpperCase().replaceAll(RegExp(r'[\s=-]'), '');
  final out = <int>[];
  var buffer = 0, bits = 0;
  for (final ch in clean.split('')) {
    final v = alphabet.indexOf(ch);
    if (v < 0) throw FormatException(l10n.totpBadCharacter(ch));
    buffer = (buffer << 5) | v;
    bits += 5;
    if (bits >= 8) {
      bits -= 8;
      out.add((buffer >> bits) & 0xff);
    }
  }
  if (out.isEmpty) throw FormatException(l10n.totpEmpty);
  return Uint8List.fromList(out);
}

String base32Encode(List<int> data) {
  const alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';
  final sb = StringBuffer();
  var buffer = 0, bits = 0;
  for (final b in data) {
    buffer = (buffer << 8) | b;
    bits += 8;
    while (bits >= 5) {
      bits -= 5;
      sb.write(alphabet[(buffer >> bits) & 31]);
    }
  }
  if (bits > 0) sb.write(alphabet[(buffer << (5 - bits)) & 31]);
  return sb.toString();
}

/// HOTP per RFC 4226.
String hotp(List<int> key, int counter, {int digits = 6, OtpAlgorithm algorithm = OtpAlgorithm.sha1}) {
  final msg = ByteData(8)..setInt64(0, counter);
  final hash = switch (algorithm) {
    OtpAlgorithm.sha1 => sha1,
    OtpAlgorithm.sha256 => sha256,
    OtpAlgorithm.sha512 => sha512,
  };
  final mac = Hmac(hash, key).convert(msg.buffer.asUint8List()).bytes;
  final offset = mac.last & 0x0f;
  final binary = ((mac[offset] & 0x7f) << 24) |
      (mac[offset + 1] << 16) |
      (mac[offset + 2] << 8) |
      mac[offset + 3];
  var mod = 1;
  for (var i = 0; i < digits; i++) {
    mod *= 10;
  }
  return (binary % mod).toString().padLeft(digits, '0');
}

/// TOTP per RFC 6238. [unixSeconds] is seconds since the epoch.
String totp(List<int> key, int unixSeconds,
        {int period = 30, int digits = 6, OtpAlgorithm algorithm = OtpAlgorithm.sha1}) =>
    hotp(key, unixSeconds ~/ period, digits: digits, algorithm: algorithm);

int secondsLeft(int unixSeconds, {int period = 30}) => period - unixSeconds % period;

/// Steam Guard's code alphabet: digits and letters that can't be confused with each other.
const steamAlphabet = '23456789BCDFGHJKMNPQRTVWXY';

/// Steam Guard code: HMAC-SHA1 TOTP (30 s), the 31-bit truncated number written as 5 characters,
/// lowest first, by repeatedly taking it mod 26 into [steamAlphabet].
String steamCode(List<int> key, int unixSeconds, {int period = 30}) {
  final msg = ByteData(8)..setInt64(0, unixSeconds ~/ period);
  final mac = Hmac(sha1, key).convert(msg.buffer.asUint8List()).bytes;
  final offset = mac.last & 0x0f;
  var v = ((mac[offset] & 0x7f) << 24) | (mac[offset + 1] << 16) | (mac[offset + 2] << 8) | mac[offset + 3];
  final sb = StringBuffer();
  for (var i = 0; i < 5; i++) {
    sb.write(steamAlphabet[v % steamAlphabet.length]);
    v ~/= steamAlphabet.length;
  }
  return sb.toString();
}
