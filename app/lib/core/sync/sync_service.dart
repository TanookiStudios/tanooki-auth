// Turning sync on and off, and keeping it running while the app is open.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../vault.dart';
import 'relay_client.dart';
import 'relay_crypto.dart';
import 'sync_engine.dart';

bool syncOn(Vault v) => v.settings[Vault.syncKey] is Map;
String? syncTransport(Vault v) => syncOn(v) ? syncState(v)['transport'] as String? : null;

String get thisDeviceName => Platform.isIOS
    ? 'iPhone or iPad'
    : Platform.isAndroid
        ? 'Android'
        : Platform.isMacOS
            ? 'Mac'
            : Platform.isWindows
                ? 'Windows PC'
                : 'Computer';

// ---------------------------------------------------------------- iCloud folder (Swift side: tanooki/icloud)

/// iCloud Drive's Tanooki Auth container (iCloud.com.tanookistudios.auth), through a small Swift channel
/// in the iOS and macOS apps. [available] is false when the user isn't signed in to iCloud, iCloud Drive
/// is off, or this build can't use the container.
class ICloudFolder implements SyncFolder {
  static const _ch = MethodChannel('tanooki/icloud');

  /// Null when iCloud Drive can be used, otherwise why not, in plain words.
  static Future<String?> problem() async {
    if (!Platform.isIOS && !Platform.isMacOS) return 'iCloud only works on iPhone, iPad and Mac.';
    String? status;
    try {
      status = await _ch.invokeMethod<String>('available');
    } on MissingPluginException {
      status = 'notEnabled';
    } on PlatformException {
      status = 'notEnabled';
    }
    return switch (status) {
      'ok' => null,
      'signedOut' => 'iCloud Drive is off on this device. Sign in to iCloud and turn on iCloud Drive in Settings to use it.',
      // iPhone builds always have iCloud. On Mac only the Developer ID download does (scripts/release-mac.sh);
      // debug and test builds are ad-hoc signed, and macOS won't open an ad-hoc app that claims iCloud.
      _ => 'iCloud sync isn\'t switched on in this version of Tanooki Auth yet. Use the Tanooki relay for now; it works on every device.',
    };
  }

  @override
  Future<List<String>> list(String dir) async => (await _ch.invokeListMethod<String>('list', {'path': dir})) ?? [];
  @override
  Future<String?> read(String path) => _ch.invokeMethod<String>('read', {'path': path});
  @override
  Future<void> write(String path, String text) => _ch.invokeMethod('write', {'path': path, 'text': text});
  @override
  Future<void> delete(String path) => _ch.invokeMethod('delete', {'path': path});
}

// ---------------------------------------------------------------- turning it on and off

/// Wrong passphrase, bad invite and the like: a sentence to show as is.
class SyncSetupException implements Exception {
  SyncSetupException(this.message);
  final String message;
  @override
  String toString() => message;
}

class SyncSetup {
  /// First device on the relay: new salt, new group.
  static Future<void> startRelay(Vault v, String passphrase, {String relay = relayUrl}) async {
    final salt = randomBytes(16);
    final root = await deriveSyncRoot(passphrase, salt);
    final device = await DeviceKey.create();
    final keys = await SyncKeys.fromRoot(root);
    final cursor = await SyncRelay(relay, keys.groupId, device).create().catchError((Object e) {
      if (e is RelayException && e.status == 409) {
        throw SyncSetupException('A sync group with this passphrase already exists. On a device that\'s already syncing, tap "Add a device" and scan its code instead.');
      }
      throw e;
    });
    v.settings[Vault.syncKey] = _fresh('relay', root, salt, device, extra: {'relay': relay, 'cursor': cursor});
    await v.save();
  }

  /// The QR / link a new device joins with (PROTOCOL.md 1.4). Works once, for 24 hours.
  static Future<String> inviteLink(Vault v) async {
    final s = syncState(v);
    final relay = await RelaySync(v).relay();
    final invite = await relay.invite();
    return 'tanookiauth://sync?v=1&relay=${Uri.encodeComponent(s['relay'] as String)}&group=${relay.groupId}'
        '&salt=${s['salt']}&invite=${b64u(utf8.encode(jsonEncode(invite)))}';
  }

  static bool isInviteLink(String text) => text.trim().startsWith('tanookiauth://sync?');

  /// A new device joins with an invite and the passphrase typed on this device.
  static Future<void> joinRelay(Vault v, String link, String passphrase) async {
    final q = Uri.tryParse(link.trim())?.queryParameters ?? const {};
    final relay = q['relay'] ?? '';
    final Map<String, dynamic> invite;
    try {
      if (q['v'] != '1' || !relay.startsWith('https://')) throw const FormatException();
      invite = jsonDecode(utf8.decode(unb64u(q['invite']!))) as Map<String, dynamic>;
    } catch (_) {
      throw SyncSetupException('That isn\'t a Tanooki Auth sync code. On a device that\'s already syncing, open Settings, Sync, Add a device.');
    }
    final root = await deriveSyncRoot(passphrase, unb64u(q['salt'] ?? ''));
    final keys = await SyncKeys.fromRoot(root);
    if (keys.groupId != q['group']) {
      throw SyncSetupException('That passphrase doesn\'t match the one your other devices use. Check it and try again.');
    }
    final device = await DeviceKey.create();
    await SyncRelay(relay, keys.groupId, device).join(invite);
    v.settings[Vault.syncKey] = _fresh('relay', root, unb64u(q['salt']!), device, extra: {'relay': relay, 'cursor': 0});
    await v.save();
  }

  /// iCloud: the first Apple device makes the salt; later ones read it and must type the same passphrase.
  /// [fresh] starts over with a new salt (when the old passphrase is forgotten).
  static Future<void> startICloud(Vault v, String passphrase, SyncFolder folder, {bool fresh = false}) async {
    final existing = fresh ? null : await folder.read(FolderSync.saltFile);
    final salt = existing == null ? randomBytes(16) : unb64u((jsonDecode(existing) as Map)['salt'] as String);
    final root = await deriveSyncRoot(passphrase, salt);
    final keys = await SyncKeys.fromRoot(root);
    if (existing != null && (await folder.list(keys.groupId)).isEmpty) {
      throw SyncSetupException('Your other Apple devices sync with a different passphrase. Type that one, or start fresh with this one.');
    }
    if (existing == null) await folder.write(FolderSync.saltFile, jsonEncode({'v': 1, 'salt': b64u(salt)}));
    v.settings[Vault.syncKey] = _fresh('icloud', root, salt, null, extra: {'device': b64u(randomBytes(12)), 'name': thisDeviceName});
    await v.save();
  }

  static Map<String, dynamic> _fresh(String transport, List<int> root, List<int> salt, DeviceKey? device,
          {Map<String, dynamic> extra = const {}}) =>
      {
        'transport': transport,
        'root': b64u(root),
        'salt': b64u(salt),
        if (device != null) 'device': b64u(device.seed),
        if (device != null) 'devicePub': device.publicKey,
        ...extra,
      };

  /// Stops syncing on this device. Accounts stay. On the relay, this device leaves the group (removing the
  /// last device deletes the group); on iCloud, its file is removed.
  static Future<void> turnOff(Vault v, {SyncFolder? folder}) async {
    if (!syncOn(v)) return;
    final s = syncState(v);
    try {
      if (s['transport'] == 'relay') {
        final relay = await RelaySync(v).relay();
        await relay.removeDevice(relay.device.publicKey);
      } else if (folder != null) {
        await FolderSync(v, folder).removeDevice(s['device'] as String);
      }
    } catch (_) {
      // Offline or already removed: turning off here still works. The others just see a quiet device.
    }
    v.settings
      ..remove(Vault.syncKey)
      ..remove(Vault.tombstonesKey);
    await v.save();
  }
}

// ---------------------------------------------------------------- running

class SyncStatus {
  const SyncStatus({this.busy = false, this.error, this.lastSync, this.skipped = 0});
  final bool busy;
  final String? error;
  final DateTime? lastSync;
  final int skipped;
}

/// Syncs while the app is unlocked: right away, a couple of seconds after each local change, when the relay
/// says another device changed something, and every few minutes as a fallback.
class SyncService {
  SyncService._();
  static final instance = SyncService._();

  final status = ValueNotifier(const SyncStatus());
  /// Bumped after a sync changed accounts, so open screens redraw.
  final changed = ValueNotifier(0);
  /// Tests pass a folder; the app uses iCloud.
  SyncFolder folder = ICloudFolder();

  Vault? _vault;
  Timer? _timer;
  Timer? _soon;
  WebSocket? _ws;
  Future<void>? _running;
  bool _again = false;

  void attach(Vault v) {
    detach();
    _vault = v;
    final saved = syncOn(v) ? syncState(v)['lastSync'] as String? : null;
    status.value = SyncStatus(lastSync: saved == null ? null : DateTime.parse(saved).toLocal());
    if (!syncOn(v)) return;
    v.afterLocalEdit = () {
      _soon?.cancel();
      _soon = Timer(const Duration(seconds: 2), syncNow);
    };
    _timer = Timer.periodic(Duration(minutes: syncTransport(v) == 'relay' ? 5 : 1), (_) => syncNow());
    syncNow();
    if (syncTransport(v) == 'relay') _listen();
  }

  void detach() {
    _vault?.afterLocalEdit = null;
    _vault = null;
    _timer?.cancel();
    _soon?.cancel();
    _ws?.close();
    _ws = null;
  }

  Future<void> _listen() async {
    final v = _vault;
    if (v == null || !syncOn(v)) return;
    try {
      final ws = await (await RelaySync(v).relay()).listen((cursor) {
        if (cursor > (syncState(v)['cursor'] as int? ?? 0)) syncNow();
      });
      if (_vault != v) {
        ws.close();
        return;
      }
      _ws = ws;
      ws.done.then((_) {
        if (_ws == ws && _vault == v) Timer(const Duration(seconds: 30), _listen); // reconnect
      });
    } catch (_) {
      // No socket: the periodic sync still runs.
    }
  }

  /// Runs one sync now (or right after the one already running).
  Future<void> syncNow() {
    if (_running != null) {
      _again = true;
      return _running!;
    }
    return _running = _run().whenComplete(() {
      _running = null;
      if (_again) {
        _again = false;
        syncNow();
      }
    });
  }

  Future<void> _run() async {
    final v = _vault;
    if (v == null || !syncOn(v)) return;
    status.value = SyncStatus(busy: true, lastSync: status.value.lastSync);
    final before = jsonEncode([for (final a in v.accounts) a.toJson()]);
    try {
      final SyncReport report;
      if (syncTransport(v) == 'relay') {
        report = await RelaySync(v).sync();
      } else {
        final problem = folder is ICloudFolder ? await ICloudFolder.problem() : null;
        if (problem != null) throw SyncSetupException(problem);
        report = await FolderSync(v, folder).sync();
      }
      status.value = SyncStatus(lastSync: DateTime.now(), skipped: report.skipped);
    } catch (e) {
      status.value = SyncStatus(error: describeSyncError(e), lastSync: status.value.lastSync);
    }
    if (jsonEncode([for (final a in v.accounts) a.toJson()]) != before) changed.value++;
  }
}

/// One plain sentence per way sync can fail.
String describeSyncError(Object e) {
  if (e is SyncSetupException) return e.message;
  if (e is RelayException) {
    if (e.status == 403) return 'This device was removed from sync on another device. Turn sync off, then on again to rejoin.';
    if (e.status == 404) return 'Sync was turned off from another device. Turn it off here too, then on again to start over.';
    if (e.status == 429) return 'Syncing too often. It will try again in a few minutes.';
    if (e.status == 507) return 'You\'ve reached the sync limit (2,000 accounts, including deleted ones).';
    return e.message;
  }
  if (e is PlatformException) return 'iCloud Drive had a problem: ${e.message ?? e.code}.';
  return 'Sync stopped because of an unexpected problem: $e';
}
