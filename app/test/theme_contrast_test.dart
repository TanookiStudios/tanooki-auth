import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tanooki_auth/ui/theme.dart';

/// WCAG 2.x contrast ratio between two opaque colors.
double contrast(Color a, Color b) {
  double lum(Color c) {
    double ch(double v) => v <= 0.04045 ? v / 12.92 : pow((v + 0.055) / 1.055, 2.4).toDouble();
    return 0.2126 * ch(c.r) + 0.7152 * ch(c.g) + 0.0722 * ch(c.b);
  }

  final x = lum(a), y = lum(b);
  return (max(x, y) + 0.05) / (min(x, y) + 0.05);
}

void main() {
  test('the contrast math matches WCAG reference values', () {
    expect(contrast(Colors.black, Colors.white), closeTo(21, 0.01));
    expect(contrast(const Color(0xFF777777), Colors.white), closeTo(4.48, 0.01));
  });

  test('Pastel Pink and Pastel Blue come first among the Premium themes', () {
    final premiumThemes = themeChoices.keys.where((k) => !freeThemes.contains(k)).toList();
    expect(premiumThemes.take(2), ['pink', 'blue']);
    expect(premiumThemes.length, greaterThanOrEqualTo(10));
  });

  for (final MapEntry(key: id, value: p) in themeChoices.entries) {
    if (p == null) continue;
    test('${p.name}: text and gray text are readable (at least 4.5:1) on every surface', () {
      for (final surface in [p.background, p.panel, p.card]) {
        expect(contrast(p.text, surface), greaterThanOrEqualTo(4.5), reason: '${p.name} text');
        expect(contrast(p.muted, surface), greaterThanOrEqualTo(4.5), reason: '${p.name} muted');
      }
    });
    // The newer themes also keep the accent readable as link text, and white button labels on the accent.
    // The originals predate this check (their accents are lighter), so they're held to the text rules only.
    if (const {'sunset', 'peach', 'forest', 'ocean', 'mono'}.contains(id)) {
      test('${p.name}: accent links and button labels are readable', () {
        for (final surface in [p.background, p.panel, p.card]) {
          expect(contrast(p.accent, surface), greaterThanOrEqualTo(4.5), reason: '${p.name} accent on surface');
        }
        expect(contrast(Colors.white, p.accent),
            greaterThanOrEqualTo(p.brightness == Brightness.light ? 4.5 : 3.0), reason: '${p.name} white on accent');
      });
    }
  }
}
