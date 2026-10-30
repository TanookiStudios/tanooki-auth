// Automatic encrypted backups (Premium) to a folder the user picks, e.g. their iCloud Drive, Google Drive or
// Dropbox folder. Same file format as Export backup, so Import backup restores one.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'backup.dart';
import 'security.dart' show lastBackupKey;
import 'vault.dart';

/// vault.settings key: {folder: ref, folderName, passphrase, lastAt}. Lives only inside the encrypted vault.
/// A folder ref is a path (Windows), a base64 security-scoped bookmark (macOS, iOS) or a SAF tree URI (Android).
const autoBackupKey = 'autoBackup';
const autoBackupsKept = 10;

final _ourFile = RegExp(r'^Tanooki Auth backup \d{4}-\d{2}-\d{2}\.' '$backupExtension\$');

/// True only for files this feature writes. Retention never deletes anything else in the folder.
bool isAutoBackupName(String name) => _ourFile.hasMatch(name);

String autoBackupName(DateTime day) => 'Tanooki Auth backup ${day.toIso8601String().substring(0, 10)}.$backupExtension';

Map<String, dynamic>? autoBackupSettings(Vault v) => (v.settings[autoBackupKey] as Map?)?.cast<String, dynamic>();

DateTime? lastAutoBackup(Vault v) => DateTime.tryParse(autoBackupSettings(v)?['lastAt'] as String? ?? '')?.toLocal();

enum AutoBackupFailure { folderGone, permissionLost, diskFull, other }

class AutoBackupException implements Exception {
  AutoBackupException(this.failure, [this.detail]);
  final AutoBackupFailure failure;
  final String? detail;

  /// One message per failure mode, saying what to do about it.
  String get message => switch (failure) {
        AutoBackupFailure.folderGone =>
          'The backup folder is gone. It may have been deleted, renamed outside the app, or its drive is unplugged. Choose the folder again.',
        AutoBackupFailure.permissionLost =>
          'Tanooki Auth is no longer allowed to write to the backup folder. Choose the folder again to give permission back.',
        AutoBackupFailure.diskFull => 'The backup folder\'s drive is full. Free up some space, then tap Back up now.',
        AutoBackupFailure.other => 'The backup couldn\'t be saved${detail == null ? '' : ' ($detail)'}. Tap Back up now to try again.',
      };

  @override
  String toString() => 'AutoBackupException($failure): $message';
}

/// Turns an OS file error into one of our failure modes.
AutoBackupException classifyIoError(FileSystemException e) {
  final code = e.osError?.errorCode;
  final failure = switch (Platform.isWindows ? -(code ?? 0) : code) {
    2 || -2 || -3 => AutoBackupFailure.folderGone, // ENOENT; Windows file / path not found
    1 || 13 || -5 => AutoBackupFailure.permissionLost, // EPERM, EACCES; Windows access denied
    28 || 69 || -39 || -112 => AutoBackupFailure.diskFull, // ENOSPC, EDQUOT (macOS); Windows disk full
    _ => AutoBackupFailure.other,
  };
  return AutoBackupException(failure, e.osError?.message ?? e.message);
}

/// The few file operations a backup needs, on whatever kind of folder the platform gives us.
abstract class BackupFolder {
  Future<List<String>> list();
  Future<void> write(String name, List<int> bytes);
  Future<void> delete(String name);
}

/// A folder dart:io can reach: Windows paths, macOS/iOS folders while their bookmark is open, tests.
class IoBackupFolder implements BackupFolder {
  IoBackupFolder(this.dir);
  final Directory dir;

  Future<T> _io<T>(Future<T> Function() body) async {
    if (!await dir.exists()) throw AutoBackupException(AutoBackupFailure.folderGone);
    try {
      return await body();
    } on FileSystemException catch (e) {
      throw classifyIoError(e);
    }
  }

  @override
  Future<List<String>> list() => _io(() async => [
        await for (final e in dir.list(followLinks: false))
          if (e is File) e.uri.pathSegments.last,
      ]);

  /// Temp file then rename, so a half-written file never replaces a good one.
  @override
  Future<void> write(String name, List<int> bytes) => _io(() async {
        final tmp = File('${dir.path}${Platform.pathSeparator}.$name.tmp');
        try {
          await tmp.writeAsBytes(bytes, flush: true);
          await tmp.rename('${dir.path}${Platform.pathSeparator}$name');
        } catch (_) {
          if (await tmp.exists()) await tmp.delete();
          rethrow;
        }
      });

  @override
  Future<void> delete(String name) => _io(() => File('${dir.path}${Platform.pathSeparator}$name').delete());
}

/// Android Storage Access Framework folder, through MainActivity's `tanooki/folder` channel.
class SafBackupFolder implements BackupFolder {
  SafBackupFolder(this.ref);
  final String ref;

  @override
  Future<List<String>> list() async => (await folderCall<List>('list', {'ref': ref}) ?? []).cast<String>();
  @override
  Future<void> write(String name, List<int> bytes) => folderCall('write', {'ref': ref, 'name': name, 'bytes': Uint8List.fromList(bytes)});
  @override
  Future<void> delete(String name) => folderCall('delete', {'ref': ref, 'name': name});
}

const _channel = MethodChannel('tanooki/folder');

/// Calls the native folder channel; its error codes are our failure names.
Future<T?> folderCall<T>(String method, [Map<String, Object?>? args]) async {
  try {
    return await _channel.invokeMethod<T>(method, args);
  } on PlatformException catch (e) {
    final failure = AutoBackupFailure.values.where((f) => f.name == e.code).firstOrNull ?? AutoBackupFailure.other;
    throw AutoBackupException(failure, e.message);
  } on MissingPluginException {
    throw AutoBackupException(AutoBackupFailure.other, 'not supported on this device');
  }
}

/// Opens a stored folder ref for the length of [body]. [onNewRef] gets a refreshed bookmark when the old one went stale.
abstract class FolderOpener {
  Future<void> use(String ref, Future<void> Function(BackupFolder folder) body, {void Function(String newRef)? onNewRef});
}

class PlatformFolderOpener implements FolderOpener {
  const PlatformFolderOpener();

  @override
  Future<void> use(String ref, Future<void> Function(BackupFolder folder) body, {void Function(String newRef)? onNewRef}) async {
    if (Platform.isAndroid) return body(SafBackupFolder(ref));
    if (!Platform.isMacOS && !Platform.isIOS) return body(IoBackupFolder(Directory(ref)));
    // macOS / iOS: resolve the security-scoped bookmark; access lasts until close.
    final opened = (await folderCall<Map>('open', {'ref': ref}))!.cast<String, dynamic>();
    final path = opened['path'] as String;
    if (opened['ref'] is String && opened['ref'] != ref) onNewRef?.call(opened['ref'] as String);
    try {
      await body(IoBackupFolder(Directory(path)));
    } finally {
      await folderCall('close', {'path': path});
    }
  }
}

/// Runs automatic backups: once a day when the app opens or the vault changes (debounced), and on demand.
/// A failed backup only sets [failure] in memory; it never writes to the vault.
class AutoBackupRunner {
  AutoBackupRunner({
    this.opener = const PlatformFolderOpener(),
    this.debounce = const Duration(seconds: 10),
    this.retryAfterFailure = const Duration(hours: 1),
    this.iterations,
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  final FolderOpener opener;
  final Duration debounce;
  final Duration retryAfterFailure;
  /// PBKDF2 rounds; null means the backup format's normal count. Tests lower it.
  final int? iterations;
  final DateTime Function() _clock;
  bool Function() isPremium = () => false;

  /// The latest failure, or null when the last attempt worked. Shown in Settings and the security check-up.
  final failure = ValueNotifier<AutoBackupException?>(null);
  /// How many backup files were written. Tests and the integration test read it.
  int written = 0;

  Timer? _soon;
  Future<bool>? _running;
  DateTime? _failedAt;
  bool _ownSave = false;

  bool enabled(Vault v) => isPremium() && autoBackupSettings(v)?['folder'] is String;

  /// Due when no backup was made today (local time) and we're not cooling down after a failure.
  bool due(Vault v) {
    final now = _clock();
    final last = lastAutoBackup(v);
    final doneToday = last != null && last.year == now.year && last.month == now.month && last.day == now.day;
    final coolingDown = _failedAt != null && now.difference(_failedAt!) < retryAfterFailure;
    return enabled(v) && !doneToday && !coolingDown;
  }

  Future<void> appOpened(Vault v) async {
    if (due(v)) await _run(v);
  }

  /// Hooked to every save of the real vault. Our own bookkeeping saves don't count.
  void vaultChanged(Vault v) {
    if (_ownSave || !enabled(v)) return;
    _soon?.cancel();
    _soon = Timer(debounce, () {
      if (due(v)) _run(v);
    });
  }

  /// "Back up now": runs even if today's backup is done (it replaces today's file). True on success.
  Future<bool> runNow(Vault v) {
    _soon?.cancel();
    return _run(v);
  }

  void cancel() => _soon?.cancel();

  Future<bool> _run(Vault v) async {
    while (_running != null) {
      await _running;
    }
    final run = _backup(v);
    _running = run;
    try {
      return await run;
    } finally {
      _running = null;
    }
  }

  Future<bool> _backup(Vault v) async {
    final s = autoBackupSettings(v);
    if (s == null || s['folder'] is! String || s['passphrase'] is! String) return false;
    final now = _clock();
    String? newRef;
    try {
      // Encrypt first: the folder is only opened once there is something complete to write.
      final text = iterations == null
          ? await exportBackup(v.live, s['passphrase'] as String)
          : await exportBackup(v.live, s['passphrase'] as String, iterations: iterations!);
      await opener.use(s['folder'] as String, (folder) async {
        final name = autoBackupName(now);
        await folder.write(name, utf8.encode(text));
        written++;
        final ours = (await folder.list()).where(isAutoBackupName).toList()..sort();
        for (final old in ours.reversed.skip(autoBackupsKept)) {
          await folder.delete(old);
        }
      }, onNewRef: (r) => newRef = r);
    } on AutoBackupException catch (e) {
      return _failed(e);
    } on FileSystemException catch (e) {
      return _failed(classifyIoError(e));
    } catch (e) {
      return _failed(AutoBackupException(AutoBackupFailure.other, '$e'));
    }
    // Success: record it where the panic-wipe rule and the check-up look, plus our own last-backup time.
    failure.value = null;
    _failedAt = null;
    final stamp = now.toUtc().toIso8601String();
    v.settings[lastBackupKey] = stamp;
    // Re-read: the user may have turned this off or changed folder while the backup ran.
    final cur = autoBackupSettings(v);
    if (cur != null && cur['folder'] == s['folder']) {
      v.settings[autoBackupKey] = {...cur, 'lastAt': stamp, 'folder': newRef ?? cur['folder']};
    }
    _ownSave = true;
    try {
      await v.save();
    } finally {
      _ownSave = false;
    }
    return true;
  }

  bool _failed(AutoBackupException e) {
    _failedAt = _clock();
    failure.value = e;
    return false;
  }
}

/// The app's one runner. main.dart sets [AutoBackupRunner.isPremium] and hooks it to vault saves.
final autoBackup = AutoBackupRunner();
