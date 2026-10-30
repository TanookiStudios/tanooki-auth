import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tanooki_auth/core/account.dart';
import 'package:tanooki_auth/core/paper_backup.dart';

void main() {
  test('PDF lists every account with its setup key and only unused recovery codes', () async {
    final accounts = [
      for (var i = 0; i < 12; i++) Account(id: '$i', issuer: 'Site$i', label: 'me$i', secret: 'JBSWY3DPEHPK3PXP'),
    ];
    accounts.first.recoveryCodes.addAll([RecoveryCode('aaaa-1111'), RecoveryCode('bbbb-2222', used: true)]);
    final bytes = await buildPaperBackup(accounts, now: DateTime(2026, 10, 30), compress: false);
    final text = latin1.decode(bytes);
    expect(text.startsWith('%PDF'), isTrue);
    for (final s in ['Site0', 'Site11', 'me5', 'JBSWY3DPEHPK3PXP', 'aaaa-1111', '2026-10-30', 'SECRET.']) {
      expect(text.contains(s), isTrue, reason: s);
    }
    expect(text.contains('bbbb-2222'), isFalse, reason: 'used codes are left off');
    expect(RegExp(r'/Type\s*/Page\b').allMatches(text).length, greaterThan(1), reason: '12 accounts need more than one page');
  });
}
