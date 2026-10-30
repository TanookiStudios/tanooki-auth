// Premium purchases (feature 39), gifts (40) and invites (41): which buttons each build shows, and what a store
// purchase does, against a fake store and a fake Premium worker. Nothing here reaches a real store or server.
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cryptography/cryptography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:tanooki_auth/core/license.dart';
import 'package:tanooki_auth/core/store.dart';
import 'package:tanooki_auth/core/sync/relay_client.dart';
import 'package:tanooki_auth/core/vault.dart';
import 'package:tanooki_auth/ui/premium.dart';

class MemoryKeyStore implements KeyStore {
  String? value;
  @override
  Future<String?> read() async => value;
  @override
  Future<void> write(String v) async => value = v;
}

/// The store, faked: fixed prices, and every purchase answered with [answer].
class FakeIap implements InAppPurchase {
  final stream = StreamController<List<PurchaseDetails>>.broadcast();
  final completed = <String>[];
  PurchaseStatus answer = PurchaseStatus.purchased;
  bool available = true;

  @override
  Stream<List<PurchaseDetails>> get purchaseStream => stream.stream;
  @override
  Future<bool> isAvailable() async => available;
  @override
  Future<ProductDetailsResponse> queryProductDetails(Set<String> ids) async => ProductDetailsResponse(
        productDetails: [
          ProductDetails(id: premiumProductId, title: 'Premium', description: '', price: '\$4.99', rawPrice: 4.99, currencyCode: 'USD'),
          ProductDetails(id: familyProductId, title: 'Family', description: '', price: '\$9.99', rawPrice: 9.99, currencyCode: 'USD'),
        ],
        notFoundIDs: [],
      );
  @override
  Future<bool> buyNonConsumable({required PurchaseParam purchaseParam}) async {
    stream.add([purchase(purchaseParam.productDetails.id, answer)]);
    return true;
  }

  @override
  Future<void> completePurchase(PurchaseDetails p) async => completed.add(p.productID);
  @override
  dynamic noSuchMethod(Invocation i) => super.noSuchMethod(i);
}

PurchaseDetails purchase(String product, PurchaseStatus status) => PurchaseDetails(
      purchaseID: '2000000123',
      productID: product,
      verificationData: PurchaseVerificationData(localVerificationData: '', serverVerificationData: 'jws.$product', source: 'app_store'),
      transactionDate: '0',
      status: status,
    )..pendingCompletePurchase = status != PurchaseStatus.pending;

late SimpleKeyPair signer;
Future<String> issue(String payload) async {
  final sig = await Ed25519().sign(utf8.encode(payload), keyPair: signer);
  String b(List<int> x) => base64Url.encode(x).replaceAll('=', '');
  return 'TA1.${b(utf8.encode(payload))}.${b(sig.bytes)}';
}

/// Fake Premium worker: records each call and answers from [routes].
final calls = <String>[];
final routes = <String, FutureOr<RelayResponse> Function(Object? body)>{};
Future<RelayResponse> fakeWorker(String method, String path, {Object? body}) async {
  calls.add('$method $path');
  final route = routes['$method ${path.split('?').first}'];
  return route == null ? RelayResponse(404, {'error': 'not found'}) : await route(body);
}

/// Lets real file writes (vault saves) finish between frames; pumpAndSettle can't while a progress bar spins.
Future<void> settle(WidgetTester t) async {
  for (var i = 0; i < 20; i++) {
    await t.runAsync(() => Future.delayed(const Duration(milliseconds: 10)));
    await t.pump();
  }
}

Future<Vault> newVault() async {
  final v = Vault(File('${Directory.systemTemp.createTempSync('store').path}/v.json'), MemoryKeyStore());
  await v.load();
  return v;
}

void main() {
  setUpAll(() async {
    signer = await Ed25519().newKeyPair();
    licensePublicKey = base64.encode((await signer.extractPublicKey()).bytes);
    workerCall = fakeWorker;
  });
  setUp(() {
    calls.clear();
    routes.clear();
    premium.value = false;
  });

  group('which store each build uses', () {
    test('iPhone and Android use their stores; Mac uses the App Store only in the Mac App Store build', () {
      expect(storefrontFor('ios'), Storefront.apple);
      expect(storefrontFor('android'), Storefront.google);
      expect(storefrontFor('macos', macAppStore: false), Storefront.stripe);
      expect(storefrontFor('macos', macAppStore: true), Storefront.apple);
      expect(storefrontFor('windows', macAppStore: true), Storefront.stripe);
      expect(storefrontFor('linux'), Storefront.stripe);
      expect(macAppStoreBuild, isFalse, reason: 'only scripts/release-mac-appstore.sh sets the define');
    });

    test('store builds never show a Stripe link; Stripe builds never show the store', () {
      for (final s in [Storefront.apple, Storefront.google]) {
        final o = PremiumOffer(s, owned: false, hasKey: true, teamCheckoutUrl: 'https://buy.stripe.com/team');
        expect([o.stripeBuy, o.gift, o.invites, o.teamBuy], everyElement(isFalse), reason: '$s');
        expect([o.storeBuy, o.restore, o.enterKey], everyElement(isTrue), reason: '$s');
      }
      final d = PremiumOffer(Storefront.stripe, owned: false, hasKey: false, teamCheckoutUrl: '');
      expect([d.stripeBuy, d.gift, d.enterKey], everyElement(isTrue));
      expect([d.storeBuy, d.restore, d.invites, d.teamBuy, d.desktopKeyComingSoon], everyElement(isFalse));
      final owner = PremiumOffer(Storefront.stripe, owned: true, hasKey: true, teamCheckoutUrl: 'https://buy.stripe.com/team');
      expect([owner.invites, owner.gift, owner.teamBuy], everyElement(isTrue));
      expect([owner.stripeBuy, owner.enterKey], everyElement(isFalse));
      expect(PremiumOffer(Storefront.google, owned: true, hasKey: false, teamCheckoutUrl: '').desktopKeyComingSoon, isTrue);
      expect(PremiumOffer(Storefront.apple, owned: true, hasKey: false, teamCheckoutUrl: '').desktopKeyComingSoon, isFalse);
    });

    test('gift links tag the checkout so the worker shows a gift card', () {
      expect(giftUrl('https://buy.stripe.com/abc'), 'https://buy.stripe.com/abc?client_reference_id=gift');
    });
  });

  group('purchases', () {
    late Vault v;
    late FakeIap iap;
    late Store store;
    setUp(() async {
      v = await newVault();
      iap = FakeIap();
      store = Store(iap, Storefront.apple)..attach(v);
      await store.loadProducts();
    });
    tearDown(() => store.dispose());

    Future<void> settle() => Future.delayed(const Duration(milliseconds: 50));

    test('an App Store purchase unlocks Premium and gets a license key for desktop from the worker', () async {
      String? sent;
      routes['POST /iap/apple'] = (b) async {
        sent = (b as Map)['signedTransaction'] as String;
        return RelayResponse(200, {'key': await issue('1|ios-2000000123|20261030'), 'seats': 1});
      };
      expect(await hasPremium(v), isFalse);
      await store.buy(premiumProductId);
      await settle();
      expect(sent, 'jws.$premiumProductId', reason: 'the StoreKit 2 signed transaction goes to the worker');
      expect(await hasPremium(v), isTrue);
      expect(await verifyLicense(v.settings['license'] as String), isTrue);
      expect(iap.completed, [premiumProductId], reason: 'finished only after the unlock was saved');
      expect(store.message.value, contains('license key'));
    });

    test('the family product gets a 5-seat key; a restore with a covering key skips the worker', () async {
      routes['POST /iap/apple'] = (_) async => RelayResponse(200, {'key': await issue('1|ios-9|20261030|5'), 'seats': 5});
      await store.buy(familyProductId);
      await settle();
      expect(licenseSeats(v.settings['license'] as String), 5);
      calls.clear();
      await store.handle([purchase(familyProductId, PurchaseStatus.restored)]);
      expect(calls, isEmpty);
      expect(await hasPremium(v), isTrue);
    });

    test('when the worker refuses (sandbox), Premium still unlocks here and the reason is shown', () async {
      routes['POST /iap/apple'] = (_) => RelayResponse(403, {'error': 'sandbox and TestFlight purchases do not make license keys'});
      await store.buy(premiumProductId);
      await settle();
      expect(await hasPremium(v), isTrue);
      expect(v.settings['license'], isNull);
      expect(store.message.value, contains('Sandbox and TestFlight purchases do not make license keys.'));
      expect(iap.completed, [premiumProductId]);
    });

    test('canceled and failed purchases unlock nothing', () async {
      iap.answer = PurchaseStatus.canceled;
      await store.buy(premiumProductId);
      await settle();
      expect(await hasPremium(v), isFalse);
      expect(store.message.value, contains('canceled'));
      iap.answer = PurchaseStatus.pending;
      await store.buy(premiumProductId);
      await settle();
      expect(await hasPremium(v), isFalse);
      expect(store.message.value, contains('Waiting'));
      expect(calls, isEmpty);
    });

    test('a Google Play purchase unlocks here and never asks the worker', () async {
      final g = Store(FakeIap(), Storefront.google)..attach(v);
      await g.loadProducts();
      await g.buy(premiumProductId);
      await settle();
      expect(await hasPremium(v), isTrue);
      expect(calls, isEmpty);
      expect((v.settings[storePurchaseKey] as Map)['store'], 'google');
      await g.dispose();
    });

    test('another app\'s product is finished but unlocks nothing', () async {
      await store.handle([purchase('com.example.other', PurchaseStatus.purchased)]);
      expect(await hasPremium(v), isFalse);
      expect(iap.completed, ['com.example.other']);
    });
  });

  group('Premium screen', () {
    tearDown(() => storefront = Storefront.stripe);

    testWidgets('iPhone: store prices and Restore Purchases, no Stripe, gift or invite links', (t) async {
      final v = await t.runAsync(newVault);
      storefront = Storefront.apple;
      final store = Store(FakeIap(), Storefront.apple);
      await t.pumpWidget(MaterialApp(home: PremiumScreen(vault: v!, store: store)));
      await t.pumpAndSettle();
      expect(find.text('Just me — \$4.99'), findsOneWidget);
      expect(find.text('Family (up to 5 people) — \$9.99'), findsOneWidget);
      expect(find.text('Restore Purchases'), findsOneWidget);
      expect(find.textContaining('\$5'), findsNothing);
      expect(find.byKey(const ValueKey('gift')), findsNothing);
      expect(find.text('Invite friends'), findsNothing);
      await store.dispose();
    });

    testWidgets('desktop download: Stripe buttons and the gift button, no store', (t) async {
      final v = await t.runAsync(newVault);
      storefront = Storefront.stripe;
      await t.pumpWidget(MaterialApp(home: PremiumScreen(vault: v!)));
      await t.pumpAndSettle();
      expect(find.text('Just me — \$5'), findsOneWidget);
      expect(find.byKey(const ValueKey('gift')), findsOneWidget);
      expect(find.text('Restore Purchases'), findsNothing);
    });

    testWidgets('key holders: invite link, then Check my invites installs the Family key', (t) async {
      final v = await t.runAsync(newVault);
      final key = (await t.runAsync(() => issue('1|cs_test_abc|20261030')))!;
      final family = (await t.runAsync(() => issue('1|cs_test_abc|20261030|5')))!;
      v!.settings['license'] = key;
      premium.value = true;
      storefront = Storefront.stripe;
      routes['GET /invite'] = (_) => RelayResponse(200, {'code': 'ABCDEFGH', 'link': 'https://buy.stripe.com/x?prefilled_promo_code=FRIEND20&client_reference_id=ref_ABCDEFGH'});
      var count = 2;
      routes['GET /invites'] = (_) => RelayResponse(200, {'code': 'ABCDEFGH', 'count': count, 'needed': 3, if (count >= 3) 'familyKey': family});

      t.view.physicalSize = const Size(2400, 12000);
      addTearDown(t.view.reset);
      await t.pumpWidget(MaterialApp(home: PremiumScreen(vault: v)));
      await t.pumpAndSettle();
      expect(find.text('Friends get 20% off. When 3 friends buy, your key becomes a Family key.'), findsOneWidget);
      await t.tap(find.text('Get my invite link'));
      await settle(t);
      expect(find.textContaining('client_reference_id=ref_ABCDEFGH'), findsOneWidget);
      expect(find.text('Share'), findsOneWidget);
      expect(find.text('Copy'), findsOneWidget);

      await t.tap(find.text('Check my invites'));
      await settle(t);
      expect(find.textContaining('2 of 3 friends'), findsOneWidget);
      expect(v.settings['license'], key);

      count = 3;
      await t.tap(find.text('Check my invites'));
      await settle(t);
      expect(v.settings['license'], family, reason: 'the Family key replaces the old one');
      expect(find.textContaining('now a Family key'), findsOneWidget);
      expect(calls.where((c) => c.startsWith('GET /invite')).every((c) => c.contains('key=TA1.')), isTrue);
    });
  });
}
