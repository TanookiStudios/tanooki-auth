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
import '../l10n/l10n.dart';

String _month(int m) => l10n.homeCardsMonth('m$m');
String dayText(DateTime t) => l10n.homeCardsDay(_month(t.toLocal().month), '${t.toLocal().day}');

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
      _say(l10n.homeCardsDenied);
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
              if (w == null) _say(l10n.homeCardsClockRight);
            } on RelayException catch (e) {
              _say(e.message);
            }
          },
          child: Text(l10n.homeCardsCheckAgain),
        ),
      ]));
    }

    final g = grantOf(v), st = _emergency.status.value;
    if (g != null && st != null && st.state != 'idle' && st.releaseAt != null) {
      final who = (g['contactName'] as String? ?? '').isEmpty ? l10n.homeCardsYourContact : g['contactName'] as String;
      cards.add(_card(
        key: const Key('emergencyCard'),
        icon: Icons.warning_amber_rounded,
        color: Palette.red,
        text: st.state == 'waiting'
            ? l10n.homeCardsEmergencyWaiting(who, waitLeft(st.releaseAt!, now), dayText(st.releaseAt!))
            : l10n.homeCardsEmergencyReleased(who),
        actions: [FilledButton(onPressed: _deny, child: Text(l10n.commonDeny))],
      ));
    }

    if (showBackupNudge(v, now)) {
      cards.add(_card(
        key: const Key('backupNudge'),
        icon: Icons.save_alt,
        text: l10n.homeCardsBackupNudge,
        actions: [
          TextButton(
            onPressed: () async {
              final saving = snoozeBackupNudge(v, now);
              widget.onChanged(); // gone straight away; the save finishes behind it
              await saving;
            },
            child: Text(l10n.commonNotNow),
          ),
          FilledButton(
            onPressed: () async {
              await exportBackupFlow(context, v);
              widget.onChanged();
            },
            child: Text(l10n.homeCardsBackUpNow),
          ),
        ],
      ));
    }

    final sum = monthlySummary(v, now, premium: premium.value);
    if (sum != null) {
      cards.add(_card(
        key: const Key('monthlySummary'),
        icon: Icons.insights_outlined,
        text: [
          l10n.homeCardsSummaryNew(sum.newAccounts, _month(sum.month.month)),
          sum.lastBackup == null ? l10n.homeCardsSummaryNoBackup : l10n.homeCardsSummaryLastBackup(dayText(sum.lastBackup!)),
          sum.noRecoveryCodes == 0 ? l10n.homeCardsSummaryAllCodes : l10n.homeCardsSummaryMissingCodes(sum.noRecoveryCodes),
          sum.checkupItems == 0 ? l10n.homeCardsSummaryCheckupGood : l10n.homeCardsSummaryCheckupFix(sum.checkupItems),
        ].join(appLocale().languageCode == 'ja' ? '' : ' '), // whole sentences; Japanese doesn't put spaces between them
        actions: [
          TextButton(
            onPressed: () async {
              final saving = dismissMonthlySummary(v, now);
              widget.onChanged();
              await saving;
            },
            child: Text(l10n.commonClose),
          ),
          if (sum.checkupItems > 0)
            FilledButton(
              onPressed: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (_) => CheckupScreen(vault: v)));
                widget.onChanged();
              },
              child: Text(l10n.homeCardsOpenCheckup),
            ),
        ],
      ));
    }

    if (cards.isEmpty) return const SizedBox.shrink();
    return Padding(padding: widget.padding, child: Column(children: cards));
  }
}
