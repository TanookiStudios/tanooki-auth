import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/account.dart';
import 'theme.dart';

/// Bundled website logos (Simple Icons, CC0; see assets/brand_icons/LICENSE.md), keyed by domain.
/// Built by tool/make_brand_icons.mjs. Never fetched from the network.
class BrandIcon {
  const BrandIcon(this.title, this.color, this.path);
  final String title;
  final Color color;
  final String path; // SVG path data on a 24×24 grid, absolute M/L/H/V/C/Q/Z only
}

Map<String, BrandIcon> brandIcons = {};

Future<void> loadBrandIcons() async {
  if (brandIcons.isNotEmpty) return;
  brandIcons = parseBrandIcons(await rootBundle.loadString('assets/brand_icons/icons.json'));
}

Map<String, BrandIcon> parseBrandIcons(String json) => {
      for (final e in (jsonDecode(json) as Map<String, dynamic>).entries)
        e.key: BrandIcon(e.value['t'] as String, Color(int.parse('FF${e.value['c']}', radix: 16)), e.value['p'] as String),
    };

/// The proper name of the website at [domain] ("github.com" -> "GitHub"), for tidying names.
String? brandTitle(String domain) => brandIcons[domain]?.title;

/// The logo for [a]: its chosen icon website, then its websites (and their parent domains),
/// then a name match on the service. Null means show a letter instead.
BrandIcon? brandIconFor(Account a) {
  for (final d in [?a.iconDomain, ...a.domains]) {
    final parts = d.split('.');
    for (var i = 0; i < parts.length - 1; i++) {
      final hit = brandIcons[parts.sublist(i).join('.')];
      if (hit != null) return hit;
    }
  }
  final name = a.issuer.trim().toLowerCase();
  if (name.isEmpty) return null;
  for (final e in brandIcons.entries) {
    if (e.value.title.toLowerCase() == name || e.key.split('.').first == name) return e.value;
  }
  return null;
}

/// Parses the restricted SVG path data the generator writes.
Path parseSvgPath(String d) {
  final path = Path();
  final tokens = RegExp(r'[MLHVCQZmlhvcqz]|-?(?:\d+\.?\d*|\.\d+)(?:e-?\d+)?').allMatches(d).map((m) => m[0]!).toList();
  var i = 0;
  var cmd = 'M';
  double x = 0, y = 0;
  double n() => double.parse(tokens[i++]);
  while (i < tokens.length) {
    if (RegExp(r'[A-Za-z]').hasMatch(tokens[i])) cmd = tokens[i++];
    switch (cmd) {
      case 'M':
        path.moveTo(x = n(), y = n());
        cmd = 'L'; // extra pairs after M are lines
      case 'L':
        path.lineTo(x = n(), y = n());
      case 'H':
        path.lineTo(x = n(), y);
      case 'V':
        path.lineTo(x, y = n());
      case 'C':
        path.cubicTo(n(), n(), n(), n(), x = n(), y = n());
      case 'Q':
        path.quadraticBezierTo(n(), n(), x = n(), y = n());
      case 'Z' || 'z':
        path.close();
        cmd = 'M';
      default:
        throw FormatException('Unsupported path command $cmd');
    }
  }
  return path;
}

/// Round avatar: the site's logo on its brand color, or the first letter of the name.
class IssuerAvatar extends StatelessWidget {
  const IssuerAvatar(this.account, {super.key, this.size = 36});
  final Account account;
  final double size;

  static const _letterColors = [
    Color(0xFF2F80FF), Color(0xFF8565DD), Color(0xFFE2649A), Color(0xFF239E78),
    Color(0xFFE08A2F), Color(0xFF3AA6B9), Color(0xFFD9364F), Color(0xFF6B7A99),
  ];

  @override
  Widget build(BuildContext context) {
    // The user's own color and emoji (edit window) win over the logo and the letter.
    final custom = account.color == null ? null : Color(account.color!);
    final emoji = account.emoji?.trim() ?? '';
    if (emoji.isNotEmpty) {
      return ExcludeSemantics(
        child: CircleAvatar(
          radius: size / 2,
          backgroundColor: custom ?? Palette.line,
          child: Text(emoji, style: TextStyle(fontSize: size * .5, height: 1.1)),
        ),
      );
    }
    final icon = brandIconFor(account);
    final name = account.issuer.isNotEmpty ? account.issuer : account.label;
    if (icon == null) {
      final letter = name.isEmpty ? '?' : name.characters.first.toUpperCase();
      return ExcludeSemantics(
        child: CircleAvatar(
          radius: size / 2,
          backgroundColor: custom ?? _letterColors[name.hashCode.abs() % _letterColors.length],
          child: Text(letter, style: TextStyle(fontSize: size * .45, fontWeight: FontWeight.w700, color: Colors.white)),
        ),
      );
    }
    // Dark-on-light for very light brand colors so the glyph stays visible.
    final bg = custom ?? icon.color;
    final light = bg.computeLuminance() > .6;
    return ExcludeSemantics(
      child: CircleAvatar(
        radius: size / 2,
        backgroundColor: bg,
        child: CustomPaint(
          size: Size.square(size * .55),
          painter: _GlyphPainter(icon.path, light ? Colors.black87 : Colors.white),
        ),
      ),
    );
  }
}

class _GlyphPainter extends CustomPainter {
  _GlyphPainter(this.data, this.color);
  final String data;
  final Color color;
  static final _cache = <String, Path>{};

  @override
  void paint(Canvas canvas, Size size) {
    final path = _cache.putIfAbsent(data, () => parseSvgPath(data));
    canvas.scale(size.width / 24);
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_GlyphPainter old) => old.data != data || old.color != color;
}
