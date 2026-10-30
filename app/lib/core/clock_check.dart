import 'package:flutter/foundation.dart';

import 'sync/relay_client.dart';
import 'sync/relay_crypto.dart' show relayUrl;
import '../l10n/l10n.dart';

/// Codes are made from the clock, so a device clock that's off by more than this makes them fail.
const clockTolerance = Duration(seconds: 30);

/// How far this device's clock is from the relay's (positive: this device is ahead). Asks the relay's /health,
/// which sends nothing but the time, and allows for the trip there and back.
Future<Duration> relayClockOffset({String base = relayUrl, DateTime Function() now = DateTime.now}) async {
  final sent = now();
  final r = await relayFetch(base, 'GET', '/health');
  final back = now();
  final server = DateTime.tryParse(r.body['time'] as String? ?? '');
  if (r.status != 200 || server == null) {
    throw RelayException(r.status, l10n.clockCheckBadAnswer('${r.status}'));
  }
  final middle = sent.add(back.difference(sent) ~/ 2);
  return middle.difference(server);
}

/// The warning for a clock that's [off], or null when it's close enough.
String? clockProblem(Duration off) {
  if (off.abs() <= clockTolerance) return null;
  final minutes = (off.abs().inSeconds / 60).round().clamp(1, 1 << 30);
  return l10n.clockCheckOff(minutes);
}

/// Checks the clock at most once an hour while codes are on screen, plus whenever asked ("Codes not working?").
class ClockCheck {
  ClockCheck({this.measure = relayClockOffset});
  static final instance = ClockCheck();

  final Future<Duration> Function() measure;
  /// The warning to show on the home screen, or null.
  final warning = ValueNotifier<String?>(null);
  /// Off until the app turns it on (main.dart), so tests never go online.
  bool auto = false;
  DateTime? _last;
  Future<String?>? _running;

  /// Runs the check if it's on and the last one was over an hour ago. Failures stay quiet: this is a background
  /// nicety, and "Codes not working?" reports them.
  Future<void> maybeRun({DateTime? now}) async {
    final t = now ?? DateTime.now();
    if (!auto || (_last != null && t.difference(_last!) < const Duration(hours: 1))) return;
    _last = t;
    try {
      await runNow();
    } on RelayException {
      // offline: try again in an hour
    }
  }

  /// Measures now. Returns the warning (null when the clock is fine); throws [RelayException] when offline.
  Future<String?> runNow() => _running ??= () async {
        try {
          return warning.value = clockProblem(await measure());
        } finally {
          _running = null;
        }
      }();
}
