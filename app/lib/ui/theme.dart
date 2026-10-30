import 'package:flutter/material.dart';

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
};
const freeThemes = {'auto', 'dark', 'light'};

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

const _radius = 8.0;
RoundedRectangleBorder get _outline => RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(_radius),
  side: BorderSide(color: Palette.line),
);

ThemeData buildTheme(AppPalette p) {
  Palette.current = p;
  final scheme = ColorScheme(
    brightness: p.brightness,
    onSecondary: Colors.white,
    onError: Colors.white,
    primary: Palette.accent,
    onPrimary: Colors.white,
    secondary: Palette.green,
    surface: Palette.panel,
    onSurface: Palette.text,
    surfaceContainerHighest: Palette.line,
    error: Palette.red,
    outline: Palette.line,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: Palette.background,
    dividerColor: Palette.line,
    dividerTheme: DividerThemeData(color: Palette.line, space: 1, thickness: 1),
    appBarTheme: AppBarTheme(
      backgroundColor: Palette.background,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Palette.text),
      shape: Border(bottom: BorderSide(color: Palette.line)),
    ),
    cardTheme: CardThemeData(color: Palette.card, elevation: 0, margin: EdgeInsets.zero, shape: _outline),
    dialogTheme: DialogThemeData(backgroundColor: Palette.panel, surfaceTintColor: Colors.transparent, shape: _outline),
    popupMenuTheme: PopupMenuThemeData(color: Palette.panel, surfaceTintColor: Colors.transparent, shape: _outline),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Palette.panel,
      contentTextStyle: TextStyle(color: Palette.text),
      behavior: SnackBarBehavior.floating,
      shape: _outline,
    ),
    listTileTheme: ListTileThemeData(iconColor: Palette.muted, subtitleTextStyle: TextStyle(color: Palette.muted)),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: Palette.accent,
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
      backgroundColor: Palette.accent,
      foregroundColor: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Palette.background,
      hintStyle: TextStyle(color: Palette.muted),
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
