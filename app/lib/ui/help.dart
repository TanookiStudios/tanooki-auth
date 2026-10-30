import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/feedback.dart';
import '../core/guides.dart';
import '../core/vault.dart';
import 'about_maddie.dart' show appVersion;
import 'add.dart';
import 'import_ui.dart';
import 'theme.dart';
import '../l10n/l10n.dart';

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
      ..showSnackBar(SnackBar(content: Text(l10n.helpNoBrowser(url))));
  }
}

/// "How to turn on 2FA for X" when the website has a guide for this account.
Widget guideLink(BuildContext context, Guide g) => Align(
      alignment: Alignment.centerLeft,
      child: TextButton.icon(
        key: const Key('guideLink'),
        onPressed: () => openLink(context, guideUrl(g)),
        icon: const Icon(Icons.open_in_new, size: 18),
        label: Text(l10n.helpGuideFor(g.name)),
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
        l10n.helpTourWelcome,
        l10n.helpTourWelcomeBody,
        const [],
      ),
      _page(
        Icons.add_circle_outline,
        l10n.helpTourAdd,
        l10n.helpTourAddBody,
        [
          FilledButton.icon(
            key: const Key('tourAdd'),
            onPressed: () => _go(AddScreen(vault: widget.vault)),
            icon: const Icon(Icons.qr_code_scanner),
            label: Text(l10n.helpTourScanOrPaste),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => _go(ImportFromAppScreen(vault: widget.vault)),
            icon: const Icon(Icons.move_down),
            label: Text(l10n.helpTourImport),
          ),
        ],
      ),
      _page(
        Icons.star_outline,
        l10n.helpTourPopular,
        l10n.helpTourPopularBody,
        [
          Card(
            child: Column(children: [
              for (final g in starterGuides)
                ListTile(
                  title: Text(g.name),
                  subtitle: Text(l10n.helpGuideFor(g.name)),
                  trailing: const Icon(Icons.open_in_new, size: 18),
                  onTap: () => openLink(context, guideUrl(g)),
                ),
            ]),
          ),
          TextButton(onPressed: () => openLink(context, guidesIndexUrl), child: Text(l10n.helpAllGuides)),
        ],
      ),
    ];
    final last = _step == _steps - 1;
    return Scaffold(
      appBar: AppBar(
        title: Semantics(liveRegion: true, child: Text(l10n.helpTourStep(_step + 1, _steps))),
        automaticallyImplyLeading: false,
        actions: [
          if (!last) TextButton(key: const Key('tourSkip'), onPressed: () => Navigator.pop(context), child: Text(l10n.helpTourSkip)),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(padding: const EdgeInsets.all(24), child: _narrow(pages[_step])),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _narrow(Row(children: [
            if (_step > 0) TextButton(onPressed: () => setState(() => _step--), child: Text(l10n.commonBack)),
            const Spacer(),
            FilledButton(
              key: const Key('tourNext'),
              onPressed: () => last ? Navigator.pop(context) : setState(() => _step++),
              child: Text(last ? l10n.commonDone : l10n.commonNext),
            ),
          ])),
        ),
      ),
    );
  }
}

/// The in-app changelog, newest first. The first entry's version must match [appVersion] (a test checks).
List<({String version, List<String> items})> get changelog => [
      (version: '0.3.0', items: [l10n.helpNew030a, l10n.helpNew030b, l10n.helpNew030c, l10n.helpNew030d, l10n.helpNew030e, l10n.helpNew030f, l10n.helpNew030g, l10n.helpNew030h, l10n.helpNew030i, l10n.helpNew030j, l10n.helpNew030k, l10n.helpNew030l, l10n.helpNew030m, l10n.helpNew030n, l10n.helpNew030o, l10n.helpNew030p, l10n.helpNew030q, l10n.helpNew030r, l10n.helpNew030s]),
      (version: '0.2.0', items: [l10n.helpNew020a, l10n.helpNew020b, l10n.helpNew020c, l10n.helpNew020d]),
      (version: '0.1.0', items: [l10n.helpNew010a]),
    ];

class WhatsNewScreen extends StatelessWidget {
  const WhatsNewScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(l10n.helpWhatsNew)),
        body: ListView(padding: const EdgeInsets.all(16), children: [
          for (final v in changelog)
            _narrow(Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Semantics(
                    header: true,
                    child: Text(v.version == appVersion ? l10n.helpVersionThis(v.version) : l10n.helpVersion(v.version),
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
        _status = l10n.helpFeedbackEmpty;
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
        FeedbackResult.sent => l10n.helpFeedbackSent,
        FeedbackResult.tooLong => l10n.helpFeedbackTooLong,
        FeedbackResult.tooMany => l10n.helpFeedbackTooMany,
        FeedbackResult.offline => l10n.helpFeedbackOffline,
        FeedbackResult.serverError => l10n.helpFeedbackServerError,
      };
      if (_ok) _message.clear();
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(l10n.helpFeedbackTitle)),
        body: ListView(padding: const EdgeInsets.all(16), children: [
          _narrow(Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(l10n.helpFeedbackIntro),
            const SizedBox(height: 12),
            TextField(
              key: const Key('feedbackMessage'),
              controller: _message,
              minLines: 4,
              maxLines: 10,
              maxLength: feedbackMaxChars,
              decoration: InputDecoration(labelText: l10n.helpFeedbackMessage, alignLabelWithHint: true),
            ),
            TextField(
              key: const Key('feedbackContact'),
              controller: _contact,
              maxLength: 200,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: l10n.helpFeedbackEmail,
                helperText: l10n.helpFeedbackEmailHelp,
              ),
            ),
            CheckboxListTile(
              key: const Key('feedbackDevice'),
              contentPadding: EdgeInsets.zero,
              value: _includeDevice,
              onChanged: (v) => setState(() => _includeDevice = v ?? true),
              title: Text(l10n.helpFeedbackDevice),
              subtitle: Text(l10n.helpFeedbackDeviceHelp),
            ),
            Text(
              l10n.helpFeedbackNeverSent,
              style: TextStyle(color: Palette.muted, fontSize: 13),
            ),
            const SizedBox(height: 16),
            FilledButton(
              key: const Key('feedbackSend'),
              onPressed: _sending ? null : _send,
              child: _sending
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : Text(l10n.helpFeedbackSend),
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
