import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'signature.dart';
import 'theme.dart';
import '../l10n/l10n.dart';

const appVersion = '0.3.0';
const _supportUrl = 'https://tanookistudios.com/support';

/// The note from Maddie with her signature, the page every one of her apps carries.
/// The closing thank-you is hers verbatim across her apps (see PennyTV's AboutMaddieView).
/// Kept short on purpose, and never "on my own" / "entirely on my own" (Maddie, 2026-10-28).
class AboutMaddieScreen extends StatelessWidget {
  const AboutMaddieScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final body = TextStyle(fontSize: 15, height: 1.55, color: Palette.text);
    Widget p(String text) => Padding(padding: const EdgeInsets.only(bottom: 14), child: Text(text, style: body));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.aboutTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                p(l10n.aboutP1),
                p(l10n.aboutP2),
                p(l10n.aboutP3),
                p(l10n.aboutP4),
                Align(
                  alignment: Alignment.centerRight,
                  child: Signature(width: 200, color: Palette.text),
                ),
                const SizedBox(height: 24),
                // Apple doesn't allow iPhone apps to link out for tips, so iOS shows the address instead.
                if (Platform.isIOS)
                  SelectableText(l10n.aboutSupportAddress, style: TextStyle(color: Palette.muted))
                else
                  FilledButton.icon(
                    onPressed: () => launchUrl(Uri.parse(_supportUrl)),
                    icon: const Icon(Icons.favorite, size: 18),
                    label: Text(l10n.aboutSupport),
                  ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 20), child: Divider()),
                Padding(padding: const EdgeInsets.only(bottom: 10), child: CapsLabel(l10n.aboutCredits)),
                Text(
                  l10n.aboutCreditsBody,
                  style: TextStyle(color: Palette.muted, fontSize: 12, height: 1.5),
                ),
                const SizedBox(height: 20),
                Text('© 2026 Maddie', style: TextStyle(color: Palette.muted, fontSize: 11)),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
