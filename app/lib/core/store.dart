// Buying Premium (feature 39) and the Premium worker's other calls (invites, team license renewal).
//
// The App Store builds (iPhone, iPad, Mac App Store) and the Google Play build sell Premium through the
// store, as store rules require; the desktop downloads keep the Stripe links. After an App Store purchase
// the worker turns Apple's signed transaction into a normal license key, so the buyer's computers unlock too.
import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'license.dart';
import 'sync/relay_client.dart';
import 'vault.dart';

const workerUrl = 'https://tanooki-auth-premium.kirbymail.workers.dev';

/// Set by scripts/release-mac-appstore.sh (`--dart-define=TA_MAC_APP_STORE=true`). The Developer ID download
/// leaves it off and keeps Stripe.
const macAppStoreBuild = bool.fromEnvironment('TA_MAC_APP_STORE');

const premiumProductId = 'com.tanookistudios.auth.premium';
const familyProductId = 'com.tanookistudios.auth.family';
const storeProductIds = {premiumProductId, familyProductId};

/// Settings key: {product, store} for a purchase made in the App Store or Google Play on this device.
const storePurchaseKey = 'storePurchase';

enum Storefront { stripe, apple, google }

Storefront storefrontFor(String os, {bool macAppStore = macAppStoreBuild}) => switch (os) {
      'ios' => Storefront.apple,
      'android' => Storefront.google,
      'macos' when macAppStore => Storefront.apple,
      _ => Storefront.stripe,
    };

/// Where this copy of the app sells Premium. Tests may change it.
Storefront storefront = storefrontFor(Platform.operatingSystem);

/// What the Premium screen offers. Store builds never show a Stripe link (gift and invite links are Stripe
/// links too); Stripe builds never show the store.
class PremiumOffer {
  PremiumOffer(Storefront s, {required bool owned, required bool hasKey, required String teamCheckoutUrl})
      : stripeBuy = s == Storefront.stripe && !owned,
        storeBuy = s != Storefront.stripe && !owned,
        restore = s != Storefront.stripe,
        enterKey = !owned,
        gift = s == Storefront.stripe,
        invites = s == Storefront.stripe && hasKey,
        teamBuy = s == Storefront.stripe && teamCheckoutUrl.isNotEmpty,
        desktopKeyComingSoon = s == Storefront.google;
  final bool stripeBuy, storeBuy, restore, enterKey, gift, invites, teamBuy, desktopKeyComingSoon;
}

/// True when this vault has Premium: a genuine license key, or a store purchase made on this device.
Future<bool> hasPremium(Vault v) async {
  final key = v.settings['license'];
  return (key is String && await verifyLicense(key)) || v.settings[storePurchaseKey] is Map;
}

// ---------------------------------------------------------------- the Premium worker

/// A call to the Premium worker. Tests replace it with a fake.
typedef WorkerCall = Future<RelayResponse> Function(String method, String path, {Object? body});

WorkerCall workerCall = (method, path, {body}) async {
  try {
    return await relayFetch(workerUrl, method, path, body: body);
  } on RelayException catch (e) {
    if (e.status == 0) throw RelayException(0, 'Can\'t reach the Tanooki Auth server. Check your internet connection and try again.');
    rethrow;
  }
};

String _err(RelayResponse r) {
  final e = r.body['error'] as String? ?? 'the server said no (HTTP ${r.status})';
  return e.isEmpty ? e : '${e[0].toUpperCase()}${e.substring(1)}.';
}

/// Invite link for a key holder (GET /invite).
Future<({String code, String link})> fetchInvite(String key) async {
  final r = await workerCall('GET', '/invite?key=${Uri.encodeQueryComponent(key)}');
  if (r.status != 200) throw RelayException(r.status, _err(r));
  return (code: r.body['code'] as String, link: r.body['link'] as String);
}

/// How many friends bought through the invite link (GET /invites). [familyKey] is set once enough did.
Future<({int count, int needed, String? familyKey})> fetchInvites(String key) async {
  final r = await workerCall('GET', '/invites?key=${Uri.encodeQueryComponent(key)}');
  if (r.status != 200) throw RelayException(r.status, _err(r));
  return (count: r.body['count'] as int? ?? 0, needed: r.body['needed'] as int? ?? 3, familyKey: r.body['familyKey'] as String?);
}

/// Renews a team license (POST /team-license/refresh). Null when the worker can't right now; the reason is logged.
Future<String?> refreshTeamLicense(String token) async {
  try {
    final r = await workerCall('POST', '/team-license/refresh', body: {'token': token});
    if (r.status == 200 && r.body['token'] is String) return r.body['token'] as String;
    debugPrint('team license refresh: ${r.status} ${r.body['error']}');
  } on RelayException catch (e) {
    debugPrint('team license refresh: ${e.message}');
  }
  return null;
}

/// App Store purchase -> license key (POST /iap/apple). Returns the key, or throws with the worker's reason.
Future<({String key, int seats})> appleLicenseKey(String signedTransaction) async {
  final r = await workerCall('POST', '/iap/apple', body: {'signedTransaction': signedTransaction});
  if (r.status != 200 || r.body['key'] is! String) throw RelayException(r.status, _err(r));
  final key = r.body['key'] as String;
  if (!await verifyLicense(key)) throw RelayException(r.status, 'The server sent a license key this app doesn\'t accept.');
  return (key: key, seats: r.body['seats'] as int? ?? 1);
}

// ---------------------------------------------------------------- the store

/// Talks to the App Store or Google Play through the in_app_purchase plugin. One instance for the app, started
/// at launch on store builds so purchases that finished while the app was closed are picked up.
class Store {
  Store(this._iap, this.front);
  static Store? _instance;
  static Store get instance => _instance ??= Store(InAppPurchase.instance, storefront);

  final InAppPurchase _iap;
  final Storefront front;
  Vault? _vault;
  StreamSubscription<List<PurchaseDetails>>? _sub;

  /// Store prices by product id, straight from the store (never typed into the app).
  final products = ValueNotifier<Map<String, ProductDetails>>({});
  /// Null while loading; otherwise why the store can't sell right now ('' when it can).
  final problem = ValueNotifier<String?>(null);
  /// The latest thing to tell the person (purchase done, canceled, failed, ...).
  final message = ValueNotifier<String?>(null);
  final busy = ValueNotifier<bool>(false);
  /// Called after a purchase unlocks Premium (the app refreshes its Premium state).
  VoidCallback? onUnlocked;

  /// Starts listening (once) and points purchases at [vault].
  void attach(Vault vault) {
    _vault = vault;
    _sub ??= _iap.purchaseStream.listen(handle, onError: (Object e) => message.value = 'The store reported a problem: $e');
  }

  Future<void> loadProducts() async {
    problem.value = null;
    try {
      if (!await _iap.isAvailable()) {
        problem.value = front == Storefront.google
            ? 'Google Play isn\'t available on this device, so Premium can\'t be bought here. If you bought Premium elsewhere, enter your license key below.'
            : 'The App Store isn\'t available right now. Check your internet connection and try again.';
        return;
      }
      final r = await _iap.queryProductDetails(storeProductIds);
      products.value = {for (final p in r.productDetails) p.id: p};
      problem.value = r.productDetails.isEmpty
          ? 'The ${front == Storefront.google ? 'Play Store' : 'App Store'} didn\'t list Premium just now${r.error == null ? '' : ' (${r.error!.message})'}. Try again in a little while.'
          : '';
    } catch (e) {
      problem.value = 'Couldn\'t load prices from the store: $e';
    }
  }

  Future<void> buy(String productId) async {
    final p = products.value[productId];
    if (p == null) return;
    message.value = null;
    busy.value = true;
    try {
      await _iap.buyNonConsumable(purchaseParam: PurchaseParam(productDetails: p));
    } catch (e) {
      busy.value = false;
      message.value = 'The purchase couldn\'t start: $e';
    }
  }

  Future<void> restore() async {
    message.value = null;
    busy.value = true;
    try {
      await _iap.restorePurchases();
      // The store sends restored purchases through the stream; if there are none, nothing arrives.
      Timer(const Duration(seconds: 8), () {
        if (busy.value) {
          busy.value = false;
          message.value ??= 'No Premium purchase was found for this ${front == Storefront.google ? 'Google' : 'Apple'} account.';
        }
      });
    } catch (e) {
      busy.value = false;
      message.value = 'Couldn\'t restore purchases: $e';
    }
  }

  /// Handles what the store sends: unlock on a purchase or restore, say what happened otherwise.
  Future<void> handle(List<PurchaseDetails> list) async {
    for (final p in list) {
      switch (p.status) {
        case PurchaseStatus.pending:
          message.value = 'Waiting for the payment to be approved. Premium unlocks as soon as it is.';
          continue; // finished later, in another update
        case PurchaseStatus.canceled:
          busy.value = false;
          message.value = 'Purchase canceled. You weren\'t charged.';
        case PurchaseStatus.error:
          busy.value = false;
          message.value = 'The purchase didn\'t go through: ${p.error?.message ?? 'the store gave no reason'}. You weren\'t charged.';
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          if (storeProductIds.contains(p.productID) && _vault != null) await _unlock(_vault!, p);
          busy.value = false;
      }
      // Only after the unlock is saved: an unfinished purchase is sent again at the next launch.
      if (p.pendingCompletePurchase) await _iap.completePurchase(p);
    }
  }

  Future<void> _unlock(Vault v, PurchaseDetails p) async {
    final family = p.productID == familyProductId;
    v.settings[storePurchaseKey] = {'product': p.productID, 'store': front.name};
    await v.save();
    onUnlocked?.call();
    if (front != Storefront.apple) {
      message.value = 'Premium unlocked. Thank you so much!';
      return;
    }
    // A key that already covers this purchase needs no new one (restores happen often).
    final have = v.settings['license'];
    if (have is String && await verifyLicense(have) && licenseSeats(have) >= (family ? 5 : 1)) {
      message.value = 'Premium unlocked. Thank you so much!';
      return;
    }
    try {
      final k = await appleLicenseKey(p.verificationData.serverVerificationData);
      v.settings['license'] = k.key;
      await v.save();
      onUnlocked?.call();
      message.value = 'Premium unlocked. Your license key for your computers is below.';
    } on RelayException catch (e) {
      message.value = 'Premium is unlocked on this device. The key for your computers couldn\'t be made yet: ${e.message} '
          'Tap Restore Purchases later to try again.';
    }
  }

  @visibleForTesting
  Future<void> dispose() async => _sub?.cancel();
}
