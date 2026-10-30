import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/feedback.dart';
import '../core/guides.dart';
import '../core/vault.dart';
import 'about_maddie.dart' show appVersion;
import 'add.dart';
import 'import_ui.dart';
import 'theme.dart';

/// vault.settings keys: the tour was shown, and the last version whose What's new was seen.
const tourShownKey = 'tourShown';
const whatsNewSeenKey = 'whatsNewSeen';

/// Opens [url] in the browser, or says so (with the address) when there's no browser to open it.
Future<void> openLink(BuildContext context, String url) async {
  var ok = false;
  try {
    ok = await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  } catch (_) {}
  if (!ok && context.mounted) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('Couldn\'t open your web browser. The page is $url')));
  }
}

/// "How to turn on 2FA for X" when the website has a guide for this account.
Widget guideLink(BuildContext context, Guide g) => Align(
      alignment: Alignment.centerLeft,
      child: TextButton.icon(
        key: const Key('guideLink'),
        onPressed: () => openLink(context, guideUrl(g)),
        icon: const Icon(Icons.open_in_new, size: 18),
        label: Text('How to turn on 2FA for ${g.name}'),
      ),
    );

// ---------------------------------------------------------------- first run and What's new

/// After unlocking the real vault: the tour on a fresh install, or What's new once after an update.
/// Never both, and the decoy vault never gets here (see Gate._enter).
Future<void> showTourOrWhatsNew(BuildContext context, Vault v) async {
  final seen = v.settings[whatsNewSeenKey];
  final tour = v.settings[tourShownKey] != true && v.accounts.isEmpty;
  // A fresh install has nothing new to tell; it just remembers this version.
  final whatsNew = !tour && seen != appVersion && !(seen == null && v.accounts.isEmpty);
  if (seen == appVersion && !tour) return;
  v.settings[whatsNewSeenKey] = appVersion;
  if (tour) v.settings[tourShownKey] = true;
  await v.save();
  if (!context.mounted) return;
  final nav = Navigator.of(context);
  if (tour) await nav.push(MaterialPageRoute<void>(builder: (_) => TourScreen(vault: v)));
  if (whatsNew) await nav.push(MaterialPageRoute<void>(builder: (_) => const WhatsNewScreen()));
}

/// Keeps a screen's content readable on the wide layout.
Widget _narrow(Widget child) => Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 560), child: child));

class TourScreen extends StatefulWidget {
  const TourScreen({super.key, required this.vault});
  final Vault vault;

  @override
  State<TourScreen> createState() => _TourScreenState();
}

class _TourScreenState extends State<TourScreen> {
  static const _steps = 3;
  var _step = 0;

  void _go(Widget screen) => Navigator.of(context).pushReplacement(MaterialPageRoute<void>(builder: (_) => screen));

  Widget _page(IconData icon, String title, String body, List<Widget> extra) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ExcludeSemantics(child: Icon(icon, size: 56, color: Palette.accent)),
          const SizedBox(height: 16),
          Semantics(header: true, child: Text(title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineSmall)),
          const SizedBox(height: 12),
          Text(body, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, height: 1.5)),
          const SizedBox(height: 20),
          ...extra,
        ],
      );

  @override
  Widget build(BuildContext context) {
    final pages = [
      _page(
        Icons.shield_outlined,
        'Welcome to Tanooki Auth',
        'Lots of websites can ask for a 6-digit code as well as your password. That\'s two-factor authentication, '
            'or 2FA. Tanooki Auth makes those codes for you, right here on your device, so someone with only your '
            'password still can\'t get in.',
        const [],
      ),
      _page(
        Icons.add_circle_outline,
        'Add your first account',
        'Turn on 2FA in a website\'s security settings. It shows a QR code: scan it here, or copy its setup link and '
            'paste it. Already using another authenticator app? Bring your accounts across in one go.',
        [
          FilledButton.icon(
            key: const Key('tourAdd'),
            onPressed: () => _go(AddScreen(vault: widget.vault)),
            icon: const Icon(Icons.qr_code_scanner),
            label: const Text('Scan a QR code or paste a link'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => _go(ImportFromAppScreen(vault: widget.vault)),
            icon: const Icon(Icons.move_down),
            label: const Text('Import from another app'),
          ),
        ],
      ),
      _page(
        Icons.star_outline,
        'Popular sites to protect first',
        'Your email, your social media and anywhere with your money matter most. Our step-by-step guides show where '
            'the 2FA setting is on each site.',
        [
          Card(
            child: Column(children: [
              for (final g in starterGuides)
                ListTile(
                  title: Text(g.name),
                  subtitle: Text('How to turn on 2FA for ${g.name}'),
                  trailing: const Icon(Icons.open_in_new, size: 18),
                  onTap: () => openLink(context, guideUrl(g)),
                ),
            ]),
          ),
          TextButton(onPressed: () => openLink(context, guidesIndexUrl), child: const Text('All 2FA guides')),
        ],
      ),
    ];
    final last = _step == _steps - 1;
    return Scaffold(
      appBar: AppBar(
        title: Semantics(liveRegion: true, child: Text('Step ${_step + 1} of $_steps')),
        automaticallyImplyLeading: false,
        actions: [
          if (!last) TextButton(key: const Key('tourSkip'), onPressed: () => Navigator.pop(context), child: const Text('Skip tour')),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(padding: const EdgeInsets.all(24), child: _narrow(pages[_step])),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _narrow(Row(children: [
            if (_step > 0) TextButton(onPressed: () => setState(() => _step--), child: const Text('Back')),
            const Spacer(),
            FilledButton(
              key: const Key('tourNext'),
              onPressed: () => last ? Navigator.pop(context) : setState(() => _step++),
              child: Text(last ? 'Done' : 'Next'),
            ),
          ])),
        ),
      ),
    );
  }
}

/// The in-app changelog, newest first. The first entry's version must match [appVersion] (a test checks).
const changelog = <({String version, List<String> items})>[
  (
    version: '0.3.0',
    items: [
      'Step-by-step guides for turning on 2FA at 40 popular sites. When you add or edit an account we have a guide for, there\'s a link to it.',
      'A short welcome tour the first time you open the app. See it again in Settings > Help.',
      'Send feedback from Settings > Help. It never includes your accounts or codes.',
      'This What\'s new page.',
      'Import from Apple Passwords, and move your accounts to Aegis, 2FAS or Google Authenticator.',
      'Steam Guard codes, counter-based codes with a "Next code" button, and advanced code settings with a live preview.',
      'Folders, select many accounts at once, sort A to Z or by recently used, and "Tidy account names".',
      'Show an account\'s QR code (after Face ID or your passcode) to move it to another device.',
      'Unlock with a security key such as a YubiKey (Premium), on newer iPhones, Macs and Windows PCs.',
      '"Ask first" accounts that need Face ID or your passcode before showing the code, and travel mode to hide chosen accounts (Premium).',
      'Activity history (Premium), "Codes not working?" clock check, Test a backup, lock on sleep, and backup reminders.',
      'Emergency access: let someone you trust ask for your accounts, with days for you to say no.',
      'Spotlight search, a copied-code Live Activity and a watch face complication (Premium), Copy on open, and Mac "Clear after one paste".',
      'Countdown styles, a color or emoji for each account, Read aloud, an easy-to-read font, and better screen reader support.',
      'A wide layout for big windows, and seasonal Premium icons.',
      'Buy Premium inside the app on iPhone and Android, gift it, and invite friends.',
      'Team vault for sharing codes with up to 10 people. The team plan itself is coming soon.',
      'The Family plan is coming soon.',
      'The desktop app now runs on Linux too. Linux downloads are coming soon.',
    ],
  ),
  (
    version: '0.2.0',
    items: [
      'Sync between your devices, phone link for the browser extension, and secure sharing of one account.',
      'Passcode, auto-lock, panic wipe, decoy passcode, screenshot blocking, check-up and breach alerts.',
      'Widgets, Apple Watch and Wear OS apps, the Mac menu bar and Windows tray, and automatic encrypted backups (Premium).',
      'Importers for Aegis, 2FAS, Authy, Bitwarden and 1Password, plus favorites, tags, notes, recovery codes and Trash.',
    ],
  ),
  (
    version: '0.1.0',
    items: ['The first version: scan or paste accounts, see codes, encrypted backups, and the browser extension.'],
  ),
];

class WhatsNewScreen extends StatelessWidget {
  const WhatsNewScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('What\'s new')),
        body: ListView(padding: const EdgeInsets.all(16), children: [
          for (final v in changelog)
            _narrow(Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Semantics(
                    header: true,
                    child: Text('Version ${v.version}${v.version == appVersion ? ' (this version)' : ''}',
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                  const SizedBox(height: 8),
                  for (final item in v.items)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const ExcludeSemantics(child: Text('•  ')),
                        Expanded(child: Text(item, style: const TextStyle(height: 1.4))),
                      ]),
                    ),
                ]),
              ),
            )),
        ]),
      );
}

// ---------------------------------------------------------------- feedback

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _message = TextEditingController(), _contact = TextEditingController();
  var _includeDevice = true, _sending = false;
  String? _status;
  var _ok = false;

  @override
  void dispose() {
    _message.dispose();
    _contact.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (_message.text.trim().isEmpty) {
      setState(() {
        _status = 'Type a message first.';
        _ok = false;
      });
      return;
    }
    setState(() {
      _sending = true;
      _status = null;
    });
    final r = await sendFeedback(feedbackBody(
      message: _message.text,
      contact: _contact.text,
      includeDevice: _includeDevice,
      appVersion: appVersion,
    ));
    if (!mounted) return;
    setState(() {
      _sending = false;
      _ok = r == FeedbackResult.sent;
      _status = switch (r) {
        FeedbackResult.sent => 'Sent. Thank you! Maddie reads every message.',
        FeedbackResult.tooLong => 'That\'s too long to send. Please make it shorter (about 4,000 letters at most).',
        FeedbackResult.tooMany => 'You\'ve sent a lot of feedback in the last hour. Please try again in an hour.',
        FeedbackResult.offline => 'Couldn\'t reach the internet. Check your connection and try again. Your message is still here.',
        FeedbackResult.serverError => 'The feedback server had a problem and didn\'t take your message. Please try again later. Your message is still here.',
      };
      if (_ok) _message.clear();
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Send feedback')),
        body: ListView(padding: const EdgeInsets.all(16), children: [
          _narrow(Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            const Text('Found a bug, or wish the app did something? Tell Maddie here.'),
            const SizedBox(height: 12),
            TextField(
              key: const Key('feedbackMessage'),
              controller: _message,
              minLines: 4,
              maxLines: 10,
              maxLength: feedbackMaxChars,
              decoration: const InputDecoration(labelText: 'Your message', alignLabelWithHint: true),
            ),
            TextField(
              key: const Key('feedbackContact'),
              controller: _contact,
              maxLength: 200,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Your email (optional)',
                helperText: 'Only if you\'d like a reply.',
              ),
            ),
            CheckboxListTile(
              key: const Key('feedbackDevice'),
              contentPadding: EdgeInsets.zero,
              value: _includeDevice,
              onChanged: (v) => setState(() => _includeDevice = v ?? true),
              title: const Text('Include app version and device type'),
              subtitle: const Text('For example "0.3.0" and "iOS". It helps track down bugs.'),
            ),
            Text(
              'Never sent: your accounts, their names, codes, setup keys, tags, notes, or anything else in the app.',
              style: TextStyle(color: Palette.muted, fontSize: 13),
            ),
            const SizedBox(height: 16),
            FilledButton(
              key: const Key('feedbackSend'),
              onPressed: _sending ? null : _send,
              child: _sending
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Send'),
            ),
            if (_status != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Semantics(
                  liveRegion: true,
                  child: Text(_status!, key: const Key('feedbackStatus'), style: TextStyle(color: _ok ? Palette.green : Palette.red)),
                ),
              ),
          ])),
        ]),
      );
}
