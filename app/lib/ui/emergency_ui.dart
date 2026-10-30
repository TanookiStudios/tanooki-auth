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
import '../l10n/l10n.dart';

String get emergencyExplainer => l10n.emergencyUiExplainer;

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
      _pushProblem = l10n.emergencyUiPushNotWorking(e.message);
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
          SimpleDialogOption(onPressed: () => Navigator.pop(c, 'scan'), child: Text(l10n.emergencyUiScanTheirQr)),
          SimpleDialogOption(onPressed: () => Navigator.pop(c, 'paste'), child: Text(l10n.emergencyUiPasteCode)),
        ]),
      );
      if (how == null || !mounted) return null;
      if (how == 'scan') {
        return Navigator.push<String>(
            context, MaterialPageRoute(builder: (_) => ScanScreen(prefixes: scanPrefixes, title: title, wrongCode: scanWrong ?? l10n.emergencyUiWrongCode)));
      }
    }
    final field = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(title),
        content: TextField(controller: field, autofocus: true, maxLines: 3, decoration: InputDecoration(hintText: hint)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: Text(l10n.commonCancel)),
          FilledButton(onPressed: () => Navigator.pop(c, field.text.trim()), child: Text(l10n.commonOk)),
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
                _say(l10n.emergencyUiCopiedCode);
              },
              icon: const Icon(Icons.copy, size: 18),
              label: Text(l10n.emergencyUiCopyAsText),
            ),
          ]),
        ),
      );

  // ------------------------------------------------------------ owner

  Future<void> _choose() async {
    if (!await needPremium(context, _v) || !mounted) return _refresh();
    final text = await _askText(l10n.emergencyUiTheirContactCode, 'tanookiauth-contact:…',
        scanPrefixes: const [contactPrefix], scanWrong: l10n.emergencyUiNotContactCodeShort);
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
        title: Text(contact.name.isEmpty ? l10n.emergencyUiMakeThemContact : l10n.emergencyUiMakeNamedContact(contact.name)),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(l10n.emergencyUiCopyLeftOnServer),
          TextField(controller: name, decoration: InputDecoration(labelText: l10n.emergencyUiYourNameWhose)),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: Text(l10n.commonCancel)),
          FilledButton(onPressed: () => Navigator.pop(c, true), child: Text(l10n.commonContinueLabel)),
        ],
      ),
    );
    if (go != true || !mounted) return;
    await _try(() async {
      await _service.setUp(_v, contact, name.text);
      _say(l10n.emergencyUiDoneGiveCode);
      await _registerPush();
    });
  }

  Future<void> _removeGrant() async {
    final sure = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(l10n.emergencyUiStopTitle),
        content: Text(l10n.emergencyUiStopBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: Text(l10n.commonCancel)),
          FilledButton(onPressed: () => Navigator.pop(c, true), child: Text(l10n.commonStop)),
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
            title: Text(premium.value ? l10n.emergencyUiChooseContact : l10n.emergencyUiChooseContactPremium),
            subtitle: Text(l10n.emergencyUiChooseContactHow),
            onTap: _working ? null : _choose,
          ),
        ),
      ];
    }
    final who = (g['contactName'] as String? ?? '').isEmpty ? l10n.emergencyUiYourContact : g['contactName'] as String;
    final now = DateTime.now();
    final state = switch (st?.state) {
      null => l10n.emergencyUiChecking,
      'idle' => st!.updatedAt == null ? l10n.emergencyUiIdleJustNow : l10n.emergencyUiIdleUpdated(dayText(st.updatedAt!)),
      'waiting' => l10n.emergencyUiWaiting(who, dayText(st!.requestedAt!), waitLeft(st.releaseAt!, now)),
      _ => l10n.emergencyUiReleased(who),
    };
    return [
      Card(
        child: Column(children: [
          ListTile(leading: const Icon(Icons.shield_outlined), title: Text(l10n.emergencyUiContactIs(who)), subtitle: Text(state)),
          if (_service.problem.value != null)
            ListTile(leading: Icon(Icons.error_outline, color: Palette.red), title: Text(_service.problem.value!)),
          if (_pushProblem != null) ListTile(leading: const Icon(Icons.notifications_off_outlined), subtitle: Text(_pushProblem!)),
          OverflowBar(alignment: MainAxisAlignment.end, children: [
            if (st != null && st.state != 'idle')
              FilledButton(
                onPressed: _working ? null : () => _try(() async {
                  await _service.deny(_v);
                  _say(l10n.emergencyUiDenied);
                }),
                child: Text(l10n.commonDeny),
              ),
            TextButton(
              onPressed: _working
                  ? null
                  : () => _try(() async {
                        if (await _service.updateNow(_v)) {
                          await _v.save();
                          _say(l10n.emergencyUiCopyUpdated);
                        } else {
                          _say(_service.problem.value ?? l10n.emergencyUiCouldntUpdate);
                        }
                      }),
              child: Text(l10n.emergencyUiUpdateNow),
            ),
            TextButton(onPressed: _working ? null : _removeGrant, child: Text(l10n.commonStop)),
          ]),
        ]),
      ),
      _codeBox(grantCode(g['id'] as String, g['ownerName'] as String? ?? ''),
          l10n.emergencyUiGiveCode(who)),
    ];
  }

  // ------------------------------------------------------------ contact

  Future<void> _showMyCode() async {
    final code = await myContactCode(_v, _myName.text);
    await _v.save(); // keeps the keys the code was made from
    setState(() => _myCode = code);
  }

  Future<void> _addTheirCode() async {
    final text = await _askText(l10n.emergencyUiCodeTheyGave, 'tanookiauth-emergency:…',
        scanPrefixes: const [grantPrefix], scanWrong: l10n.emergencyUiNotEmergencyCodeShort);
    if (text == null || text.isEmpty || !mounted) return;
    await _try(() async {
      final f = await addGrantCode(_v, text);
      _say(f.ownerName.isEmpty ? l10n.emergencyUiAddedTheir : l10n.emergencyUiAddedNamed(f.ownerName));
      await _checkTheirs();
    });
  }

  Future<void> _request(EmergencyFrom f) async {
    final who = f.ownerName.isEmpty ? l10n.emergencyUiTheOwner : f.ownerName;
    final sure = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(l10n.emergencyUiAskTitle),
        content: Text(l10n.emergencyUiAskBody(who)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: Text(l10n.commonCancel)),
          FilledButton(onPressed: () => Navigator.pop(c, true), child: Text(l10n.emergencyUiAsk)),
        ],
      ),
    );
    if (sure != true) return;
    await _try(() async {
      _theirs[f.grantId] = await (await contactRelay(_v, f.grantId)).request();
      _say(l10n.emergencyUiAsked);
    });
  }

  Future<void> _openCopy(EmergencyFrom f) async {
    await _try(() async {
      final accounts = await fetchEmergencyCopy(_v, f.grantId);
      if (!mounted) return;
      final title = f.ownerName.isEmpty ? l10n.emergencyUiAddTheirAccounts(accounts.length) : l10n.emergencyUiAddNamedAccounts(accounts.length, f.ownerName);
      if (await confirmImport(context, title, accounts) && mounted) {
        await mergeAndReport(context, _v, accounts, verb: 'Added');
      }
    });
  }

  Widget _copyTile(EmergencyFrom f) {
    final st = _theirs[f.grantId], problem = _theirProblem[f.grantId], now = DateTime.now();
    final who = f.ownerName.isEmpty ? l10n.emergencyUiSomeone : f.ownerName;
    final String text;
    Widget? action;
    if (problem != null) {
      text = problem;
    } else if (st == null) {
      text = l10n.emergencyUiCheckingShort;
    } else if (st.state == 'idle') {
      text = l10n.emergencyUiNotAsked;
      action = FilledButton(onPressed: _working ? null : () => _request(f), child: Text(l10n.emergencyUiRequestAccess));
    } else if (st.state == 'waiting' && st.releaseAt!.isAfter(now)) {
      text = l10n.emergencyUiOpensIn(waitLeft(st.releaseAt!, now), dayText(st.releaseAt!));
    } else {
      text = l10n.emergencyUiWaitOver;
      action = FilledButton(onPressed: _working ? null : () => _openCopy(f), child: Text(l10n.emergencyUiOpenCopy));
    }
    return Column(children: [
      ListTile(leading: const Icon(Icons.person_outline), title: Text(l10n.emergencyUiPersonAccounts(who)), subtitle: Text(text)),
      OverflowBar(alignment: MainAxisAlignment.end, children: [
        ?action,
        TextButton(
          onPressed: () async {
            await forgetGrant(_v, f.grantId);
            _refresh();
          },
          child: Text(l10n.commonRemove),
        ),
      ]),
    ]);
  }

  List<Widget> _contactSection() => [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Text(l10n.emergencyUiYourContactCode, style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(l10n.emergencyUiShowThis, style: TextStyle(color: Palette.muted)),
              TextField(controller: _myName, decoration: InputDecoration(labelText: l10n.emergencyUiYourNameItsYou)),
              const SizedBox(height: 8),
              Align(alignment: Alignment.centerRight, child: FilledButton(onPressed: _showMyCode, child: Text(l10n.emergencyUiShowMyCode))),
            ]),
          ),
        ),
        if (_myCode != null) _codeBox(_myCode!, l10n.emergencyUiLetThemScan),
        Card(
          child: Column(children: [
            for (final f in copiesForMe(_v)) ...[_copyTile(f), const Divider()],
            ListTile(
              leading: const Icon(Icons.add),
              title: Text(l10n.emergencyUiAddCodeGiven),
              subtitle: Text(l10n.emergencyUiAddCodeGivenHow),
              onTap: _working ? null : _addTheirCode,
            ),
          ]),
        ),
      ];

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(l10n.emergencyUiTitle)),
        body: ListView(padding: const EdgeInsets.all(16), children: [
          Text(emergencyExplainer, style: TextStyle(color: Palette.muted, height: 1.4)),
          Padding(padding: EdgeInsets.fromLTRB(4, 20, 4, 8), child: CapsLabel(l10n.emergencyUiYourEmergencyContact)),
          ..._ownerSection(),
          Padding(padding: EdgeInsets.fromLTRB(4, 20, 4, 8), child: CapsLabel(l10n.emergencyUiPeopleWhoChoseYou)),
          ..._contactSection(),
        ]),
      );
}
