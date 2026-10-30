// ignore_for_file: avoid_print
// End-to-end test against the LIVE relay with the app's real sync and phone-link code. Not part of the normal
// `flutter test` run (it needs the internet and Node). Run from app/:
//   flutter test tool/relay_live_test.dart
// RELAY=http://localhost:8787 points it at a local relay instead. Every vault is a throwaway in a temp
// folder (like --dart-define=TA_STORAGE), so nothing here can reach a real vault.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tanooki_auth/core/otpauth_uri.dart';
import 'package:tanooki_auth/core/phone_link.dart';
import 'package:tanooki_auth/core/sync/relay_client.dart';
import 'package:tanooki_auth/core/sync/relay_crypto.dart';
import 'package:tanooki_auth/core/sync/sync_engine.dart';
import 'package:tanooki_auth/core/sync/sync_service.dart';
import 'package:tanooki_auth/core/vault.dart';

class MemoryKeyStore implements KeyStore {
  String? value;
  @override
  Future<String?> read() async => value;
  @override
  Future<void> write(String v) async => value = v;
}

final relay = Platform.environment['RELAY'] ?? relayUrl;

void main() {
  late Directory dir;
  setUp(() => dir = Directory.systemTemp.createTempSync('relay_live'));
  tearDown(() => dir.deleteSync(recursive: true));

  Future<Vault> vault(String storageName) async {
    final v = Vault(File('${dir.path}/$storageName/vault.json'), MemoryKeyStore());
    await v.load();
    return v;
  }

  test('two devices sync an add, an edit and a delete through the relay', () async {
    final a = await vault('live-a');
    final b = await vault('live-b');
    final pass = 'live test ${b64u(randomBytes(9))}'; // a new group every run
    await SyncSetup.startRelay(a, pass, relay: relay);
    final invite = await SyncSetup.inviteLink(a);

    await expectLater(SyncSetup.joinRelay(b, invite, 'wrong passphrase'), throwsA(isA<SyncSetupException>()));
    await SyncSetup.joinRelay(b, invite, pass);
    final devices = await (await RelaySync(a).relay()).devices();
    expect(devices, hasLength(2));

    // Add on A.
    a.accounts.add(parseOtpauthUri('otpauth://totp/GitHub:maddie?secret=JBSWY3DPEHPK3PXP')..domains.add('github.com'));
    await a.save();
    final pushed = await RelaySync(a).sync();
    expect(pushed.pushed, 1);
    await RelaySync(b).sync();
    expect(b.live.single.issuer, 'GitHub');
    expect(b.live.single.secret, 'JBSWY3DPEHPK3PXP');
    print('add: A pushed 1, B has GitHub');

    // Edit on B.
    b.live.single.issuer = 'GitHub (work)';
    await b.save();
    await RelaySync(b).sync();
    await RelaySync(a).sync();
    expect(a.live.single.issuer, 'GitHub (work)');
    print('edit: A sees "GitHub (work)"');

    // Edit on both while "offline", then sync: the later edit wins on both.
    a.live.single.notes = 'from A';
    await a.save();
    await Future<void>.delayed(const Duration(milliseconds: 20));
    b.live.single.notes = 'from B, later';
    await b.save();
    await RelaySync(a).sync();
    final conflict = await RelaySync(b).sync(); // B's push conflicts with A's, merges, pushes again
    await RelaySync(a).sync();
    expect(a.live.single.notes, 'from B, later');
    expect(b.live.single.notes, 'from B, later');
    print('conflict: both keep the later edit (B pulled ${conflict.pulled}, pushed ${conflict.pushed})');

    // Delete for good on A.
    a.accounts.clear();
    await a.save();
    await RelaySync(a).sync();
    await RelaySync(b).sync();
    expect(b.accounts, isEmpty);
    print('delete: gone on B');

    // The relay only ever saw ciphertext.
    final raw = await (await RelaySync(a).relay()).changes(0);
    expect(jsonEncode(raw.records).contains('JBSWY3DPEHPK3PXP'), isFalse);
    expect(jsonEncode(raw.records).contains('GitHub'), isFalse);

    // Both leave; the last one out deletes the group.
    final groupRelay = await RelaySync(a).relay();
    await SyncSetup.turnOff(b);
    await SyncSetup.turnOff(a);
    await expectLater(groupRelay.devices(), throwsA(isA<RelayException>().having((e) => e.status, 'status', 404)));
  }, timeout: const Timeout(Duration(minutes: 3)));

  test('extension asks the phone for a code; phone approves, then denies', () async {
    final phone = await vault('live-phone');
    final gh = parseOtpauthUri('otpauth://totp/GitHub:maddie?secret=JBSWY3DPEHPK3PXP')..domains.add('github.com');
    phone.accounts.addAll([gh, parseOtpauthUri('otpauth://totp/Evil:x?secret=KRUGKIDROVUWG2ZA')..domains.add('github.com.evil.io')]);

    final node = await Process.start('node', ['../extension/test/link-client.cjs', relay, 'github.com']);
    final lines = StreamController<String>.broadcast();
    node.stdout.transform(utf8.decoder).transform(const LineSplitter()).listen((l) {
      print('extension: $l');
      lines.add(l);
    });
    node.stderr.transform(utf8.decoder).listen((l) => print('extension stderr: $l'));
    final queue = StreamIterator(lines.stream);
    Future<String> next(String prefix) async {
      while (await queue.moveNext().timeout(const Duration(seconds: 90))) {
        if (queue.current.startsWith('ERROR')) fail(queue.current);
        if (queue.current.startsWith(prefix)) return queue.current.substring(prefix.length).trim();
      }
      fail('extension exited before $prefix');
    }

    final qr = await next('QR');
    final link = await BrowserLink.pair(qr, deviceName: 'Test phone');
    expect(await next('PAIRED'), 'Test phone');

    final requests = StreamController<FillRequest>();
    await link.connect(requests.add, onGone: () {}, onDrop: () {});
    final asks = StreamIterator(requests.stream);

    expect(await asks.moveNext().timeout(const Duration(seconds: 30)), isTrue);
    final first = asks.current;
    expect(first.host, 'github.com');
    final offered = accountsForHost(phone.live, first.host);
    expect(offered, [gh], reason: 'only the account saved for github.com is offered');
    final before = gh.codeAt(DateTime.now());
    await link.answer(first, offered.single);
    final got = (await next('CODE')).split(' ');
    final after = gh.codeAt(DateTime.now());
    expect([before, after], contains(got[0]));
    expect(got[1], 'github.com');
    print('approve: extension got ${got[0]} for ${got[1]}, phone computed $before');

    expect(await asks.moveNext().timeout(const Duration(seconds: 30)), isTrue);
    await link.answer(asks.current, null);
    await next('DENIED');
    final stored = await next('STORED');
    expect(stored.contains('code'), isFalse);
    await next('DONE');
    link.disconnect();
    expect(await node.exitCode, 0);
    await asks.cancel(); // (closing a paused stream would wait forever)
    await queue.cancel();
  }, timeout: const Timeout(Duration(minutes: 3)));
}

