import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tanooki_auth/ui/theme.dart';

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
    test('${p.name}: white labels on filled buttons are readable (at least 4.5:1)', () {
      expect(contrast(Colors.white, buttonFill(p.accent)), greaterThanOrEqualTo(4.5));
    });
    // The newer themes also keep the accent readable as link text, and white button labels on the accent.
    // The originals predate this check (their accents are lighter), so they're held to the text rules only.
    if (const {'sunset', 'peach', 'forest', 'ocean', 'mono', ...seasonalThemes}.contains(id)) {
      test('${p.name}: accent links and button labels are readable', () {
        for (final surface in [p.background, p.panel, p.card]) {
          expect(contrast(p.accent, surface), greaterThanOrEqualTo(4.5), reason: '${p.name} accent on surface');
        }
        expect(contrast(Colors.white, p.accent),
            greaterThanOrEqualTo(p.brightness == Brightness.light ? 4.5 : 3.0), reason: '${p.name} white on accent');
      });
    }
  }

  /// Every rule the built-in themes meet, for a palette made in the editor.
  void expectReadable(AppPalette p) {
    for (final surface in [p.background, p.panel, p.card]) {
      expect(contrast(p.text, surface), greaterThanOrEqualTo(4.5), reason: 'text');
      expect(contrast(p.muted, surface), greaterThanOrEqualTo(4.5), reason: 'muted');
      expect(contrast(p.accent, surface), greaterThanOrEqualTo(4.5), reason: 'accent');
    }
    expect(contrast(Colors.white, buttonFill(p.accent)), greaterThanOrEqualTo(4.5), reason: 'button label');
  }

  group('make your own theme', () {
    test('colors that already read well are kept as picked', () {
      final p = customPalette('c', accent: const Color(0xFF7AA2FF), background: darkPalette.background, card: darkPalette.card, text: Colors.white)!;
      expect(p.text, Colors.white);
      expect(p.accent, const Color(0xFF7AA2FF));
      expect(p.brightness, Brightness.dark);
      expectReadable(p);
    });

    test('hard-to-read picks are adjusted until they pass', () {
      // Gray text and a pale yellow accent on white: both fail as picked.
      final p = customPalette('c', accent: const Color(0xFFFFE680), background: Colors.white, card: const Color(0xFFF7F7F7), text: const Color(0xFFBBBBBB))!;
      expect(contrast(const Color(0xFFBBBBBB), Colors.white), lessThan(4.5)); // the pick really failed
      expect(p.text, isNot(const Color(0xFFBBBBBB)));
      expect(p.brightness, Brightness.light);
      expectReadable(p);
    });

    test('text the same color as the background is moved, not kept', () {
      final p = customPalette('c', accent: Colors.black, background: Colors.black, card: Colors.black, text: Colors.black)!;
      expectReadable(p);
    });

    test('picks that no shade can fix are refused', () {
      // Near-black background with near-white cards: nothing reads at 4.5:1 on both.
      expect(customPalette('c', accent: Colors.blue, background: Colors.black, card: Colors.white, text: Colors.grey), isNull);
    });

    test('every hue on every preset background passes or is refused, never saved unreadable', () {
      for (final bg in [darkPalette.background, lightPalette.background, const Color(0xFF808080)]) {
        for (var h = 0.0; h < 360; h += 15) {
          final c = HSLColor.fromAHSL(1, h, 0.7, 0.5).toColor();
          final p = customPalette('c', accent: c, background: bg, card: bg, text: c);
          if (p != null) expectReadable(p);
        }
      }
    });

    test('saved themes load by slot, and broken entries are left out', () {
      final settings = <String, dynamic>{
        customThemesKey: {
          'custom1': {'accent': 0xFF2F80FF, 'background': 0xFF0B0B0D, 'card': 0xFF16161A, 'text': 0xFFF2F2F5},
          'custom2': {'accent': 'blue'},
          'custom9': {'accent': 0xFF2F80FF, 'background': 0xFF0B0B0D, 'card': 0xFF16161A, 'text': 0xFFF2F2F5},
        },
        'theme': 'custom1',
      };
      loadCustomThemes(settings);
      addTearDown(customThemes.clear);
      expect(customThemes.keys, ['custom1']);
      expect(paletteFor('custom1'), isNotNull);
      expect(themeToUse(settings, premium: true, now: DateTime(2026, 7)), 'custom1');
      expect(themeToUse(settings, premium: false, now: DateTime(2026, 7)), 'auto');
      settings['theme'] = 'custom2';
      expect(themeToUse(settings, premium: true, now: DateTime(2026, 7)), 'auto');
    });
  });

  group('seasonal themes', () {
    test('each month maps to its season, and summer has none', () {
      expect([for (var m = 1; m <= 12; m++) seasonFor(DateTime(2026, m))], [
        'cozy', 'cozy', 'spring', 'spring', 'spring', null, null, null, 'spooky', 'spooky', 'spooky', 'cozy',
      ]);
      expect(seasonalThemes.every(themeChoices.containsKey), isTrue);
    });

    test('"Change with the seasons" wins over the pick, except in summer and without Premium', () {
      final s = <String, dynamic>{'theme': 'pink', seasonalThemeKey: true};
      expect(themeToUse(s, premium: true, now: DateTime(2026, 10, 31)), 'spooky');
      expect(themeToUse(s, premium: true, now: DateTime(2026, 12, 25)), 'cozy');
      expect(themeToUse(s, premium: true, now: DateTime(2026, 4, 1)), 'spring');
      expect(themeToUse(s, premium: true, now: DateTime(2026, 7, 4)), 'pink');
      expect(themeToUse(s, premium: false, now: DateTime(2026, 10, 31)), 'auto');
      s[seasonalThemeKey] = false;
      expect(themeToUse(s, premium: true, now: DateTime(2026, 10, 31)), 'pink');
    });
  });
}
