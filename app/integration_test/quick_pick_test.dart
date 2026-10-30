import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tanooki_auth/ui/about_maddie.dart' show appVersion;
import 'package:tanooki_auth/ui/help.dart' show tourShownKey, whatsNewSeenKey;
import 'package:tanooki_auth/core/otpauth_uri.dart';
import 'package:tanooki_auth/core/security.dart';
import 'package:tanooki_auth/core/totp.dart';
import 'package:tanooki_auth/main.dart';

// Menu bar (Mac) / tray icon (Windows), Quick pick copy, and Type code, through the real native side.
// Run with: flutter test integration_test/quick_pick_test.dart -d <macos|windows> --dart-define=TA_STORAGE=itest
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  const window = MethodChannel('tanooki/window');
  const uri = 'otpauth://totp/GitHub:octo%40example.com?secret=JBSWY3DPEHPK3PXP&issuer=GitHub';
  int nowSec() => DateTime.now().millisecondsSinceEpoch ~/ 1000;
  String code() => totp(base32Decode('JBSWY3DPEHPK3PXP'), nowSec());

  Future<void> pumpFor(WidgetTester t, Duration d) async {
    for (var i = 0; i < d.inMilliseconds ~/ 100; i++) {
      await t.pump(const Duration(milliseconds: 100));
    }
  }

  Future<void> waitFor(WidgetTester t, Finder f) async {
    for (var i = 0; i < 100 && f.evaluate().isEmpty; i++) {
      await t.pump(const Duration(milliseconds: 100));
    }
    expect(f, findsWidgets);
  }

  // Stay clear of the 30-second rollover so the code we expect is the one the app used.
  Future<void> awayFromRollover(WidgetTester t) async {
    final left = secondsLeft(nowSec());
    if (left <= 8) await pumpFor(t, Duration(seconds: left + 1));
  }

  testWidgets('menu bar / tray icon opens Quick pick, click copies, Type types', (t) async {
    // Progress goes to a file too: CI only prints test output at the end, so a hang would otherwise show nothing.
    final log = File('${(await getTemporaryDirectory()).path}${Platform.pathSeparator}ta_quickpick_log.txt')
      ..createSync(recursive: true)
      ..writeAsStringSync('');
    void step(String s) {
      debugPrint(s);
      log.writeAsStringSync('${DateTime.now().toIso8601String()} $s\n', mode: FileMode.append, flush: true);
    }

    expect(storageName, isNotEmpty, reason: 'refusing to run against the real vault; pass --dart-define=TA_STORAGE=itest');
    final vault = await openVault();
    await vault.resetToEmpty();
    vault.accounts.add(parseOtpauthUri(uri));
    vault.settings.addAll({lockKey: false, kitShownKey: true, tourShownKey: true, whatsNewSeenKey: appVersion});
    await vault.save();

    await t.pumpWidget(const TanookiAuthApp(key: ValueKey('quickpick')));
    await waitFor(t, find.text('GitHub'));

    step('app up; checking tray');
    expect(await window.invokeMethod<bool>('trayStatus'), isTrue, reason: 'menu bar / tray icon is not there');
    step('tray ok; clicking it');
    await window.invokeMethod<void>('trayClick'); // native click handler -> trayClicked -> Quick pick
    await waitFor(t, find.text('Quick pick'));
    await pumpFor(t, const Duration(milliseconds: 500));

    step('quick pick open; copying');
    await Clipboard.setData(const ClipboardData(text: 'before'));
    await awayFromRollover(t);
    final copied = code();
    await t.tap(find.text('GitHub'));
    await pumpFor(t, const Duration(milliseconds: 500));
    expect((await Clipboard.getData(Clipboard.kTextPlain))?.text, copied);
    step('PROOF tray=ok quickpick-copy=$copied platform=${Platform.operatingSystem}');

    if (Platform.isMacOS) {
      final plan = (await window.invokeMapMethod<String, Object?>('typePlan', '048213'))!;
      expect(plan['events'], [
        for (final c in '048213'.codeUnits) ...[
          [c, true],
          [c, false],
        ],
      ]);
      if (plan['trusted'] == true) {
        // This build may press keys: tapping Type would type into whatever is in front on this Mac, so stop here.
        step('PROOF mac-type-plan=ok denied-path=SKIPPED (this build already has Accessibility) ax=${plan['axTrusted']}');
        return;
      }
      await t.tap(find.text('Type'));
      await waitFor(t, find.text('Allow Tanooki Auth to type'));
      expect(find.textContaining('Find Tanooki Auth and turn its switch on'), findsOneWidget);
      await t.tap(find.text('Not now'));
      await pumpFor(t, const Duration(milliseconds: 500));
      expect(find.text('Quick pick'), findsOneWidget);
      step('PROOF mac-type-plan=ok denied-path=explained ax=${plan['axTrusted']}');
    }

    if (Platform.isWindows) {
      // A window this test controls: a text box that writes what it receives to a file.
      final dir = await getTemporaryDirectory();
      final script = File('${dir.path}\\ta_type_target.ps1')..writeAsStringSync(_targetScript);
      final out = File('${dir.path}\\ta_typed.txt');
      final ready = File('${out.path}.ready');
      for (final f in [out, ready]) {
        if (f.existsSync()) f.deleteSync();
      }
      final target = await Process.start(
          'powershell', ['-NoProfile', '-ExecutionPolicy', 'Bypass', '-STA', '-File', script.path, '-Out', out.path]);
      try {
        for (var i = 0; i < 150 && !ready.existsSync(); i++) {
          await t.pump(const Duration(milliseconds: 100));
        }
        step('target window: ${ready.existsSync() ? ready.readAsStringSync() : 'not shown'}');
        expect(ready.existsSync() ? ready.readAsStringSync() : 'not shown', contains('front=True'),
            reason: 'the target text box must be the window in front before Tanooki Auth comes up');
        await window.invokeMethod<void>('trayClick'); // like the user clicking the tray icon while in the text box
        await pumpFor(t, const Duration(seconds: 1));
        await awayFromRollover(t);
        final typed = code();
        step('tapping Type');
        await t.tap(find.text('Type'));
        // Type minimizes the app, and a minimized Flutter window draws no frames, so wait in real time, not with pump.
        for (var i = 0; i < 100 && (!out.existsSync() || out.readAsStringSync().length < typed.length); i++) {
          await Future<void>.delayed(const Duration(milliseconds: 100));
        }
        step('typed: ${out.existsSync() ? out.readAsStringSync() : '<none>'}');
        step('target window after Type: ${ready.readAsStringSync()}');
        expect(out.existsSync() ? out.readAsStringSync() : '<nothing typed>', typed);
        step('PROOF windows-type=$typed');
      } finally {
        target.kill();
        step('target output: ${await target.stdout.transform(systemEncoding.decoder).join()} ${await target.stderr.transform(systemEncoding.decoder).join()}');
        await window.invokeMethod<void>('focus');
        await pumpFor(t, const Duration(seconds: 1));
        step('on screen after: ${find.byType(AlertDialog).evaluate().isEmpty ? 'no dialog' : find.descendant(of: find.byType(AlertDialog), matching: find.byType(Text)).evaluate().map((e) => (e.widget as Text).data).join(' | ')}');
      }
    }
  }, skip: !(Platform.isMacOS || Platform.isWindows), timeout: const Timeout(Duration(minutes: 4)));
}

const _targetScript = r'''
param([string]$Out)
Add-Type -AssemblyName System.Windows.Forms
$form = New-Object Windows.Forms.Form
$form.Text = 'Tanooki type target'
$form.TopMost = $true
$form.Width = 420
$form.Height = 120
$box = New-Object Windows.Forms.TextBox
$box.Dock = 'Fill'
$form.Controls.Add($box)
$box.Add_TextChanged({ [IO.File]::WriteAllText($Out, $box.Text) })
Add-Type @"
using System;
using System.Runtime.InteropServices;
public static class Fg {
  [DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr h);
  [DllImport("user32.dll")] public static extern IntPtr GetForegroundWindow();
  [DllImport("user32.dll")] public static extern void keybd_event(byte k, byte s, uint f, UIntPtr e);
}
"@
# Windows only lets a window take the front after a key press, so tap F24 first. Not Alt: a lone Alt tap puts the
# window in menu mode, which eats the next key typed.
$form.Add_Shown({
  [Fg]::keybd_event(0x87, 0, 0, [UIntPtr]::Zero); [Fg]::keybd_event(0x87, 0, 2, [UIntPtr]::Zero)
  [Fg]::SetForegroundWindow($form.Handle) | Out-Null
  $box.Focus() | Out-Null
  [IO.File]::WriteAllText("$Out.ready", "shown front=$([Fg]::GetForegroundWindow() -eq $form.Handle)")
})
$form.Add_Activated({ $box.Focus() | Out-Null })
$quit = New-Object Windows.Forms.Timer
$quit.Interval = 120000
$quit.Add_Tick({ $form.Close() })
$quit.Start()
[Windows.Forms.Application]::Run($form)
''';
