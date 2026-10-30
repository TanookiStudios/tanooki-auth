import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'account.dart';
import 'vault.dart';

/// Settings key: copy favorites' secrets to the home/lock screen widgets and the watch. Off by default.
const shareCodesKey = 'shareCodes';

/// Settings keys (Premium): show a Live Activity after copying a code (iPhone, off by default), and which
/// favorite's code the watch face complication shows (an account id).
const liveActivityKey = 'liveActivity', complicationKey = 'complicationAccount';

/// Whether Premium is unlocked; set by the app (main.dart). The complication is Premium.
bool Function() widgetPremium = () => false;

/// Phone-only native side: shared favorites for widgets and watch, and actions from widgets/controls/tiles.
const _channel = MethodChannel('tanooki/extras');

/// What widgets and the watch get: favorite time-based accounts, and nothing unless [shareCodesKey] is on.
/// Counter-based (HOTP) accounts are left out: a widget can't move the counter forward. So are accounts
/// travel mode hides. The one chosen for the watch face complication carries `complication: true`.
List<Map<String, Object>> sharedFavorites(Vault v, {bool premium = false}) => v.settings[shareCodesKey] != true
    ? const []
    : [
        for (final a in v.live)
          if (a.favorite && a.timeBased && !a.travelHidden)
            {
              if (premium && v.settings[complicationKey] == a.id) 'complication': true,
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
  final json = jsonEncode(sharedFavorites(v, premium: widgetPremium()));
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

/// After a code is copied on iPhone: a Live Activity (Lock Screen and Dynamic Island) with the account's
/// name, that code and a countdown, ending when the code expires. Premium, opt-in, and never for an account
/// travel mode hides.
Future<void> showCopiedCodeActivity(Vault v, Account a, DateTime now) async {
  if (!Platform.isIOS || !widgetPremium() || v.settings[liveActivityKey] != true || a.travelHidden || !a.timeBased) return;
  final unix = now.millisecondsSinceEpoch ~/ 1000;
  try {
    await _channel.invokeMethod<void>('startCodeActivity', {
      'title': a.issuer.isNotEmpty ? a.issuer : a.label,
      'code': a.codeAt(now),
      'expires': (unix - unix % a.period + a.period) * 1000, // ms since 1970, when this code stops working
    });
  } on MissingPluginException {
    // Not wired (unit tests).
  } on PlatformException catch (e) {
    debugPrint('Live Activity failed: ${e.code}'); // e.g. turned off in the iPhone Settings app
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
