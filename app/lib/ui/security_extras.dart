// Phase C screens: activity history, security keys, and the monthly summary notification switch.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/activity.dart';
import '../core/security_key.dart';
import '../core/vault.dart';
import 'home.dart' show accountTitle;
import 'home_cards.dart' show dayText;
import 'premium.dart';
import 'theme.dart';
import '../l10n/l10n.dart';

/// Shown in Settings > About. Every way the app goes online.
String get privacyText => l10n.securityExtrasPrivacy;

// ---------------------------------------------------------------- monthly summary notification

const _notify = MethodChannel('tanooki/notify');

/// iPhone, iPad and Mac can remind on the 1st without the app running (packages/tanooki_cloud).
bool get monthlyNotificationSupported => Platform.isIOS || Platform.isMacOS;

/// Schedules (or cancels) the reminder on the 1st of each month. Null when it worked, else why not.
Future<String?> setMonthlyNotification(bool on) async {
  try {
    await _notify.invokeMethod<void>(on ? 'scheduleMonthly' : 'cancelMonthly', {
      'title': 'Tanooki Auth',
      'body': l10n.securityExtrasMonthlyBody,
    });
    return null;
  } on PlatformException catch (e) {
    return e.code == 'denied'
        ? (Platform.isIOS ? l10n.securityExtrasNotificationsOffIos : l10n.securityExtrasNotificationsOffMac)
        : l10n.securityExtrasReminderFailed(e.message ?? e.code);
  } on MissingPluginException {
    return l10n.securityExtrasRemindersUnavailable;
  }
}

/// Opens the Premium screen when Premium isn't unlocked. True when it is (afterwards).
Future<bool> needPremium(BuildContext context, Vault vault) async {
  if (premium.value) return true;
  await Navigator.push(context, MaterialPageRoute(builder: (_) => PremiumScreen(vault: vault)));
  return premium.value;
}

// ---------------------------------------------------------------- activity history

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key, required this.vault});
  final Vault vault;

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  String _time(DateTime t) {
    final l = t.toLocal();
    final mm = l.minute.toString().padLeft(2, '0');
    if (appLocale().languageCode != 'en') return l10n.securityExtrasDayTime(dayText(l), '${l.hour}:$mm'); // 24-hour clock outside English
    final h = l.hour % 12 == 0 ? 12 : l.hour % 12;
    return l10n.securityExtrasDayTime(dayText(l), '$h:$mm ${l.hour < 12 ? 'AM' : 'PM'}');
  }

  Future<void> _clear() async {
    final sure = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(l10n.securityExtrasClearTitle),
        content: Text(l10n.securityExtrasClearBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: Text(l10n.commonCancel)),
          FilledButton(onPressed: () => Navigator.pop(c, true), child: Text(l10n.commonClear)),
        ],
      ),
    );
    if (sure != true) return;
    await clearActivity(widget.vault);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final events = activityOf(widget.vault);
    final names = {for (final a in widget.vault.visible) a.id: accountTitle(a)};
    // Events for accounts travel mode hides are left out too, so the list never names them.
    final hidden = {for (final a in widget.vault.accounts) if (!names.containsKey(a.id)) a.id};
    final shown = events.where((e) => !hidden.contains(e.accountId)).toList();
    return Scaffold(
      appBar: AppBar(title: Text(l10n.securityExtrasActivityTitle), actions: [
        if (events.isNotEmpty) TextButton(onPressed: _clear, child: Text(l10n.commonClear)),
      ]),
      body: !premium.value
          ? _PremiumPitch(
              vault: widget.vault,
              text: l10n.securityExtrasActivityPitch(maxActivity),
              onUnlocked: () => setState(() {}),
            )
          : shown.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(l10n.securityExtrasNothingYet,
                        textAlign: TextAlign.center, style: TextStyle(color: Palette.muted)),
                  ),
                )
              : ListView.separated(
                  itemCount: shown.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (_, i) {
                    final e = shown[i];
                    final what = e.accountId == null ? l10n.securityExtrasAllAccounts : names[e.accountId] ?? l10n.securityExtrasDeletedAccount;
                    return ListTile(
                      leading: Icon(switch (e.kind) {
                        ActivityKind.copied => Icons.copy,
                        ActivityKind.filled => Icons.input,
                        ActivityKind.typed => Icons.keyboard_outlined,
                        ActivityKind.shownQr => Icons.qr_code_2,
                        ActivityKind.exported => Icons.output,
                      }),
                      title: Text(l10n.securityExtrasActivityLine(e.kind.label, what)),
                      subtitle: Text('${_time(e.time)} · ${e.where}'),
                    );
                  },
                ),
    );
  }
}

class _PremiumPitch extends StatelessWidget {
  const _PremiumPitch({required this.vault, required this.text, required this.onUnlocked});
  final Vault vault;
  final String text;
  final VoidCallback onUnlocked;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(text, textAlign: TextAlign.center, style: const TextStyle(height: 1.4)),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () async {
                if (await needPremium(context, vault)) onUnlocked();
              },
              child: Text(l10n.securityExtrasGetPremium),
            ),
          ]),
        ),
      );
}

// ---------------------------------------------------------------- security keys

class SecurityKeyScreen extends StatefulWidget {
  const SecurityKeyScreen({super.key, required this.vault});
  final Vault vault;

  @override
  State<SecurityKeyScreen> createState() => _SecurityKeyScreenState();
}

class _SecurityKeyScreenState extends State<SecurityKeyScreen> {
  String? _unavailable;
  bool _checked = false, _working = false;

  @override
  void initState() {
    super.initState();
    SecurityKeys.platform.unavailable().then((why) {
      if (mounted) {
        setState(() {
          _unavailable = why;
          _checked = true;
        });
      }
    });
  }

  void _say(String msg) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(msg)));

  Future<void> _add() async {
    if (!await needPremium(context, widget.vault) || !mounted) return setState(() {});
    final name = TextEditingController(text: 'YubiKey');
    final go = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(l10n.securityExtrasAddKey),
        content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(Platform.isIOS
              ? l10n.securityExtrasAddKeyIos
              : l10n.securityExtrasAddKeyOther),
          TextField(controller: name, decoration: InputDecoration(labelText: l10n.securityExtrasKeyName)),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: Text(l10n.commonCancel)),
          FilledButton(onPressed: () => Navigator.pop(c, true), child: Text(l10n.commonContinueLabel)),
        ],
      ),
    );
    if (go != true || !mounted) return;
    setState(() => _working = true);
    try {
      final e = await SecurityKeys.add(widget.vault, name.text);
      _say(l10n.securityExtrasKeyAdded(e.name));
    } on SecurityKeyException catch (e) {
      _say(e.message);
    } finally {
      if (mounted) setState(() => _working = false);
    }
  }

  Future<void> _remove(SecurityKeyEntry e) async {
    await SecurityKeys.remove(widget.vault, e.id);
    if (mounted) setState(() {});
    _say(l10n.securityExtrasKeyRemoved(e.name));
  }

  @override
  Widget build(BuildContext context) {
    final keys = securityKeysOf(widget.vault.settings);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.securityExtrasKeysTitle)),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Text(
          l10n.securityExtrasKeysIntro(_lockWord),
          style: TextStyle(color: Palette.muted, height: 1.4),
        ),
        const SizedBox(height: 16),
        if (_checked && _unavailable != null)
          Card(child: ListTile(leading: const Icon(Icons.info_outline), title: Text(_unavailable!)))
        else
          Card(
            child: Column(children: [
              for (final e in keys) ...[
                ListTile(
                  leading: const Icon(Icons.key),
                  title: Text(e.name),
                  subtitle: Text(l10n.securityExtrasKeyAddedOn(dayText(e.added))),
                  trailing: TextButton(onPressed: () => _remove(e), child: Text(l10n.commonRemove)),
                ),
                const Divider(),
              ],
              ListTile(
                leading: _working ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.add),
                title: Text(premium.value ? l10n.securityExtrasAddKey : l10n.securityExtrasAddKeyPremium),
                onTap: _working || !_checked ? null : _add,
              ),
            ]),
          ),
        if (keys.isNotEmpty && widget.vault.settings['lock'] != true && widget.vault.settings['passcode'] == null) ...[
          const SizedBox(height: 12),
          Text(l10n.securityExtrasLockOffNote,
              style: TextStyle(color: Palette.red, height: 1.4)),
        ],
      ]),
    );
  }

  String get _lockWord => Platform.isWindows ? l10n.securityExtrasLockWordWindows : Platform.isMacOS ? l10n.securityExtrasLockWordMac : l10n.securityExtrasLockWordOther;
}
