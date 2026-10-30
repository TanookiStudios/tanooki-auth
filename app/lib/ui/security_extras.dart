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

/// Shown in Settings > About. Every way the app goes online.
const privacyText =
    'No account, no tracking. Your setup keys are stored encrypted on this device. The app goes online only for: a clock check '
    '(it asks the Tanooki Auth server for the time, at most once an hour while codes are on screen and when you tap "Codes not '
    'working?"; nothing about you or your accounts is sent), breach alerts if you turn them on (downloads the public breach list), '
    'sync, phone link and emergency access if you set them up (they carry only encrypted data the server can\'t read), and buying Premium.';

// ---------------------------------------------------------------- monthly summary notification

const _notify = MethodChannel('tanooki/notify');

/// iPhone, iPad and Mac can remind on the 1st without the app running (packages/tanooki_cloud).
bool get monthlyNotificationSupported => Platform.isIOS || Platform.isMacOS;

/// Schedules (or cancels) the reminder on the 1st of each month. Null when it worked, else why not.
Future<String?> setMonthlyNotification(bool on) async {
  try {
    await _notify.invokeMethod<void>(on ? 'scheduleMonthly' : 'cancelMonthly', {
      'title': 'Tanooki Auth',
      'body': 'Your monthly security summary is ready. Open Tanooki Auth to see it.',
    });
    return null;
  } on PlatformException catch (e) {
    return e.code == 'denied'
        ? 'Notifications are turned off for Tanooki Auth. Turn them on in ${Platform.isIOS ? 'the iPhone Settings app' : 'System Settings'}, under Notifications, then try again.'
        : 'Couldn\'t set the reminder (${e.message ?? e.code}).';
  } on MissingPluginException {
    return 'Reminders aren\'t available on this device yet.';
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
    final h = l.hour % 12 == 0 ? 12 : l.hour % 12;
    return '${dayText(l)}, $h:${l.minute.toString().padLeft(2, '0')} ${l.hour < 12 ? 'AM' : 'PM'}';
  }

  Future<void> _clear() async {
    final sure = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Clear activity history?'),
        content: const Text('Every entry is removed from this device. Your accounts aren\'t touched.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(c, true), child: const Text('Clear')),
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
      appBar: AppBar(title: const Text('Activity history'), actions: [
        if (events.isNotEmpty) TextButton(onPressed: _clear, child: const Text('Clear')),
      ]),
      body: !premium.value
          ? _PremiumPitch(
              vault: widget.vault,
              text: 'Activity history is part of Premium. It keeps the last $maxActivity times a code was copied, filled into a website, '
                  'typed, shown as a QR code or exported, on this device only.',
              onUnlocked: () => setState(() {}),
            )
          : shown.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text('Nothing yet. Copying, filling, typing, showing a QR code or exporting shows up here.',
                        textAlign: TextAlign.center, style: TextStyle(color: Palette.muted)),
                  ),
                )
              : ListView.separated(
                  itemCount: shown.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (_, i) {
                    final e = shown[i];
                    final what = e.accountId == null ? 'All accounts' : names[e.accountId] ?? 'A deleted account';
                    return ListTile(
                      leading: Icon(switch (e.kind) {
                        ActivityKind.copied => Icons.copy,
                        ActivityKind.filled => Icons.input,
                        ActivityKind.typed => Icons.keyboard_outlined,
                        ActivityKind.shownQr => Icons.qr_code_2,
                        ActivityKind.exported => Icons.output,
                      }),
                      title: Text('${e.kind.label}: $what'),
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
              child: const Text('Get Premium'),
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
        title: const Text('Add a security key'),
        content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(Platform.isIOS
              ? 'Next, hold the key to the top of your iPhone, or plug it in, when asked. You may need to touch it twice.'
              : 'Next, plug the key in and touch it when it blinks. You may need to touch it twice, and type its PIN if it has one.'),
          TextField(controller: name, decoration: const InputDecoration(labelText: 'Name (so you can tell your keys apart)')),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(c, true), child: const Text('Continue')),
        ],
      ),
    );
    if (go != true || !mounted) return;
    setState(() => _working = true);
    try {
      final e = await SecurityKeys.add(widget.vault, name.text);
      _say('Added "${e.name}". You can now unlock Tanooki Auth with it on this device.');
    } on SecurityKeyException catch (e) {
      _say(e.message);
    } finally {
      if (mounted) setState(() => _working = false);
    }
  }

  Future<void> _remove(SecurityKeyEntry e) async {
    await SecurityKeys.remove(widget.vault, e.id);
    if (mounted) setState(() {});
    _say('Removed "${e.name}". It can\'t unlock Tanooki Auth any more.');
  }

  @override
  Widget build(BuildContext context) {
    final keys = securityKeysOf(widget.vault.settings);
    return Scaffold(
      appBar: AppBar(title: const Text('Security keys')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Text(
          'A security key (like a YubiKey) can unlock Tanooki Auth instead of $_lockWord. The key holds a secret that never leaves it, '
          'and the app uses it to lock away the key to your accounts. Lose the key and you can still unlock the usual way.',
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
                  subtitle: Text('Added ${dayText(e.added)}'),
                  trailing: TextButton(onPressed: () => _remove(e), child: const Text('Remove')),
                ),
                const Divider(),
              ],
              ListTile(
                leading: _working ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.add),
                title: Text(premium.value ? 'Add a security key' : 'Add a security key (Premium)'),
                onTap: _working || !_checked ? null : _add,
              ),
            ]),
          ),
        if (keys.isNotEmpty && widget.vault.settings['lock'] != true && widget.vault.settings['passcode'] == null) ...[
          const SizedBox(height: 12),
          Text('The app lock is off, so the app opens without asking. Turn on "Lock the app" or a passcode in Settings to use your key.',
              style: TextStyle(color: Palette.red, height: 1.4)),
        ],
      ]),
    );
  }

  String get _lockWord => Platform.isWindows ? 'Windows Hello or your passcode' : Platform.isMacOS ? 'Touch ID or your passcode' : 'Face ID or your passcode';
}
