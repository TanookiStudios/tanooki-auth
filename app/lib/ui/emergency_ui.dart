// Settings > Emergency access: choose a trusted contact (owner side), and ask for copies others left you.
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/emergency.dart';
import '../core/sync/relay_client.dart' show RelayException;
import '../core/vault.dart';
import 'add.dart' show ScanScreen, hasCamera;
import 'backup_ui.dart' show confirmImport, mergeAndReport;
import 'home_cards.dart' show dayText;
import 'phone_link_ui.dart' show pushToken;
import 'premium.dart';
import 'security_extras.dart' show needPremium;
import 'sync_ui.dart' show QrView;
import 'theme.dart';

const emergencyExplainer =
    'Pick one person you trust. If something happens to you, they can ask for your accounts. Your devices get a notification '
    'and you have 7 days to say no. If nobody says no, they get a copy.\n\n'
    'The Tanooki Auth server only enforces the 7-day wait. The copy is locked with a key that only their device has, so the '
    'server can\'t read it, and neither can anyone who breaks into the server.';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key, required this.vault});
  final Vault vault;

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  final _service = EmergencyService.instance;
  final _myName = TextEditingController();
  final _theirs = <String, GrantStatus?>{}; // grant id -> status of a copy someone left me (null: not checked)
  final _theirProblem = <String, String>{};
  String? _myCode, _pushProblem;
  bool _working = false;
  late final Timer _tick;

  Vault get _v => widget.vault;

  @override
  void initState() {
    super.initState();
    _service.status.addListener(_refresh);
    _service.problem.addListener(_refresh);
    _tick = Timer.periodic(const Duration(seconds: 30), (_) => _refresh());
    _service.check(_v);
    _registerPush();
    _checkTheirs();
  }

  @override
  void dispose() {
    _tick.cancel();
    _service.status.removeListener(_refresh);
    _service.problem.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  void _say(String msg) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(msg)));

  /// Runs [work], showing its failure as one plain sentence.
  Future<void> _try(Future<void> Function() work) async {
    setState(() => _working = true);
    try {
      await work();
    } on EmergencyException catch (e) {
      _say(e.message);
    } on RelayException catch (e) {
      _say(e.message);
    } finally {
      if (mounted) setState(() => _working = false);
    }
  }

  Future<void> _registerPush() async {
    if (grantOf(_v) == null) return;
    try {
      final (platform, token) = await pushToken();
      await _service.registerPush(_v, platform, token, kReleaseMode ? 'production' : 'sandbox');
      _pushProblem = null;
    } on String catch (why) {
      _pushProblem = why;
    } on EmergencyException catch (e) {
      // 503 "push not configured" lands here until the relay has push keys.
      _pushProblem = 'Notifications aren\'t working yet (${e.message}). Tanooki Auth checks for requests each time you open it.';
    } on RelayException catch (e) {
      _pushProblem = e.message;
    }
    _refresh();
  }

  Future<void> _checkTheirs() async {
    for (final f in copiesForMe(_v)) {
      try {
        _theirs[f.grantId] = await (await contactRelay(_v, f.grantId)).status();
        _theirProblem.remove(f.grantId);
      } on EmergencyException catch (e) {
        _theirProblem[f.grantId] = e.message;
      } on RelayException catch (e) {
        _theirProblem[f.grantId] = e.message;
      }
      _refresh();
    }
  }

  Future<String?> _askText(String title, String hint, {List<String> scanPrefixes = const [], String? scanWrong}) async {
    if (hasCamera && scanPrefixes.isNotEmpty) {
      final how = await showDialog<String>(
        context: context,
        builder: (c) => SimpleDialog(title: Text(title), children: [
          SimpleDialogOption(onPressed: () => Navigator.pop(c, 'scan'), child: const Text('Scan their QR code')),
          SimpleDialogOption(onPressed: () => Navigator.pop(c, 'paste'), child: const Text('Paste a code they sent')),
        ]),
      );
      if (how == null || !mounted) return null;
      if (how == 'scan') {
        return Navigator.push<String>(
            context, MaterialPageRoute(builder: (_) => ScanScreen(prefixes: scanPrefixes, title: title, wrongCode: scanWrong ?? 'That isn\'t the right code.')));
      }
    }
    final field = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(title),
        content: TextField(controller: field, autofocus: true, maxLines: 3, decoration: InputDecoration(hintText: hint)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(c, field.text.trim()), child: const Text('OK')),
        ],
      ),
    );
  }

  Widget _codeBox(String code, String note) => Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(children: [
            QrView(code, size: 200),
            const SizedBox(height: 10),
            Text(note, textAlign: TextAlign.center, style: TextStyle(color: Palette.muted, height: 1.4)),
            TextButton.icon(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: code));
                _say('Copied. Send it to them however you like: it holds no secrets.');
              },
              icon: const Icon(Icons.copy, size: 18),
              label: const Text('Copy as text'),
            ),
          ]),
        ),
      );

  // ------------------------------------------------------------ owner

  Future<void> _choose() async {
    if (!await needPremium(context, _v) || !mounted) return _refresh();
    final text = await _askText('Their contact code', 'tanookiauth-contact:…',
        scanPrefixes: const [contactPrefix], scanWrong: 'That isn\'t a Tanooki Auth contact code.');
    if (text == null || text.isEmpty || !mounted) return;
    final ContactCode contact;
    try {
      contact = parseContactCode(text);
    } on EmergencyException catch (e) {
      return _say(e.message);
    }
    final name = TextEditingController();
    final go = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text('Make ${contact.name.isEmpty ? 'them' : contact.name} your emergency contact?'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('A copy of all your accounts is locked to their device and left on the Tanooki Auth server. It updates when you change your accounts.'),
          TextField(controller: name, decoration: const InputDecoration(labelText: 'Your name (so they know whose copy it is)')),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(c, true), child: const Text('Continue')),
        ],
      ),
    );
    if (go != true || !mounted) return;
    await _try(() async {
      await _service.setUp(_v, contact, name.text);
      _say('Done. Now give them the code on this screen.');
      await _registerPush();
    });
  }

  Future<void> _removeGrant() async {
    final sure = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Stop emergency access?'),
        content: const Text('The copy is deleted from the server, and they can\'t ask for it any more.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(c, true), child: const Text('Stop')),
        ],
      ),
    );
    if (sure == true) await _try(() => _service.remove(_v));
  }

  List<Widget> _ownerSection() {
    final g = grantOf(_v);
    final st = _service.status.value;
    if (g == null) {
      return [
        Card(
          child: ListTile(
            leading: const Icon(Icons.person_add_alt),
            title: Text(premium.value ? 'Choose an emergency contact' : 'Choose an emergency contact (Premium)'),
            subtitle: const Text('They open Tanooki Auth on their device, go to Settings > Emergency access, and show you their contact code.'),
            onTap: _working ? null : _choose,
          ),
        ),
      ];
    }
    final who = (g['contactName'] as String? ?? '').isEmpty ? 'Your contact' : g['contactName'] as String;
    final now = DateTime.now();
    final state = switch (st?.state) {
      null => 'Checking with the server…',
      'idle' => 'Nobody has asked. Copy last updated ${st!.updatedAt == null ? 'just now' : dayText(st.updatedAt!)}.',
      'waiting' => '$who asked on ${dayText(st!.requestedAt!)}. They can open the copy in ${waitLeft(st.releaseAt!, now)} unless you deny it.',
      _ => '$who asked and the wait is over: they can open the copy now. Deny to stop that.',
    };
    return [
      Card(
        child: Column(children: [
          ListTile(leading: const Icon(Icons.shield_outlined), title: Text('Emergency contact: $who'), subtitle: Text(state)),
          if (_service.problem.value != null)
            ListTile(leading: Icon(Icons.error_outline, color: Palette.red), title: Text(_service.problem.value!)),
          if (_pushProblem != null) ListTile(leading: const Icon(Icons.notifications_off_outlined), subtitle: Text(_pushProblem!)),
          OverflowBar(alignment: MainAxisAlignment.end, children: [
            if (st != null && st.state != 'idle')
              FilledButton(
                onPressed: _working ? null : () => _try(() async {
                  await _service.deny(_v);
                  _say('Denied. They can\'t open your accounts. They can ask again later.');
                }),
                child: const Text('Deny'),
              ),
            TextButton(
              onPressed: _working
                  ? null
                  : () => _try(() async {
                        if (await _service.updateNow(_v)) {
                          await _v.save();
                          _say('Copy updated.');
                        } else {
                          _say(_service.problem.value ?? 'Couldn\'t update the copy.');
                        }
                      }),
              child: const Text('Update copy now'),
            ),
            TextButton(onPressed: _working ? null : _removeGrant, child: const Text('Stop')),
          ]),
        ]),
      ),
      _codeBox(grantCode(g['id'] as String, g['ownerName'] as String? ?? ''),
          'Give $who this code. In Tanooki Auth they go to Settings > Emergency access > "Add a code someone gave you".'),
    ];
  }

  // ------------------------------------------------------------ contact

  Future<void> _showMyCode() async {
    final code = await myContactCode(_v, _myName.text);
    await _v.save(); // keeps the keys the code was made from
    setState(() => _myCode = code);
  }

  Future<void> _addTheirCode() async {
    final text = await _askText('Code they gave you', 'tanookiauth-emergency:…',
        scanPrefixes: const [grantPrefix], scanWrong: 'That isn\'t a Tanooki Auth emergency code.');
    if (text == null || text.isEmpty || !mounted) return;
    await _try(() async {
      final f = await addGrantCode(_v, text);
      _say('Added. You can ask for ${f.ownerName.isEmpty ? 'their' : '${f.ownerName}\'s'} accounts here if you ever need to.');
      await _checkTheirs();
    });
  }

  Future<void> _request(EmergencyFrom f) async {
    final who = f.ownerName.isEmpty ? 'the owner' : f.ownerName;
    final sure = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Ask for emergency access?'),
        content: Text('$who gets a notification and has 7 days to say no. If they don\'t, you can open a copy of their accounts here. Only ask if you really need it.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(c, true), child: const Text('Ask')),
        ],
      ),
    );
    if (sure != true) return;
    await _try(() async {
      _theirs[f.grantId] = await (await contactRelay(_v, f.grantId)).request();
      _say('Asked. The 7-day wait has started.');
    });
  }

  Future<void> _openCopy(EmergencyFrom f) async {
    await _try(() async {
      final accounts = await fetchEmergencyCopy(_v, f.grantId);
      if (!mounted) return;
      final who = f.ownerName.isEmpty ? 'their' : '${f.ownerName}\'s';
      if (await confirmImport(context, 'Add $who ${accounts.length} accounts?', accounts) && mounted) {
        await mergeAndReport(context, _v, accounts, verb: 'Added');
      }
    });
  }

  Widget _copyTile(EmergencyFrom f) {
    final st = _theirs[f.grantId], problem = _theirProblem[f.grantId], now = DateTime.now();
    final who = f.ownerName.isEmpty ? 'Someone' : f.ownerName;
    final String text;
    Widget? action;
    if (problem != null) {
      text = problem;
    } else if (st == null) {
      text = 'Checking…';
    } else if (st.state == 'idle') {
      text = 'You haven\'t asked.';
      action = FilledButton(onPressed: _working ? null : () => _request(f), child: const Text('Request access'));
    } else if (st.state == 'waiting' && st.releaseAt!.isAfter(now)) {
      text = 'You asked. Opens in ${waitLeft(st.releaseAt!, now)} (${dayText(st.releaseAt!)}), unless they say no.';
    } else {
      text = 'The wait is over.';
      action = FilledButton(onPressed: _working ? null : () => _openCopy(f), child: const Text('Open emergency copy'));
    }
    return Column(children: [
      ListTile(leading: const Icon(Icons.person_outline), title: Text('$who\'s accounts'), subtitle: Text(text)),
      OverflowBar(alignment: MainAxisAlignment.end, children: [
        ?action,
        TextButton(
          onPressed: () async {
            await forgetGrant(_v, f.grantId);
            _refresh();
          },
          child: const Text('Remove'),
        ),
      ]),
    ]);
  }

  List<Widget> _contactSection() => [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              const Text('Your contact code', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text('If someone wants you as their emergency contact, show them this. It holds no secrets.', style: TextStyle(color: Palette.muted)),
              TextField(controller: _myName, decoration: const InputDecoration(labelText: 'Your name (so they know it\'s you)')),
              const SizedBox(height: 8),
              Align(alignment: Alignment.centerRight, child: FilledButton(onPressed: _showMyCode, child: const Text('Show my contact code'))),
            ]),
          ),
        ),
        if (_myCode != null) _codeBox(_myCode!, 'Let them scan this in Tanooki Auth, or copy it and send it to them.'),
        Card(
          child: Column(children: [
            for (final f in copiesForMe(_v)) ...[_copyTile(f), const Divider()],
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Add a code someone gave you'),
              subtitle: const Text('After they chose you, their app shows a code for you'),
              onTap: _working ? null : _addTheirCode,
            ),
          ]),
        ),
      ];

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Emergency access')),
        body: ListView(padding: const EdgeInsets.all(16), children: [
          Text(emergencyExplainer, style: TextStyle(color: Palette.muted, height: 1.4)),
          const Padding(padding: EdgeInsets.fromLTRB(4, 20, 4, 8), child: CapsLabel('Your emergency contact')),
          ..._ownerSection(),
          const Padding(padding: EdgeInsets.fromLTRB(4, 20, 4, 8), child: CapsLabel('People who chose you')),
          ..._contactSection(),
        ]),
      );
}
