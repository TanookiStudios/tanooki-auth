import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/license.dart';
import '../core/store.dart';
import '../core/sync/relay_client.dart' show RelayException;
import '../core/vault.dart';
import 'app_icon.dart';
import 'theme.dart';
import '../l10n/l10n.dart';

/// Stripe Payment Link for the $5 Premium purchase (Mac, Windows, Android sideload). After paying, Stripe
/// redirects to the key page (worker/), which shows the buyer's license key.
const checkoutUrl = 'https://buy.stripe.com/fZubJ3dsP5kv5xZ2kr1VK03';

/// TODO(maddie): Stripe Payment Link for the $10 family plan (up to 5 people). Empty until Maddie creates
/// it in the Stripe Dashboard; while empty the Premium screen says "Family plan coming soon".
const familyCheckoutUrl = '';

/// TODO(maddie): Stripe Payment Link for the $20/year team vault subscription (up to 10 people). Its "after
/// payment" page must be the worker's /team-license?session_id={CHECKOUT_SESSION_ID}. Empty until Maddie makes
/// it; while empty the Team screen says "Team plan coming soon".
const teamCheckoutUrl = '';

/// Stripe link that sells a gift: the worker's /thanks shows a printable gift card instead of the buyer's key.
String giftUrl(String paymentLink) => '$paymentLink?client_reference_id=gift';

/// "$5 once" on the Stripe builds; store builds never type a price in (the store's own price is on the buy button).
String get payOnce => storefront == Storefront.stripe ? l10n.premiumFiveOnce : l10n.premiumPayOnce;

final premium = ValueNotifier<bool>(false);
final themeChoice = ValueNotifier<String>('auto');

/// Reads Premium and the chosen theme from the vault. A Premium theme without Premium falls back to Auto.
/// On store builds it also starts listening to the store, so a purchase that finished while the app was
/// closed still unlocks.
Future<void> loadPremiumAndTheme(Vault vault) async {
  premium.value = await hasPremium(vault);
  final t = vault.settings['theme'] as String? ?? 'auto';
  themeChoice.value = themeChoices.containsKey(t) && (freeThemes.contains(t) || premium.value) ? t : 'auto';
  if (storefront != Storefront.stripe) {
    Store.instance
      ..onUnlocked = (() => premium.value = true)
      ..attach(vault);
  }
}

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key, required this.vault, this.store});
  final Vault vault;
  /// Tests pass a store with a fake behind it; the app uses [Store.instance].
  final Store? store;

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  Store? get _store => storefront == Storefront.stripe ? null : widget.store ?? Store.instance;
  ({String code, String link})? _invite;
  String? _inviteNote;
  bool _inviteBusy = false;

  @override
  void initState() {
    super.initState();
    final s = _store;
    if (s != null) {
      s.attach(widget.vault);
      s.message.addListener(_refresh);
      s.loadProducts();
    }
  }

  @override
  void dispose() {
    _store?.message.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  void _say(String msg) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(msg)));

  Future<void> _buy(String url) async {
    if (url.isEmpty) {
      _say(l10n.premiumCheckoutSoon);
      return;
    }
    await launchUrl(Uri.parse(url));
  }

  Future<void> _enterKey() async {
    final field = TextEditingController();
    final key = await showDialog<String>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(l10n.premiumEnterKeyTitle),
        content: TextField(
          controller: field,
          autofocus: true,
          maxLines: 3,
          autocorrect: false,
          decoration: InputDecoration(hintText: l10n.premiumEnterKeyHint),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: Text(l10n.commonCancel)),
          FilledButton(onPressed: () => Navigator.pop(c, field.text.trim()), child: Text(l10n.commonUnlock)),
        ],
      ),
    );
    if (key == null || key.isEmpty) return;
    if (!await verifyLicense(key)) {
      _say(l10n.premiumBadKey);
      return;
    }
    widget.vault.settings['license'] = key;
    await widget.vault.save();
    premium.value = true;
    if (mounted) setState(() {});
    _say(l10n.storeUnlocked);
  }

  String? get _key {
    final k = widget.vault.settings['license'];
    return k is String ? k : null;
  }

  Future<void> _getInvite() async {
    setState(() => _inviteBusy = true);
    try {
      final inv = await fetchInvite(_key!);
      setState(() => _invite = inv);
    } on RelayException catch (e) {
      _say(e.message);
    } finally {
      if (mounted) setState(() => _inviteBusy = false);
    }
  }

  Future<void> _checkInvites() async {
    setState(() => _inviteBusy = true);
    try {
      final r = await fetchInvites(_key!);
      final fk = r.familyKey;
      if (fk != null && await verifyLicense(fk)) {
        widget.vault.settings['license'] = fk;
        await widget.vault.save();
        premium.value = true;
        _inviteNote = l10n.premiumInvitesNowFamily(r.count);
      } else if (licenseSeats(_key!) >= 5) {
        _inviteNote = l10n.premiumInvitesAlreadyFamily(r.count);
      } else {
        _inviteNote = l10n.premiumInvitesProgress(r.count, r.needed, r.needed - r.count);
      }
    } on RelayException catch (e) {
      _say(e.message);
    } finally {
      if (mounted) setState(() => _inviteBusy = false);
    }
  }

  Future<void> _copy(String text, String copied) async {
    await Clipboard.setData(ClipboardData(text: text));
    _say(copied);
  }

  Future<void> _share(String text) async {
    try {
      final box = context.findRenderObject() as RenderBox?;
      await SharePlus.instance.share(ShareParams(
        text: text,
        sharePositionOrigin: box == null ? null : box.localToGlobal(Offset.zero) & box.size,
      ));
    } catch (_) {
      await _copy(text, l10n.premiumInviteLinkCopied);
    }
  }

  Widget _wide(Widget child) => SizedBox(width: double.infinity, child: child);
  ButtonStyle get _tall => FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14));
  ButtonStyle get _tallOutlined => OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14));

  Widget _storeButtons(Store s) => ValueListenableBuilder<String?>(
        valueListenable: s.problem,
        builder: (_, problem, _) {
          if (problem == null) {
            return const Center(child: Padding(padding: EdgeInsets.all(12), child: CircularProgressIndicator()));
          }
          if (problem.isNotEmpty) {
            return Column(children: [
              Text(problem, textAlign: TextAlign.center, style: TextStyle(color: Palette.muted, height: 1.4)),
              TextButton(onPressed: s.loadProducts, child: Text(l10n.commonTryAgain)),
            ]);
          }
          return ValueListenableBuilder<bool>(
            valueListenable: s.busy,
            builder: (_, busy, _) {
              final single = s.products.value[premiumProductId], family = s.products.value[familyProductId];
              return Column(children: [
                if (single != null)
                  _wide(FilledButton(
                    key: const ValueKey('buy-premium'),
                    onPressed: busy ? null : () => s.buy(premiumProductId),
                    style: _tall,
                    child: Text(l10n.premiumJustMe(single.price), style: const TextStyle(fontSize: 16)),
                  )),
                if (family != null) ...[
                  const SizedBox(height: 10),
                  _wide(OutlinedButton(
                    key: const ValueKey('buy-family'),
                    onPressed: busy ? null : () => s.buy(familyProductId),
                    style: _tallOutlined,
                    child: Text(l10n.premiumFamilyPrice(family.price), style: const TextStyle(fontSize: 16)),
                  )),
                  const SizedBox(height: 6),
                  Text(
                      s.front == Storefront.apple
                          ? l10n.premiumFamilyApple
                          : l10n.premiumFamilyKey,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Palette.muted, fontSize: 13, height: 1.4)),
                ],
                if (busy) const Padding(padding: EdgeInsets.only(top: 12), child: LinearProgressIndicator()),
              ]);
            },
          );
        },
      );

  Widget _keyCard(String key) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(l10n.premiumYourKey, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
            const SizedBox(height: 4),
            Text(l10n.premiumYourKeyHelp,
                style: TextStyle(color: Palette.muted, height: 1.4)),
            const SizedBox(height: 10),
            SelectableText(key, key: const ValueKey('license-key'), style: const TextStyle(fontFamily: 'monospace', fontSize: 13)),
            const SizedBox(height: 8),
            OutlinedButton.icon(onPressed: () => _copy(key, l10n.premiumKeyCopied), icon: const Icon(Icons.copy, size: 18), label: Text(l10n.premiumCopyKey)),
          ]),
        ),
      );

  Widget _inviteCard() => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(l10n.premiumInviteFriends, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
            const SizedBox(height: 4),
            Text(l10n.premiumInviteHelp, style: TextStyle(color: Palette.muted, height: 1.4)),
            const SizedBox(height: 10),
            if (_invite == null)
              OutlinedButton.icon(
                onPressed: _inviteBusy ? null : _getInvite,
                icon: const Icon(Icons.card_giftcard, size: 18),
                label: Text(l10n.premiumGetInvite),
              )
            else ...[
              SelectableText(_invite!.link, key: const ValueKey('invite-link'), style: const TextStyle(fontSize: 13)),
              const SizedBox(height: 8),
              Wrap(spacing: 8, runSpacing: 8, children: [
                FilledButton.icon(onPressed: () => _share(_invite!.link), icon: const Icon(Icons.ios_share, size: 18), label: Text(l10n.commonShare)),
                OutlinedButton.icon(onPressed: () => _copy(_invite!.link, l10n.premiumInviteLinkCopied), icon: const Icon(Icons.copy, size: 18), label: Text(l10n.commonCopy)),
              ]),
            ],
            const SizedBox(height: 4),
            TextButton(onPressed: _inviteBusy ? null : _checkInvites, child: Text(l10n.premiumCheckInvites)),
            if (_inviteNote != null) Text(_inviteNote!, key: const ValueKey('invite-note'), style: const TextStyle(height: 1.4)),
            if (_inviteBusy) const Padding(padding: EdgeInsets.only(top: 8), child: LinearProgressIndicator()),
          ]),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final owned = premium.value;
    final key = _key;
    final purchase = (widget.vault.settings[storePurchaseKey] as Map?)?.cast<String, dynamic>();
    final family = owned && ((key != null && licenseSeats(key) > 1) || purchase?['product'] == familyProductId);
    final offer = PremiumOffer(storefront, owned: owned, hasKey: key != null && owned, teamCheckoutUrl: teamCheckoutUrl);
    final store = _store;
    final stripe = storefront == Storefront.stripe;
    final message = store?.message.value;
    Widget perk(IconData icon, String title, String body) => Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(icon, color: Palette.accent),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                const SizedBox(height: 2),
                Text(body, style: TextStyle(color: Palette.muted, height: 1.4)),
              ]),
            ),
          ]),
        );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.commonPremiumBadge)),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(owned ? l10n.premiumYouHave : l10n.premiumTitle,
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text(
                  owned
                      ? (family
                          ? l10n.premiumOwnedFamily
                          : l10n.premiumOwnedThanks)
                      // Store builds show the store's own prices on the buttons, never typed-in ones.
                      : stripe
                          ? l10n.premiumPitchStripe
                          : l10n.premiumPitchStore,
                  style: TextStyle(color: Palette.muted, fontSize: 16)),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 4),
                  child: Column(children: [
                    perk(Icons.palette_outlined, l10n.premiumPerkThemes, l10n.premiumPerkThemesBody(themeChoices.length - freeThemes.length - 2)),
                    perk(Icons.apps_outlined, l10n.premiumPerkIcons, l10n.premiumPerkIconsBody(appIcons.length - 6)),
                    perk(Icons.sync, l10n.premiumPerkSync, l10n.premiumPerkSyncBody),
                    perk(Icons.phonelink_lock_outlined, l10n.premiumPerkApprove, l10n.premiumPerkApproveBody),
                    perk(Icons.shield_outlined, l10n.premiumPerkBreach, l10n.premiumPerkBreachBody),
                    perk(Icons.people_outline, l10n.premiumPerkShare, l10n.premiumPerkShareBody),
                    perk(Icons.family_restroom, l10n.premiumPerkFamily, stripe ? l10n.premiumPerkFamilyStripe : l10n.premiumPerkFamilyStore),
                    perk(Icons.auto_awesome_outlined, l10n.premiumPerkFuture, l10n.premiumPerkFutureBody),
                    perk(Icons.favorite_outline, l10n.premiumPerkFree, stripe ? l10n.premiumPerkFreeStripe : l10n.premiumPerkFreeStore),
                  ]),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                l10n.premiumFreeForever,
                style: TextStyle(color: Palette.muted, height: 1.4),
              ),
              const SizedBox(height: 22),
              if (offer.storeBuy && store != null) _storeButtons(store),
              if (offer.stripeBuy) ...[
                _wide(FilledButton(
                  onPressed: () => _buy(checkoutUrl),
                  style: _tall,
                  child: Text(l10n.premiumJustMe('\$5'), style: const TextStyle(fontSize: 16)),
                )),
                const SizedBox(height: 10),
                if (familyCheckoutUrl.isEmpty)
                  Center(child: Text(l10n.premiumFamilySoon, style: TextStyle(color: Palette.muted)))
                else
                  _wide(OutlinedButton(
                    onPressed: () => _buy(familyCheckoutUrl),
                    style: _tallOutlined,
                    child: Text(l10n.premiumFamilyPrice('\$10'), style: const TextStyle(fontSize: 16)),
                  )),
                const SizedBox(height: 6),
                Text(l10n.premiumFamilyKeyEach,
                    textAlign: TextAlign.center, style: TextStyle(color: Palette.muted, fontSize: 13, height: 1.4)),
              ],
              if (message != null) ...[
                const SizedBox(height: 12),
                Text(message, key: const ValueKey('store-message'), textAlign: TextAlign.center, style: const TextStyle(height: 1.4)),
              ],
              if (offer.restore && store != null)
                Center(
                  child: ValueListenableBuilder<bool>(
                    valueListenable: store.busy,
                    builder: (_, busy, _) => TextButton(onPressed: busy ? null : store.restore, child: Text(l10n.premiumRestore)),
                  ),
                ),
              if (offer.enterKey) ...[
                const SizedBox(height: 8),
                Center(
                  child: TextButton(onPressed: _enterKey, child: Text(l10n.premiumAlreadyBought)),
                ),
              ],
              if (owned && key != null) ...[const SizedBox(height: 8), _keyCard(key)],
              if (owned && key == null && offer.desktopKeyComingSoon && purchase != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(l10n.premiumDesktopKeySoon,
                      style: TextStyle(color: Palette.muted, height: 1.4)),
                ),
              if (offer.invites) ...[const SizedBox(height: 8), _inviteCard()],
              if (offer.gift) ...[
                const SizedBox(height: 14),
                _wide(OutlinedButton.icon(
                  key: const ValueKey('gift'),
                  onPressed: () => _buy(giftUrl(checkoutUrl)),
                  style: _tallOutlined,
                  icon: const Icon(Icons.redeem),
                  label: Text(l10n.premiumGift('\$5')),
                )),
                if (familyCheckoutUrl.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _wide(OutlinedButton.icon(
                    onPressed: () => _buy(giftUrl(familyCheckoutUrl)),
                    style: _tallOutlined,
                    icon: const Icon(Icons.redeem),
                    label: Text(l10n.premiumGiftFamily('\$10')),
                  )),
                ],
                const SizedBox(height: 6),
                Text(l10n.premiumGiftHelp,
                    textAlign: TextAlign.center, style: TextStyle(color: Palette.muted, fontSize: 13, height: 1.4)),
              ],
            ]),
          ),
        ),
      ]),
    );
  }
}
