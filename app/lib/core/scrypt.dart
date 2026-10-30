import 'dart:typed_data';

import 'package:crypto/crypto.dart';

/// scrypt (RFC 7914). Only used to open password-protected Aegis exports, which use it as their KDF.
/// N=32768, r=8 needs 32 MB and about a second, so call it from an isolate.
Uint8List scrypt(List<int> password, List<int> salt, {required int n, required int r, required int p, int dkLen = 32}) {
  if (n < 2 || n & (n - 1) != 0) throw ArgumentError('N must be a power of 2');
  final blockWords = 32 * r;
  final b = _pbkdf2(password, salt, p * 128 * r);
  final x = Uint32List(blockWords), v = Uint32List(blockWords * n), y = Uint32List(blockWords);
  final bView = ByteData.sublistView(b);
  for (var i = 0; i < p; i++) {
    final off = i * 128 * r;
    for (var k = 0; k < blockWords; k++) {
      x[k] = bView.getUint32(off + k * 4, Endian.little);
    }
    for (var j = 0; j < n; j++) {
      v.setRange(j * blockWords, (j + 1) * blockWords, x);
      _blockMix(x, y, r);
    }
    for (var j = 0; j < n; j++) {
      final idx = x[(2 * r - 1) * 16] & (n - 1);
      for (var k = 0; k < blockWords; k++) {
        x[k] ^= v[idx * blockWords + k];
      }
      _blockMix(x, y, r);
    }
    for (var k = 0; k < blockWords; k++) {
      bView.setUint32(off + k * 4, x[k], Endian.little);
    }
  }
  return _pbkdf2(password, b, dkLen);
}

/// PBKDF2-HMAC-SHA256 with one iteration, which is all scrypt uses.
Uint8List _pbkdf2(List<int> password, List<int> salt, int len) {
  final hmac = Hmac(sha256, password);
  final out = BytesBuilder();
  for (var i = 1; out.length < len; i++) {
    out.add(hmac.convert([...salt, i >> 24 & 255, i >> 16 & 255, i >> 8 & 255, i & 255]).bytes);
  }
  return Uint8List.fromList(out.takeBytes().sublist(0, len));
}

void _blockMix(Uint32List b, Uint32List y, int r) {
  final x = Uint32List.fromList(b.sublist((2 * r - 1) * 16, 2 * r * 16));
  for (var i = 0; i < 2 * r; i++) {
    for (var k = 0; k < 16; k++) {
      x[k] ^= b[i * 16 + k];
    }
    _salsa8(x);
    // Even blocks go to the first half, odd blocks to the second.
    y.setRange(((i & 1) * r + (i >> 1)) * 16, ((i & 1) * r + (i >> 1)) * 16 + 16, x);
  }
  b.setAll(0, y);
}

int _rotl(int v, int c) => ((v << c) | (v >> (32 - c))) & 0xffffffff;

void _salsa8(Uint32List b) {
  final x = Uint32List.fromList(b);
  for (var i = 0; i < 8; i += 2) {
    x[4] ^= _rotl((x[0] + x[12]) & 0xffffffff, 7);
    x[8] ^= _rotl((x[4] + x[0]) & 0xffffffff, 9);
    x[12] ^= _rotl((x[8] + x[4]) & 0xffffffff, 13);
    x[0] ^= _rotl((x[12] + x[8]) & 0xffffffff, 18);
    x[9] ^= _rotl((x[5] + x[1]) & 0xffffffff, 7);
    x[13] ^= _rotl((x[9] + x[5]) & 0xffffffff, 9);
    x[1] ^= _rotl((x[13] + x[9]) & 0xffffffff, 13);
    x[5] ^= _rotl((x[1] + x[13]) & 0xffffffff, 18);
    x[14] ^= _rotl((x[10] + x[6]) & 0xffffffff, 7);
    x[2] ^= _rotl((x[14] + x[10]) & 0xffffffff, 9);
    x[6] ^= _rotl((x[2] + x[14]) & 0xffffffff, 13);
    x[10] ^= _rotl((x[6] + x[2]) & 0xffffffff, 18);
    x[3] ^= _rotl((x[15] + x[11]) & 0xffffffff, 7);
    x[7] ^= _rotl((x[3] + x[15]) & 0xffffffff, 9);
    x[11] ^= _rotl((x[7] + x[3]) & 0xffffffff, 13);
    x[15] ^= _rotl((x[11] + x[7]) & 0xffffffff, 18);
    x[1] ^= _rotl((x[0] + x[3]) & 0xffffffff, 7);
    x[2] ^= _rotl((x[1] + x[0]) & 0xffffffff, 9);
    x[3] ^= _rotl((x[2] + x[1]) & 0xffffffff, 13);
    x[0] ^= _rotl((x[3] + x[2]) & 0xffffffff, 18);
    x[6] ^= _rotl((x[5] + x[4]) & 0xffffffff, 7);
    x[7] ^= _rotl((x[6] + x[5]) & 0xffffffff, 9);
    x[4] ^= _rotl((x[7] + x[6]) & 0xffffffff, 13);
    x[5] ^= _rotl((x[4] + x[7]) & 0xffffffff, 18);
    x[11] ^= _rotl((x[10] + x[9]) & 0xffffffff, 7);
    x[8] ^= _rotl((x[11] + x[10]) & 0xffffffff, 9);
    x[9] ^= _rotl((x[8] + x[11]) & 0xffffffff, 13);
    x[10] ^= _rotl((x[9] + x[8]) & 0xffffffff, 18);
    x[12] ^= _rotl((x[15] + x[14]) & 0xffffffff, 7);
    x[13] ^= _rotl((x[12] + x[15]) & 0xffffffff, 9);
    x[14] ^= _rotl((x[13] + x[12]) & 0xffffffff, 13);
    x[15] ^= _rotl((x[14] + x[13]) & 0xffffffff, 18);
  }
  for (var i = 0; i < 16; i++) {
    b[i] = (b[i] + x[i]) & 0xffffffff;
  }
}
