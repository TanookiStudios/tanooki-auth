import 'dart:convert';
import 'dart:io' show gzip;
import 'dart:math';
import 'dart:typed_data';

/// Paper backup in two halves: the encrypted backup file is split so that half A is pure random bytes and
/// half B is the backup XOR half A. Either half alone is indistinguishable from random noise; both together give
/// the backup file back, which still needs its passphrase.
///
/// Each half is printed as a set of QR codes. One code's text:
/// `TA2H:1:<set>:<A|B>:<part>:<parts>:<base64url bytes>`, where set is a random id both halves share.
const halfPrefix = 'TA2H:';
const _version = '1';
/// Bytes per QR code: 800 characters once base64-encoded, small enough for a phone camera to read off paper.
const halfChunk = 600;

/// Splits [data] into two halves of the same length. [random] is for tests only.
(Uint8List, Uint8List) xorSplit(List<int> data, {Random? random}) {
  final r = random ?? Random.secure();
  final a = Uint8List.fromList(List.generate(data.length, (_) => r.nextInt(256)));
  return (a, xorJoin(a, data));
}

Uint8List xorJoin(List<int> a, List<int> b) {
  if (a.length != b.length) throw const FormatException('halves-differ');
  return Uint8List.fromList([for (var i = 0; i < a.length; i++) a[i] ^ b[i]]);
}

/// The two halves of a backup file's text, as the QR code texts to print. [setId] and [random] are for tests.
({List<String> a, List<String> b}) splitBackupText(String backupText, {String? setId, Random? random}) {
  final r = random ?? Random.secure();
  final id = setId ?? base64Url.encode(List.generate(6, (_) => r.nextInt(256)));
  // Compressed first (the backup's base64 shrinks by a quarter), so there are fewer codes to print and scan.
  final (a, b) = xorSplit(gzip.encode(utf8.encode(backupText)), random: r);
  return (a: _codes(a, 'A', id), b: _codes(b, 'B', id));
}

List<String> _codes(Uint8List half, String which, String id) {
  final parts = (half.length / halfChunk).ceil().clamp(1, 1 << 20);
  return [
    for (var i = 0; i < parts; i++)
      '$halfPrefix$_version:$id:$which:${i + 1}:$parts:${base64Url.encode(half.sublist(i * halfChunk, min(half.length, (i + 1) * halfChunk)))}',
  ];
}

/// Why a scanned code was turned away (see [HalfCollector.add]).
enum HalfProblem { notAHalf, otherSet, duplicate }

/// Collects scanned codes from both halves, in any order, until both are complete.
class HalfCollector {
  String? setId;
  final _parts = <String, Map<int, List<int>>>{'A': {}, 'B': {}};
  final _counts = <String, int>{};

  /// Adds one code. Returns null when it was new, or why it wasn't used.
  HalfProblem? add(String text) {
    final f = text.trim().split(':');
    if (f.length != 7 || '${f[0]}:' != halfPrefix || f[1] != _version || !(f[3] == 'A' || f[3] == 'B')) return HalfProblem.notAHalf;
    final part = int.tryParse(f[4]), parts = int.tryParse(f[5]);
    final List<int> bytes;
    try {
      bytes = base64Url.decode(f[6]);
    } on FormatException {
      return HalfProblem.notAHalf;
    }
    if (part == null || parts == null || part < 1 || part > parts) return HalfProblem.notAHalf;
    if (setId != null && f[2] != setId) return HalfProblem.otherSet;
    if (_counts[f[3]] != null && _counts[f[3]] != parts) return HalfProblem.otherSet;
    if (_parts[f[3]]!.containsKey(part)) return HalfProblem.duplicate;
    setId = f[2];
    _counts[f[3]] = parts;
    _parts[f[3]]![part] = bytes;
    return null;
  }

  int have(String which) => _parts[which]!.length;
  /// How many codes the half has, or null until one of its codes is scanned.
  int? total(String which) => _counts[which];
  bool done(String which) => total(which) != null && have(which) == total(which);
  bool get complete => done('A') && done('B');

  Uint8List _half(String which) =>
      Uint8List.fromList([for (var i = 1; i <= total(which)!; i++) ..._parts[which]![i]!]);

  /// The backup file's text. Throws [FormatException] if the halves don't fit together.
  String join() {
    if (!complete) throw const FormatException('incomplete');
    try {
      return utf8.decode(gzip.decode(xorJoin(_half('A'), _half('B'))));
    } on FormatException {
      rethrow;
    } catch (_) {
      throw const FormatException('halves-differ'); // gzip's checksum failed: a misread or mismatched code
    }
  }
}
