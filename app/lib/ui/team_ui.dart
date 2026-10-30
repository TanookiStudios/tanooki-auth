// Team vault screens (feature 42): Settings > Team vault, and the Team section on the home list.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/account.dart';
import '../core/store.dart';
import '../core/sync/relay_client.dart' show RelayException;
import '../core/sync/relay_crypto.dart' show relayUrl;
import '../core/team.dart';
import '../core/vault.dart';
import 'add.dart' show ScanScreen, hasCamera;
import 'clipboard.dart';
import 'premium.dart';
import 'sync_ui.dart' show QrView, agoText;
import 'theme.dart';
import '../l10n/l10n.dart';

/// One sync pass with the app's license renewal wired in. Returns a sentence when it failed, else null.
Future<String?> runTeamSync(Vault v) async {
  if (!inTeam(v)) return null;
  try {
    await TeamClient(v, refreshLicense: refreshTeamLicense).sync();
    return null;
  } on TeamException catch (e) {
    return e.message;
  } on RelayException catch (e) {
    return e.message;
  }
}

String _title(Account a) => a.issuer.isNotEmpty ? a.issuer : a.label;

/// Settings > Team vault.
class TeamScreen extends StatefulWidget {
  const TeamScreen({super.key, required this.vault, this.relay = relayUrl});
  final Vault vault;
  /// Where a new team is made. Tests point it at a local relay.
  final String relay;

  @override
  State<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  Vault get v => widget.vault;
  bool _working = false;
  String? _problem;
  TeamStatus? _status;
  String? _me;

  @override
  void initState() {
    super.initState();
    if (inTeam(v)) _sync();
  }

  void _say(String msg) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(msg)));

  /// Runs [job] with the progress bar on. Shows its failure as a sentence; returns false when it failed.
  Future<bool> _busy(Future<void> Function() job) async {
    setState(() => _working = true);
    try {
      await job();
      return true;
    } on TeamException catch (e) {
      _say(e.message);
    } on RelayException catch (e) {
      _say(e.message);
    } finally {
      if (mounted) setState(() => _working = false);
    }
    return false;
  }

  Future<void> _sync() async {
    setState(() => _working = true);
    _problem = await runTeamSync(v);
    if (inTeam(v)) {
      try {
        final c = TeamClient(v);
        _status = await c.status();
        _me = await c.myKey();
      } on Exception {
        // the problem line already says why
      }
    }
    if (mounted) setState(() => _working = false);
  }

  Future<String?> _ask(String title, String hint, String button) {
    final field = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(title),
        content: TextField(controller: field, autofocus: true, maxLines: 3, autocorrect: false, decoration: InputDecoration(hintText: hint)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: Text(l10n.commonCancel)),
          FilledButton(onPressed: () => Navigator.pop(c, field.text.trim()), child: Text(button)),
        ],
      ),
    );
  }

  Future<bool> _confirm(String title, String body, String button) async =>
      await showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
          title: Text(title),
          content: Text(body),
          actions: [
            TextButton(onPressed: () => Navigator.pop(c, false), child: Text(l10n.commonCancel)),
            FilledButton(onPressed: () => Navigator.pop(c, true), child: Text(button)),
          ],
        ),
      ) ==
      true;

  Future<void> _create() async {
    final lic = await _ask(l10n.teamUiCreateTitle, l10n.teamUiCreateHint, l10n.teamUiCreateButton);
    if (lic == null || lic.isEmpty) return;
    if (await _busy(() => TeamClient.create(v, lic, relay: widget.relay))) {
      await _sync();
      _say(l10n.teamUiReady);
    }
  }

  Future<void> _join({required bool scan}) async {
    String? link;
    if (scan) {
      link = await Navigator.push<String>(
        context,
        MaterialPageRoute(
          builder: (_) => ScanScreen(
            prefixes: const [teamLinkPrefix],
            title: l10n.teamUiScanTitle,
            wrongCode: l10n.teamUiScanWrong,
          ),
        ),
      );
    } else {
      link = await _ask(l10n.teamUiJoinTitle, l10n.teamUiJoinHint, l10n.teamUiJoinButton);
    }
    if (link == null || link.isEmpty || !mounted) return;
    if (await _busy(() => TeamClient.join(v, link!))) {
      await _sync();
      _say(l10n.teamUiJoinedTeam);
    }
  }

  Future<void> _invite() async {
    String? link;
    if (!await _busy(() async => link = await TeamClient(v).inviteLink()) || !mounted) return;
    await showDialog<void>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(l10n.teamUiInvite),
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(l10n.teamUiInviteHelp),
            const SizedBox(height: 12),
            QrView(link!),
            const SizedBox(height: 12),
            SelectableText(link!, key: const ValueKey('team-invite-link'), style: const TextStyle(fontSize: 12)),
          ]),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              try {
                await SharePlus.instance.share(ShareParams(text: link!));
              } on Exception {
                await Clipboard.setData(ClipboardData(text: link!));
              }
            },
            child: Text(l10n.commonShare),
          ),
          TextButton(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: link!));
              if (c.mounted) Navigator.pop(c);
              _say(l10n.premiumInviteLinkCopied);
            },
            child: Text(l10n.commonCopy),
          ),
          FilledButton(onPressed: () => Navigator.pop(c), child: Text(l10n.commonDone)),
        ],
      ),
    );
    await _sync();
  }

  Future<void> _remove(TeamMember m) async {
    if (!await _confirm(
        l10n.teamUiRemovePersonTitle,
        l10n.teamUiRemovePersonBody,
        l10n.commonRemove)) {
      return;
    }
    if (await _busy(() => TeamClient(v).removeMember(m.key))) {
      await _sync();
      _say(l10n.teamUiRemoved);
    }
  }

  Future<void> _leaveOrDelete() async {
    final admin = isTeamAdmin(v);
    if (!await _confirm(
        admin ? l10n.teamUiDeleteTitle : l10n.teamUiLeaveTitle,
        admin ? l10n.teamUiDeleteBody : l10n.teamUiLeaveBody,
        admin ? l10n.teamUiDeleteButton : l10n.teamUiLeaveButton)) {
      return;
    }
    if (await _busy(() => admin ? TeamClient(v).deleteTeam() : TeamClient(v).leave())) {
      _status = null;
      _say(admin ? l10n.teamUiDeleted : l10n.teamUiLeft);
    }
  }

  Future<void> _addFromMine() async {
    final mine = v.visible;
    if (mine.isEmpty) {
      _say(l10n.teamUiAddFirst);
      return;
    }
    final picked = await showDialog<Account>(
      context: context,
      builder: (c) => SimpleDialog(
        title: Text(l10n.teamUiCopyInTitle),
        children: [
          for (final a in mine)
            ListTile(title: Text(_title(a)), subtitle: a.label.isEmpty ? null : Text(a.label), onTap: () => Navigator.pop(c, a)),
        ],
      ),
    );
    if (picked == null) return;
    putTeamAccount(v, teamCopyOf(picked));
    await v.save();
    await _sync();
    _say(l10n.teamUiCopiedIn(_title(picked)));
  }

  Future<void> _rename(Account a) async {
    final name = await _ask(l10n.teamUiRenameTitle, l10n.teamUiRenameHint, l10n.commonSave);
    if (name == null || name.isEmpty) return;
    a.issuer = name;
    putTeamAccount(v, a);
    await v.save();
    await _sync();
  }

  Future<void> _removeAccount(Account a) async {
    if (!await _confirm(l10n.teamUiRemoveAccountTitle(_title(a)), l10n.teamUiRemoveAccountBody, l10n.commonRemove)) return;
    removeTeamAccount(v, a.id);
    await v.save();
    await _sync();
  }

  Widget _notInTeam() {
    final canBuy = storefront == Storefront.stripe;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text(
        l10n.teamUiIntro,
        style: TextStyle(color: Palette.muted, height: 1.4),
      ),
      const SizedBox(height: 18),
      Text(l10n.teamUiStart, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
      const SizedBox(height: 8),
      if (canBuy && teamCheckoutUrl.isNotEmpty)
        FilledButton.icon(
          onPressed: () => launchUrl(Uri.parse(teamCheckoutUrl)),
          icon: const Icon(Icons.groups_outlined),
          label: Text(l10n.teamUiBuy),
        )
      else if (canBuy)
        Text(l10n.teamUiPlanSoon, key: const ValueKey('team-coming-soon'), style: TextStyle(color: Palette.muted)),
      const SizedBox(height: 6),
      OutlinedButton(
        onPressed: _working ? null : _create,
        child: Text(l10n.teamUiHaveLicense),
      ),
      const SizedBox(height: 22),
      Text(l10n.teamUiJoinTitle, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
      const SizedBox(height: 4),
      Text(l10n.teamUiJoinHelp, style: TextStyle(color: Palette.muted)),
      const SizedBox(height: 8),
      if (hasCamera)
        FilledButton.icon(
          onPressed: _working ? null : () => _join(scan: true),
          icon: const Icon(Icons.qr_code_scanner),
          label: Text(l10n.teamUiScanInvite),
        ),
      const SizedBox(height: 6),
      OutlinedButton(onPressed: _working ? null : () => _join(scan: false), child: Text(l10n.teamUiPasteInvite)),
    ]);
  }

  Widget _inTeam() {
    final s = teamState(v)!;
    final admin = isTeamAdmin(v);
    final accounts = teamAccounts(v);
    final st = _status;
    final lastSync = DateTime.tryParse(s['lastSync'] as String? ?? '')?.toLocal();
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Card(
        child: ListTile(
          leading: const Icon(Icons.groups_outlined),
          title: Text(admin ? l10n.teamUiYouRun : l10n.teamUiYoureIn),
          subtitle: Text([
            if (st != null) l10n.teamUiPeopleCount(st.members.length, teamMaxMembers),
            l10n.teamUiLastSynced(agoText(lastSync)),
            if (admin && st != null) l10n.teamUiPaidUntil(st.licenseEnd),
          ].join(' · ')),
          trailing: IconButton(tooltip: l10n.teamUiSyncNow, icon: const Icon(Icons.sync), onPressed: _working ? null : _sync),
        ),
      ),
      if (_problem != null)
        Padding(padding: const EdgeInsets.only(top: 8), child: Text(_problem!, style: TextStyle(color: Palette.red, height: 1.4))),
      if (s['waitingForKey'] == true)
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(l10n.teamUiWaitingForKey, key: const ValueKey('team-waiting'), style: TextStyle(color: Palette.muted, height: 1.4)),
        ),
      const SizedBox(height: 18),
      Row(children: [
        Expanded(child: Text(l10n.teamUiAccounts, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16))),
        TextButton.icon(onPressed: _working ? null : _addFromMine, icon: const Icon(Icons.add, size: 18), label: Text(l10n.teamUiAddMine)),
      ]),
      if (accounts.isEmpty) Text(l10n.teamUiNoAccounts, style: TextStyle(color: Palette.muted)),
      for (final a in accounts)
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(_title(a)),
          subtitle: a.label.isEmpty ? null : Text(a.label),
          trailing: PopupMenuButton<String>(
            tooltip: l10n.teamUiChange,
            onSelected: (x) => x == 'rename' ? _rename(a) : _removeAccount(a),
            itemBuilder: (_) => [
              PopupMenuItem(value: 'rename', child: Text(l10n.teamUiRename)),
              PopupMenuItem(value: 'remove', child: Text(l10n.teamUiRemoveFromTeam)),
            ],
          ),
        ),
      if (admin) ...[
        const SizedBox(height: 18),
        Row(children: [
          Expanded(child: Text(l10n.teamUiPeople, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16))),
          TextButton.icon(onPressed: _working ? null : _invite, icon: const Icon(Icons.person_add_alt, size: 18), label: Text(l10n.teamUiInvite)),
        ]),
        for (final m in st?.members ?? const <TeamMember>[])
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(m.admin ? Icons.shield_outlined : Icons.person_outline),
            title: Text(m.key == _me ? l10n.teamUiThisDevice : l10n.teamUiDevice(m.key.substring(0, 6))),
            subtitle: Text(m.hasKey ? l10n.teamUiJoined(m.added) : l10n.teamUiJoinedGettingKey(m.added)),
            trailing: m.admin
                ? null
                : IconButton(tooltip: l10n.teamUiRemoveFromTeam, icon: const Icon(Icons.person_remove_outlined), onPressed: _working ? null : () => _remove(m)),
          ),
      ],
      const SizedBox(height: 22),
      OutlinedButton(
        onPressed: _working ? null : _leaveOrDelete,
        style: OutlinedButton.styleFrom(foregroundColor: Palette.red),
        child: Text(admin ? l10n.teamUiDeleteTeam : l10n.teamUiLeaveTeam),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(l10n.teamUiTitle)),
        body: ListView(padding: const EdgeInsets.all(20), children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                if (_working) const Padding(padding: EdgeInsets.only(bottom: 12), child: LinearProgressIndicator()),
                inTeam(v) ? _inTeam() : _notInTeam(),
              ]),
            ),
          ),
        ]),
      );
}

/// Settings key: the Team section on the home list is folded away.
const teamCollapsedKey = 'teamCollapsed';

/// The Team section on the home list: the team's accounts with their codes (tap to copy). Nothing when this
/// device isn't in a team. Syncs the team when shown and every 5 minutes while it stays on screen.
class TeamHomeSection extends StatefulWidget {
  const TeamHomeSection({super.key, required this.vault, this.padding = EdgeInsets.zero});
  final Vault vault;
  final EdgeInsets padding;

  @override
  State<TeamHomeSection> createState() => _TeamHomeSectionState();
}

class _TeamHomeSectionState extends State<TeamHomeSection> {
  Timer? _tick, _sync;

  @override
  void initState() {
    super.initState();
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted && inTeam(widget.vault) && widget.vault.settings[teamCollapsedKey] != true) setState(() {});
    });
    _sync = Timer.periodic(const Duration(minutes: 5), (_) => _run());
    _run();
  }

  Future<void> _run() async {
    if (!inTeam(widget.vault)) return;
    await runTeamSync(widget.vault);
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _tick?.cancel();
    _sync?.cancel();
    super.dispose();
  }

  Future<void> _copy(Account a) async {
    await copyCode(a.codeAt(DateTime.now()));
    if (a.type == OtpType.hotp) {
      a.counter++; // a counter code works once; the next tap gets the next one, for the whole team
      putTeamAccount(widget.vault, a);
      await widget.vault.save();
      unawaited(_run());
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l10n.teamUiCopiedCode(_title(a))), duration: const Duration(seconds: 2)));
  }

  @override
  Widget build(BuildContext context) {
    final v = widget.vault;
    if (!inTeam(v)) return const SizedBox.shrink();
    final accounts = teamAccounts(v);
    final collapsed = v.settings[teamCollapsedKey] == true;
    final now = DateTime.now();
    return Padding(
      padding: widget.padding,
      child: Card(
        margin: EdgeInsets.zero,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          InkWell(
            key: const ValueKey('team-section'),
            onTap: () async {
              v.settings[teamCollapsedKey] = !collapsed;
              setState(() {});
              await v.save();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(children: [
                Icon(Icons.groups_outlined, size: 20, color: Palette.muted),
                const SizedBox(width: 8),
                Text(l10n.teamUiSection(accounts.length), style: const TextStyle(fontWeight: FontWeight.w700)),
                const Spacer(),
                Icon(collapsed ? Icons.expand_more : Icons.expand_less, color: Palette.muted),
              ]),
            ),
          ),
          if (!collapsed)
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 220),
              child: accounts.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
                      child: Text(
                          teamState(v)?['waitingForKey'] == true
                              ? l10n.teamUiWaitingShort
                              : l10n.teamUiNoAccountsHint,
                          style: TextStyle(color: Palette.muted)),
                    )
                  : ListView(shrinkWrap: true, padding: const EdgeInsets.only(bottom: 6), children: [
                      for (final a in accounts)
                        ListTile(
                          dense: true,
                          title: Text(_title(a)),
                          subtitle: a.label.isEmpty ? null : Text(a.label, maxLines: 1, overflow: TextOverflow.ellipsis),
                          trailing: Text(a.codeAt(now),
                              style: const TextStyle(fontFamily: 'monospace', fontSize: 18, fontWeight: FontWeight.w700, letterSpacing: 1.5)),
                          onTap: () => _copy(a),
                        ),
                    ]),
            ),
        ]),
      ),
    );
  }
}
