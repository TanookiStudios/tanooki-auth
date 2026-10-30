import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

import '../core/account.dart';
import '../core/vault.dart';

/// Settings keys: "Clear after one paste" (Mac) and "Copy on open" (all). Both off by default.
const pasteOnceKey = 'pasteOnce', copyOnOpenKey = 'copyOnOpen';

/// Mac "Clear after one paste", from the open vault's settings (set on unlock and when toggled).
bool pasteOnce = false;

const _window = MethodChannel('tanooki/window');

Timer? _clearTimer;

/// Copies a code and clears the clipboard 30 s later if it still holds that code. With [pasteOnce] on a
/// Mac, the code is handed over only when something pastes it, and the clipboard empties right after.
Future<void> copyCode(String code) async {
  _clearTimer?.cancel();
  if (pasteOnce && Platform.isMacOS) {
    try {
      await _window.invokeMethod<void>('copyOnce', code);
      // Not pasted within 30 s: clear it anyway (the native side checks it's still ours, without reading it).
      _clearTimer = Timer(const Duration(seconds: 30), () => _window.invokeMethod<void>('clearOnce'));
      return;
    } on MissingPluginException {
      // Older build without the native half: fall back to the normal copy.
    }
  }
  await Clipboard.setData(ClipboardData(text: code));
  if (Platform.isIOS || Platform.isAndroid) await HapticFeedback.lightImpact(); // a small tap so you feel it worked
  _clearTimer = Timer(const Duration(seconds: 30), () async {
    // Reading the clipboard on iOS pops a "paste from" banner, so clear without checking there.
    if (!Platform.isIOS) {
      final now = await Clipboard.getData(Clipboard.kTextPlain);
      if (now?.text != code) return;
    }
    await Clipboard.setData(const ClipboardData(text: ''));
  });
}

/// "Copy on open": the account whose code is copied when the app opens or unlocks, or null. The most
/// recently used one, skipping accounts that ask before revealing (requireAuth), travel mode hides, or
/// count up (HOTP, where copying would use up a code).
Account? copyOnOpenPick(Vault v) {
  if (v.settings[copyOnOpenKey] != true) return null;
  final used = v.live.where((a) => a.lastUsedAt != null && a.timeBased && !a.requireAuth && !a.travelHidden).toList()
    ..sort((a, b) => b.lastUsedAt!.compareTo(a.lastUsedAt!));
  return used.firstOrNull;
}
