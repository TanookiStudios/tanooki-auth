import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'signature.dart';
import 'theme.dart';

const appVersion = '0.1.0';
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
      appBar: AppBar(title: const Text('About Maddie')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                p('I\'m Maddie, an autistic developer who cares, maybe a little too much, about getting the small things right.'),
                p('I\'m a big believer in privacy. The keys that protect your accounts are about as personal as data gets, so Tanooki Auth keeps them encrypted on your own device. No account, no ads, no tracking, and nothing is ever sent to me.'),
                p('Tanooki Auth is free, and I want it to stay that way. Your support is what lets me keep making free privacy apps like this one. If Tanooki Auth suits you, the rest might too — they\'re at madilynthomas.com.'),
                p('So, from me to you: thank you. You\'re not just using an app — you\'re making this whole way of living possible.'),
                Align(
                  alignment: Alignment.centerRight,
                  child: Signature(width: 200, color: Palette.text),
                ),
                const SizedBox(height: 24),
                // Apple doesn't allow iPhone apps to link out for tips, so iOS shows the address instead.
                if (Platform.isIOS)
                  SelectableText('Support my work: tanookistudios.com/support', style: TextStyle(color: Palette.muted))
                else
                  FilledButton.icon(
                    onPressed: () => launchUrl(Uri.parse(_supportUrl)),
                    icon: const Icon(Icons.favorite, size: 18),
                    label: const Text('Support my work'),
                  ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 20), child: Divider()),
                const Padding(padding: EdgeInsets.only(bottom: 10), child: CapsLabel('Credits')),
                Text(
                  'QR codes are read with jsQR (Apache 2.0) in the browser extension and ZXing in the app. '
                  'Not affiliated with Google, Twilio or Authy; Google Authenticator is a trademark of Google LLC.',
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
