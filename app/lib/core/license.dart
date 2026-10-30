import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:flutter/foundation.dart' show visibleForTesting;

/// Public half of the Premium signing key (private half: ~/.tanooki-auth-signing, never in the repo).
/// Keys are checked offline, so unlocking Premium never contacts a server.
const _licensePublicKey = 'JZ9iKjegJLat8xNt2L80HNWmHfXJc9at34lUBynULM8=';

/// The key [verifyLicense] checks against. Only tests change it, to sign keys with a throwaway key pair.
@visibleForTesting
String licensePublicKey = _licensePublicKey;

/// Returns true when [key] is a Premium license signed with our key.
/// Format: `TA1.` + base64url payload `1|orderId|yyyymmdd` (family keys add `|seats`) + `.` + base64url
/// Ed25519 signature.
Future<bool> verifyLicense(String key, {String? publicKey}) async {
  final parts = key.trim().split('.');
  if (parts.length != 3 || parts[0] != 'TA1') return false;
  try {
    List<int> d(String s) => base64Url.decode(base64Url.normalize(s));
    final payload = d(parts[1]);
    if (!utf8.decode(payload).startsWith('1|')) return false;
    return await Ed25519().verify(
      payload,
      signature: Signature(d(parts[2]), publicKey: SimplePublicKey(base64.decode(publicKey ?? licensePublicKey), type: KeyPairType.ed25519)),
    );
  } catch (_) {
    return false;
  }
}

/// How many people a key covers: 1 for a normal key (and every key sold before the family plan), 5 for a
/// family key. Only meaningful once [verifyLicense] has said the key is genuine.
int licenseSeats(String key) {
  try {
    final payload = utf8.decode(base64Url.decode(base64Url.normalize(key.trim().split('.')[1]))).split('|');
    return payload.length > 3 ? int.parse(payload[3]) : 1;
  } catch (_) {
    return 1;
  }
}
