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
          TextButton(onPressed: () => Navigator.pop(c), child: const Text('Cancel')),
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
            TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
            FilledButton(onPressed: () => Navigator.pop(c, true), child: Text(button)),
          ],
        ),
      ) ==
      true;

  Future<void> _create() async {
    final lic = await _ask('Create your team', 'TT1.…  (from the page after you subscribed)', 'Create team');
    if (lic == null || lic.isEmpty) return;
    if (await _busy(() => TeamClient.create(v, lic, relay: widget.relay))) {
      await _sync();
      _say('Your team is ready. Invite people with "Invite someone".');
    }
  }

  Future<void> _join({required bool scan}) async {
    String? link;
    if (scan) {
      link = await Navigator.push<String>(
        context,
        MaterialPageRoute(
          builder: (_) => const ScanScreen(
            prefixes: [teamLinkPrefix],
            title: 'Scan the team invite',
            wrongCode: 'That isn\'t a team invite. Ask the team admin to open Settings, Team vault, Invite someone.',
          ),
        ),
      );
    } else {
      link = await _ask('Join a team', 'tanookiauth://team?…  (the invite link from the team admin)', 'Join');
    }
    if (link == null || link.isEmpty || !mounted) return;
    if (await _busy(() => TeamClient.join(v, link!))) {
      await _sync();
      _say('You\'re in the team. Team accounts appear once the admin\'s app shares the team key with this device.');
    }
  }

  Future<void> _invite() async {
    String? link;
    if (!await _busy(() async => link = await TeamClient(v).inviteLink()) || !mounted) return;
    await showDialog<void>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Invite someone'),
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text('On their device: Settings, Team vault, then "Scan an invite QR code" or "Paste an invite link". '
                'The invite works once and lasts 7 days.'),
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
            child: const Text('Share'),
          ),
          TextButton(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: link!));
              if (c.mounted) Navigator.pop(c);
              _say('Invite link copied.');
            },
            child: const Text('Copy'),
          ),
          FilledButton(onPressed: () => Navigator.pop(c), child: const Text('Done')),
        ],
      ),
    );
    await _sync();
  }

  Future<void> _remove(TeamMember m) async {
    if (!await _confirm(
        'Remove this person?',
        'They lose access straight away, and the team gets a new key so they can\'t read anything added or changed from now on. '
            'They may have kept copies of the codes they could already see, so change the two-factor setup of any account that matters.',
        'Remove')) {
      return;
    }
    if (await _busy(() => TeamClient(v).removeMember(m.key))) {
      await _sync();
      _say('Removed. The team has a new key.');
    }
  }

  Future<void> _leaveOrDelete() async {
    final admin = isTeamAdmin(v);
    if (!await _confirm(
        admin ? 'Delete the team?' : 'Leave the team?',
        admin
            ? 'Every team account is deleted for everyone in the team. Everyone\'s own accounts are not touched.'
            : 'The team\'s accounts disappear from this device. Your own accounts are not touched.',
        admin ? 'Delete team' : 'Leave')) {
      return;
    }
    if (await _busy(() => admin ? TeamClient(v).deleteTeam() : TeamClient(v).leave())) {
      _status = null;
      _say(admin ? 'Team deleted.' : 'You left the team.');
    }
  }

  Future<void> _addFromMine() async {
    final mine = v.visible;
    if (mine.isEmpty) {
      _say('Add the account to Tanooki Auth first, then copy it into the team here.');
      return;
    }
    final picked = await showDialog<Account>(
      context: context,
      builder: (c) => SimpleDialog(
        title: const Text('Copy one of your accounts into the team'),
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
    _say('${_title(picked)} is now in the team. Your own copy stays where it was.');
  }

  Future<void> _rename(Account a) async {
    final name = await _ask('Rename team account', 'Name, e.g. AWS', 'Save');
    if (name == null || name.isEmpty) return;
    a.issuer = name;
    putTeamAccount(v, a);
    await v.save();
    await _sync();
  }

  Future<void> _removeAccount(Account a) async {
    if (!await _confirm('Remove ${_title(a)} from the team?', 'It disappears for everyone in the team.', 'Remove')) return;
    removeTeamAccount(v, a.id);
    await v.save();
    await _sync();
  }

  Widget _notInTeam() {
    final canBuy = storefront == Storefront.stripe;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text(
        'A team vault shares sign-in codes with up to 10 people, for \$20 a year. Everyone in the team can see, add and change '
        'team accounts. They\'re encrypted on your devices with a key only the team has, so our server can\'t read them. '
        'Team accounts sit in their own Team section and never mix with your own accounts.',
        style: TextStyle(color: Palette.muted, height: 1.4),
      ),
      const SizedBox(height: 18),
      const Text('Start a team', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
      const SizedBox(height: 8),
      if (canBuy && teamCheckoutUrl.isNotEmpty)
        FilledButton.icon(
          onPressed: () => launchUrl(Uri.parse(teamCheckoutUrl)),
          icon: const Icon(Icons.groups_outlined),
          label: const Text('Buy a team plan — \$20 a year'),
        )
      else if (canBuy)
        Text('Team plan coming soon', key: const ValueKey('team-coming-soon'), style: TextStyle(color: Palette.muted)),
      const SizedBox(height: 6),
      OutlinedButton(
        onPressed: _working ? null : _create,
        child: const Text('I have a team license: create the team'),
      ),
      const SizedBox(height: 22),
      const Text('Join a team', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
      const SizedBox(height: 4),
      Text('Ask the team admin for an invite. Joining is free.', style: TextStyle(color: Palette.muted)),
      const SizedBox(height: 8),
      if (hasCamera)
        FilledButton.icon(
          onPressed: _working ? null : () => _join(scan: true),
          icon: const Icon(Icons.qr_code_scanner),
          label: const Text('Scan an invite QR code'),
        ),
      const SizedBox(height: 6),
      OutlinedButton(onPressed: _working ? null : () => _join(scan: false), child: const Text('Paste an invite link')),
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
          title: Text(admin ? 'You run this team' : 'You\'re in a team'),
          subtitle: Text([
            if (st != null) '${st.members.length} of $teamMaxMembers people',
            'Last synced: ${agoText(lastSync)}',
            if (admin && st != null) 'Paid until ${st.licenseEnd.month}/${st.licenseEnd.day}/${st.licenseEnd.year}',
          ].join(' · ')),
          trailing: IconButton(tooltip: 'Sync now', icon: const Icon(Icons.sync), onPressed: _working ? null : _sync),
        ),
      ),
      if (_problem != null)
        Padding(padding: const EdgeInsets.only(top: 8), child: Text(_problem!, style: TextStyle(color: Palette.red, height: 1.4))),
      if (s['waitingForKey'] == true)
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text('Waiting for the team admin\'s app to share the team key with this device. It happens the next time '
              'the admin opens Tanooki Auth.', key: const ValueKey('team-waiting'), style: TextStyle(color: Palette.muted, height: 1.4)),
        ),
      const SizedBox(height: 18),
      Row(children: [
        const Expanded(child: Text('Team accounts', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16))),
        TextButton.icon(onPressed: _working ? null : _addFromMine, icon: const Icon(Icons.add, size: 18), label: const Text('Add one of mine')),
      ]),
      if (accounts.isEmpty) Text('No team accounts yet.', style: TextStyle(color: Palette.muted)),
      for (final a in accounts)
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(_title(a)),
          subtitle: a.label.isEmpty ? null : Text(a.label),
          trailing: PopupMenuButton<String>(
            tooltip: 'Change',
            onSelected: (x) => x == 'rename' ? _rename(a) : _removeAccount(a),
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'rename', child: Text('Rename')),
              PopupMenuItem(value: 'remove', child: Text('Remove from team')),
            ],
          ),
        ),
      if (admin) ...[
        const SizedBox(height: 18),
        Row(children: [
          const Expanded(child: Text('People', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16))),
          TextButton.icon(onPressed: _working ? null : _invite, icon: const Icon(Icons.person_add_alt, size: 18), label: const Text('Invite someone')),
        ]),
        for (final m in st?.members ?? const <TeamMember>[])
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(m.admin ? Icons.shield_outlined : Icons.person_outline),
            title: Text(m.key == _me ? 'This device (admin)' : 'Device ${m.key.substring(0, 6)}'),
            subtitle: Text('Joined ${m.added.month}/${m.added.day}/${m.added.year}${m.hasKey ? '' : ' · getting the team key'}'),
            trailing: m.admin
                ? null
                : IconButton(tooltip: 'Remove from team', icon: const Icon(Icons.person_remove_outlined), onPressed: _working ? null : () => _remove(m)),
          ),
      ],
      const SizedBox(height: 22),
      OutlinedButton(
        onPressed: _working ? null : _leaveOrDelete,
        style: OutlinedButton.styleFrom(foregroundColor: Palette.red),
        child: Text(admin ? 'Delete the team' : 'Leave the team'),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Team vault')),
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
      ..showSnackBar(SnackBar(content: Text('Copied ${_title(a)} code. The clipboard clears in 30 seconds.'), duration: const Duration(seconds: 2)));
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
                Text('Team · ${accounts.length}', style: const TextStyle(fontWeight: FontWeight.w700)),
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
                              ? 'Waiting for the team admin to share the team key with this device.'
                              : 'No team accounts yet. Add them in Settings, Team vault.',
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
