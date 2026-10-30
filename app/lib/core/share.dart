import 'dart:convert';
import 'dart:math';

import 'package:cryptography/cryptography.dart';

import 'account.dart';
import 'otpauth_uri.dart';
import 'sync/relay_crypto.dart' show deriveSyncRoot;

/// One account shared with someone else, no server involved: the account's otpauth link, encrypted with
/// AES-256-GCM under a key stretched (Argon2id, 64 MiB) from a random 6-digit one-time code. The expiry
/// is part of the authenticated data, so changing it breaks decryption.
const sharePrefix = 'tanookiauth-share:';
const shareExtension = 'tanookishare';
const shareLifetime = Duration(hours: 24);

class ShareException implements Exception {
  ShareException(this.message);
  final String message;
  @override
  String toString() => message;
}

List<int> _aad(int exp) => utf8.encode('tanooki-share-v1|$exp');
String _b(List<int> x) => base64Url.encode(x).replaceAll('=', '');
List<int> _d(String s) => base64Url.decode(base64Url.normalize(s));

/// Returns the share text (for the QR code and the file) and the 6-digit code to tell the other person.
Future<({String text, String code})> createShare(Account a, {DateTime? now}) async {
  final r = Random.secure();
  final code = r.nextInt(1000000).toString().padLeft(6, '0');
  final salt = List.generate(16, (_) => r.nextInt(256));
  final exp = (now ?? DateTime.now()).add(shareLifetime).millisecondsSinceEpoch ~/ 1000;
  final key = await deriveSyncRoot(code, salt);
  final box = await AesGcm.with256bits()
      .encrypt(utf8.encode(toOtpauthUri(a)), secretKey: SecretKey(key), aad: _aad(exp));
  final body = jsonEncode({'v': 1, 'exp': exp, 's': _b(salt), 'n': _b(box.nonce), 'c': _b(box.cipherText + box.mac.bytes)});
  return (text: '$sharePrefix${_b(utf8.encode(body))}', code: code);
}

/// Opens a share made by [createShare]. Throws [ShareException] with a message for the person.
Future<Account> openShare(String text, String code, {DateTime? now}) async {
  final Map<String, dynamic> j;
  try {
    j = jsonDecode(utf8.decode(_d(text.trim().substring(sharePrefix.length)))) as Map<String, dynamic>;
    if (!text.trim().startsWith(sharePrefix) || j['v'] != 1) throw const FormatException();
  } catch (_) {
    throw ShareException('That isn\'t a Tanooki Auth shared account.');
  }
  final exp = j['exp'];
  if (exp is! int) throw ShareException('That isn\'t a Tanooki Auth shared account.');
  if ((now ?? DateTime.now()).millisecondsSinceEpoch ~/ 1000 > exp) {
    throw ShareException('This share has expired (they only last 24 hours). Ask for a new one.');
  }
  final String uri;
  try {
    final c = _d(j['c'] as String);
    final key = await deriveSyncRoot(code.trim(), _d(j['s'] as String));
    final clear = await AesGcm.with256bits().decrypt(
      SecretBox(c.sublist(0, c.length - 16), nonce: _d(j['n'] as String), mac: Mac(c.sublist(c.length - 16))),
      secretKey: SecretKey(key),
      aad: _aad(exp),
    );
    uri = utf8.decode(clear);
  } catch (_) {
    throw ShareException('Wrong code, or the share is damaged. Check the 6 digits and try again.');
  }
  return parseOtpauthUri(uri);
}
