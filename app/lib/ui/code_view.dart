import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../core/account.dart';
import 'theme.dart';
import '../l10n/l10n.dart';

/// Settings key for how each code's time left is drawn: a ring, a bar, or just the number.
const countdownKey = 'countdown';
Map<String, String> get countdownChoices => {'ring': l10n.codeViewRing, 'bar': l10n.codeViewBar, 'number': l10n.codeViewNumber};
String countdownOf(Map<String, dynamic> settings) =>
    countdownChoices.containsKey(settings[countdownKey]) ? settings[countdownKey] as String : 'ring';

/// A code split the way it is shown: 6 digits as 3+3, 8 as 4+4, anything else (Steam, 7 digits) whole.
List<String> codeGroups(String code) => switch (code.length) {
      6 => [code.substring(0, 3), code.substring(3)],
      8 => [code.substring(0, 4), code.substring(4)],
      _ => [code],
    };

/// [code] for a screen reader: one character at a time, a pause (comma) between the groups on screen.
/// "482139" -> "4 8 2, 1 3 9".
String spokenCode(String code) => codeGroups(code).map((g) => g.split('').join(' ')).join(', ');

/// What a screen reader says for a code with [left] seconds to go (null for counter-based codes).
String codeSemantics(String code, int? left) => left == null
    ? l10n.codeViewSpoken(spokenCode(code))
    : l10n.codeViewSpokenLeft(left, spokenCode(code));

/// What Read aloud says: digits in pairs ("4 8, 2 1, 3 9"), and Steam's letters one by one so each is spelled.
String readAloudText(String code, {bool letters = false}) {
  final step = letters ? 1 : 2;
  return [for (var i = 0; i < code.length; i += step) code.substring(i, (i + step).clamp(0, code.length)).split('').join(' ')]
      .join(', ');
}

/// flutter_tts has no Linux (or web) version, so the speaker button is hidden there.
bool get readAloudSupported => !kIsWeb && !Platform.isLinux;

FlutterTts? _tts;

/// Says [a]'s [code] slowly. Callers must already have asked for Face ID etc. on "ask first" accounts.
Future<void> readAloud(Account a, String code) async {
  try {
    final tts = _tts ??= FlutterTts();
    await tts.stop();
    await tts.setSpeechRate(0.35); // 0.5 is normal speed on every platform
    await tts.speak(readAloudText(code.toUpperCase(), letters: a.type == OtpType.steam));
  } on MissingPluginException {
    // Not wired (unit tests).
  } on PlatformException catch (e) {
    debugPrint('Read aloud failed: ${e.code}'); // never log the code itself
  }
}

/// Speaker button that reads a code. [onPressed] does the asking and reading.
class ReadAloudButton extends StatelessWidget {
  const ReadAloudButton({super.key, required this.onPressed, this.size = 20});
  final VoidCallback onPressed;
  final double size;

  @override
  Widget build(BuildContext context) => IconButton(
        tooltip: l10n.codeViewReadAloud,
        iconSize: size,
        icon: Icon(Icons.volume_up_outlined, color: Palette.muted),
        onPressed: onPressed,
      );
}

/// Time left on a code, drawn the way the user picked in Settings ([countdownKey]). Hidden from screen
/// readers: the code's own label already says how many seconds are left.
class Countdown extends StatelessWidget {
  const Countdown({super.key, required this.left, required this.period, this.style = 'ring', this.big = false});
  final int left, period;
  final String style;
  final bool big;

  @override
  Widget build(BuildContext context) {
    final urgent = left <= 5;
    final color = urgent ? Palette.red : Palette.accent;
    final label = Text(l10n.codeViewSecondsShort(left),
        style: TextStyle(fontSize: big ? 15 : 12, color: urgent ? Palette.red : Palette.muted, fontFeatures: const [FontFeature.tabularFigures()]));
    final Widget body = switch (style) {
      'number' => Text('$left',
          key: const Key('countdownNumber'),
          style: TextStyle(fontSize: big ? 30 : 20, fontWeight: FontWeight.w700, color: color, fontFeatures: const [FontFeature.tabularFigures()])),
      'bar' => SizedBox(
          key: const Key('countdownBar'),
          width: big ? 160 : 56,
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.end, children: [
            label,
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(value: left / period, minHeight: big ? 6 : 4, color: color, backgroundColor: Palette.line),
            ),
          ]),
        ),
      _ => Row(key: const Key('countdownRing'), mainAxisSize: MainAxisSize.min, children: [
          label,
          const SizedBox(width: 8),
          SizedBox(
            width: big ? 34 : 22,
            height: big ? 34 : 22,
            child: CircularProgressIndicator(value: left / period, strokeWidth: big ? 4 : 3, color: color, backgroundColor: Palette.line),
          ),
        ]),
    };
    return ExcludeSemantics(child: body);
  }
}

/// The small palette offered for an account's color (ARGB ints, as stored in [Account.color]).
const accountColors = [
  0xFF2F80FF, 0xFF8565DD, 0xFFE2649A, 0xFFD9364F, 0xFFE08A2F, 0xFFD4A51C, 0xFF239E78, 0xFF3AA6B9, 0xFF6B7A99,
];
List<String> get accountColorNames => [
      l10n.codeViewColorBlue, l10n.codeViewColorPurple, l10n.codeViewColorPink, l10n.codeViewColorRed, l10n.codeViewColorOrange,
      l10n.codeViewColorGold, l10n.codeViewColorGreen, l10n.codeViewColorTeal, l10n.codeViewColorGray,
    ];

/// A few emoji offered next to the emoji field.
const emojiSuggestions = ['🔑', '💼', '🎮', '🏦', '📧', '🛒', '🏠', '⭐', '💬', '☁️'];
