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
import '../l10n/l10n.dart';

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
    if (e.status == 0) throw RelayException(0, l10n.storeServerUnreachable);
    rethrow;
  }
};

String _err(RelayResponse r) {
  final e = r.body['error'] as String?;
  if (e == null) return l10n.storeServerSaidNo(r.status);
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
  if (!await verifyLicense(key)) throw RelayException(r.status, l10n.storeBadKey);
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
    _sub ??= _iap.purchaseStream.listen(handle, onError: (Object e) => message.value = l10n.storeReportedProblem('$e'));
  }

  Future<void> loadProducts() async {
    problem.value = null;
    try {
      if (!await _iap.isAvailable()) {
        problem.value = front == Storefront.google
            ? l10n.storeGooglePlayUnavailable
            : l10n.storeAppStoreUnavailable;
        return;
      }
      final r = await _iap.queryProductDetails(storeProductIds);
      products.value = {for (final p in r.productDetails) p.id: p};
      problem.value = r.productDetails.isEmpty
          ? r.error == null
              ? l10n.storeNotListed(front == Storefront.google ? 'Play Store' : 'App Store')
              : l10n.storeNotListedWithError(front == Storefront.google ? 'Play Store' : 'App Store', r.error!.message)
          : '';
    } catch (e) {
      problem.value = l10n.storePricesFailed('$e');
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
      message.value = l10n.storePurchaseCouldNotStart('$e');
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
          message.value ??= l10n.storeNothingToRestore(front == Storefront.google ? 'Google' : 'Apple');
        }
      });
    } catch (e) {
      busy.value = false;
      message.value = l10n.storeRestoreFailed('$e');
    }
  }

  /// Handles what the store sends: unlock on a purchase or restore, say what happened otherwise.
  Future<void> handle(List<PurchaseDetails> list) async {
    for (final p in list) {
      switch (p.status) {
        case PurchaseStatus.pending:
          message.value = l10n.storePending;
          continue; // finished later, in another update
        case PurchaseStatus.canceled:
          busy.value = false;
          message.value = l10n.storeCanceled;
        case PurchaseStatus.error:
          busy.value = false;
          message.value = p.error?.message == null ? l10n.storeFailedNoReason : l10n.storeFailed(p.error!.message);
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
      message.value = l10n.storeUnlocked;
      return;
    }
    // A key that already covers this purchase needs no new one (restores happen often).
    final have = v.settings['license'];
    if (have is String && await verifyLicense(have) && licenseSeats(have) >= (family ? 5 : 1)) {
      message.value = l10n.storeUnlocked;
      return;
    }
    try {
      final k = await appleLicenseKey(p.verificationData.serverVerificationData);
      v.settings['license'] = k.key;
      await v.save();
      onUnlocked?.call();
      message.value = l10n.storeUnlockedWithKey;
    } on RelayException catch (e) {
      message.value = l10n.storeUnlockedKeyFailed(e.message);
    }
  }

  @visibleForTesting
  Future<void> dispose() async => _sub?.cancel();
}
