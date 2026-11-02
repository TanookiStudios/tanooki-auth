import 'dart:io';

import 'package:flutter/material.dart';

import '../core/clock_check.dart';
import '../core/health.dart';
import '../core/sync/relay_client.dart' show RelayException;
import '../core/vault.dart';
import 'backup_ui.dart' show exportBackupFlow;
import 'phone_link_ui.dart' show BrowserLinkScreen;
import 'recovery_codes.dart';
import 'sync_ui.dart' show SyncScreen, agoText;
import 'theme.dart';
import '../l10n/l10n.dart';

/// Settings > Health check: sync, backup, clock, phone link, lock and recovery codes on one screen, each green
/// (fine) or yellow (worth a look) with one button that fixes it.
class HealthScreen extends StatefulWidget {
  const HealthScreen({super.key, required this.vault});
  final Vault vault;

  @override
  State<HealthScreen> createState() => _HealthScreenState();
}

class _HealthScreenState extends State<HealthScreen> {
  bool _checkingClock = false;

  Future<void> _open(Widget screen) async {
    await Navigator.push(context, MaterialPageRoute<void>(builder: (_) => screen));
    if (mounted) setState(() {});
  }

  Future<void> _checkClock() async {
    if (_checkingClock) return;
    setState(() => _checkingClock = true);
    try {
      await ClockCheck.instance.runNow();
    } on RelayException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.settingsClockFailed(e.message))));
    }
    if (mounted) setState(() => _checkingClock = false);
  }

  (IconData, String, String, String, VoidCallback?) _row(HealthItem h) {
    final v = widget.vault;
    final clock = ClockCheck.instance;
    return switch (h.kind) {
      HealthKind.sync => (
          Icons.sync,
          l10n.healthSync,
          !h.set
              ? l10n.healthSyncOff
              : h.ok
                  ? l10n.healthSyncOk(agoText(h.when?.toLocal()))
                  : l10n.healthSyncStale(agoText(h.when?.toLocal())),
          h.set ? l10n.healthOpenSync : l10n.healthSetUp,
          () => _open(SyncScreen(vault: v)),
        ),
      HealthKind.backup => (
          Icons.save_alt,
          l10n.healthBackup,
          !h.set ? l10n.healthBackupNever : (h.ok ? l10n.healthBackupOk(h.when!.toLocal()) : l10n.healthBackupOld(h.when!.toLocal())),
          l10n.securityUiMakeBackupNow,
          () async {
            await exportBackupFlow(context, v);
            if (mounted) setState(() {});
          },
        ),
      HealthKind.clock => (
          Icons.schedule,
          l10n.healthClock,
          !h.set ? l10n.healthClockNotChecked : (clock.warning.value ?? l10n.healthClockOk(agoText(h.when))),
          _checkingClock ? l10n.settingsCheckingClock : l10n.healthCheckNow,
          _checkClock,
        ),
      HealthKind.phoneLink => (
          Icons.phonelink_lock_outlined,
          l10n.healthPhoneLink,
          h.ok ? l10n.healthPhoneLinkOk(h.count) : l10n.healthPhoneLinkOff,
          h.ok ? l10n.healthOpen : l10n.healthSetUp,
          () => _open(BrowserLinkScreen(vault: v)),
        ),
      HealthKind.lock => (
          Icons.lock_outline,
          l10n.healthLock,
          h.ok ? l10n.healthLockOn : l10n.healthLockOff,
          // The lock switch is at the top of Settings > Security, the screen this one was opened from.
          l10n.healthGoToSettings,
          () => Navigator.maybePop(context),
        ),
      HealthKind.recoveryCodes => (
          Icons.key_outlined,
          l10n.healthRecovery,
          h.total == 0 ? l10n.healthRecoveryNoAccounts : l10n.healthRecoveryCount(h.count, h.total),
          l10n.healthAddCodes,
          h.ok
              ? null
              : () {
                  final missing = v.visible.firstWhere((a) => !a.recoveryCodes.any((r) => !r.used));
                  _open(RecoveryCodesScreen(vault: v, account: missing));
                },
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final items = healthCheck(widget.vault, DateTime.now().toUtc(),
        phone: Platform.isIOS || Platform.isAndroid, clockWarning: ClockCheck.instance.warning.value, clockCheckedAt: ClockCheck.instance.checkedAt);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.healthTitle)),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Text(l10n.healthIntro, style: TextStyle(color: Palette.muted, height: 1.4)),
        const SizedBox(height: 12),
        for (final h in items)
          Builder(builder: (context) {
            final (icon, title, detail, action, onAction) = _row(h);
            // Yellow, dark enough to stand out on a light theme too.
            final yellow = Palette.current.brightness == Brightness.dark ? const Color(0xFFFFC107) : const Color(0xFFB26A00);
            final color = h.ok ? Palette.green : yellow;
            return Card(
              key: ValueKey('health-${h.kind.name}'),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 8, 8),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Icon(icon, color: color),
                    const SizedBox(width: 10),
                    Expanded(child: Text(title, style: Theme.of(context).textTheme.titleMedium)),
                    Icon(h.ok ? Icons.check_circle : Icons.error_outline, color: color,
                        semanticLabel: h.ok ? l10n.healthGood : l10n.healthLook),
                  ]),
                  const SizedBox(height: 6),
                  Text(detail),
                  if (onAction != null)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(onPressed: onAction, child: Text(action)),
                    ),
                ]),
              ),
            );
          }),
      ]),
    );
  }
}
