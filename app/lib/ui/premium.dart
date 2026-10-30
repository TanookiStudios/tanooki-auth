import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/license.dart';
import '../core/vault.dart';
import 'theme.dart';

/// Stripe Payment Link for the $5 Premium purchase (Mac, Windows, Android sideload). After paying, Stripe
/// redirects to the key page (worker/), which shows the buyer's license key.
const checkoutUrl = 'https://buy.stripe.com/fZubJ3dsP5kv5xZ2kr1VK03';

final premium = ValueNotifier<bool>(false);
final themeChoice = ValueNotifier<String>('auto');

/// Reads Premium and the chosen theme from the vault. A Premium theme without Premium falls back to Auto.
Future<void> loadPremiumAndTheme(Vault vault) async {
  final key = vault.settings['license'];
  premium.value = key is String && await verifyLicense(key);
  final t = vault.settings['theme'] as String? ?? 'auto';
  themeChoice.value = themeChoices.containsKey(t) && (freeThemes.contains(t) || premium.value) ? t : 'auto';
}

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key, required this.vault});
  final Vault vault;

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  void _say(String msg) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(msg)));

  Future<void> _buy() async {
    if (checkoutUrl.isEmpty) {
      _say('Checkout isn\'t open yet; it\'s coming very soon. Thank you for wanting to support Tanooki Auth!');
      return;
    }
    await launchUrl(Uri.parse(checkoutUrl));
  }

  Future<void> _enterKey() async {
    final field = TextEditingController();
    final key = await showDialog<String>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Enter license key'),
        content: TextField(
          controller: field,
          autofocus: true,
          maxLines: 3,
          autocorrect: false,
          decoration: const InputDecoration(hintText: 'TA1.…  (from your purchase email)'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(c, field.text.trim()), child: const Text('Unlock')),
        ],
      ),
    );
    if (key == null || key.isEmpty) return;
    if (!await verifyLicense(key)) {
      _say('That license key isn\'t valid. Copy the whole key from your purchase email and try again.');
      return;
    }
    widget.vault.settings['license'] = key;
    await widget.vault.save();
    premium.value = true;
    if (mounted) setState(() {});
    _say('Premium unlocked. Thank you so much!');
  }

  @override
  Widget build(BuildContext context) {
    final owned = premium.value;
    Widget perk(IconData icon, String title, String body) => Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(icon, color: Palette.accent),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                const SizedBox(height: 2),
                Text(body, style: TextStyle(color: Palette.muted, height: 1.4)),
              ]),
            ),
          ]),
        );

    return Scaffold(
      appBar: AppBar(title: const Text('Premium')),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(owned ? 'You have Premium' : 'Tanooki Auth Premium',
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text(owned ? 'Thank you for supporting Tanooki Auth.' : '\$5, once. Yours forever.',
                  style: TextStyle(color: Palette.muted, fontSize: 16)),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 4),
                  child: Column(children: [
                    perk(Icons.palette_outlined, 'Every Premium theme',
                        'Pastel Pink, Pastel Blue, Lavender, Mint and Midnight, plus every theme added later.'),
                    perk(Icons.sync, 'Sync across your devices',
                        'Add an account on one device and see it on all of them, end-to-end encrypted. Through iCloud on Apple devices, or the Tanooki relay for any mix.'),
                    perk(Icons.phonelink_lock_outlined, 'Approve codes from your phone',
                        'Use the browser extension on any computer: it asks your phone, you tap Approve, and the code fills in.'),
                    perk(Icons.auto_awesome_outlined, 'Every future Premium feature',
                        'Pay once and get whatever Premium grows into. No subscription, ever.'),
                    perk(Icons.favorite_outline, 'Keeps privacy apps free',
                        'Your \$5 is what lets me keep making free apps that don\'t track you.'),
                  ]),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Free forever, with or without Premium: unlimited accounts, scanning, backups, the browser extension, and the app lock.',
                style: TextStyle(color: Palette.muted, height: 1.4),
              ),
              const SizedBox(height: 22),
              if (!owned) ...[
                // deferred(v1-release): iPhone needs Apple in-app purchase; until it's set up, no buy button there.
                if (Platform.isIOS)
                  Text('Buying on iPhone is coming soon.', style: TextStyle(color: Palette.muted))
                else
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _buy,
                      style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                      child: const Text('Get Premium for \$5', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                const SizedBox(height: 8),
                Center(
                  child: TextButton(onPressed: _enterKey, child: const Text('Already bought it? Enter your license key')),
                ),
              ],
            ]),
          ),
        ),
      ]),
    );
  }
}
