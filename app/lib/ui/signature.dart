import 'dart:math';

import 'package:flutter/material.dart';

/// Maddie's signature (the same signature.svg used across her apps), redrawn natively like
/// Couchy's SignatureView: 330×116 viewBox, the SVG's rotate(-4 160 66) skewX(-8) flourish,
/// round 2.7 strokes, plus the dot. Takes the given color, so no light/dark variant is needed.
class Signature extends StatelessWidget {
  const Signature({super.key, this.width = 200, required this.color});
  final double width;
  final Color color;

  @override
  Widget build(BuildContext context) => Semantics(
        label: 'Signed, Maddie',
        image: true,
        child: CustomPaint(size: Size(width, width * 116 / 330), painter: _SignaturePainter(color)),
      );
}

// Paths from signature.svg: only absolute M and C commands, so a tiny reader is enough.
const _paths = [
  ('M2 72 C 12 69 22 69 32 68', 0.85),
  ('M50 92 C 46 66 48 34 56 30 C 62 27 62 46 63 62 C 64 74 63 84 68 90 C 74 64 84 40 92 46 C 97 58 95 80 102 90 C 106 94 114 92 118 84 C 122 72 108 68 106 80 C 105 90 118 94 121 84 C 122 76 122 82 126 90 C 130 94 138 92 141 84 C 144 72 130 68 128 80 C 127 90 140 94 143 84 C 145 60 149 26 152 27 C 154 26 153 42 152 54 C 151 68 149 82 155 90 C 159 94 167 92 170 84 C 173 72 159 68 157 80 C 156 90 169 94 172 84 C 174 60 178 26 181 27 C 183 26 182 42 181 54 C 180 68 178 82 184 90 C 188 94 193 82 194 74 C 195 80 194 88 199 90 C 205 86 214 82 216 74 C 218 66 205 64 202 72 C 199 82 210 90 222 84 C 242 96 278 96 306 74 C 316 67 320 62 323 63', 1.0),
];

Path parseSignaturePath(String d) {
  final n = RegExp(r'-?\d+(\.\d+)?').allMatches(d).map((m) => double.parse(m[0]!)).toList();
  final path = Path()..moveTo(n[0], n[1]);
  for (var i = 2; i + 5 < n.length; i += 6) {
    path.cubicTo(n[i], n[i + 1], n[i + 2], n[i + 3], n[i + 4], n[i + 5]);
  }
  return path;
}

/// SVG "rotate(-4 160 66) skewX(-8)": skew first, then rotate about (160, 66).
Matrix4 get signatureTransform {
  final skew = Matrix4.identity()..setEntry(0, 1, tan(-8 * pi / 180));
  final rotate = Matrix4.identity()
    ..translateByDouble(160, 66, 0, 1)
    ..rotateZ(-4 * pi / 180)
    ..translateByDouble(-160, -66, 0, 1);
  return rotate..multiply(skew);
}

class _SignaturePainter extends CustomPainter {
  _SignaturePainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 330);
    canvas.transform(signatureTransform.storage);
    for (final (d, opacity) in _paths) {
      canvas.drawPath(
        parseSignaturePath(d),
        Paint()
          ..color = color.withValues(alpha: opacity)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.7
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
    }
    canvas.drawCircle(const Offset(196, 48), 2.4, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_SignaturePainter old) => old.color != color;
}
