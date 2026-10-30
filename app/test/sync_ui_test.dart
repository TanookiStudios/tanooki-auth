import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tanooki_auth/core/account.dart';
import 'package:tanooki_auth/core/phone_link.dart';
import 'package:tanooki_auth/core/vault.dart';
import 'package:tanooki_auth/ui/phone_link_ui.dart';
import 'package:tanooki_auth/ui/premium.dart';
import 'package:tanooki_auth/ui/sync_ui.dart';

class MemoryKeyStore implements KeyStore {
  String? value;
  @override
  Future<String?> read() async => value;
  @override
  Future<void> write(String v) async => value = v;
}

void main() {
  late Vault vault;
  setUp(() {
    vault = Vault(File('${Directory.systemTemp.createTempSync('sync_ui').path}/v.json'), MemoryKeyStore());
  });

  testWidgets('Sync screen: Premium gate, then the turn-on choices', (tester) async {
    await tester.runAsync(vault.load);
    premium.value = false;
    await tester.pumpWidget(MaterialApp(home: SyncScreen(vault: vault)));
    expect(find.text('Sync is part of Premium'), findsOneWidget);
    expect(find.text('Turn on sync'), findsNothing);

    premium.value = true;
    await tester.pumpWidget(MaterialApp(home: SyncScreen(vault: vault, key: UniqueKey())));
    expect(find.text('Turn on sync'), findsOneWidget);
    expect(find.text('Join from another device'), findsOneWidget);
  });

  testWidgets('Approve sheet offers only the account saved for the site; a lookalike gets only Deny', (tester) async {
    final gh = Account(id: '1', issuer: 'GitHub', secret: 'JBSWY3DPEHPK3PXP', domains: ['github.com']);
    vault.accounts.add(gh);
    final link = BrowserLink({'relay': 'https://x', 'room': 'r', 'token': 't', 'pairedAt': DateTime.now().toIso8601String()});
    late BuildContext ctx;
    await tester.pumpWidget(MaterialApp(home: Builder(builder: (c) {
      ctx = c;
      return const SizedBox();
    })));

    Account? answer = Account(id: 'sentinel', secret: 'A');
    askToApprove(ctx, vault, FillRequest(link, 'req', 'github.com', 1)).then((a) => answer = a);
    await tester.pumpAndSettle();
    expect(find.text('github.com'), findsOneWidget);
    await tester.tap(find.text('Approve'));
    await tester.pumpAndSettle();
    expect(answer, gh);

    askToApprove(ctx, vault, FillRequest(link, 'req2', 'gihtub.com', 2)).then((a) => answer = a);
    await tester.pumpAndSettle();
    expect(find.text('Approve'), findsNothing);
    expect(find.textContaining('fake site'), findsOneWidget);
    await tester.tap(find.text('Deny'));
    await tester.pumpAndSettle();
    expect(answer, isNull);
  });
}
