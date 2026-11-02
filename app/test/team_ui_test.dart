// Team screens and "ask first": a team copy of an "ask first" account keeps asking, and copying one of your own
// "ask first" accounts into the team asks too (it hands the setup key to everyone in the team).
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tanooki_auth/core/account.dart';
import 'package:tanooki_auth/core/sync/relay_crypto.dart';
import 'package:tanooki_auth/core/team.dart';
import 'package:tanooki_auth/core/vault.dart';
import 'package:tanooki_auth/ui/security_ui.dart';
import 'package:tanooki_auth/ui/team_ui.dart';
import 'package:tanooki_auth/ui/theme.dart';

import 'vault_test.dart' show MemoryKeyStore;

void main() {
  late Directory dir;
  late Vault vault;
  final clipboard = <String>[];

  setUp(() {
    dir = Directory.systemTemp.createTempSync('team_ui');
    vault = Vault(File('${dir.path}/vault.json'), MemoryKeyStore()..value = base64.encode(List.filled(32, 5)));
    // A member device with nowhere to sync to: the screens show what's stored here.
    vault.settings[teamStateKey] = {
      'relay': 'http://127.0.0.1:9',
      'teamId': b64u(randomBytes(32)),
      'role': 'member',
      'device': b64u(randomBytes(32)),
      'box': b64u(randomBytes(32)),
      'keys': <String, dynamic>{},
      'epoch': 1,
      'cursor': 0,
      'entries': <String, dynamic>{},
    };
    clipboard.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, (c) async {
      if (c.method == 'Clipboard.setData') clipboard.add((c.arguments as Map)['text'] as String);
      return null;
    });
  });
  tearDown(() {
    confirmItsYouOverride = null;
    dir.deleteSync(recursive: true);
  });

  Future<void> pump(WidgetTester t, Widget child) async {
    t.view.physicalSize = const Size(420, 1400);
    t.view.devicePixelRatio = 1;
    addTearDown(t.view.reset);
    await t.pumpWidget(MaterialApp(theme: buildTheme(darkPalette), home: child));
    await t.pump();
  }

  Future<void> finish(WidgetTester t) async {
    await t.pumpWidget(const SizedBox());
    await t.pump(const Duration(seconds: 31));
  }

  testWidgets('home Team section: an "ask first" team account shows dots and asks before copying', (t) async {
    final bank = Account(id: 'bank', issuer: 'Bank', secret: 'JBSWY3DPEHPK3PXP', requireAuth: true);
    putTeamAccount(vault, bank);
    var allow = false, asked = 0;
    confirmItsYouOverride = (_, _, reason) async {
      asked++;
      expect(reason, 'Copy the code for Bank');
      return allow;
    };
    await pump(t, Scaffold(body: TeamHomeSection(vault: vault)));
    expect(find.text(bank.codeAt(DateTime.now())), findsNothing, reason: 'hidden like on the personal list');

    await t.tap(find.text('Bank'));
    await t.pump();
    expect(asked, 1);
    expect(clipboard, isEmpty, reason: 'refused: nothing copied');

    allow = true;
    await t.tap(find.text('Bank'));
    await t.pump();
    expect(clipboard, [bank.codeAt(DateTime.now())]);
    await finish(t);
  });

  testWidgets('Team screen: copying an "ask first" account into the team asks first', (t) async {
    vault.accounts.add(Account(id: 'mine', issuer: 'Bank', secret: 'JBSWY3DPEHPK3PXP', requireAuth: true));
    final reasons = <String>[];
    confirmItsYouOverride = (_, _, reason) async {
      reasons.add(reason);
      return false;
    };
    await pump(t, TeamScreen(vault: vault));
    await t.pumpAndSettle();
    await t.tap(find.text('Add one of mine'));
    await t.pumpAndSettle();
    await t.tap(find.text('Bank').last);
    await t.pumpAndSettle();
    expect(reasons, ['Share Bank']);
    expect(teamAccounts(vault), isEmpty, reason: 'refused: nothing went to the team');
    await finish(t);
  });
}
