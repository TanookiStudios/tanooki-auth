import 'dart:math';

import 'package:flutter/material.dart';
import '../l10n/l10n.dart';

/// One color set. The house look is near-black panels, thin outlines, an accent color, small caps labels.
class AppPalette {
  const AppPalette({
    required this.name,
    required this.brightness,
    required this.background,
    required this.panel,
    required this.card,
    required this.line,
    required this.lineBright,
    required this.text,
    required this.muted,
    required this.accent,
    this.green = const Color(0xFF2BD66B),
    this.red = const Color(0xFFFF5A5F),
  });
  final String name;
  final Brightness brightness;
  final Color background, panel, card, line, lineBright, text, muted, accent, green, red;
}

const darkPalette = AppPalette(
  name: 'Dark', brightness: Brightness.dark,
  background: Color(0xFF0B0B0D), panel: Color(0xFF131316), card: Color(0xFF16161A),
  line: Color(0xFF2A2A30), lineBright: Color(0xFF3A3A42),
  text: Color(0xFFF2F2F5), muted: Color(0xFF8B8B95), accent: Color(0xFF2F80FF),
);
const lightPalette = AppPalette(
  name: 'Light', brightness: Brightness.light,
  background: Color(0xFFF5F5F7), panel: Color(0xFFFFFFFF), card: Color(0xFFFFFFFF),
  line: Color(0xFFE2E2E8), lineBright: Color(0xFFCFCFD8),
  text: Color(0xFF16161A), muted: Color(0xFF6B6B75), accent: Color(0xFF2F6FE0),
  green: Color(0xFF15934C), red: Color(0xFFD93A40),
);

/// Theme choices in picker order. Auto, Dark and Light are free; the rest are Premium,
/// and Maddie's two pastels always come first.
const themeChoices = <String, AppPalette?>{
  'auto': null, // follows the device's light/dark setting
  'dark': darkPalette,
  'light': lightPalette,
  'pink': AppPalette(
    name: 'Pastel Pink', brightness: Brightness.light,
    background: Color(0xFFFFF3F7), panel: Color(0xFFFFFFFF), card: Color(0xFFFFFFFF),
    line: Color(0xFFF5D2E0), lineBright: Color(0xFFEDB6CB),
    text: Color(0xFF3A2230), muted: Color(0xFF866574), accent: Color(0xFFE2649A),
    green: Color(0xFF2E9E6E), red: Color(0xFFD9364F),
  ),
  'blue': AppPalette(
    name: 'Pastel Blue', brightness: Brightness.light,
    background: Color(0xFFF1F6FF), panel: Color(0xFFFFFFFF), card: Color(0xFFFFFFFF),
    line: Color(0xFFCFDFF6), lineBright: Color(0xFFB3CCEE),
    text: Color(0xFF1E2A3A), muted: Color(0xFF607086), accent: Color(0xFF4387E2),
    green: Color(0xFF2E9E6E), red: Color(0xFFD9364F),
  ),
  'lavender': AppPalette(
    name: 'Lavender', brightness: Brightness.light,
    background: Color(0xFFF6F3FF), panel: Color(0xFFFFFFFF), card: Color(0xFFFFFFFF),
    line: Color(0xFFDFD5F6), lineBright: Color(0xFFC9BAEF),
    text: Color(0xFF2A2240), muted: Color(0xFF726A8C), accent: Color(0xFF8565DD),
    green: Color(0xFF2E9E6E), red: Color(0xFFD9364F),
  ),
  'mint': AppPalette(
    name: 'Mint', brightness: Brightness.light,
    background: Color(0xFFF0FAF6), panel: Color(0xFFFFFFFF), card: Color(0xFFFFFFFF),
    line: Color(0xFFCBEBDD), lineBright: Color(0xFFADDFC8),
    text: Color(0xFF173228), muted: Color(0xFF5A756A), accent: Color(0xFF239E78),
    green: Color(0xFF239E78), red: Color(0xFFD9364F),
  ),
  'midnight': AppPalette(
    name: 'Midnight', brightness: Brightness.dark,
    background: Color(0xFF0A0F1F), panel: Color(0xFF10182C), card: Color(0xFF131C33),
    line: Color(0xFF243150), lineBright: Color(0xFF33436B),
    text: Color(0xFFEAF0FF), muted: Color(0xFF8592B3), accent: Color(0xFF7AA2FF),
  ),
  'sunset': AppPalette(
    name: 'Sunset', brightness: Brightness.dark,
    background: Color(0xFF1A0F1E), panel: Color(0xFF22142A), card: Color(0xFF26172F),
    line: Color(0xFF3A2643), lineBright: Color(0xFF4D3358),
    text: Color(0xFFFFF1EA), muted: Color(0xFFB9A0B4), accent: Color(0xFFE8673A),
  ),
  'peach': AppPalette(
    name: 'Peach', brightness: Brightness.light,
    background: Color(0xFFFFF5EE), panel: Color(0xFFFFFFFF), card: Color(0xFFFFFFFF),
    line: Color(0xFFF7DCCB), lineBright: Color(0xFFEFC4A8),
    text: Color(0xFF3D2519), muted: Color(0xFF876858), accent: Color(0xFFA84E28),
    green: Color(0xFF2E8B5E), red: Color(0xFFD9364F),
  ),
  'forest': AppPalette(
    name: 'Forest', brightness: Brightness.dark,
    background: Color(0xFF0D1612), panel: Color(0xFF12201A), card: Color(0xFF15251E),
    line: Color(0xFF24382E), lineBright: Color(0xFF33503F),
    text: Color(0xFFEAF5EE), muted: Color(0xFF93AD9F), accent: Color(0xFF2E9E66),
    green: Color(0xFF3DDC84),
  ),
  'ocean': AppPalette(
    name: 'Ocean', brightness: Brightness.dark,
    background: Color(0xFF071A1F), panel: Color(0xFF0C242B), card: Color(0xFF0F2A32),
    line: Color(0xFF1D3E47), lineBright: Color(0xFF2A5560),
    text: Color(0xFFE6F6F8), muted: Color(0xFF8FB3BA), accent: Color(0xFF1A9BB0),
  ),
  'mono': AppPalette(
    name: 'Mono', brightness: Brightness.light,
    background: Color(0xFFF4F4F4), panel: Color(0xFFFFFFFF), card: Color(0xFFFFFFFF),
    line: Color(0xFFDDDDDD), lineBright: Color(0xFFC4C4C4),
    text: Color(0xFF111111), muted: Color(0xFF5E5E5E), accent: Color(0xFF222222),
    green: Color(0xFF1F7A45), red: Color(0xFFC62828),
  ),
  // Seasonal (Premium), matching the seasonal app icons. "Change with the seasons" picks one by month.
  'spooky': AppPalette(
    name: 'Spooky', brightness: Brightness.dark,
    background: Color(0xFF1A1022), panel: Color(0xFF21152B), card: Color(0xFF251830),
    line: Color(0xFF3A2643), lineBright: Color(0xFF4F3459),
    text: Color(0xFFFFF0E0), muted: Color(0xFFB9A3B8), accent: Color(0xFFE86E14),
  ),
  'cozy': AppPalette(
    name: 'Cozy', brightness: Brightness.dark,
    background: Color(0xFF0E2238), panel: Color(0xFF112840), card: Color(0xFF132B45),
    line: Color(0xFF22405F), lineBright: Color(0xFF2F5378),
    text: Color(0xFFF2F6FB), muted: Color(0xFF9DB0C6), accent: Color(0xFFF06070),
  ),
  'spring': AppPalette(
    name: 'Spring', brightness: Brightness.light,
    background: Color(0xFFEEF8EA), panel: Color(0xFFFFFFFF), card: Color(0xFFFFFFFF),
    line: Color(0xFFCFE6C6), lineBright: Color(0xFFB5D8A8),
    text: Color(0xFF1D3324), muted: Color(0xFF56705C), accent: Color(0xFF2E7D4A),
    green: Color(0xFF2E7D4A), red: Color(0xFFD9364F),
  ),
};
const freeThemes = {'auto', 'dark', 'light'};
const seasonalThemes = {'spooky', 'cozy', 'spring'};

/// Settings keys (Premium): the custom themes made in the editor, and "Change with the seasons".
const customThemesKey = 'customThemes', seasonalThemeKey = 'seasonalTheme';

/// Up to three custom themes, saved in these slots.
const customSlots = ['custom1', 'custom2', 'custom3'];

/// The custom themes in use, by slot. Filled from the vault's settings by [loadCustomThemes].
final customThemes = <String, AppPalette>{};

/// Built-in or custom palette for [id]; null for Auto or an unknown id.
AppPalette? paletteFor(String id) => themeChoices[id] ?? customThemes[id];
bool themeExists(String id) => themeChoices.containsKey(id) || customThemes.containsKey(id);

/// The seasonal theme for [now]'s month, or null in summer (then the picked theme shows).
/// shortcut: northern-hemisphere seasons; add a hemisphere choice if southern users ask.
String? seasonFor(DateTime now) => switch (now.month) {
      9 || 10 || 11 => 'spooky',
      12 || 1 || 2 => 'cozy',
      3 || 4 || 5 => 'spring',
      _ => null,
    };

/// The theme to show: this season's one when "Change with the seasons" is on, else the picked one.
/// Premium themes without Premium (and themes that no longer exist) fall back to Auto.
String themeToUse(Map<String, dynamic> settings, {required bool premium, required DateTime now}) {
  final season = premium && settings[seasonalThemeKey] == true ? seasonFor(now) : null;
  if (season != null) return season;
  final t = settings['theme'] as String? ?? 'auto';
  return themeExists(t) && (freeThemes.contains(t) || premium) ? t : 'auto';
}

/// WCAG 2.x contrast ratio between two opaque colors, from 1 to 21.
double contrast(Color a, Color b) {
  final x = a.computeLuminance(), y = b.computeLuminance();
  return (max(x, y) + 0.05) / (min(x, y) + 0.05);
}

/// [fg], made lighter or darker only as far as needed to read at [ratio] on every one of [surfaces].
/// Returns null when no shade of it can (say, one surface is near-black and the other near-white).
Color? readableOn(Color fg, List<Color> surfaces, [double ratio = 4.5]) {
  bool ok(Color c) => surfaces.every((s) => contrast(c, s) >= ratio);
  if (ok(fg)) return fg;
  final up = surfaces.every((s) => contrast(Colors.white, s) >= contrast(Colors.black, s));
  var hsl = HSLColor.fromColor(fg);
  while (!ok(hsl.toColor()) && (up ? hsl.lightness < 1 : hsl.lightness > 0)) {
    hsl = hsl.withLightness((hsl.lightness + (up ? 0.01 : -0.01)).clamp(0.0, 1.0));
  }
  return ok(hsl.toColor()) ? hsl.toColor() : null;
}

/// A whole palette from the editor's four picks. Text, gray text and the accent are adjusted until they
/// read at 4.5:1 (WCAG AA) on the background and cards; filled buttons get [buttonFill] like every theme.
/// Null when the picks can't be made readable.
AppPalette? customPalette(String name, {required Color accent, required Color background, required Color card, required Color text}) {
  final surfaces = [background, card];
  final t = readableOn(text, surfaces);
  if (t == null) return null;
  final muted = readableOn(Color.lerp(t, card, 0.35)!, surfaces);
  final a = readableOn(accent, surfaces);
  if (muted == null || a == null) return null;
  final dark = contrast(Colors.white, background) > contrast(Colors.black, background);
  final base = dark ? darkPalette : lightPalette;
  return AppPalette(
    name: name, brightness: dark ? Brightness.dark : Brightness.light,
    background: background, panel: card, card: card,
    line: Color.lerp(card, t, 0.14)!, lineBright: Color.lerp(card, t, 0.24)!,
    text: t, muted: muted, accent: a, green: base.green, red: base.red,
  );
}

/// The editor's four picks for a custom theme, as saved in settings (0xAARRGGBB numbers).
const customRoles = ['accent', 'background', 'card', 'text'];

AppPalette? customPaletteFrom(String id, Map<dynamic, dynamic> picks) {
  final c = [for (final r in customRoles) picks[r]];
  if (c.any((v) => v is! int)) return null;
  final colors = [for (final v in c) Color(v as int)];
  return customPalette(id, accent: colors[0], background: colors[1], card: colors[2], text: colors[3]);
}

/// Reads the saved custom themes into [customThemes]. Broken entries are left out.
void loadCustomThemes(Map<String, dynamic> settings) {
  customThemes.clear();
  final saved = settings[customThemesKey];
  if (saved is! Map) return;
  for (final id in customSlots) {
    final picks = saved[id];
    final p = picks is Map ? customPaletteFrom(id, picks) : null;
    if (p != null) customThemes[id] = p;
  }
}

/// The name shown for theme [id] in the app's language (AppPalette.name stays the English one).
String themeName(String id) => switch (id) {
      'dark' => l10n.themeDark,
      'light' => l10n.themeLight,
      'pink' => l10n.themePink,
      'blue' => l10n.themeBlue,
      'lavender' => l10n.themeLavender,
      'mint' => l10n.themeMint,
      'midnight' => l10n.themeMidnight,
      'sunset' => l10n.themeSunset,
      'peach' => l10n.themePeach,
      'forest' => l10n.themeForest,
      'ocean' => l10n.themeOcean,
      'mono' => l10n.themeMono,
      'spooky' => l10n.appIconSpooky,
      'cozy' => l10n.appIconCozy,
      'spring' => l10n.appIconSpring,
      'custom1' => l10n.themeCustom(1),
      'custom2' => l10n.themeCustom(2),
      'custom3' => l10n.themeCustom(3),
      _ => l10n.themeAuto,
    };

/// The colors in use right now. Set once per build by the app root, which also re-keys the whole
/// tree when it changes, so every widget reading these repaints.
abstract final class Palette {
  static AppPalette current = darkPalette;
  static Color get background => current.background;
  static Color get panel => current.panel;
  static Color get card => current.card;
  static Color get line => current.line;
  static Color get lineBright => current.lineBright;
  static Color get text => current.text;
  static Color get muted => current.muted;
  static Color get accent => current.accent;
  static Color get green => current.green;
  static Color get red => current.red;
}

/// Settings key and switch for the easy-to-read font (Atkinson Hyperlegible, bundled in assets/fonts with
/// its SIL Open Font License). Read by [buildTheme]; the app root repaints everything when it changes.
const easyFontKey = 'easyFont', easyFontFamily = 'AtkinsonHyperlegible';
final easyFont = ValueNotifier<bool>(false);

/// [accent] darkened just enough for white button labels on it to read at 4.5:1 (WCAG AA). Themes whose
/// accent already passes get it unchanged. Used for filled buttons only; links keep the brighter accent.
Color buttonFill(Color accent) {
  double onWhite(Color c) => 1.05 / (c.computeLuminance() + 0.05);
  var hsl = HSLColor.fromColor(accent);
  while (onWhite(hsl.toColor()) < 4.5 && hsl.lightness > 0.02) {
    hsl = hsl.withLightness(hsl.lightness - 0.01);
  }
  return hsl.toColor();
}

const _radius = 8.0;
RoundedRectangleBorder get _outline => RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(_radius),
  side: BorderSide(color: Palette.line),
);

ThemeData buildTheme(AppPalette p) {
  Palette.current = p;
  // Styles set right here don't pick up ThemeData.fontFamily on their own, so each one names it too.
  final font = easyFont.value ? easyFontFamily : null;
  final scheme = ColorScheme(
    brightness: p.brightness,
    onSecondary: Colors.white,
    onError: Colors.white,
    primary: Palette.accent,
    onPrimary: Colors.white,
    secondary: Palette.green,
    // Selected chips and segments. Unset, these fall back to green with white text, which is hard to read.
    secondaryContainer: buttonFill(Palette.accent),
    onSecondaryContainer: Colors.white,
    surface: Palette.panel,
    onSurface: Palette.text,
    surfaceContainerHighest: Palette.line,
    error: Palette.red,
    outline: Palette.line,
  );
  return ThemeData(
    useMaterial3: true,
    fontFamily: font,
    colorScheme: scheme,
    scaffoldBackgroundColor: Palette.background,
    dividerColor: Palette.line,
    dividerTheme: DividerThemeData(color: Palette.line, space: 1, thickness: 1),
    appBarTheme: AppBarTheme(
      backgroundColor: Palette.background,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: TextStyle(fontFamily: font, fontSize: 22, fontWeight: FontWeight.w700, color: Palette.text),
      shape: Border(bottom: BorderSide(color: Palette.line)),
    ),
    cardTheme: CardThemeData(color: Palette.card, elevation: 0, margin: EdgeInsets.zero, shape: _outline),
    dialogTheme: DialogThemeData(backgroundColor: Palette.panel, surfaceTintColor: Colors.transparent, shape: _outline),
    popupMenuTheme: PopupMenuThemeData(color: Palette.panel, surfaceTintColor: Colors.transparent, shape: _outline),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Palette.panel,
      contentTextStyle: TextStyle(fontFamily: font, color: Palette.text),
      behavior: SnackBarBehavior.floating,
      shape: _outline,
    ),
    listTileTheme: ListTileThemeData(iconColor: Palette.muted, subtitleTextStyle: TextStyle(fontFamily: font, color: Palette.muted)),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: buttonFill(Palette.accent),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Palette.text,
        side: BorderSide(color: Palette.lineBright),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: buttonFill(Palette.accent),
      foregroundColor: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Palette.background,
      hintStyle: TextStyle(fontFamily: font, color: Palette.muted),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: Palette.lineBright),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide(color: Palette.accent),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? Colors.white : Palette.muted),
      trackOutlineColor: WidgetStatePropertyAll(Palette.lineBright),
      trackColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? Palette.accent : Palette.line),
    ),
  );
}

/// Small gray all-caps label, e.g. "TOTP · 30 S".
class CapsLabel extends StatelessWidget {
  const CapsLabel(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Text(
        text.toUpperCase(),
        style: TextStyle(fontSize: 10.5, letterSpacing: 1.1, fontWeight: FontWeight.w600, color: Palette.muted),
      );
}

/// Outlined pill, blue for tags, filled for little badges.
class Pill extends StatelessWidget {
  Pill(this.text, {super.key, Color? color, this.filled = false}) : color = color ?? Palette.accent;
  final String text;
  final Color color;
  final bool filled;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: filled ? color : color.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: filled ? color : color.withValues(alpha: 0.55)),
        ),
        child: Text(
          text,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: filled ? Colors.black : Palette.text,
          ),
        ),
      );
}

/// A count badge next to a heading, like "Your accounts [3]".
class CountBadge extends StatelessWidget {
  const CountBadge(this.count, {super.key});
  final int count;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Palette.lineBright),
        ),
        child: Text('$count', style: TextStyle(fontSize: 12, color: Palette.muted)),
      );
}
