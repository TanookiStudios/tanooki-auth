import 'package:flutter/material.dart';

import '../core/clock_check.dart';
import '../core/emergency.dart';
import '../core/security.dart';
import '../core/sync/relay_client.dart' show RelayException;
import '../core/vault.dart';
import 'backup_ui.dart' show exportBackupFlow;
import 'premium.dart';
import 'security_ui.dart' show CheckupScreen;
import 'theme.dart';

const _months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
String dayText(DateTime t) => '${_months[t.toLocal().month - 1]} ${t.toLocal().day}';

/// The cards above the home list: a wrong clock, an emergency access request, the backup reminder and the
/// monthly summary. Empty when there's nothing to say.
class HomeNotices extends StatefulWidget {
  const HomeNotices({super.key, required this.vault, required this.padding, required this.onChanged});
  final Vault vault;
  final EdgeInsets padding;
  final VoidCallback onChanged;

  @override
  State<HomeNotices> createState() => _HomeNoticesState();
}

class _HomeNoticesState extends State<HomeNotices> {
  final _clock = ClockCheck.instance, _emergency = EmergencyService.instance;

  @override
  void initState() {
    super.initState();
    _clock.warning.addListener(_refresh);
    _emergency.status.addListener(_refresh);
  }

  @override
  void dispose() {
    _clock.warning.removeListener(_refresh);
    _emergency.status.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  void _say(String msg) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(msg)));

  Widget _card({required IconData icon, required String text, Color? color, required List<Widget> actions, Key? key}) => Card(
        key: key,
        margin: const EdgeInsets.only(bottom: 8),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 8, 4),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(icon, color: color ?? Palette.accent),
              const SizedBox(width: 12),
              Expanded(child: Text(text, style: const TextStyle(height: 1.4))),
            ]),
            Wrap(alignment: WrapAlignment.end, children: actions),
          ]),
        ),
      );

  Future<void> _deny() async {
    try {
      await _emergency.deny(widget.vault);
      _say('Denied. They can\'t open your accounts. They can ask again later, and you\'ll be asked again.');
    } on EmergencyException catch (e) {
      _say(e.message);
    } on RelayException catch (e) {
      _say(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final v = widget.vault, now = DateTime.now();
    final cards = <Widget>[];

    final clock = _clock.warning.value;
    if (clock != null) {
      cards.add(_card(key: const Key('clockCard'), icon: Icons.schedule, color: Palette.red, text: clock, actions: [
        TextButton(
          onPressed: () async {
            try {
              final w = await _clock.runNow();
              if (w == null) _say('Your clock is right now. Codes should work.');
            } on RelayException catch (e) {
              _say(e.message);
            }
          },
          child: const Text('Check again'),
        ),
      ]));
    }

    final g = grantOf(v), st = _emergency.status.value;
    if (g != null && st != null && st.state != 'idle' && st.releaseAt != null) {
      final who = (g['contactName'] as String? ?? '').isEmpty ? 'Your emergency contact' : g['contactName'] as String;
      cards.add(_card(
        key: const Key('emergencyCard'),
        icon: Icons.warning_amber_rounded,
        color: Palette.red,
        text: st.state == 'waiting'
            ? '$who asked for emergency access to your accounts. Unless you deny it, they can open a copy in ${waitLeft(st.releaseAt!, now)} (${dayText(st.releaseAt!)}).'
            : '$who asked for emergency access and the 7-day wait is over, so they can open a copy of your accounts now. Deny to stop that.',
        actions: [FilledButton(onPressed: _deny, child: const Text('Deny'))],
      ));
    }

    if (showBackupNudge(v, now)) {
      cards.add(_card(
        key: const Key('backupNudge'),
        icon: Icons.save_alt,
        text: 'Your accounts changed since your last backup. A backup file is how you get them back if this device is lost.',
        actions: [
          TextButton(
            onPressed: () async {
              final saving = snoozeBackupNudge(v, now);
              widget.onChanged(); // gone straight away; the save finishes behind it
              await saving;
            },
            child: const Text('Not now'),
          ),
          FilledButton(
            onPressed: () async {
              await exportBackupFlow(context, v);
              widget.onChanged();
            },
            child: const Text('Back up now'),
          ),
        ],
      ));
    }

    final sum = monthlySummary(v, now, premium: premium.value);
    if (sum != null) {
      String n(int x, String what) => '$x $what${x == 1 ? '' : 's'}';
      cards.add(_card(
        key: const Key('monthlySummary'),
        icon: Icons.insights_outlined,
        text: 'Your ${_months[sum.month.month - 1]} summary: ${n(sum.newAccounts, 'new account')}. '
            '${sum.lastBackup == null ? 'No backup yet' : 'Last backup ${dayText(sum.lastBackup!)}'}. '
            '${sum.noRecoveryCodes == 0 ? 'Every account has recovery codes' : '${n(sum.noRecoveryCodes, 'account')} without recovery codes'}. '
            '${sum.checkupItems == 0 ? 'Security check-up: all good.' : 'Security check-up: ${n(sum.checkupItems, 'thing')} to fix.'}',
        actions: [
          TextButton(
            onPressed: () async {
              final saving = dismissMonthlySummary(v, now);
              widget.onChanged();
              await saving;
            },
            child: const Text('Close'),
          ),
          if (sum.checkupItems > 0)
            FilledButton(
              onPressed: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (_) => CheckupScreen(vault: v)));
                widget.onChanged();
              },
              child: const Text('Open check-up'),
            ),
        ],
      ));
    }

    if (cards.isEmpty) return const SizedBox.shrink();
    return Padding(padding: widget.padding, child: Column(children: cards));
  }
}
