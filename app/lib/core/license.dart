import 'dart:convert';

import 'package:cryptography/cryptography.dart';

/// Public half of the Premium signing key (private half: ~/.tanooki-auth-signing, never in the repo).
/// Keys are checked offline, so unlocking Premium never contacts a server.
const _licensePublicKey = 'JZ9iKjegJLat8xNt2L80HNWmHfXJc9at34lUBynULM8=';

/// Returns true when [key] is a Premium license signed with our key.
/// Format: `TA1.` + base64url payload `1|orderId|yyyymmdd` + `.` + base64url Ed25519 signature.
Future<bool> verifyLicense(String key, {String publicKey = _licensePublicKey}) async {
  final parts = key.trim().split('.');
  if (parts.length != 3 || parts[0] != 'TA1') return false;
  try {
    List<int> d(String s) => base64Url.decode(base64Url.normalize(s));
    final payload = d(parts[1]);
    if (!utf8.decode(payload).startsWith('1|')) return false;
    return await Ed25519().verify(
      payload,
      signature: Signature(d(parts[2]), publicKey: SimplePublicKey(base64.decode(publicKey), type: KeyPairType.ed25519)),
    );
  } catch (_) {
    return false;
  }
}
