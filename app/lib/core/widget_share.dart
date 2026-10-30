import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'vault.dart';

/// Settings key: copy favorites' secrets to the home/lock screen widgets and the watch. Off by default.
const shareCodesKey = 'shareCodes';

/// Phone-only native side: shared favorites for widgets and watch, and actions from widgets/controls/tiles.
const _channel = MethodChannel('tanooki/extras');

/// What widgets and the watch get: favorite time-based accounts, and nothing unless [shareCodesKey] is on.
/// Counter-based (HOTP) accounts are left out: a widget can't move the counter forward.
List<Map<String, Object>> sharedFavorites(Vault v) => v.settings[shareCodesKey] != true
    ? const []
    : [
        for (final a in v.live)
          if (a.favorite && a.timeBased)
            {
              'type': a.type.name, // "steam" switches the widget to Steam Guard's letters
              'issuer': a.issuer,
              'label': a.label,
              'secret': a.secret,
              'algorithm': a.algorithm.name,
              'digits': a.digits,
              'period': a.period,
            },
      ];

String? _lastSent;

/// Hands the current favorites (or an empty list, which erases them) to the widgets and watch.
/// Called after every save of the real vault, so a deleted or unstarred account disappears right away.
Future<void> publishSharedFavorites(Vault v) async {
  if (!Platform.isIOS && !Platform.isAndroid) return;
  final json = jsonEncode(sharedFavorites(v));
  if (json == _lastSent) return;
  try {
    await _channel.invokeMethod<void>('setFavorites', json);
    _lastSent = json;
  } on MissingPluginException {
    // Not wired (unit tests).
  } on PlatformException catch (e) {
    // Never log the payload: it holds secrets. Not remembered as sent, so the next save retries.
    debugPrint('Updating widgets/watch failed: ${e.code}');
  }
}

/// Something a widget, Control Center button or quick settings tile asked for ("scan"), or null.
/// Reading it clears it, so it runs once.
Future<String?> takePendingAction() async {
  try {
    return await _channel.invokeMethod<String>('takeAction');
  } on MissingPluginException {
    return null;
  }
}

/// [onAction] runs when the native side says an action is waiting (the app was already open).
void listenForPlatformActions(VoidCallback onAction) {
  _channel.setMethodCallHandler((call) async {
    if (call.method == 'action') onAction();
  });
}
