import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ja.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('ja'),
  ];

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get commonOk;

  /// No description provided for @commonRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get commonRemove;

  /// No description provided for @commonUnlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get commonUnlock;

  /// No description provided for @commonTurnOff.
  ///
  /// In en, this message translates to:
  /// **'Turn off'**
  String get commonTurnOff;

  /// No description provided for @commonNotNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get commonNotNow;

  /// No description provided for @commonNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get commonNext;

  /// No description provided for @commonDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get commonDone;

  /// No description provided for @commonDeny.
  ///
  /// In en, this message translates to:
  /// **'Deny'**
  String get commonDeny;

  /// No description provided for @commonAllow.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get commonAllow;

  /// No description provided for @commonTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get commonTryAgain;

  /// No description provided for @commonStop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get commonStop;

  /// No description provided for @commonShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get commonShare;

  /// No description provided for @commonOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get commonOpen;

  /// No description provided for @commonCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get commonCopy;

  /// No description provided for @commonContinueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get commonContinueLabel;

  /// No description provided for @commonClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get commonClear;

  /// No description provided for @commonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// No description provided for @commonAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get commonAdd;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// No description provided for @commonEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get commonEdit;

  /// No description provided for @commonYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get commonYes;

  /// No description provided for @commonNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get commonNo;

  /// No description provided for @commonSeePremium.
  ///
  /// In en, this message translates to:
  /// **'See Premium'**
  String get commonSeePremium;

  /// No description provided for @commonPremiumBadge.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get commonPremiumBadge;

  /// No description provided for @commonAppName.
  ///
  /// In en, this message translates to:
  /// **'Tanooki Auth'**
  String get commonAppName;

  /// No description provided for @googleMigrationUnreadable.
  ///
  /// In en, this message translates to:
  /// **'That Google Authenticator code couldn\'t be read.'**
  String get googleMigrationUnreadable;

  /// No description provided for @googleMigrationDamaged.
  ///
  /// In en, this message translates to:
  /// **'That Google Authenticator code is damaged.'**
  String get googleMigrationDamaged;

  /// No description provided for @googleMigrationEmpty.
  ///
  /// In en, this message translates to:
  /// **'That Google Authenticator code has no accounts in it.'**
  String get googleMigrationEmpty;

  /// No description provided for @googleMigrationNoSecret.
  ///
  /// In en, this message translates to:
  /// **'An account in that code has no secret.'**
  String get googleMigrationNoSecret;

  /// No description provided for @googleMigrationMd5.
  ///
  /// In en, this message translates to:
  /// **'An account in that code uses MD5, which Tanooki Auth doesn\'t support.'**
  String get googleMigrationMd5;

  /// No description provided for @googleCantTakeSteam.
  ///
  /// In en, this message translates to:
  /// **'Steam codes'**
  String get googleCantTakeSteam;

  /// No description provided for @googleCantTakeDigits.
  ///
  /// In en, this message translates to:
  /// **'{digits}-digit codes'**
  String googleCantTakeDigits(int digits);

  /// No description provided for @googleCantTakePeriod.
  ///
  /// In en, this message translates to:
  /// **'codes that change every {seconds} seconds'**
  String googleCantTakePeriod(int seconds);

  /// No description provided for @otpauthNotALink.
  ///
  /// In en, this message translates to:
  /// **'That is not an otpauth:// link.'**
  String get otpauthNotALink;

  /// No description provided for @otpauthNoSecret.
  ///
  /// In en, this message translates to:
  /// **'The link has no secret.'**
  String get otpauthNoSecret;

  /// No description provided for @otpauthUnsupportedType.
  ///
  /// In en, this message translates to:
  /// **'Unsupported code type \"{type}\".'**
  String otpauthUnsupportedType(String type);

  /// No description provided for @otpauthUnsupportedAlgorithm.
  ///
  /// In en, this message translates to:
  /// **'Unsupported algorithm \"{algorithm}\".'**
  String otpauthUnsupportedAlgorithm(String algorithm);

  /// No description provided for @otpauthBadDigits.
  ///
  /// In en, this message translates to:
  /// **'Digits must be 6, 7 or 8.'**
  String get otpauthBadDigits;

  /// No description provided for @otpauthBadPeriod.
  ///
  /// In en, this message translates to:
  /// **'Period must be a positive number.'**
  String get otpauthBadPeriod;

  /// No description provided for @otpauthBadCounter.
  ///
  /// In en, this message translates to:
  /// **'Counter must be zero or more.'**
  String get otpauthBadCounter;

  /// No description provided for @phoneLinkNotAPairingCode.
  ///
  /// In en, this message translates to:
  /// **'That isn\'t a Tanooki Auth browser pairing code.'**
  String get phoneLinkNotAPairingCode;

  /// No description provided for @phoneLinkNotSavedFor.
  ///
  /// In en, this message translates to:
  /// **'That account isn\'t saved for {host}.'**
  String phoneLinkNotSavedFor(String host);

  /// No description provided for @phoneLinkPushNotSetUp.
  ///
  /// In en, this message translates to:
  /// **'Notifications aren\'t set up on the Tanooki Auth server yet, so requests only show up while the app is open.'**
  String get phoneLinkPushNotSetUp;

  /// No description provided for @phoneLinkPushFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t turn on notifications (HTTP {status}).'**
  String phoneLinkPushFailed(int status);

  /// No description provided for @qrImageNotAPicture.
  ///
  /// In en, this message translates to:
  /// **'That file is not a picture this app can read.'**
  String get qrImageNotAPicture;

  /// No description provided for @qrImageNoQr.
  ///
  /// In en, this message translates to:
  /// **'No QR code found in that picture.'**
  String get qrImageNoQr;

  /// No description provided for @relayBadAnswer.
  ///
  /// In en, this message translates to:
  /// **'The sync server sent an answer the app doesn\'t understand (HTTP {status}).'**
  String relayBadAnswer(int status);

  /// No description provided for @relayUnreachable.
  ///
  /// In en, this message translates to:
  /// **'Can\'t reach the sync server. Check your internet connection.'**
  String get relayUnreachable;

  /// No description provided for @relayTimeout.
  ///
  /// In en, this message translates to:
  /// **'The sync server didn\'t answer in time. Check your internet connection.'**
  String get relayTimeout;

  /// No description provided for @relayInsecure.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t make a secure connection to the sync server.'**
  String get relayInsecure;

  /// No description provided for @relaySaidNo.
  ///
  /// In en, this message translates to:
  /// **'The sync server said no (HTTP {status}).'**
  String relaySaidNo(int status);

  /// No description provided for @shareNotAShare.
  ///
  /// In en, this message translates to:
  /// **'That isn\'t a Tanooki Auth shared account.'**
  String get shareNotAShare;

  /// No description provided for @shareExpired.
  ///
  /// In en, this message translates to:
  /// **'This share has expired (they only last 24 hours). Ask for a new one.'**
  String get shareExpired;

  /// No description provided for @shareWrongCode.
  ///
  /// In en, this message translates to:
  /// **'Wrong code, or the share is damaged. Check the 6 digits and try again.'**
  String get shareWrongCode;

  /// No description provided for @storeServerUnreachable.
  ///
  /// In en, this message translates to:
  /// **'Can\'t reach the Tanooki Auth server. Check your internet connection and try again.'**
  String get storeServerUnreachable;

  /// No description provided for @storeBadKey.
  ///
  /// In en, this message translates to:
  /// **'The server sent a license key this app doesn\'t accept.'**
  String get storeBadKey;

  /// No description provided for @storeReportedProblem.
  ///
  /// In en, this message translates to:
  /// **'The store reported a problem: {problem}'**
  String storeReportedProblem(String problem);

  /// No description provided for @storeGooglePlayUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Google Play isn\'t available on this device, so Premium can\'t be bought here. If you bought Premium elsewhere, enter your license key below.'**
  String get storeGooglePlayUnavailable;

  /// No description provided for @storeAppStoreUnavailable.
  ///
  /// In en, this message translates to:
  /// **'The App Store isn\'t available right now. Check your internet connection and try again.'**
  String get storeAppStoreUnavailable;

  /// No description provided for @storeNotListed.
  ///
  /// In en, this message translates to:
  /// **'The {store} didn\'t list Premium just now. Try again in a little while.'**
  String storeNotListed(String store);

  /// No description provided for @storeNotListedWithError.
  ///
  /// In en, this message translates to:
  /// **'The {store} didn\'t list Premium just now ({problem}). Try again in a little while.'**
  String storeNotListedWithError(String store, String problem);

  /// No description provided for @storePricesFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load prices from the store: {problem}'**
  String storePricesFailed(String problem);

  /// No description provided for @storePurchaseCouldNotStart.
  ///
  /// In en, this message translates to:
  /// **'The purchase couldn\'t start: {problem}'**
  String storePurchaseCouldNotStart(String problem);

  /// No description provided for @storeNothingToRestore.
  ///
  /// In en, this message translates to:
  /// **'No Premium purchase was found for this {store} account.'**
  String storeNothingToRestore(String store);

  /// No description provided for @storeRestoreFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t restore purchases: {problem}'**
  String storeRestoreFailed(String problem);

  /// No description provided for @storePending.
  ///
  /// In en, this message translates to:
  /// **'Waiting for the payment to be approved. Premium unlocks as soon as it is.'**
  String get storePending;

  /// No description provided for @storeCanceled.
  ///
  /// In en, this message translates to:
  /// **'Purchase canceled. You weren\'t charged.'**
  String get storeCanceled;

  /// No description provided for @storeFailed.
  ///
  /// In en, this message translates to:
  /// **'The purchase didn\'t go through: {problem}. You weren\'t charged.'**
  String storeFailed(String problem);

  /// No description provided for @storeFailedNoReason.
  ///
  /// In en, this message translates to:
  /// **'The purchase didn\'t go through: the store gave no reason. You weren\'t charged.'**
  String get storeFailedNoReason;

  /// No description provided for @storeUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Premium unlocked. Thank you so much!'**
  String get storeUnlocked;

  /// No description provided for @storeUnlockedWithKey.
  ///
  /// In en, this message translates to:
  /// **'Premium unlocked. Your license key for your computers is below.'**
  String get storeUnlockedWithKey;

  /// No description provided for @storeUnlockedKeyFailed.
  ///
  /// In en, this message translates to:
  /// **'Premium is unlocked on this device. The key for your computers couldn\'t be made yet: {problem} Tap Restore Purchases later to try again.'**
  String storeUnlockedKeyFailed(String problem);

  /// No description provided for @storeServerSaidNo.
  ///
  /// In en, this message translates to:
  /// **'The server said no (HTTP {status}).'**
  String storeServerSaidNo(int status);

  /// No description provided for @syncGroupExists.
  ///
  /// In en, this message translates to:
  /// **'A sync group with this passphrase already exists. On a device that\'s already syncing, tap \"Add a device\" and scan its code instead.'**
  String get syncGroupExists;

  /// No description provided for @syncNotASyncCode.
  ///
  /// In en, this message translates to:
  /// **'That isn\'t a Tanooki Auth sync code. On a device that\'s already syncing, open Settings, Sync, Add a device.'**
  String get syncNotASyncCode;

  /// No description provided for @syncWrongPassphrase.
  ///
  /// In en, this message translates to:
  /// **'That passphrase doesn\'t match the one your other devices use. Check it and try again.'**
  String get syncWrongPassphrase;

  /// No description provided for @syncICloudOtherPassphrase.
  ///
  /// In en, this message translates to:
  /// **'Your other Apple devices sync with a different passphrase. Type that one, or start fresh with this one.'**
  String get syncICloudOtherPassphrase;

  /// No description provided for @syncErrorRemoved.
  ///
  /// In en, this message translates to:
  /// **'This device was removed from sync on another device. Turn sync off, then on again to rejoin.'**
  String get syncErrorRemoved;

  /// No description provided for @syncErrorTurnedOff.
  ///
  /// In en, this message translates to:
  /// **'Sync was turned off from another device. Turn it off here too, then on again to start over.'**
  String get syncErrorTurnedOff;

  /// No description provided for @syncErrorTooOften.
  ///
  /// In en, this message translates to:
  /// **'Syncing too often. It will try again in a few minutes.'**
  String get syncErrorTooOften;

  /// No description provided for @syncErrorLimit.
  ///
  /// In en, this message translates to:
  /// **'You\'ve reached the sync limit (2,000 accounts, including deleted ones).'**
  String get syncErrorLimit;

  /// No description provided for @syncErrorICloud.
  ///
  /// In en, this message translates to:
  /// **'iCloud Drive had a problem: {problem}.'**
  String syncErrorICloud(String problem);

  /// No description provided for @syncErrorUnexpected.
  ///
  /// In en, this message translates to:
  /// **'Sync stopped because of an unexpected problem: {problem}'**
  String syncErrorUnexpected(String problem);

  /// No description provided for @syncICloudAppleOnly.
  ///
  /// In en, this message translates to:
  /// **'iCloud only works on iPhone, iPad and Mac.'**
  String get syncICloudAppleOnly;

  /// No description provided for @syncICloudSignedOut.
  ///
  /// In en, this message translates to:
  /// **'iCloud Drive is off on this device. Sign in to iCloud and turn on iCloud Drive in Settings to use it.'**
  String get syncICloudSignedOut;

  /// No description provided for @syncICloudNotInBuild.
  ///
  /// In en, this message translates to:
  /// **'iCloud sync isn\'t switched on in this version of Tanooki Auth yet. Use the Tanooki relay for now; it works on every device.'**
  String get syncICloudNotInBuild;

  /// No description provided for @teamKeyUnopenable.
  ///
  /// In en, this message translates to:
  /// **'The team key sent to this device couldn\'t be opened. Ask the team admin to remove this device and invite it again.'**
  String get teamKeyUnopenable;

  /// No description provided for @teamNotAnInvite.
  ///
  /// In en, this message translates to:
  /// **'That isn\'t a Tanooki Auth team invite. Ask the team admin for a new invite link or QR code.'**
  String get teamNotAnInvite;

  /// No description provided for @teamNotInTeam.
  ///
  /// In en, this message translates to:
  /// **'This device isn\'t in a team.'**
  String get teamNotInTeam;

  /// No description provided for @teamDeletedByAdmin.
  ///
  /// In en, this message translates to:
  /// **'This team was deleted by its admin.'**
  String get teamDeletedByAdmin;

  /// No description provided for @teamDeviceRemoved.
  ///
  /// In en, this message translates to:
  /// **'This device was removed from the team.'**
  String get teamDeviceRemoved;

  /// No description provided for @teamAlreadyInTeam.
  ///
  /// In en, this message translates to:
  /// **'This device is already in a team.'**
  String get teamAlreadyInTeam;

  /// No description provided for @teamNotALicense.
  ///
  /// In en, this message translates to:
  /// **'That isn\'t a team license. It starts with TT1. and comes from the page Stripe shows after you subscribe.'**
  String get teamNotALicense;

  /// No description provided for @teamAlreadyInTeamLeaveFirst.
  ///
  /// In en, this message translates to:
  /// **'This device is already in a team. Leave it first.'**
  String get teamAlreadyInTeamLeaveFirst;

  /// No description provided for @teamGone.
  ///
  /// In en, this message translates to:
  /// **'That team doesn\'t exist any more. Ask the team admin for a new invite.'**
  String get teamGone;

  /// No description provided for @teamInviteUsed.
  ///
  /// In en, this message translates to:
  /// **'That invite has already been used or has expired (they last 7 days and work once). Ask the team admin for a new one.'**
  String get teamInviteUsed;

  /// No description provided for @teamFull.
  ///
  /// In en, this message translates to:
  /// **'That team is full (10 people). The admin has to remove someone first.'**
  String get teamFull;

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About Maddie'**
  String get aboutTitle;

  /// No description provided for @aboutP1.
  ///
  /// In en, this message translates to:
  /// **'I\'m Maddie, an autistic developer who cares, maybe a little too much, about getting the small things right.'**
  String get aboutP1;

  /// No description provided for @aboutP2.
  ///
  /// In en, this message translates to:
  /// **'I\'m a big believer in privacy. The keys that protect your accounts are about as personal as data gets, so Tanooki Auth keeps them encrypted on your own device. No account, no ads, no tracking, and nothing is ever sent to me.'**
  String get aboutP2;

  /// No description provided for @aboutP3.
  ///
  /// In en, this message translates to:
  /// **'Tanooki Auth is free, and I want it to stay that way. Your support is what lets me keep making free privacy apps like this one. If Tanooki Auth suits you, the rest might too — they\'re at madilynthomas.com.'**
  String get aboutP3;

  /// No description provided for @aboutP4.
  ///
  /// In en, this message translates to:
  /// **'So, from me to you: thank you. You\'re not just using an app — you\'re making this whole way of living possible.'**
  String get aboutP4;

  /// No description provided for @aboutSupportAddress.
  ///
  /// In en, this message translates to:
  /// **'Support my work: tanookistudios.com/support'**
  String get aboutSupportAddress;

  /// No description provided for @aboutSupport.
  ///
  /// In en, this message translates to:
  /// **'Support my work'**
  String get aboutSupport;

  /// No description provided for @aboutCredits.
  ///
  /// In en, this message translates to:
  /// **'Credits'**
  String get aboutCredits;

  /// No description provided for @aboutCreditsBody.
  ///
  /// In en, this message translates to:
  /// **'QR codes are read with jsQR (Apache 2.0) in the browser extension and ZXing in the app. Not affiliated with Google, Twilio or Authy; Google Authenticator is a trademark of Google LLC.'**
  String get aboutCreditsBody;

  /// No description provided for @addFromBrowserOne.
  ///
  /// In en, this message translates to:
  /// **'Add from your browser?'**
  String get addFromBrowserOne;

  /// No description provided for @addFromBrowserMany.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Add 1 account from your browser?} other{Add {count} accounts from your browser?}}'**
  String addFromBrowserMany(int count);

  /// No description provided for @addFromGoogleTransfer.
  ///
  /// In en, this message translates to:
  /// **'From a Google Authenticator transfer code:'**
  String get addFromGoogleTransfer;

  /// No description provided for @addCount.
  ///
  /// In en, this message translates to:
  /// **'Add {count}'**
  String addCount(int count);

  /// No description provided for @addNoColor.
  ///
  /// In en, this message translates to:
  /// **'No color'**
  String get addNoColor;

  /// No description provided for @addColorName.
  ///
  /// In en, this message translates to:
  /// **'{name} color'**
  String addColorName(String name);

  /// No description provided for @addServiceLabel.
  ///
  /// In en, this message translates to:
  /// **'Service (e.g. GitHub)'**
  String get addServiceLabel;

  /// No description provided for @addAccountLabel.
  ///
  /// In en, this message translates to:
  /// **'Account (e.g. your email)'**
  String get addAccountLabel;

  /// No description provided for @addWebsiteLabel.
  ///
  /// In en, this message translates to:
  /// **'Website (optional)'**
  String get addWebsiteLabel;

  /// No description provided for @addWebsiteHelp.
  ///
  /// In en, this message translates to:
  /// **'e.g. github.com. The browser extension only fills codes here.'**
  String get addWebsiteHelp;

  /// No description provided for @addTagsLabel.
  ///
  /// In en, this message translates to:
  /// **'Tags (optional)'**
  String get addTagsLabel;

  /// No description provided for @addTagsHelp.
  ///
  /// In en, this message translates to:
  /// **'e.g. work, games. Separate with commas.'**
  String get addTagsHelp;

  /// No description provided for @addFolderLabel.
  ///
  /// In en, this message translates to:
  /// **'Folder (optional)'**
  String get addFolderLabel;

  /// No description provided for @addFolderHelp.
  ///
  /// In en, this message translates to:
  /// **'e.g. Work. Leave empty for no folder.'**
  String get addFolderHelp;

  /// No description provided for @addPickFolder.
  ///
  /// In en, this message translates to:
  /// **'Pick a folder'**
  String get addPickFolder;

  /// No description provided for @addNoFolder.
  ///
  /// In en, this message translates to:
  /// **'No folder'**
  String get addNoFolder;

  /// No description provided for @addNotesLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get addNotesLabel;

  /// No description provided for @addColorLabel.
  ///
  /// In en, this message translates to:
  /// **'Color (optional)'**
  String get addColorLabel;

  /// No description provided for @addEmojiLabel.
  ///
  /// In en, this message translates to:
  /// **'Emoji (optional)'**
  String get addEmojiLabel;

  /// No description provided for @addEmojiHelp.
  ///
  /// In en, this message translates to:
  /// **'Shown instead of the logo, here and on widgets and the watch.'**
  String get addEmojiHelp;

  /// No description provided for @addUseEmoji.
  ///
  /// In en, this message translates to:
  /// **'Use {emoji}'**
  String addUseEmoji(String emoji);

  /// No description provided for @addRequireAuth.
  ///
  /// In en, this message translates to:
  /// **'Ask for {proof} before showing this code'**
  String addRequireAuth(String proof);

  /// No description provided for @addRequireAuthHelp.
  ///
  /// In en, this message translates to:
  /// **'The code stays hidden on the list, and widgets, the watch and Quick pick never show it.'**
  String get addRequireAuthHelp;

  /// No description provided for @addTravelHide.
  ///
  /// In en, this message translates to:
  /// **'Hide in travel mode'**
  String get addTravelHide;

  /// No description provided for @addTravelHidePremium.
  ///
  /// In en, this message translates to:
  /// **'Hide in travel mode (Premium)'**
  String get addTravelHidePremium;

  /// No description provided for @addTravelHideHelp.
  ///
  /// In en, this message translates to:
  /// **'When travel mode is on (Settings), this account disappears from the app until you turn it off.'**
  String get addTravelHideHelp;

  /// No description provided for @addTravelNeedsPremium.
  ///
  /// In en, this message translates to:
  /// **'Travel mode is part of Premium. Get it in Settings > Get Premium.'**
  String get addTravelNeedsPremium;

  /// No description provided for @addAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get addAdvanced;

  /// No description provided for @addAdvancedExisting.
  ///
  /// In en, this message translates to:
  /// **'Only change these if the website told you to. Wrong settings make wrong codes, and the website will refuse them.'**
  String get addAdvancedExisting;

  /// No description provided for @addAdvancedNew.
  ///
  /// In en, this message translates to:
  /// **'Most websites use the normal settings. Only change these if the website told you to.'**
  String get addAdvancedNew;

  /// No description provided for @addType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get addType;

  /// No description provided for @addTypeTotp.
  ///
  /// In en, this message translates to:
  /// **'Time-based (normal)'**
  String get addTypeTotp;

  /// No description provided for @addTypeHotp.
  ///
  /// In en, this message translates to:
  /// **'Counter-based (new code when you ask)'**
  String get addTypeHotp;

  /// No description provided for @addDigits.
  ///
  /// In en, this message translates to:
  /// **'Digits'**
  String get addDigits;

  /// No description provided for @addAlgorithm.
  ///
  /// In en, this message translates to:
  /// **'Algorithm'**
  String get addAlgorithm;

  /// No description provided for @addSha1Normal.
  ///
  /// In en, this message translates to:
  /// **'SHA-1 (normal)'**
  String get addSha1Normal;

  /// No description provided for @addPeriod.
  ///
  /// In en, this message translates to:
  /// **'New code every'**
  String get addPeriod;

  /// No description provided for @addSeconds.
  ///
  /// In en, this message translates to:
  /// **'{seconds} seconds'**
  String addSeconds(int seconds);

  /// No description provided for @addCounter.
  ///
  /// In en, this message translates to:
  /// **'Counter'**
  String get addCounter;

  /// No description provided for @addCounterHelp.
  ///
  /// In en, this message translates to:
  /// **'How many codes have been used so far'**
  String get addCounterHelp;

  /// No description provided for @addNotASharedFile.
  ///
  /// In en, this message translates to:
  /// **'That file isn\'t a Tanooki Auth shared account. Ask the person to share it again.'**
  String get addNotASharedFile;

  /// No description provided for @addAlreadyInList.
  ///
  /// In en, this message translates to:
  /// **'{name} is already in your list.'**
  String addAlreadyInList(String name);

  /// No description provided for @addThisAccount.
  ///
  /// In en, this message translates to:
  /// **'Add this account?'**
  String get addThisAccount;

  /// No description provided for @addNoCameraWindows.
  ///
  /// In en, this message translates to:
  /// **'Windows can\'t use a camera in Tanooki Auth. Open a picture of the QR code or paste the setup link instead.'**
  String get addNoCameraWindows;

  /// No description provided for @addFromGoogle.
  ///
  /// In en, this message translates to:
  /// **'Move from Google Authenticator'**
  String get addFromGoogle;

  /// No description provided for @addFromGoogleSteps.
  ///
  /// In en, this message translates to:
  /// **'On the device with Google Authenticator:\n\n1. Open Google Authenticator.\n2. Tap the menu (☰ or ⋮), then \"Transfer accounts\", then \"Export accounts\".\n3. Pick the accounts and tap Next. It shows a QR code.\n\nThen scan that QR code here. If it shows several QR codes, scan each one.'**
  String get addFromGoogleSteps;

  /// No description provided for @addScan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get addScan;

  /// No description provided for @addOpenPicture.
  ///
  /// In en, this message translates to:
  /// **'Open picture'**
  String get addOpenPicture;

  /// No description provided for @addLookingOnScreen.
  ///
  /// In en, this message translates to:
  /// **'Looking for a QR code on your screen…'**
  String get addLookingOnScreen;

  /// No description provided for @addScreenNoQr.
  ///
  /// In en, this message translates to:
  /// **'No QR code found on your screen. Make sure the whole code is showing and not covered by another window, then try again.'**
  String get addScreenNoQr;

  /// No description provided for @addScreenUnsupported.
  ///
  /// In en, this message translates to:
  /// **'Scanning the screen needs macOS 14 (Sonoma) or newer. Take a screenshot and use \"Open a picture\" instead.'**
  String get addScreenUnsupported;

  /// No description provided for @addScreenFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t take a picture of the screen. Take a screenshot and use \"Open a picture\" instead.'**
  String get addScreenFailed;

  /// No description provided for @addScreenWrongQr.
  ///
  /// In en, this message translates to:
  /// **'Found a QR code on your screen, but it isn\'t a two-factor setup code.'**
  String get addScreenWrongQr;

  /// No description provided for @addScreenPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Let Tanooki Auth see your screen'**
  String get addScreenPermissionTitle;

  /// No description provided for @addScreenPermissionSteps.
  ///
  /// In en, this message translates to:
  /// **'To read a QR code off your screen, your Mac needs to let Tanooki Auth take a picture of it. Tanooki Auth only looks when you press \"Scan my screen\", and the picture never leaves this Mac.\n\n1. Open System Settings (the gear icon in the Dock, or Apple menu > System Settings).\n2. Click \"Privacy & Security\" in the left column.\n3. Click \"Screen & System Audio Recording\".\n4. Turn on the switch next to Tanooki Auth. If it isn\'t in the list, click +, pick Tanooki Auth from Applications, and turn it on.\n5. Your Mac will ask to quit Tanooki Auth. Click \"Quit & Reopen\", then press \"Scan my screen\" again.'**
  String get addScreenPermissionSteps;

  /// No description provided for @addPasteLinksTitle.
  ///
  /// In en, this message translates to:
  /// **'Paste setup links'**
  String get addPasteLinksTitle;

  /// No description provided for @addPasteLinksHint.
  ///
  /// In en, this message translates to:
  /// **'otpauth://totp/...\nOne link per line. You can paste many at once.'**
  String get addPasteLinksHint;

  /// No description provided for @addManyTitle.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Add 1 account?} other{Add {count} accounts?}}'**
  String addManyTitle(int count);

  /// No description provided for @addManyBadLines.
  ///
  /// In en, this message translates to:
  /// **'{count} line(s) can\'t be used; you\'ll see which after.'**
  String addManyBadLines(int count);

  /// No description provided for @addEnterKey.
  ///
  /// In en, this message translates to:
  /// **'Enter setup key'**
  String get addEnterKey;

  /// No description provided for @addSetupKey.
  ///
  /// In en, this message translates to:
  /// **'Setup key'**
  String get addSetupKey;

  /// No description provided for @addSetupKeyHelp.
  ///
  /// In en, this message translates to:
  /// **'The letters and numbers the website shows'**
  String get addSetupKeyHelp;

  /// No description provided for @addBadKey.
  ///
  /// In en, this message translates to:
  /// **'That setup key isn\'t valid. It should only contain letters A–Z and numbers 2–7.'**
  String get addBadKey;

  /// No description provided for @addTitle.
  ///
  /// In en, this message translates to:
  /// **'Add account'**
  String get addTitle;

  /// No description provided for @addScanQr.
  ///
  /// In en, this message translates to:
  /// **'Scan QR code'**
  String get addScanQr;

  /// No description provided for @addScanQrHelp.
  ///
  /// In en, this message translates to:
  /// **'Point the camera at the code the website shows'**
  String get addScanQrHelp;

  /// No description provided for @addNoCameraOn.
  ///
  /// In en, this message translates to:
  /// **'No camera support on {platform}'**
  String addNoCameraOn(String platform);

  /// No description provided for @addScanScreen.
  ///
  /// In en, this message translates to:
  /// **'Scan my screen'**
  String get addScanScreen;

  /// No description provided for @addScanScreenHelp.
  ///
  /// In en, this message translates to:
  /// **'Reads a QR code showing anywhere on your screen'**
  String get addScanScreenHelp;

  /// No description provided for @addScanScreenLinux.
  ///
  /// In en, this message translates to:
  /// **'Not available on Linux yet. Open a screenshot of the QR code instead.'**
  String get addScanScreenLinux;

  /// No description provided for @addFromPhotos.
  ///
  /// In en, this message translates to:
  /// **'Scan a QR code from your photos'**
  String get addFromPhotos;

  /// No description provided for @addFromPicture.
  ///
  /// In en, this message translates to:
  /// **'Open a picture of a QR code'**
  String get addFromPicture;

  /// No description provided for @addFromPhotosHelp.
  ///
  /// In en, this message translates to:
  /// **'Pick a screenshot of the setup page'**
  String get addFromPhotosHelp;

  /// No description provided for @addFromPictureHelp.
  ///
  /// In en, this message translates to:
  /// **'A screenshot of the setup page works'**
  String get addFromPictureHelp;

  /// No description provided for @addPasteLink.
  ///
  /// In en, this message translates to:
  /// **'Paste setup link'**
  String get addPasteLink;

  /// No description provided for @addPasteLinkHelp.
  ///
  /// In en, this message translates to:
  /// **'Links starting with otpauth://, one or many'**
  String get addPasteLinkHelp;

  /// No description provided for @addOpenShared.
  ///
  /// In en, this message translates to:
  /// **'Open a shared account'**
  String get addOpenShared;

  /// No description provided for @addOpenSharedHelp.
  ///
  /// In en, this message translates to:
  /// **'A .{extension} file someone sent you'**
  String addOpenSharedHelp(String extension);

  /// No description provided for @addFromGoogleHelp.
  ///
  /// In en, this message translates to:
  /// **'Bring all your accounts across at once'**
  String get addFromGoogleHelp;

  /// No description provided for @addFromOtherApp.
  ///
  /// In en, this message translates to:
  /// **'Move from another app'**
  String get addFromOtherApp;

  /// No description provided for @addFromOtherAppHelp.
  ///
  /// In en, this message translates to:
  /// **'Aegis, 2FAS, Authy, Bitwarden, 1Password, Apple Passwords, Microsoft'**
  String get addFromOtherAppHelp;

  /// No description provided for @addEnterKeyHelp.
  ///
  /// In en, this message translates to:
  /// **'Type the key shown under \"can\'t scan the code?\"'**
  String get addEnterKeyHelp;

  /// No description provided for @addWrongQr.
  ///
  /// In en, this message translates to:
  /// **'That QR code isn\'t a two-factor setup code.'**
  String get addWrongQr;

  /// No description provided for @addCameraDenied.
  ///
  /// In en, this message translates to:
  /// **'Tanooki Auth isn\'t allowed to use the camera. Turn on camera access for Tanooki Auth in your device\'s Settings, or go back and use a picture or the setup key instead.'**
  String get addCameraDenied;

  /// No description provided for @addCameraFailed.
  ///
  /// In en, this message translates to:
  /// **'The camera couldn\'t start ({problem}). Go back and use a picture or the setup key instead.'**
  String addCameraFailed(String problem);

  /// No description provided for @helpNew030a.
  ///
  /// In en, this message translates to:
  /// **'Step-by-step guides for turning on 2FA at 40 popular sites. When you add or edit an account we have a guide for, there\'s a link to it.'**
  String get helpNew030a;

  /// No description provided for @helpNew030b.
  ///
  /// In en, this message translates to:
  /// **'A short welcome tour the first time you open the app. See it again in Settings > Help.'**
  String get helpNew030b;

  /// No description provided for @helpNew030c.
  ///
  /// In en, this message translates to:
  /// **'Send feedback from Settings > Help. It never includes your accounts or codes.'**
  String get helpNew030c;

  /// No description provided for @helpNew030d.
  ///
  /// In en, this message translates to:
  /// **'This What\'s new page.'**
  String get helpNew030d;

  /// No description provided for @helpNew030e.
  ///
  /// In en, this message translates to:
  /// **'Import from Apple Passwords, and move your accounts to Aegis, 2FAS or Google Authenticator.'**
  String get helpNew030e;

  /// No description provided for @helpNew030f.
  ///
  /// In en, this message translates to:
  /// **'Steam Guard codes, counter-based codes with a \"Next code\" button, and advanced code settings with a live preview.'**
  String get helpNew030f;

  /// No description provided for @helpNew030g.
  ///
  /// In en, this message translates to:
  /// **'Folders, select many accounts at once, sort A to Z or by recently used, and \"Tidy account names\".'**
  String get helpNew030g;

  /// No description provided for @helpNew030h.
  ///
  /// In en, this message translates to:
  /// **'Show an account\'s QR code (after Face ID or your passcode) to move it to another device.'**
  String get helpNew030h;

  /// No description provided for @helpNew030i.
  ///
  /// In en, this message translates to:
  /// **'Unlock with a security key such as a YubiKey (Premium), on newer iPhones, Macs and Windows PCs.'**
  String get helpNew030i;

  /// No description provided for @helpNew030j.
  ///
  /// In en, this message translates to:
  /// **'\"Ask first\" accounts that need Face ID or your passcode before showing the code, and travel mode to hide chosen accounts (Premium).'**
  String get helpNew030j;

  /// No description provided for @helpNew030k.
  ///
  /// In en, this message translates to:
  /// **'Activity history (Premium), \"Codes not working?\" clock check, Test a backup, lock on sleep, and backup reminders.'**
  String get helpNew030k;

  /// No description provided for @helpNew030l.
  ///
  /// In en, this message translates to:
  /// **'Emergency access: let someone you trust ask for your accounts, with days for you to say no.'**
  String get helpNew030l;

  /// No description provided for @helpNew030m.
  ///
  /// In en, this message translates to:
  /// **'Spotlight search, a copied-code Live Activity and a watch face complication (Premium), Copy on open, and Mac \"Clear after one paste\".'**
  String get helpNew030m;

  /// No description provided for @helpNew030n.
  ///
  /// In en, this message translates to:
  /// **'Countdown styles, a color or emoji for each account, Read aloud, an easy-to-read font, and better screen reader support.'**
  String get helpNew030n;

  /// No description provided for @helpNew030o.
  ///
  /// In en, this message translates to:
  /// **'A wide layout for big windows, and seasonal Premium icons.'**
  String get helpNew030o;

  /// No description provided for @helpNew030p.
  ///
  /// In en, this message translates to:
  /// **'Buy Premium inside the app on iPhone and Android, gift it, and invite friends.'**
  String get helpNew030p;

  /// No description provided for @helpNew030q.
  ///
  /// In en, this message translates to:
  /// **'Team vault for sharing codes with up to 10 people. The team plan itself is coming soon.'**
  String get helpNew030q;

  /// No description provided for @helpNew030r.
  ///
  /// In en, this message translates to:
  /// **'The Family plan is coming soon.'**
  String get helpNew030r;

  /// No description provided for @helpNew030s.
  ///
  /// In en, this message translates to:
  /// **'The desktop app now runs on Linux too. Linux downloads are coming soon.'**
  String get helpNew030s;

  /// No description provided for @helpNew020a.
  ///
  /// In en, this message translates to:
  /// **'Sync between your devices, phone link for the browser extension, and secure sharing of one account.'**
  String get helpNew020a;

  /// No description provided for @helpNew020b.
  ///
  /// In en, this message translates to:
  /// **'Passcode, auto-lock, panic wipe, decoy passcode, screenshot blocking, check-up and breach alerts.'**
  String get helpNew020b;

  /// No description provided for @helpNew020c.
  ///
  /// In en, this message translates to:
  /// **'Widgets, Apple Watch and Wear OS apps, the Mac menu bar and Windows tray, and automatic encrypted backups (Premium).'**
  String get helpNew020c;

  /// No description provided for @helpNew020d.
  ///
  /// In en, this message translates to:
  /// **'Importers for Aegis, 2FAS, Authy, Bitwarden and 1Password, plus favorites, tags, notes, recovery codes and Trash.'**
  String get helpNew020d;

  /// No description provided for @helpNew010a.
  ///
  /// In en, this message translates to:
  /// **'The first version: scan or paste accounts, see codes, encrypted backups, and the browser extension.'**
  String get helpNew010a;

  /// No description provided for @helpNoBrowser.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open your web browser. The page is {url}'**
  String helpNoBrowser(String url);

  /// No description provided for @helpGuideFor.
  ///
  /// In en, this message translates to:
  /// **'How to turn on 2FA for {name}'**
  String helpGuideFor(String name);

  /// No description provided for @helpTourWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Tanooki Auth'**
  String get helpTourWelcome;

  /// No description provided for @helpTourWelcomeBody.
  ///
  /// In en, this message translates to:
  /// **'Lots of websites can ask for a 6-digit code as well as your password. That\'s two-factor authentication, or 2FA. Tanooki Auth makes those codes for you, right here on your device, so someone with only your password still can\'t get in.'**
  String get helpTourWelcomeBody;

  /// No description provided for @helpTourAdd.
  ///
  /// In en, this message translates to:
  /// **'Add your first account'**
  String get helpTourAdd;

  /// No description provided for @helpTourAddBody.
  ///
  /// In en, this message translates to:
  /// **'Turn on 2FA in a website\'s security settings. It shows a QR code: scan it here, or copy its setup link and paste it. Already using another authenticator app? Bring your accounts across in one go.'**
  String get helpTourAddBody;

  /// No description provided for @helpTourScanOrPaste.
  ///
  /// In en, this message translates to:
  /// **'Scan a QR code or paste a link'**
  String get helpTourScanOrPaste;

  /// No description provided for @helpTourImport.
  ///
  /// In en, this message translates to:
  /// **'Import from another app'**
  String get helpTourImport;

  /// No description provided for @helpTourPopular.
  ///
  /// In en, this message translates to:
  /// **'Popular sites to protect first'**
  String get helpTourPopular;

  /// No description provided for @helpTourPopularBody.
  ///
  /// In en, this message translates to:
  /// **'Your email, your social media and anywhere with your money matter most. Our step-by-step guides show where the 2FA setting is on each site.'**
  String get helpTourPopularBody;

  /// No description provided for @helpAllGuides.
  ///
  /// In en, this message translates to:
  /// **'All 2FA guides'**
  String get helpAllGuides;

  /// No description provided for @helpTourStep.
  ///
  /// In en, this message translates to:
  /// **'Step {step} of {total}'**
  String helpTourStep(int step, int total);

  /// No description provided for @helpTourSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip tour'**
  String get helpTourSkip;

  /// No description provided for @helpWhatsNew.
  ///
  /// In en, this message translates to:
  /// **'What\'s new'**
  String get helpWhatsNew;

  /// No description provided for @helpVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String helpVersion(String version);

  /// No description provided for @helpVersionThis.
  ///
  /// In en, this message translates to:
  /// **'Version {version} (this version)'**
  String helpVersionThis(String version);

  /// No description provided for @helpFeedbackEmpty.
  ///
  /// In en, this message translates to:
  /// **'Type a message first.'**
  String get helpFeedbackEmpty;

  /// No description provided for @helpFeedbackSent.
  ///
  /// In en, this message translates to:
  /// **'Sent. Thank you! Maddie reads every message.'**
  String get helpFeedbackSent;

  /// No description provided for @helpFeedbackTooLong.
  ///
  /// In en, this message translates to:
  /// **'That\'s too long to send. Please make it shorter (about 4,000 letters at most).'**
  String get helpFeedbackTooLong;

  /// No description provided for @helpFeedbackTooMany.
  ///
  /// In en, this message translates to:
  /// **'You\'ve sent a lot of feedback in the last hour. Please try again in an hour.'**
  String get helpFeedbackTooMany;

  /// No description provided for @helpFeedbackOffline.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t reach the internet. Check your connection and try again. Your message is still here.'**
  String get helpFeedbackOffline;

  /// No description provided for @helpFeedbackServerError.
  ///
  /// In en, this message translates to:
  /// **'The feedback server had a problem and didn\'t take your message. Please try again later. Your message is still here.'**
  String get helpFeedbackServerError;

  /// No description provided for @helpFeedbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Send feedback'**
  String get helpFeedbackTitle;

  /// No description provided for @helpFeedbackIntro.
  ///
  /// In en, this message translates to:
  /// **'Found a bug, or wish the app did something? Tell Maddie here.'**
  String get helpFeedbackIntro;

  /// No description provided for @helpFeedbackMessage.
  ///
  /// In en, this message translates to:
  /// **'Your message'**
  String get helpFeedbackMessage;

  /// No description provided for @helpFeedbackEmail.
  ///
  /// In en, this message translates to:
  /// **'Your email (optional)'**
  String get helpFeedbackEmail;

  /// No description provided for @helpFeedbackEmailHelp.
  ///
  /// In en, this message translates to:
  /// **'Only if you\'d like a reply.'**
  String get helpFeedbackEmailHelp;

  /// No description provided for @helpFeedbackDevice.
  ///
  /// In en, this message translates to:
  /// **'Include app version and device type'**
  String get helpFeedbackDevice;

  /// No description provided for @helpFeedbackDeviceHelp.
  ///
  /// In en, this message translates to:
  /// **'For example \"0.3.0\" and \"iOS\". It helps track down bugs.'**
  String get helpFeedbackDeviceHelp;

  /// No description provided for @helpFeedbackNeverSent.
  ///
  /// In en, this message translates to:
  /// **'Never sent: your accounts, their names, codes, setup keys, tags, notes, or anything else in the app.'**
  String get helpFeedbackNeverSent;

  /// No description provided for @helpFeedbackSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get helpFeedbackSend;

  /// No description provided for @phoneUiPushAndroid.
  ///
  /// In en, this message translates to:
  /// **'Notifications on Android aren\'t set up yet, so requests show up while Tanooki Auth is open.'**
  String get phoneUiPushAndroid;

  /// No description provided for @phoneUiPushThisDevice.
  ///
  /// In en, this message translates to:
  /// **'This device gets requests while Tanooki Auth is open.'**
  String get phoneUiPushThisDevice;

  /// No description provided for @phoneUiPushNoToken.
  ///
  /// In en, this message translates to:
  /// **'iPhone didn\'t give the app a notification token.'**
  String get phoneUiPushNoToken;

  /// No description provided for @phoneUiPushDenied.
  ///
  /// In en, this message translates to:
  /// **'Notifications are turned off for Tanooki Auth. Turn them on in the iPhone Settings app, under Notifications, to get requests when the app is closed.'**
  String get phoneUiPushDenied;

  /// No description provided for @phoneUiPushFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t turn on notifications: {problem}. Requests still show up while Tanooki Auth is open.'**
  String phoneUiPushFailed(String problem);

  /// No description provided for @phoneUiPushNotInBuild.
  ///
  /// In en, this message translates to:
  /// **'Notifications aren\'t available in this build. Requests show up while Tanooki Auth is open.'**
  String get phoneUiPushNotInBuild;

  /// No description provided for @phoneUiPushChecking.
  ///
  /// In en, this message translates to:
  /// **'Checking whether notifications work…'**
  String get phoneUiPushChecking;

  /// No description provided for @phoneUiRequest.
  ///
  /// In en, this message translates to:
  /// **'Sign-in code request'**
  String get phoneUiRequest;

  /// No description provided for @phoneUiNoAccount.
  ///
  /// In en, this message translates to:
  /// **'No account is saved for this website, so there\'s nothing to send. If you expected one, this might be a fake site pretending to be a real one.'**
  String get phoneUiNoAccount;

  /// No description provided for @phoneUiWantsCode.
  ///
  /// In en, this message translates to:
  /// **'Your paired browser wants the code for this website. Only approve if you\'re signing in right now.'**
  String get phoneUiWantsCode;

  /// No description provided for @phoneUiApprove.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get phoneUiApprove;

  /// No description provided for @phoneUiApproveAccount.
  ///
  /// In en, this message translates to:
  /// **'Approve: {name}'**
  String phoneUiApproveAccount(String name);

  /// No description provided for @phoneUiScanTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan the browser\'s code'**
  String get phoneUiScanTitle;

  /// No description provided for @phoneUiScanWrong.
  ///
  /// In en, this message translates to:
  /// **'That isn\'t a browser pairing code. In the browser, click the Tanooki Auth extension, then \"Use my phone instead\".'**
  String get phoneUiScanWrong;

  /// No description provided for @phoneUiPasteTitle.
  ///
  /// In en, this message translates to:
  /// **'Paste the pairing link'**
  String get phoneUiPasteTitle;

  /// No description provided for @phoneUiPair.
  ///
  /// In en, this message translates to:
  /// **'Pair'**
  String get phoneUiPair;

  /// No description provided for @phoneUiPaired.
  ///
  /// In en, this message translates to:
  /// **'Paired. When that browser asks for a code, you\'ll see it here.'**
  String get phoneUiPaired;

  /// No description provided for @phoneUiExpired.
  ///
  /// In en, this message translates to:
  /// **'That code has expired. In the browser, make a new one and scan it again.'**
  String get phoneUiExpired;

  /// No description provided for @phoneUiPremium.
  ///
  /// In en, this message translates to:
  /// **'Using your phone with a browser is part of Premium'**
  String get phoneUiPremium;

  /// No description provided for @phoneUiIntro.
  ///
  /// In en, this message translates to:
  /// **'Fill codes in a browser on any computer, even one without the Tanooki Auth app. The browser extension asks, and you tap Approve here. Codes travel end-to-end encrypted, and only for the website each account is saved for.'**
  String get phoneUiIntro;

  /// No description provided for @phoneUiPairBrowser.
  ///
  /// In en, this message translates to:
  /// **'Pair a browser'**
  String get phoneUiPairBrowser;

  /// No description provided for @phoneUiPairHelp.
  ///
  /// In en, this message translates to:
  /// **'In the browser, click the Tanooki Auth extension, then \"Use my phone instead\" to show the code.'**
  String get phoneUiPairHelp;

  /// No description provided for @phoneUiPairedBrowsers.
  ///
  /// In en, this message translates to:
  /// **'Paired browsers'**
  String get phoneUiPairedBrowsers;

  /// No description provided for @phoneUiNoneYet.
  ///
  /// In en, this message translates to:
  /// **'None yet'**
  String get phoneUiNoneYet;

  /// No description provided for @phoneUiBrowser.
  ///
  /// In en, this message translates to:
  /// **'Browser'**
  String get phoneUiBrowser;

  /// No description provided for @phoneUiPairedOn.
  ///
  /// In en, this message translates to:
  /// **'Paired {date}'**
  String phoneUiPairedOn(DateTime date);

  /// No description provided for @phoneUiUnpair.
  ///
  /// In en, this message translates to:
  /// **'Unpair'**
  String get phoneUiUnpair;

  /// No description provided for @phoneUiPushOn.
  ///
  /// In en, this message translates to:
  /// **'Notifications on'**
  String get phoneUiPushOn;

  /// No description provided for @phoneUiPushOff.
  ///
  /// In en, this message translates to:
  /// **'Requests show while the app is open'**
  String get phoneUiPushOff;

  /// No description provided for @phoneUiPushOnHelp.
  ///
  /// In en, this message translates to:
  /// **'You\'ll get a notification for each request, even when Tanooki Auth is closed.'**
  String get phoneUiPushOnHelp;

  /// No description provided for @phoneUiSendCodeFor.
  ///
  /// In en, this message translates to:
  /// **'Send the code for {name}'**
  String phoneUiSendCodeFor(String name);

  /// No description provided for @phoneUiActivityWhere.
  ///
  /// In en, this message translates to:
  /// **'Browser, through this phone'**
  String get phoneUiActivityWhere;

  /// No description provided for @premiumFiveOnce.
  ///
  /// In en, this message translates to:
  /// **'\$5 once'**
  String get premiumFiveOnce;

  /// No description provided for @premiumPayOnce.
  ///
  /// In en, this message translates to:
  /// **'Pay once'**
  String get premiumPayOnce;

  /// No description provided for @premiumCheckoutSoon.
  ///
  /// In en, this message translates to:
  /// **'Checkout isn\'t open yet; it\'s coming very soon. Thank you for wanting to support Tanooki Auth!'**
  String get premiumCheckoutSoon;

  /// No description provided for @premiumEnterKeyTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter license key'**
  String get premiumEnterKeyTitle;

  /// No description provided for @premiumEnterKeyHint.
  ///
  /// In en, this message translates to:
  /// **'TA1.…  (from your purchase email)'**
  String get premiumEnterKeyHint;

  /// No description provided for @premiumBadKey.
  ///
  /// In en, this message translates to:
  /// **'That license key isn\'t valid. Copy the whole key from your purchase email and try again.'**
  String get premiumBadKey;

  /// No description provided for @premiumInvitesNowFamily.
  ///
  /// In en, this message translates to:
  /// **'{count} friends bought Premium with your link, so your key is now a Family key for up to 5 people. It\'s installed on this device. Copy the new key below and enter it on your other devices too.'**
  String premiumInvitesNowFamily(int count);

  /// No description provided for @premiumInvitesAlreadyFamily.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 friend has bought Premium with your link. Your key is already a Family key.} other{{count} friends have bought Premium with your link. Your key is already a Family key.}}'**
  String premiumInvitesAlreadyFamily(int count);

  /// No description provided for @premiumInvitesProgress.
  ///
  /// In en, this message translates to:
  /// **'{count} of {needed} friends have bought Premium with your link. {left} more and your key becomes a Family key.'**
  String premiumInvitesProgress(int count, int needed, int left);

  /// No description provided for @premiumInviteLinkCopied.
  ///
  /// In en, this message translates to:
  /// **'Invite link copied.'**
  String get premiumInviteLinkCopied;

  /// No description provided for @premiumKeyCopied.
  ///
  /// In en, this message translates to:
  /// **'License key copied.'**
  String get premiumKeyCopied;

  /// No description provided for @premiumJustMe.
  ///
  /// In en, this message translates to:
  /// **'Just me — {price}'**
  String premiumJustMe(String price);

  /// No description provided for @premiumFamilyPrice.
  ///
  /// In en, this message translates to:
  /// **'Family (up to 5 people) — {price}'**
  String premiumFamilyPrice(String price);

  /// No description provided for @premiumFamilyApple.
  ///
  /// In en, this message translates to:
  /// **'Family: shared with your Apple family through Family Sharing, plus a license key for up to 5 people on any device.'**
  String get premiumFamilyApple;

  /// No description provided for @premiumFamilyKey.
  ///
  /// In en, this message translates to:
  /// **'Family: one license key you share with up to 4 other people.'**
  String get premiumFamilyKey;

  /// No description provided for @premiumYourKey.
  ///
  /// In en, this message translates to:
  /// **'Your license key'**
  String get premiumYourKey;

  /// No description provided for @premiumYourKeyHelp.
  ///
  /// In en, this message translates to:
  /// **'Enter it on your other devices: Settings → Get Premium → \"Already bought it? Enter your license key\".'**
  String get premiumYourKeyHelp;

  /// No description provided for @premiumCopyKey.
  ///
  /// In en, this message translates to:
  /// **'Copy key'**
  String get premiumCopyKey;

  /// No description provided for @premiumInviteFriends.
  ///
  /// In en, this message translates to:
  /// **'Invite friends'**
  String get premiumInviteFriends;

  /// No description provided for @premiumInviteHelp.
  ///
  /// In en, this message translates to:
  /// **'Friends get 20% off. When 3 friends buy, your key becomes a Family key.'**
  String get premiumInviteHelp;

  /// No description provided for @premiumGetInvite.
  ///
  /// In en, this message translates to:
  /// **'Get my invite link'**
  String get premiumGetInvite;

  /// No description provided for @premiumCheckInvites.
  ///
  /// In en, this message translates to:
  /// **'Check my invites'**
  String get premiumCheckInvites;

  /// No description provided for @premiumYouHave.
  ///
  /// In en, this message translates to:
  /// **'You have Premium'**
  String get premiumYouHave;

  /// No description provided for @premiumTitle.
  ///
  /// In en, this message translates to:
  /// **'Tanooki Auth Premium'**
  String get premiumTitle;

  /// No description provided for @premiumOwnedFamily.
  ///
  /// In en, this message translates to:
  /// **'Family plan: share your license key with up to 4 other people (5 in all). Thank you for supporting Tanooki Auth.'**
  String get premiumOwnedFamily;

  /// No description provided for @premiumOwnedThanks.
  ///
  /// In en, this message translates to:
  /// **'Thank you for supporting Tanooki Auth.'**
  String get premiumOwnedThanks;

  /// No description provided for @premiumPitchStripe.
  ///
  /// In en, this message translates to:
  /// **'\$5 once, or \$10 for your whole family. Yours forever.'**
  String get premiumPitchStripe;

  /// No description provided for @premiumPitchStore.
  ///
  /// In en, this message translates to:
  /// **'Pay once for you, or once for your whole family. Yours forever.'**
  String get premiumPitchStore;

  /// No description provided for @premiumPerkThemes.
  ///
  /// In en, this message translates to:
  /// **'Every Premium theme'**
  String get premiumPerkThemes;

  /// No description provided for @premiumPerkThemesBody.
  ///
  /// In en, this message translates to:
  /// **'Pastel Pink, Pastel Blue and {count} more, plus every theme added later.'**
  String premiumPerkThemesBody(int count);

  /// No description provided for @premiumPerkIcons.
  ///
  /// In en, this message translates to:
  /// **'App icons'**
  String get premiumPerkIcons;

  /// No description provided for @premiumPerkIconsBody.
  ///
  /// In en, this message translates to:
  /// **'Pick a different home-screen icon on iPhone and Android, in Pastel Pink, Pastel Blue and {count} more colors, plus seasonal ones for fall, winter and spring. On a Mac it changes the Dock icon while the app is open.'**
  String premiumPerkIconsBody(int count);

  /// No description provided for @premiumPerkSync.
  ///
  /// In en, this message translates to:
  /// **'Sync across your devices'**
  String get premiumPerkSync;

  /// No description provided for @premiumPerkSyncBody.
  ///
  /// In en, this message translates to:
  /// **'Add an account on one device and see it on all of them, end-to-end encrypted. Through iCloud on Apple devices, or the Tanooki relay for any mix.'**
  String get premiumPerkSyncBody;

  /// No description provided for @premiumPerkApprove.
  ///
  /// In en, this message translates to:
  /// **'Approve codes from your phone'**
  String get premiumPerkApprove;

  /// No description provided for @premiumPerkApproveBody.
  ///
  /// In en, this message translates to:
  /// **'Use the browser extension on any computer: it asks your phone, you tap Approve, and the code fills in.'**
  String get premiumPerkApproveBody;

  /// No description provided for @premiumPerkBreach.
  ///
  /// In en, this message translates to:
  /// **'Breach alerts'**
  String get premiumPerkBreach;

  /// No description provided for @premiumPerkBreachBody.
  ///
  /// In en, this message translates to:
  /// **'Get told when a website you have an account for is in a known data breach. Checked on your device; nothing about you is sent.'**
  String get premiumPerkBreachBody;

  /// No description provided for @premiumPerkShare.
  ///
  /// In en, this message translates to:
  /// **'Share an account securely'**
  String get premiumPerkShare;

  /// No description provided for @premiumPerkShareBody.
  ///
  /// In en, this message translates to:
  /// **'Give one account to someone you trust with a QR code and a 6-digit code. Locked, expires in 24 hours, no server.'**
  String get premiumPerkShareBody;

  /// No description provided for @premiumPerkFamily.
  ///
  /// In en, this message translates to:
  /// **'Family plan'**
  String get premiumPerkFamily;

  /// No description provided for @premiumPerkFamilyStripe.
  ///
  /// In en, this message translates to:
  /// **'For \$10 instead of \$5, one key unlocks Premium for up to 5 people. Send it to your family and they enter it like you do.'**
  String get premiumPerkFamilyStripe;

  /// No description provided for @premiumPerkFamilyStore.
  ///
  /// In en, this message translates to:
  /// **'One family purchase unlocks Premium for up to 5 people. Send them your license key and they enter it like you do.'**
  String get premiumPerkFamilyStore;

  /// No description provided for @premiumPerkFuture.
  ///
  /// In en, this message translates to:
  /// **'Every future Premium feature'**
  String get premiumPerkFuture;

  /// No description provided for @premiumPerkFutureBody.
  ///
  /// In en, this message translates to:
  /// **'Pay once and get whatever Premium grows into. No subscription, ever.'**
  String get premiumPerkFutureBody;

  /// No description provided for @premiumPerkFree.
  ///
  /// In en, this message translates to:
  /// **'Keeps privacy apps free'**
  String get premiumPerkFree;

  /// No description provided for @premiumPerkFreeStripe.
  ///
  /// In en, this message translates to:
  /// **'Your \$5 is what lets me keep making free apps that don\'t track you.'**
  String get premiumPerkFreeStripe;

  /// No description provided for @premiumPerkFreeStore.
  ///
  /// In en, this message translates to:
  /// **'Buying Premium is what lets me keep making free apps that don\'t track you.'**
  String get premiumPerkFreeStore;

  /// No description provided for @premiumFreeForever.
  ///
  /// In en, this message translates to:
  /// **'Free forever, with or without Premium: unlimited accounts, scanning, backups, the browser extension, and the app lock.'**
  String get premiumFreeForever;

  /// No description provided for @premiumFamilySoon.
  ///
  /// In en, this message translates to:
  /// **'Family plan coming soon'**
  String get premiumFamilySoon;

  /// No description provided for @premiumFamilyKeyEach.
  ///
  /// In en, this message translates to:
  /// **'Family: one license key you share with up to 4 other people. Each of them enters it in their own Tanooki Auth.'**
  String get premiumFamilyKeyEach;

  /// No description provided for @premiumRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore Purchases'**
  String get premiumRestore;

  /// No description provided for @premiumAlreadyBought.
  ///
  /// In en, this message translates to:
  /// **'Already bought it? Enter your license key'**
  String get premiumAlreadyBought;

  /// No description provided for @premiumDesktopKeySoon.
  ///
  /// In en, this message translates to:
  /// **'Desktop key coming soon for Android purchases. Premium is unlocked on this phone now; a license key for your computers will show up here in a later update.'**
  String get premiumDesktopKeySoon;

  /// No description provided for @premiumGift.
  ///
  /// In en, this message translates to:
  /// **'Give Premium as a gift — {price}'**
  String premiumGift(String price);

  /// No description provided for @premiumGiftFamily.
  ///
  /// In en, this message translates to:
  /// **'Give the Family plan as a gift — {price}'**
  String premiumGiftFamily(String price);

  /// No description provided for @premiumGiftHelp.
  ///
  /// In en, this message translates to:
  /// **'After paying you get a printable gift card with a key for them.'**
  String get premiumGiftHelp;

  /// No description provided for @settingsIconFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t change the app icon. Try again, or restart the app.'**
  String get settingsIconFailed;

  /// No description provided for @settingsIconFailedWhy.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t change the app icon ({problem}). Try again, or restart the app.'**
  String settingsIconFailedWhy(String problem);

  /// No description provided for @settingsIconSemantic.
  ///
  /// In en, this message translates to:
  /// **'{name} app icon'**
  String settingsIconSemantic(String name);

  /// No description provided for @settingsIconSemanticPremium.
  ///
  /// In en, this message translates to:
  /// **'{name} app icon, Premium'**
  String settingsIconSemanticPremium(String name);

  /// No description provided for @settingsAppIcon.
  ///
  /// In en, this message translates to:
  /// **'App icon'**
  String get settingsAppIcon;

  /// No description provided for @settingsAppIconPremium.
  ///
  /// In en, this message translates to:
  /// **'App icon (Premium)'**
  String get settingsAppIconPremium;

  /// No description provided for @settingsAppIconIos.
  ///
  /// In en, this message translates to:
  /// **'The icon on your home screen.'**
  String get settingsAppIconIos;

  /// No description provided for @settingsAppIconAndroid.
  ///
  /// In en, this message translates to:
  /// **'The icon on your home screen. It may disappear for a moment while your phone swaps it.'**
  String get settingsAppIconAndroid;

  /// No description provided for @settingsAppIconMac.
  ///
  /// In en, this message translates to:
  /// **'Changes the Dock icon while Tanooki Auth is open. Macs can\'t keep a different icon after the app quits, so Finder and Launchpad keep the blue one.'**
  String get settingsAppIconMac;

  /// No description provided for @settingsAppIconOther.
  ///
  /// In en, this message translates to:
  /// **'App icons can be changed on iPhone and Android.'**
  String get settingsAppIconOther;

  /// No description provided for @settingsLockNameMac.
  ///
  /// In en, this message translates to:
  /// **'Touch ID or your Mac password'**
  String get settingsLockNameMac;

  /// No description provided for @settingsLockNamePhone.
  ///
  /// In en, this message translates to:
  /// **'Face ID, fingerprint, or passcode'**
  String get settingsLockNamePhone;

  /// No description provided for @settingsNoLockSetUp.
  ///
  /// In en, this message translates to:
  /// **'This device has no {lock} set up, so the app can\'t be locked. Set one up in your system settings first.'**
  String settingsNoLockSetUp(String lock);

  /// No description provided for @settingsLockReasonOn.
  ///
  /// In en, this message translates to:
  /// **'Turn on the app lock'**
  String get settingsLockReasonOn;

  /// No description provided for @settingsLockReasonOff.
  ///
  /// In en, this message translates to:
  /// **'Turn off the app lock'**
  String get settingsLockReasonOff;

  /// No description provided for @settingsSetPasscode.
  ///
  /// In en, this message translates to:
  /// **'Set an app passcode'**
  String get settingsSetPasscode;

  /// No description provided for @settingsSetPasscodeIntro.
  ///
  /// In en, this message translates to:
  /// **'Type this to open Tanooki Auth. It also works when Face ID or your fingerprint doesn\'t. If you forget it, the only way back in is a backup.'**
  String get settingsSetPasscodeIntro;

  /// No description provided for @settingsPasscodeOn.
  ///
  /// In en, this message translates to:
  /// **'App passcode on.'**
  String get settingsPasscodeOn;

  /// No description provided for @settingsPasscode.
  ///
  /// In en, this message translates to:
  /// **'App passcode'**
  String get settingsPasscode;

  /// No description provided for @settingsChangePasscode.
  ///
  /// In en, this message translates to:
  /// **'Change passcode'**
  String get settingsChangePasscode;

  /// No description provided for @settingsPasscodeOff.
  ///
  /// In en, this message translates to:
  /// **'Turn passcode off'**
  String get settingsPasscodeOff;

  /// No description provided for @settingsNewPasscode.
  ///
  /// In en, this message translates to:
  /// **'New app passcode'**
  String get settingsNewPasscode;

  /// No description provided for @settingsPasscodeChanged.
  ///
  /// In en, this message translates to:
  /// **'Passcode changed.'**
  String get settingsPasscodeChanged;

  /// No description provided for @settingsPasscodeIsOff.
  ///
  /// In en, this message translates to:
  /// **'App passcode off.'**
  String get settingsPasscodeIsOff;

  /// No description provided for @settingsRemoveDecoyTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove the decoy passcode?'**
  String get settingsRemoveDecoyTitle;

  /// No description provided for @settingsRemoveDecoyBody.
  ///
  /// In en, this message translates to:
  /// **'The decoy accounts are erased. Your real accounts aren\'t touched.'**
  String get settingsRemoveDecoyBody;

  /// No description provided for @settingsSetDecoy.
  ///
  /// In en, this message translates to:
  /// **'Set a decoy passcode'**
  String get settingsSetDecoy;

  /// No description provided for @settingsSetDecoyIntro.
  ///
  /// In en, this message translates to:
  /// **'If someone forces you to open Tanooki Auth, type this one instead. It opens a separate, empty set of accounts, and nothing on screen shows it isn\'t the real one. Add a couple of harmless accounts there so it looks used.\n\nYour real passcode keeps opening your real accounts.'**
  String get settingsSetDecoyIntro;

  /// No description provided for @settingsDecoySet.
  ///
  /// In en, this message translates to:
  /// **'Decoy passcode set.'**
  String get settingsDecoySet;

  /// No description provided for @settingsWipeTitle.
  ///
  /// In en, this message translates to:
  /// **'Erase everything after {count} wrong passcodes?'**
  String settingsWipeTitle(int count);

  /// No description provided for @settingsWipeBody.
  ///
  /// In en, this message translates to:
  /// **'If anyone types the wrong app passcode {count} times in a row, Tanooki Auth erases every account on this device. There is no undo and no way to stop it once it starts.'**
  String settingsWipeBody(int count);

  /// No description provided for @settingsWipeSureTitle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get settingsWipeSureTitle;

  /// No description provided for @settingsWipeSureBody.
  ///
  /// In en, this message translates to:
  /// **'A child playing with your phone, or you on a bad day, can trigger this. After an erase, the only way back is your backup file. Without it you could be locked out of every website that uses these codes.'**
  String get settingsWipeSureBody;

  /// No description provided for @settingsWipeTurnOn.
  ///
  /// In en, this message translates to:
  /// **'Turn on panic wipe'**
  String get settingsWipeTurnOn;

  /// No description provided for @settingsTravelOffReason.
  ///
  /// In en, this message translates to:
  /// **'Turn off travel mode'**
  String get settingsTravelOffReason;

  /// No description provided for @settingsTravelOnNone.
  ///
  /// In en, this message translates to:
  /// **'Travel mode on, but no account is marked \"Hide in travel mode\" yet. Mark them with ⋯ > Edit first.'**
  String get settingsTravelOnNone;

  /// No description provided for @settingsTravelOn.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Travel mode on. 1 account is hidden.} other{Travel mode on. {count} accounts are hidden.}}'**
  String settingsTravelOn(int count);

  /// No description provided for @settingsTravelOff.
  ///
  /// In en, this message translates to:
  /// **'Travel mode off. Every account is back.'**
  String get settingsTravelOff;

  /// No description provided for @settingsCheckingClock.
  ///
  /// In en, this message translates to:
  /// **'Checking your clock…'**
  String get settingsCheckingClock;

  /// No description provided for @settingsClockRight.
  ///
  /// In en, this message translates to:
  /// **'Your clock is right, so that\'s not it. Check the account\'s settings (⋯ > Edit > Advanced) match what the website said.'**
  String get settingsClockRight;

  /// No description provided for @settingsClockFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t check the clock: {problem}'**
  String settingsClockFailed(String problem);

  /// No description provided for @settingsLockApp.
  ///
  /// In en, this message translates to:
  /// **'Lock the app'**
  String get settingsLockApp;

  /// No description provided for @settingsLockAppHelp.
  ///
  /// In en, this message translates to:
  /// **'Ask for {lock} when the app opens'**
  String settingsLockAppHelp(String lock);

  /// No description provided for @settingsPasscodeOnHelp.
  ///
  /// In en, this message translates to:
  /// **'On. Tap to change or turn off.'**
  String get settingsPasscodeOnHelp;

  /// No description provided for @settingsPasscodeOffHelp.
  ///
  /// In en, this message translates to:
  /// **'Off. Numbers you type to open the app, instead of or as well as {lock}.'**
  String settingsPasscodeOffHelp(String lock);

  /// No description provided for @settingsLockAgain.
  ///
  /// In en, this message translates to:
  /// **'Lock again'**
  String get settingsLockAgain;

  /// No description provided for @settingsLockAgainHelp.
  ///
  /// In en, this message translates to:
  /// **'{time} in the background'**
  String settingsLockAgainHelp(String time);

  /// No description provided for @settingsLockFirst.
  ///
  /// In en, this message translates to:
  /// **'Turn on the lock or a passcode first'**
  String get settingsLockFirst;

  /// No description provided for @settingsDecoy.
  ///
  /// In en, this message translates to:
  /// **'Decoy passcode'**
  String get settingsDecoy;

  /// No description provided for @settingsDecoyOn.
  ///
  /// In en, this message translates to:
  /// **'On. Opens a separate set of accounts. Tap to remove.'**
  String get settingsDecoyOn;

  /// No description provided for @settingsDecoyOff.
  ///
  /// In en, this message translates to:
  /// **'A second passcode that opens a separate, empty set of accounts'**
  String get settingsDecoyOff;

  /// No description provided for @settingsWipe.
  ///
  /// In en, this message translates to:
  /// **'Erase after {count} wrong passcodes'**
  String settingsWipe(int count);

  /// No description provided for @settingsWipeHelp.
  ///
  /// In en, this message translates to:
  /// **'Panic wipe. Needs a backup made in the last 30 days.'**
  String get settingsWipeHelp;

  /// No description provided for @settingsLockOnSleep.
  ///
  /// In en, this message translates to:
  /// **'Lock when the computer sleeps'**
  String get settingsLockOnSleep;

  /// No description provided for @settingsLockOnSleepHelp.
  ///
  /// In en, this message translates to:
  /// **'Also when the screen locks or you log out for a moment'**
  String get settingsLockOnSleepHelp;

  /// No description provided for @settingsLockOnSleepNeedsLock.
  ///
  /// In en, this message translates to:
  /// **'Turn on \"Lock the app\" or an app passcode first, so there is something to lock.'**
  String get settingsLockOnSleepNeedsLock;

  /// No description provided for @settingsTravel.
  ///
  /// In en, this message translates to:
  /// **'Travel mode'**
  String get settingsTravel;

  /// No description provided for @settingsTravelPremium.
  ///
  /// In en, this message translates to:
  /// **'Travel mode (Premium)'**
  String get settingsTravelPremium;

  /// No description provided for @settingsTravelOnHelp.
  ///
  /// In en, this message translates to:
  /// **'On. Accounts marked \"Hide in travel mode\" are gone from this device\'s screens, widgets, watch, extension and exports until you turn it off. They aren\'t deleted.'**
  String get settingsTravelOnHelp;

  /// No description provided for @settingsTravelOffHelp.
  ///
  /// In en, this message translates to:
  /// **'Before a border crossing: hides the accounts you marked \"Hide in travel mode\" (⋯ > Edit). Turning it off asks for {proof}.'**
  String settingsTravelOffHelp(String proof);

  /// No description provided for @settingsKeys.
  ///
  /// In en, this message translates to:
  /// **'Security keys'**
  String get settingsKeys;

  /// No description provided for @settingsKeysPremium.
  ///
  /// In en, this message translates to:
  /// **'Security keys (Premium)'**
  String get settingsKeysPremium;

  /// No description provided for @settingsKeysHelp.
  ///
  /// In en, this message translates to:
  /// **'Unlock with a YubiKey or other security key'**
  String get settingsKeysHelp;

  /// No description provided for @settingsActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity history'**
  String get settingsActivity;

  /// No description provided for @settingsActivityPremium.
  ///
  /// In en, this message translates to:
  /// **'Activity history (Premium)'**
  String get settingsActivityPremium;

  /// No description provided for @settingsActivityHelp.
  ///
  /// In en, this message translates to:
  /// **'Which codes were copied, filled, typed or exported, and when. Kept on this device only.'**
  String get settingsActivityHelp;

  /// No description provided for @settingsEmergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency access'**
  String get settingsEmergency;

  /// No description provided for @settingsEmergencyPremium.
  ///
  /// In en, this message translates to:
  /// **'Emergency access (Premium)'**
  String get settingsEmergencyPremium;

  /// No description provided for @settingsEmergencyHelp.
  ///
  /// In en, this message translates to:
  /// **'Let one trusted person get your accounts if something happens to you, after a 7-day wait you can stop'**
  String get settingsEmergencyHelp;

  /// No description provided for @settingsTeamHelp.
  ///
  /// In en, this message translates to:
  /// **'Share sign-in codes with up to 10 people, end-to-end encrypted'**
  String get settingsTeamHelp;

  /// No description provided for @settingsMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly summary notification'**
  String get settingsMonthly;

  /// No description provided for @settingsMonthlyPremium.
  ///
  /// In en, this message translates to:
  /// **'Monthly summary notification (Premium)'**
  String get settingsMonthlyPremium;

  /// No description provided for @settingsMonthlyHelp.
  ///
  /// In en, this message translates to:
  /// **'A reminder on the 1st of each month to look at your summary card. It never says anything about your accounts.'**
  String get settingsMonthlyHelp;

  /// No description provided for @settingsBlockShots.
  ///
  /// In en, this message translates to:
  /// **'Block screenshots'**
  String get settingsBlockShots;

  /// No description provided for @settingsBlockShotsDesktop.
  ///
  /// In en, this message translates to:
  /// **'Hides this window from screenshots, screen recording and screen sharing'**
  String get settingsBlockShotsDesktop;

  /// No description provided for @settingsBlockShotsPhone.
  ///
  /// In en, this message translates to:
  /// **'Keeps codes out of screenshots, screen recording and the app switcher'**
  String get settingsBlockShotsPhone;

  /// No description provided for @settingsCheckup.
  ///
  /// In en, this message translates to:
  /// **'Security check-up'**
  String get settingsCheckup;

  /// No description provided for @settingsCheckupHelp.
  ///
  /// In en, this message translates to:
  /// **'Things worth fixing, and your recovery kit'**
  String get settingsCheckupHelp;

  /// No description provided for @settingsBreachPremium.
  ///
  /// In en, this message translates to:
  /// **'Breach alerts (Premium)'**
  String get settingsBreachPremium;

  /// No description provided for @settingsBreachOn.
  ///
  /// In en, this message translates to:
  /// **'On. Checks the public breach list weekly.'**
  String get settingsBreachOn;

  /// No description provided for @settingsBreachOff.
  ///
  /// In en, this message translates to:
  /// **'Off. When on, the app downloads the public breach list once a week.'**
  String get settingsBreachOff;

  /// No description provided for @settingsThemeSemantic.
  ///
  /// In en, this message translates to:
  /// **'{name} theme'**
  String settingsThemeSemantic(String name);

  /// No description provided for @settingsThemeSemanticPremium.
  ///
  /// In en, this message translates to:
  /// **'{name} theme, Premium'**
  String settingsThemeSemanticPremium(String name);

  /// No description provided for @settingsPremiumThanks.
  ///
  /// In en, this message translates to:
  /// **'Premium: thank you!'**
  String get settingsPremiumThanks;

  /// No description provided for @settingsGetPremium.
  ///
  /// In en, this message translates to:
  /// **'Get Premium'**
  String get settingsGetPremium;

  /// No description provided for @settingsPremiumThanksHelp.
  ///
  /// In en, this message translates to:
  /// **'Every theme and future Premium feature is yours.'**
  String get settingsPremiumThanksHelp;

  /// No description provided for @settingsGetPremiumHelp.
  ///
  /// In en, this message translates to:
  /// **'{payOnce}: every theme, sync across your devices, and more.'**
  String settingsGetPremiumHelp(String payOnce);

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @settingsCountdown.
  ///
  /// In en, this message translates to:
  /// **'Countdown style'**
  String get settingsCountdown;

  /// No description provided for @settingsCountdownHelp.
  ///
  /// In en, this message translates to:
  /// **'How the time left on each code is shown'**
  String get settingsCountdownHelp;

  /// No description provided for @settingsEasyFont.
  ///
  /// In en, this message translates to:
  /// **'Easy-to-read font'**
  String get settingsEasyFont;

  /// No description provided for @settingsEasyFontHelp.
  ///
  /// In en, this message translates to:
  /// **'Atkinson Hyperlegible, made by the Braille Institute so letters and numbers are hard to mix up'**
  String get settingsEasyFontHelp;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsLanguageSystem;

  /// No description provided for @settingsAccountsList.
  ///
  /// In en, this message translates to:
  /// **'Accounts list'**
  String get settingsAccountsList;

  /// No description provided for @settingsCompact.
  ///
  /// In en, this message translates to:
  /// **'Compact cards'**
  String get settingsCompact;

  /// No description provided for @settingsCompactHelp.
  ///
  /// In en, this message translates to:
  /// **'Smaller cards, so more accounts fit on screen'**
  String get settingsCompactHelp;

  /// No description provided for @settingsSort.
  ///
  /// In en, this message translates to:
  /// **'Sort accounts'**
  String get settingsSort;

  /// No description provided for @settingsSortHelp.
  ///
  /// In en, this message translates to:
  /// **'{sort}. Favorites always come first.'**
  String settingsSortHelp(String sort);

  /// No description provided for @settingsSortCustom.
  ///
  /// In en, this message translates to:
  /// **'Your own order. Press and hold a card, then drag it.'**
  String get settingsSortCustom;

  /// No description provided for @settingsSortRecent.
  ///
  /// In en, this message translates to:
  /// **'Accounts you just copied a code from move to the top'**
  String get settingsSortRecent;

  /// No description provided for @settingsSortName.
  ///
  /// In en, this message translates to:
  /// **'By service name'**
  String get settingsSortName;

  /// No description provided for @settingsTidyHelp.
  ///
  /// In en, this message translates to:
  /// **'Turns names like \"google.com:you@gmail.com\" into \"Google\". You see every change first.'**
  String get settingsTidyHelp;

  /// No description provided for @settingsHideCodes.
  ///
  /// In en, this message translates to:
  /// **'Hide codes until tapped'**
  String get settingsHideCodes;

  /// No description provided for @settingsHideCodesHelp.
  ///
  /// In en, this message translates to:
  /// **'Shows dots instead of codes, so people nearby can\'t read them'**
  String get settingsHideCodesHelp;

  /// No description provided for @settingsShareCodes.
  ///
  /// In en, this message translates to:
  /// **'Show codes on widgets and watch'**
  String get settingsShareCodes;

  /// No description provided for @settingsShareCodesHelp.
  ///
  /// In en, this message translates to:
  /// **'Your favorites\' codes show on your Home Screen, Lock Screen and watch without opening this app, so anyone holding your unlocked phone or your watch can read them. Star an account to make it a favorite.'**
  String get settingsShareCodesHelp;

  /// No description provided for @settingsTrash.
  ///
  /// In en, this message translates to:
  /// **'Trash'**
  String get settingsTrash;

  /// No description provided for @settingsTrashCount.
  ///
  /// In en, this message translates to:
  /// **'Trash ({count})'**
  String settingsTrashCount(int count);

  /// No description provided for @settingsTrashHelp.
  ///
  /// In en, this message translates to:
  /// **'Deleted accounts stay here for 30 days'**
  String get settingsTrashHelp;

  /// No description provided for @settingsWatchFace.
  ///
  /// In en, this message translates to:
  /// **'Watch face favorite'**
  String get settingsWatchFace;

  /// No description provided for @settingsWatchFacePremium.
  ///
  /// In en, this message translates to:
  /// **'Watch face favorite (Premium)'**
  String get settingsWatchFacePremium;

  /// No description provided for @settingsWatchFaceNoFavorites.
  ///
  /// In en, this message translates to:
  /// **'Star an account on the main list first. Only favorites can go on the watch face.'**
  String get settingsWatchFaceNoFavorites;

  /// No description provided for @settingsNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get settingsNone;

  /// No description provided for @settingsCopying.
  ///
  /// In en, this message translates to:
  /// **'Copying and shortcuts'**
  String get settingsCopying;

  /// No description provided for @settingsCopyOnOpen.
  ///
  /// In en, this message translates to:
  /// **'Copy on open'**
  String get settingsCopyOnOpen;

  /// No description provided for @settingsCopyOnOpenHelp.
  ///
  /// In en, this message translates to:
  /// **'Opening or unlocking the app copies the code of the account you used last. Accounts that ask before showing their code are skipped.'**
  String get settingsCopyOnOpenHelp;

  /// No description provided for @settingsPasteOnce.
  ///
  /// In en, this message translates to:
  /// **'Clear after one paste'**
  String get settingsPasteOnce;

  /// No description provided for @settingsPasteOnceHelp.
  ///
  /// In en, this message translates to:
  /// **'The copied code works for one paste, then the clipboard empties. Clipboard history apps can count as that one paste. On Windows, codes clear after 30 seconds instead.'**
  String get settingsPasteOnceHelp;

  /// No description provided for @settingsSpotlight.
  ///
  /// In en, this message translates to:
  /// **'Show accounts in Spotlight'**
  String get settingsSpotlight;

  /// No description provided for @settingsSpotlightHelp.
  ///
  /// In en, this message translates to:
  /// **'Search for an account\'s name from anywhere and jump straight to it. Only names are shared, never codes.'**
  String get settingsSpotlightHelp;

  /// No description provided for @settingsLiveActivity.
  ///
  /// In en, this message translates to:
  /// **'Code on Lock Screen after copying'**
  String get settingsLiveActivity;

  /// No description provided for @settingsLiveActivityPremium.
  ///
  /// In en, this message translates to:
  /// **'Code on Lock Screen after copying (Premium)'**
  String get settingsLiveActivityPremium;

  /// No description provided for @settingsLiveActivityHelp.
  ///
  /// In en, this message translates to:
  /// **'After you copy a code, it shows on your Lock Screen and Dynamic Island with a countdown until it expires.'**
  String get settingsLiveActivityHelp;

  /// No description provided for @settingsWatchFaceHelp.
  ///
  /// In en, this message translates to:
  /// **'Pick one favorite whose code shows on your Apple Watch face. Needs \"Show codes on widgets and watch\" on.'**
  String get settingsWatchFaceHelp;

  /// No description provided for @settingsWatchFaceChosen.
  ///
  /// In en, this message translates to:
  /// **'{name}. Add the Tanooki Auth complication to your watch face to see it.'**
  String settingsWatchFaceChosen(String name);

  /// No description provided for @settingsBrowserSection.
  ///
  /// In en, this message translates to:
  /// **'Browser extension and launchers'**
  String get settingsBrowserSection;

  /// No description provided for @settingsBridgeOff.
  ///
  /// In en, this message translates to:
  /// **'Not running'**
  String get settingsBridgeOff;

  /// No description provided for @settingsBridgeOn.
  ///
  /// In en, this message translates to:
  /// **'Ready for the browser extension'**
  String get settingsBridgeOn;

  /// No description provided for @settingsBridgeOffHelp.
  ///
  /// In en, this message translates to:
  /// **'Ports {first}–{last} are all in use by other programs, so the extension can\'t connect. Restart your computer and try again.'**
  String settingsBridgeOffHelp(String first, String last);

  /// No description provided for @settingsBridgeOnHelp.
  ///
  /// In en, this message translates to:
  /// **'Listening on this computer only (127.0.0.1:{port}). Works while Tanooki Auth is open.'**
  String settingsBridgeOnHelp(String port);

  /// No description provided for @settingsPairedClient.
  ///
  /// In en, this message translates to:
  /// **'Paired: {name}'**
  String settingsPairedClient(String name);

  /// No description provided for @settingsPairedBrowser.
  ///
  /// In en, this message translates to:
  /// **'Paired browser'**
  String get settingsPairedBrowser;

  /// No description provided for @settingsExtensionId.
  ///
  /// In en, this message translates to:
  /// **'Extension {id}'**
  String settingsExtensionId(String id);

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get settingsSecurity;

  /// No description provided for @settingsBackup.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get settingsBackup;

  /// No description provided for @settingsExport.
  ///
  /// In en, this message translates to:
  /// **'Export backup'**
  String get settingsExport;

  /// No description provided for @settingsExportHelp.
  ///
  /// In en, this message translates to:
  /// **'An encrypted file, locked with a passphrase you choose'**
  String get settingsExportHelp;

  /// No description provided for @settingsImport.
  ///
  /// In en, this message translates to:
  /// **'Import backup'**
  String get settingsImport;

  /// No description provided for @settingsImportHelp.
  ///
  /// In en, this message translates to:
  /// **'Adds accounts from a backup file; skips ones you already have'**
  String get settingsImportHelp;

  /// No description provided for @settingsTestBackup.
  ///
  /// In en, this message translates to:
  /// **'Test a backup'**
  String get settingsTestBackup;

  /// No description provided for @settingsTestBackupHelp.
  ///
  /// In en, this message translates to:
  /// **'Checks a backup file opens with your passphrase. Changes nothing.'**
  String get settingsTestBackupHelp;

  /// No description provided for @settingsMoveOut.
  ///
  /// In en, this message translates to:
  /// **'Move to another app'**
  String get settingsMoveOut;

  /// No description provided for @settingsMoveOutHelp.
  ///
  /// In en, this message translates to:
  /// **'Aegis, 2FAS, Google Authenticator, or plain setup links'**
  String get settingsMoveOutHelp;

  /// No description provided for @settingsPaper.
  ///
  /// In en, this message translates to:
  /// **'Print paper backup'**
  String get settingsPaper;

  /// No description provided for @settingsPaperHelp.
  ///
  /// In en, this message translates to:
  /// **'A PDF of QR codes and recovery codes to keep somewhere locked'**
  String get settingsPaperHelp;

  /// No description provided for @settingsHelp.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get settingsHelp;

  /// No description provided for @settingsGuidesHelp.
  ///
  /// In en, this message translates to:
  /// **'Step-by-step help turning on 2FA at popular sites, on our website'**
  String get settingsGuidesHelp;

  /// No description provided for @settingsTour.
  ///
  /// In en, this message translates to:
  /// **'Show the welcome tour'**
  String get settingsTour;

  /// No description provided for @settingsFeedbackHelp.
  ///
  /// In en, this message translates to:
  /// **'Tell Maddie about a bug or an idea. Never includes your accounts or codes.'**
  String get settingsFeedbackHelp;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsAboutMaddieHelp.
  ///
  /// In en, this message translates to:
  /// **'A note from the person who makes Tanooki Auth'**
  String get settingsAboutMaddieHelp;

  /// No description provided for @settingsCodesNotWorking.
  ///
  /// In en, this message translates to:
  /// **'Codes not working?'**
  String get settingsCodesNotWorking;

  /// No description provided for @settingsCodesNotWorkingHelp.
  ///
  /// In en, this message translates to:
  /// **'Device time {time}. Codes depend on the clock: tap to check it against the internet.'**
  String settingsCodesNotWorkingHelp(String time);

  /// No description provided for @shareUiConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Share {name}?'**
  String shareUiConfirmTitle(String name);

  /// No description provided for @shareUiConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'The person you share this with gets full access: their phone will make the same codes as yours, for as long as they keep it. Only share with someone you trust completely, like family.\n\nRemoving it from your list later does not take it back from them. To cut them off, turn two-factor off and on again on the website.'**
  String get shareUiConfirmBody;

  /// No description provided for @shareUiConfirmButton.
  ///
  /// In en, this message translates to:
  /// **'I understand, share it'**
  String get shareUiConfirmButton;

  /// No description provided for @shareUiLocking.
  ///
  /// In en, this message translates to:
  /// **'Locking the share…'**
  String get shareUiLocking;

  /// No description provided for @shareUiTitle.
  ///
  /// In en, this message translates to:
  /// **'Share {name}'**
  String shareUiTitle(String name);

  /// No description provided for @shareUiInstructions.
  ///
  /// In en, this message translates to:
  /// **'On their device: open Tanooki Auth, tap Add account, then \"Scan QR code\" (or \"Open a shared account\" for the file). Then they type this code:'**
  String get shareUiInstructions;

  /// No description provided for @shareUiTellCode.
  ///
  /// In en, this message translates to:
  /// **'Tell them the code yourself, out loud or in a different app from the file.'**
  String get shareUiTellCode;

  /// No description provided for @shareUiSendFile.
  ///
  /// In en, this message translates to:
  /// **'Send as a file instead'**
  String get shareUiSendFile;

  /// No description provided for @shareUiCopyLink.
  ///
  /// In en, this message translates to:
  /// **'Copy as a link'**
  String get shareUiCopyLink;

  /// No description provided for @shareUiCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied. They paste it with \"Paste setup link\".'**
  String get shareUiCopied;

  /// No description provided for @shareUiWorksFor.
  ///
  /// In en, this message translates to:
  /// **'Works for 24 hours, and only with the code. Nothing goes through a server.'**
  String get shareUiWorksFor;

  /// No description provided for @shareUiOpenTitle.
  ///
  /// In en, this message translates to:
  /// **'Shared account'**
  String get shareUiOpenTitle;

  /// No description provided for @shareUiOpenBody.
  ///
  /// In en, this message translates to:
  /// **'Type the 6-digit code the person who shared it gave you.'**
  String get shareUiOpenBody;

  /// No description provided for @shareUiUnlocking.
  ///
  /// In en, this message translates to:
  /// **'Unlocking…'**
  String get shareUiUnlocking;

  /// No description provided for @signatureLabel.
  ///
  /// In en, this message translates to:
  /// **'Signed, Maddie'**
  String get signatureLabel;

  /// No description provided for @syncUiQrCode.
  ///
  /// In en, this message translates to:
  /// **'QR code'**
  String get syncUiQrCode;

  /// No description provided for @syncUiNotYet.
  ///
  /// In en, this message translates to:
  /// **'Not yet'**
  String get syncUiNotYet;

  /// No description provided for @syncUiJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get syncUiJustNow;

  /// No description provided for @syncUiMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min ago'**
  String syncUiMinutesAgo(int minutes);

  /// No description provided for @syncUiHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{hours} h ago'**
  String syncUiHoursAgo(int hours);

  /// No description provided for @syncUiDate.
  ///
  /// In en, this message translates to:
  /// **'{date}'**
  String syncUiDate(DateTime date);

  /// No description provided for @syncUiThisDevice.
  ///
  /// In en, this message translates to:
  /// **'This device'**
  String get syncUiThisDevice;

  /// No description provided for @syncUiAnotherDevice.
  ///
  /// In en, this message translates to:
  /// **'Another device'**
  String get syncUiAnotherDevice;

  /// No description provided for @syncUiAdded.
  ///
  /// In en, this message translates to:
  /// **'Added {when}'**
  String syncUiAdded(String when);

  /// No description provided for @syncUiThisDeviceNamed.
  ///
  /// In en, this message translates to:
  /// **'This device ({name})'**
  String syncUiThisDeviceNamed(String name);

  /// No description provided for @syncUiLastSyncedAgo.
  ///
  /// In en, this message translates to:
  /// **'Last synced {when}'**
  String syncUiLastSyncedAgo(String when);

  /// No description provided for @syncUiWhere.
  ///
  /// In en, this message translates to:
  /// **'Where should your devices sync?'**
  String get syncUiWhere;

  /// No description provided for @syncUiICloudHelp.
  ///
  /// In en, this message translates to:
  /// **'For iPhone, iPad and Mac only. Uses your own iCloud Drive.'**
  String get syncUiICloudHelp;

  /// No description provided for @syncUiRelay.
  ///
  /// In en, this message translates to:
  /// **'Tanooki relay'**
  String get syncUiRelay;

  /// No description provided for @syncUiRelayHelp.
  ///
  /// In en, this message translates to:
  /// **'Works with every device, including Android and Windows. The server only stores scrambled data.'**
  String get syncUiRelayHelp;

  /// No description provided for @syncUiStartFreshTitle.
  ///
  /// In en, this message translates to:
  /// **'Start fresh?'**
  String get syncUiStartFreshTitle;

  /// No description provided for @syncUiStartFreshBody.
  ///
  /// In en, this message translates to:
  /// **'If you\'ve forgotten the passphrase your other Apple devices use, you can start a new sync with this one. Your other devices then need to turn sync off and on again with the new passphrase.'**
  String get syncUiStartFreshBody;

  /// No description provided for @syncUiStartFresh.
  ///
  /// In en, this message translates to:
  /// **'Start fresh'**
  String get syncUiStartFresh;

  /// No description provided for @syncUiOn.
  ///
  /// In en, this message translates to:
  /// **'Sync is on.'**
  String get syncUiOn;

  /// No description provided for @syncUiScanTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan the sync code'**
  String get syncUiScanTitle;

  /// No description provided for @syncUiScanWrong.
  ///
  /// In en, this message translates to:
  /// **'That isn\'t a sync code. On your other device, open Settings, Sync, Add a device.'**
  String get syncUiScanWrong;

  /// No description provided for @syncUiNowSyncing.
  ///
  /// In en, this message translates to:
  /// **'This device is now syncing.'**
  String get syncUiNowSyncing;

  /// No description provided for @syncUiPasteTitle.
  ///
  /// In en, this message translates to:
  /// **'Paste the sync link'**
  String get syncUiPasteTitle;

  /// No description provided for @syncUiPasteHint.
  ///
  /// In en, this message translates to:
  /// **'tanookiauth://sync?…  (from Add a device on your other device)'**
  String get syncUiPasteHint;

  /// No description provided for @syncUiAddApple.
  ///
  /// In en, this message translates to:
  /// **'Add an Apple device'**
  String get syncUiAddApple;

  /// No description provided for @syncUiAddAppleBody.
  ///
  /// In en, this message translates to:
  /// **'On your other iPhone, iPad or Mac (signed in to the same Apple ID, with iCloud Drive on), open Tanooki Auth, go to Settings, then Sync, tap \"Turn on sync\", pick iCloud and type the same sync passphrase.\n\nWant to add an Android phone or a Windows PC? Turn sync off on every device, then turn it on again with the Tanooki relay.'**
  String get syncUiAddAppleBody;

  /// No description provided for @syncUiAddDevice.
  ///
  /// In en, this message translates to:
  /// **'Add a device'**
  String get syncUiAddDevice;

  /// No description provided for @syncUiAddDeviceBody.
  ///
  /// In en, this message translates to:
  /// **'On the new device, open Tanooki Auth, go to Settings, then Sync, and tap \"Join from another device\". Scan this code, then type your sync passphrase there.'**
  String get syncUiAddDeviceBody;

  /// No description provided for @syncUiAddDeviceNote.
  ///
  /// In en, this message translates to:
  /// **'Works once, for 24 hours. Someone with only this code can\'t read anything without your passphrase.'**
  String get syncUiAddDeviceNote;

  /// No description provided for @syncUiLinkCopied.
  ///
  /// In en, this message translates to:
  /// **'Link copied. Paste it on the new device.'**
  String get syncUiLinkCopied;

  /// No description provided for @syncUiCopyLink.
  ///
  /// In en, this message translates to:
  /// **'Copy link instead'**
  String get syncUiCopyLink;

  /// No description provided for @syncUiRemoveTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove this device from sync?'**
  String get syncUiRemoveTitle;

  /// No description provided for @syncUiRemoveBody.
  ///
  /// In en, this message translates to:
  /// **'It stops getting changes. If the device was lost or stolen, also change your sync passphrase: turn sync off on every device, then on again with a new passphrase, because the lost device still knows the old one.'**
  String get syncUiRemoveBody;

  /// No description provided for @syncUiTurnOffTitle.
  ///
  /// In en, this message translates to:
  /// **'Turn off sync on this device?'**
  String get syncUiTurnOffTitle;

  /// No description provided for @syncUiTurnOffBody.
  ///
  /// In en, this message translates to:
  /// **'Your accounts stay on this device. It just stops sending and getting changes. Your other devices keep syncing with each other.'**
  String get syncUiTurnOffBody;

  /// No description provided for @syncUiOff.
  ///
  /// In en, this message translates to:
  /// **'Sync is off on this device.'**
  String get syncUiOff;

  /// No description provided for @syncUiPremium.
  ///
  /// In en, this message translates to:
  /// **'Sync is part of Premium'**
  String get syncUiPremium;

  /// No description provided for @syncUiPremiumBody.
  ///
  /// In en, this message translates to:
  /// **'Add an account on one device and it shows up on all of them, end-to-end encrypted. {payOnce}, no subscription.'**
  String syncUiPremiumBody(String payOnce);

  /// No description provided for @syncUiIntro.
  ///
  /// In en, this message translates to:
  /// **'Sync keeps your accounts the same on all your devices. Before anything leaves this device it\'s locked with your sync passphrase, so iCloud or our server only ever stores scrambled data. Nobody else can read it, including us.'**
  String get syncUiIntro;

  /// No description provided for @syncUiTurnOn.
  ///
  /// In en, this message translates to:
  /// **'Turn on sync'**
  String get syncUiTurnOn;

  /// No description provided for @syncUiJoin.
  ///
  /// In en, this message translates to:
  /// **'Join from another device'**
  String get syncUiJoin;

  /// No description provided for @syncUiJoinHelp.
  ///
  /// In en, this message translates to:
  /// **'Use \"Join\" when another device already syncs with the Tanooki relay.'**
  String get syncUiJoinHelp;

  /// No description provided for @syncUiSyncingRelay.
  ///
  /// In en, this message translates to:
  /// **'Syncing with the Tanooki relay'**
  String get syncUiSyncingRelay;

  /// No description provided for @syncUiSyncingICloud.
  ///
  /// In en, this message translates to:
  /// **'Syncing with iCloud'**
  String get syncUiSyncingICloud;

  /// No description provided for @syncUiSyncingNow.
  ///
  /// In en, this message translates to:
  /// **'Syncing now…'**
  String get syncUiSyncingNow;

  /// No description provided for @syncUiSkipped.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 synced item couldn\'t be read} other{{count} synced items couldn\'t be read}}'**
  String syncUiSkipped(int count);

  /// No description provided for @syncUiSkippedHelp.
  ///
  /// In en, this message translates to:
  /// **'They may have been changed by someone else or made with another passphrase. Nothing was deleted because of them.'**
  String get syncUiSkippedHelp;

  /// No description provided for @syncUiDevices.
  ///
  /// In en, this message translates to:
  /// **'Devices'**
  String get syncUiDevices;

  /// No description provided for @syncUiLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get syncUiLoading;

  /// No description provided for @syncUiAddDeviceRelay.
  ///
  /// In en, this message translates to:
  /// **'Shows a code to scan on the new device'**
  String get syncUiAddDeviceRelay;

  /// No description provided for @syncUiAddDeviceApple.
  ///
  /// In en, this message translates to:
  /// **'Another iPhone, iPad or Mac'**
  String get syncUiAddDeviceApple;

  /// No description provided for @syncUiTurnOffButton.
  ///
  /// In en, this message translates to:
  /// **'Turn off sync on this device'**
  String get syncUiTurnOffButton;

  /// No description provided for @syncUiPassphraseNoteRelay.
  ///
  /// In en, this message translates to:
  /// **'Your sync passphrase can\'t be recovered. If you forget it, turn sync off on every device and start again with a new one. Your accounts stay put.'**
  String get syncUiPassphraseNoteRelay;

  /// No description provided for @syncUiPassphraseNoteICloud.
  ///
  /// In en, this message translates to:
  /// **'Sync uses your iCloud Drive. Your sync passphrase can\'t be recovered; if you forget it, start fresh with a new one. Your accounts stay put.'**
  String get syncUiPassphraseNoteICloud;

  /// No description provided for @syncUiTitle.
  ///
  /// In en, this message translates to:
  /// **'Sync'**
  String get syncUiTitle;

  /// No description provided for @syncUiTooShort.
  ///
  /// In en, this message translates to:
  /// **'Use at least 10 characters. A few random words works well.'**
  String get syncUiTooShort;

  /// No description provided for @syncUiMismatch.
  ///
  /// In en, this message translates to:
  /// **'The two passphrases don\'t match.'**
  String get syncUiMismatch;

  /// No description provided for @syncUiChoosePassphrase.
  ///
  /// In en, this message translates to:
  /// **'Choose a sync passphrase'**
  String get syncUiChoosePassphrase;

  /// No description provided for @syncUiTypePassphrase.
  ///
  /// In en, this message translates to:
  /// **'Type your sync passphrase'**
  String get syncUiTypePassphrase;

  /// No description provided for @syncUiChooseHelp.
  ///
  /// In en, this message translates to:
  /// **'You\'ll type this once on each device you add. It locks your accounts before they leave this device.\n\nWrite it down somewhere safe. It can\'t be recovered or reset, by you or by us.'**
  String get syncUiChooseHelp;

  /// No description provided for @syncUiTypeHelp.
  ///
  /// In en, this message translates to:
  /// **'The same passphrase you chose when you turned on sync on your first device.'**
  String get syncUiTypeHelp;

  /// No description provided for @syncUiPassphrase.
  ///
  /// In en, this message translates to:
  /// **'Sync passphrase'**
  String get syncUiPassphrase;

  /// No description provided for @syncUiTypeAgain.
  ///
  /// In en, this message translates to:
  /// **'Type it again'**
  String get syncUiTypeAgain;

  /// No description provided for @syncUiSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Sync and phone'**
  String get syncUiSectionTitle;

  /// No description provided for @syncUiTitlePremium.
  ///
  /// In en, this message translates to:
  /// **'Sync (Premium)'**
  String get syncUiTitlePremium;

  /// No description provided for @syncUiOnRelay.
  ///
  /// In en, this message translates to:
  /// **'On, with the Tanooki relay'**
  String get syncUiOnRelay;

  /// No description provided for @syncUiOnICloud.
  ///
  /// In en, this message translates to:
  /// **'On, with iCloud'**
  String get syncUiOnICloud;

  /// No description provided for @syncUiOffHelp.
  ///
  /// In en, this message translates to:
  /// **'Keep your accounts the same on all your devices'**
  String get syncUiOffHelp;

  /// No description provided for @syncUiBrowser.
  ///
  /// In en, this message translates to:
  /// **'Use with a browser'**
  String get syncUiBrowser;

  /// No description provided for @syncUiBrowserPremium.
  ///
  /// In en, this message translates to:
  /// **'Use with a browser (Premium)'**
  String get syncUiBrowserPremium;

  /// No description provided for @syncUiBrowserHelp.
  ///
  /// In en, this message translates to:
  /// **'Approve codes on this phone for a browser on any computer'**
  String get syncUiBrowserHelp;

  /// No description provided for @teamUiCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your team'**
  String get teamUiCreateTitle;

  /// No description provided for @teamUiCreateHint.
  ///
  /// In en, this message translates to:
  /// **'TT1.…  (from the page after you subscribed)'**
  String get teamUiCreateHint;

  /// No description provided for @teamUiCreateButton.
  ///
  /// In en, this message translates to:
  /// **'Create team'**
  String get teamUiCreateButton;

  /// No description provided for @teamUiReady.
  ///
  /// In en, this message translates to:
  /// **'Your team is ready. Invite people with \"Invite someone\".'**
  String get teamUiReady;

  /// No description provided for @teamUiScanTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan the team invite'**
  String get teamUiScanTitle;

  /// No description provided for @teamUiScanWrong.
  ///
  /// In en, this message translates to:
  /// **'That isn\'t a team invite. Ask the team admin to open Settings, Team vault, Invite someone.'**
  String get teamUiScanWrong;

  /// No description provided for @teamUiJoinTitle.
  ///
  /// In en, this message translates to:
  /// **'Join a team'**
  String get teamUiJoinTitle;

  /// No description provided for @teamUiJoinHint.
  ///
  /// In en, this message translates to:
  /// **'tanookiauth://team?…  (the invite link from the team admin)'**
  String get teamUiJoinHint;

  /// No description provided for @teamUiJoinButton.
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get teamUiJoinButton;

  /// No description provided for @teamUiJoinedTeam.
  ///
  /// In en, this message translates to:
  /// **'You\'re in the team. Team accounts appear once the admin\'s app shares the team key with this device.'**
  String get teamUiJoinedTeam;

  /// No description provided for @teamUiInvite.
  ///
  /// In en, this message translates to:
  /// **'Invite someone'**
  String get teamUiInvite;

  /// No description provided for @teamUiInviteHelp.
  ///
  /// In en, this message translates to:
  /// **'On their device: Settings, Team vault, then \"Scan an invite QR code\" or \"Paste an invite link\". The invite works once and lasts 7 days.'**
  String get teamUiInviteHelp;

  /// No description provided for @teamUiRemovePersonTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove this person?'**
  String get teamUiRemovePersonTitle;

  /// No description provided for @teamUiRemovePersonBody.
  ///
  /// In en, this message translates to:
  /// **'They lose access straight away, and the team gets a new key so they can\'t read anything added or changed from now on. They may have kept copies of the codes they could already see, so change the two-factor setup of any account that matters.'**
  String get teamUiRemovePersonBody;

  /// No description provided for @teamUiRemoved.
  ///
  /// In en, this message translates to:
  /// **'Removed. The team has a new key.'**
  String get teamUiRemoved;

  /// No description provided for @teamUiDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete the team?'**
  String get teamUiDeleteTitle;

  /// No description provided for @teamUiLeaveTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave the team?'**
  String get teamUiLeaveTitle;

  /// No description provided for @teamUiDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'Every team account is deleted for everyone in the team. Everyone\'s own accounts are not touched.'**
  String get teamUiDeleteBody;

  /// No description provided for @teamUiLeaveBody.
  ///
  /// In en, this message translates to:
  /// **'The team\'s accounts disappear from this device. Your own accounts are not touched.'**
  String get teamUiLeaveBody;

  /// No description provided for @teamUiDeleteButton.
  ///
  /// In en, this message translates to:
  /// **'Delete team'**
  String get teamUiDeleteButton;

  /// No description provided for @teamUiLeaveButton.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get teamUiLeaveButton;

  /// No description provided for @teamUiDeleted.
  ///
  /// In en, this message translates to:
  /// **'Team deleted.'**
  String get teamUiDeleted;

  /// No description provided for @teamUiLeft.
  ///
  /// In en, this message translates to:
  /// **'You left the team.'**
  String get teamUiLeft;

  /// No description provided for @teamUiAddFirst.
  ///
  /// In en, this message translates to:
  /// **'Add the account to Tanooki Auth first, then copy it into the team here.'**
  String get teamUiAddFirst;

  /// No description provided for @teamUiCopyInTitle.
  ///
  /// In en, this message translates to:
  /// **'Copy one of your accounts into the team'**
  String get teamUiCopyInTitle;

  /// No description provided for @teamUiCopiedIn.
  ///
  /// In en, this message translates to:
  /// **'{name} is now in the team. Your own copy stays where it was.'**
  String teamUiCopiedIn(String name);

  /// No description provided for @teamUiRenameTitle.
  ///
  /// In en, this message translates to:
  /// **'Rename team account'**
  String get teamUiRenameTitle;

  /// No description provided for @teamUiRenameHint.
  ///
  /// In en, this message translates to:
  /// **'Name, e.g. AWS'**
  String get teamUiRenameHint;

  /// No description provided for @teamUiRemoveAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove {name} from the team?'**
  String teamUiRemoveAccountTitle(String name);

  /// No description provided for @teamUiRemoveAccountBody.
  ///
  /// In en, this message translates to:
  /// **'It disappears for everyone in the team.'**
  String get teamUiRemoveAccountBody;

  /// No description provided for @teamUiIntro.
  ///
  /// In en, this message translates to:
  /// **'A team vault shares sign-in codes with up to 10 people, for \$20 a year. Everyone in the team can see, add and change team accounts. They\'re encrypted on your devices with a key only the team has, so our server can\'t read them. Team accounts sit in their own Team section and never mix with your own accounts.'**
  String get teamUiIntro;

  /// No description provided for @teamUiStart.
  ///
  /// In en, this message translates to:
  /// **'Start a team'**
  String get teamUiStart;

  /// No description provided for @teamUiBuy.
  ///
  /// In en, this message translates to:
  /// **'Buy a team plan — \$20 a year'**
  String get teamUiBuy;

  /// No description provided for @teamUiPlanSoon.
  ///
  /// In en, this message translates to:
  /// **'Team plan coming soon'**
  String get teamUiPlanSoon;

  /// No description provided for @teamUiHaveLicense.
  ///
  /// In en, this message translates to:
  /// **'I have a team license: create the team'**
  String get teamUiHaveLicense;

  /// No description provided for @teamUiJoinHelp.
  ///
  /// In en, this message translates to:
  /// **'Ask the team admin for an invite. Joining is free.'**
  String get teamUiJoinHelp;

  /// No description provided for @teamUiScanInvite.
  ///
  /// In en, this message translates to:
  /// **'Scan an invite QR code'**
  String get teamUiScanInvite;

  /// No description provided for @teamUiPasteInvite.
  ///
  /// In en, this message translates to:
  /// **'Paste an invite link'**
  String get teamUiPasteInvite;

  /// No description provided for @teamUiYouRun.
  ///
  /// In en, this message translates to:
  /// **'You run this team'**
  String get teamUiYouRun;

  /// No description provided for @teamUiYoureIn.
  ///
  /// In en, this message translates to:
  /// **'You\'re in a team'**
  String get teamUiYoureIn;

  /// No description provided for @teamUiPeopleCount.
  ///
  /// In en, this message translates to:
  /// **'{count} of {max} people'**
  String teamUiPeopleCount(int count, int max);

  /// No description provided for @teamUiLastSynced.
  ///
  /// In en, this message translates to:
  /// **'Last synced: {when}'**
  String teamUiLastSynced(String when);

  /// No description provided for @teamUiPaidUntil.
  ///
  /// In en, this message translates to:
  /// **'Paid until {date}'**
  String teamUiPaidUntil(DateTime date);

  /// No description provided for @teamUiSyncNow.
  ///
  /// In en, this message translates to:
  /// **'Sync now'**
  String get teamUiSyncNow;

  /// No description provided for @teamUiWaitingForKey.
  ///
  /// In en, this message translates to:
  /// **'Waiting for the team admin\'s app to share the team key with this device. It happens the next time the admin opens Tanooki Auth.'**
  String get teamUiWaitingForKey;

  /// No description provided for @teamUiAccounts.
  ///
  /// In en, this message translates to:
  /// **'Team accounts'**
  String get teamUiAccounts;

  /// No description provided for @teamUiAddMine.
  ///
  /// In en, this message translates to:
  /// **'Add one of mine'**
  String get teamUiAddMine;

  /// No description provided for @teamUiNoAccounts.
  ///
  /// In en, this message translates to:
  /// **'No team accounts yet.'**
  String get teamUiNoAccounts;

  /// No description provided for @teamUiChange.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get teamUiChange;

  /// No description provided for @teamUiRename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get teamUiRename;

  /// No description provided for @teamUiRemoveFromTeam.
  ///
  /// In en, this message translates to:
  /// **'Remove from team'**
  String get teamUiRemoveFromTeam;

  /// No description provided for @teamUiPeople.
  ///
  /// In en, this message translates to:
  /// **'People'**
  String get teamUiPeople;

  /// No description provided for @teamUiThisDevice.
  ///
  /// In en, this message translates to:
  /// **'This device (admin)'**
  String get teamUiThisDevice;

  /// No description provided for @teamUiDevice.
  ///
  /// In en, this message translates to:
  /// **'Device {id}'**
  String teamUiDevice(String id);

  /// No description provided for @teamUiJoined.
  ///
  /// In en, this message translates to:
  /// **'Joined {date}'**
  String teamUiJoined(DateTime date);

  /// No description provided for @teamUiJoinedGettingKey.
  ///
  /// In en, this message translates to:
  /// **'Joined {date} · getting the team key'**
  String teamUiJoinedGettingKey(DateTime date);

  /// No description provided for @teamUiDeleteTeam.
  ///
  /// In en, this message translates to:
  /// **'Delete the team'**
  String get teamUiDeleteTeam;

  /// No description provided for @teamUiLeaveTeam.
  ///
  /// In en, this message translates to:
  /// **'Leave the team'**
  String get teamUiLeaveTeam;

  /// No description provided for @teamUiTitle.
  ///
  /// In en, this message translates to:
  /// **'Team vault'**
  String get teamUiTitle;

  /// No description provided for @teamUiCopiedCode.
  ///
  /// In en, this message translates to:
  /// **'Copied {name} code. The clipboard clears in 30 seconds.'**
  String teamUiCopiedCode(String name);

  /// No description provided for @teamUiSection.
  ///
  /// In en, this message translates to:
  /// **'Team · {count}'**
  String teamUiSection(int count);

  /// No description provided for @teamUiWaitingShort.
  ///
  /// In en, this message translates to:
  /// **'Waiting for the team admin to share the team key with this device.'**
  String get teamUiWaitingShort;

  /// No description provided for @teamUiNoAccountsHint.
  ///
  /// In en, this message translates to:
  /// **'No team accounts yet. Add them in Settings, Team vault.'**
  String get teamUiNoAccountsHint;

  /// No description provided for @themeAuto.
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get themeAuto;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themePink.
  ///
  /// In en, this message translates to:
  /// **'Pastel Pink'**
  String get themePink;

  /// No description provided for @themeBlue.
  ///
  /// In en, this message translates to:
  /// **'Pastel Blue'**
  String get themeBlue;

  /// No description provided for @themeLavender.
  ///
  /// In en, this message translates to:
  /// **'Lavender'**
  String get themeLavender;

  /// No description provided for @themeMint.
  ///
  /// In en, this message translates to:
  /// **'Mint'**
  String get themeMint;

  /// No description provided for @themeMidnight.
  ///
  /// In en, this message translates to:
  /// **'Midnight'**
  String get themeMidnight;

  /// No description provided for @themeSunset.
  ///
  /// In en, this message translates to:
  /// **'Sunset'**
  String get themeSunset;

  /// No description provided for @themePeach.
  ///
  /// In en, this message translates to:
  /// **'Peach'**
  String get themePeach;

  /// No description provided for @themeForest.
  ///
  /// In en, this message translates to:
  /// **'Forest'**
  String get themeForest;

  /// No description provided for @themeOcean.
  ///
  /// In en, this message translates to:
  /// **'Ocean'**
  String get themeOcean;

  /// No description provided for @themeMono.
  ///
  /// In en, this message translates to:
  /// **'Mono'**
  String get themeMono;

  /// No description provided for @tidyNoName.
  ///
  /// In en, this message translates to:
  /// **'(no name)'**
  String get tidyNoName;

  /// No description provided for @tidyDone.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Tidied 1 name.} other{Tidied {count} names.}}'**
  String tidyDone(int count);

  /// No description provided for @tidyTitle.
  ///
  /// In en, this message translates to:
  /// **'Tidy account names'**
  String get tidyTitle;

  /// No description provided for @tidyNothing.
  ///
  /// In en, this message translates to:
  /// **'All your account names are already tidy.'**
  String get tidyNothing;

  /// No description provided for @tidyIntro.
  ///
  /// In en, this message translates to:
  /// **'These names have website addresses or extra bits in them. Untick any you want to keep as they are, then tap Apply. Your codes don\'t change.'**
  String get tidyIntro;

  /// No description provided for @tidyWas.
  ///
  /// In en, this message translates to:
  /// **'Was: {name}'**
  String tidyWas(String name);

  /// No description provided for @tidyNothingTicked.
  ///
  /// In en, this message translates to:
  /// **'Nothing ticked'**
  String get tidyNothingTicked;

  /// No description provided for @tidyApply.
  ///
  /// In en, this message translates to:
  /// **'Apply {count}'**
  String tidyApply(int count);

  /// No description provided for @emergencyNotContactCode.
  ///
  /// In en, this message translates to:
  /// **'That isn\'t a Tanooki Auth contact code. Ask them to open Tanooki Auth, go to Settings > Emergency access, and share their contact code.'**
  String get emergencyNotContactCode;

  /// No description provided for @emergencyCopyWontOpen.
  ///
  /// In en, this message translates to:
  /// **'The emergency copy couldn\'t be opened with this device\'s key. It was made for a different device, or it is damaged.'**
  String get emergencyCopyWontOpen;

  /// No description provided for @emergencyGone.
  ///
  /// In en, this message translates to:
  /// **'This emergency copy doesn\'t exist any more. The owner removed it.'**
  String get emergencyGone;

  /// No description provided for @emergencyWaitNotOver.
  ///
  /// In en, this message translates to:
  /// **'The 7-day wait isn\'t over yet.'**
  String get emergencyWaitNotOver;

  /// No description provided for @emergencyNotOwnerOrContact.
  ///
  /// In en, this message translates to:
  /// **'This device isn\'t the owner or the contact for that emergency copy.'**
  String get emergencyNotOwnerOrContact;

  /// No description provided for @emergencyNoRequestToDeny.
  ///
  /// In en, this message translates to:
  /// **'There is no request to deny any more.'**
  String get emergencyNoRequestToDeny;

  /// No description provided for @emergencyAskFirst.
  ///
  /// In en, this message translates to:
  /// **'Ask for access first.'**
  String get emergencyAskFirst;

  /// No description provided for @emergencyTooBig.
  ///
  /// In en, this message translates to:
  /// **'Your accounts are too big to leave as an emergency copy (the limit is about 500 KB).'**
  String get emergencyTooBig;

  /// No description provided for @emergencyTooManyTries.
  ///
  /// In en, this message translates to:
  /// **'Too many tries in a minute. Wait a minute and try again.'**
  String get emergencyTooManyTries;

  /// No description provided for @emergencyServerSaidNo.
  ///
  /// In en, this message translates to:
  /// **'The sync server said no (HTTP {status}).'**
  String emergencyServerSaidNo(String status);

  /// No description provided for @emergencyServerSaidNoWhy.
  ///
  /// In en, this message translates to:
  /// **'The sync server said no (HTTP {status}: {reason}).'**
  String emergencyServerSaidNoWhy(String status, String reason);

  /// No description provided for @emergencyNotEmergencyCode.
  ///
  /// In en, this message translates to:
  /// **'That isn\'t a Tanooki Auth emergency code. Ask the person who chose you to send it again from Settings > Emergency access.'**
  String get emergencyNotEmergencyCode;

  /// No description provided for @emergencyLessThanMinute.
  ///
  /// In en, this message translates to:
  /// **'less than a minute'**
  String get emergencyLessThanMinute;

  /// No description provided for @emergencyDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day} other{{count} days}}'**
  String emergencyDays(int count);

  /// No description provided for @emergencyHours.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 hour} other{{count} hours}}'**
  String emergencyHours(int count);

  /// No description provided for @emergencyMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 minute} other{{count} minutes}}'**
  String emergencyMinutes(int count);

  /// No description provided for @emergencyDaysHours.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =1{1 day} other{{days} days}} {hours, plural, =1{1 hour} other{{hours} hours}}'**
  String emergencyDaysHours(int days, int hours);

  /// No description provided for @emergencyUiExplainer.
  ///
  /// In en, this message translates to:
  /// **'Pick one person you trust. If something happens to you, they can ask for your accounts. Your devices get a notification and you have 7 days to say no. If nobody says no, they get a copy.\n\nThe Tanooki Auth server only enforces the 7-day wait. The copy is locked with a key that only their device has, so the server can\'t read it, and neither can anyone who breaks into the server.'**
  String get emergencyUiExplainer;

  /// No description provided for @emergencyUiPushNotWorking.
  ///
  /// In en, this message translates to:
  /// **'Notifications aren\'t working yet ({reason}). Tanooki Auth checks for requests each time you open it.'**
  String emergencyUiPushNotWorking(String reason);

  /// No description provided for @emergencyUiScanTheirQr.
  ///
  /// In en, this message translates to:
  /// **'Scan their QR code'**
  String get emergencyUiScanTheirQr;

  /// No description provided for @emergencyUiPasteCode.
  ///
  /// In en, this message translates to:
  /// **'Paste a code they sent'**
  String get emergencyUiPasteCode;

  /// No description provided for @emergencyUiWrongCode.
  ///
  /// In en, this message translates to:
  /// **'That isn\'t the right code.'**
  String get emergencyUiWrongCode;

  /// No description provided for @emergencyUiCopiedCode.
  ///
  /// In en, this message translates to:
  /// **'Copied. Send it to them however you like: it holds no secrets.'**
  String get emergencyUiCopiedCode;

  /// No description provided for @emergencyUiCopyAsText.
  ///
  /// In en, this message translates to:
  /// **'Copy as text'**
  String get emergencyUiCopyAsText;

  /// No description provided for @emergencyUiTheirContactCode.
  ///
  /// In en, this message translates to:
  /// **'Their contact code'**
  String get emergencyUiTheirContactCode;

  /// No description provided for @emergencyUiNotContactCodeShort.
  ///
  /// In en, this message translates to:
  /// **'That isn\'t a Tanooki Auth contact code.'**
  String get emergencyUiNotContactCodeShort;

  /// No description provided for @emergencyUiMakeThemContact.
  ///
  /// In en, this message translates to:
  /// **'Make them your emergency contact?'**
  String get emergencyUiMakeThemContact;

  /// No description provided for @emergencyUiMakeNamedContact.
  ///
  /// In en, this message translates to:
  /// **'Make {name} your emergency contact?'**
  String emergencyUiMakeNamedContact(String name);

  /// No description provided for @emergencyUiCopyLeftOnServer.
  ///
  /// In en, this message translates to:
  /// **'A copy of all your accounts is locked to their device and left on the Tanooki Auth server. It updates when you change your accounts.'**
  String get emergencyUiCopyLeftOnServer;

  /// No description provided for @emergencyUiYourNameWhose.
  ///
  /// In en, this message translates to:
  /// **'Your name (so they know whose copy it is)'**
  String get emergencyUiYourNameWhose;

  /// No description provided for @emergencyUiDoneGiveCode.
  ///
  /// In en, this message translates to:
  /// **'Done. Now give them the code on this screen.'**
  String get emergencyUiDoneGiveCode;

  /// No description provided for @emergencyUiStopTitle.
  ///
  /// In en, this message translates to:
  /// **'Stop emergency access?'**
  String get emergencyUiStopTitle;

  /// No description provided for @emergencyUiStopBody.
  ///
  /// In en, this message translates to:
  /// **'The copy is deleted from the server, and they can\'t ask for it any more.'**
  String get emergencyUiStopBody;

  /// No description provided for @emergencyUiChooseContact.
  ///
  /// In en, this message translates to:
  /// **'Choose an emergency contact'**
  String get emergencyUiChooseContact;

  /// No description provided for @emergencyUiChooseContactPremium.
  ///
  /// In en, this message translates to:
  /// **'Choose an emergency contact (Premium)'**
  String get emergencyUiChooseContactPremium;

  /// No description provided for @emergencyUiChooseContactHow.
  ///
  /// In en, this message translates to:
  /// **'They open Tanooki Auth on their device, go to Settings > Emergency access, and show you their contact code.'**
  String get emergencyUiChooseContactHow;

  /// No description provided for @emergencyUiYourContact.
  ///
  /// In en, this message translates to:
  /// **'Your contact'**
  String get emergencyUiYourContact;

  /// No description provided for @emergencyUiChecking.
  ///
  /// In en, this message translates to:
  /// **'Checking with the server…'**
  String get emergencyUiChecking;

  /// No description provided for @emergencyUiIdleJustNow.
  ///
  /// In en, this message translates to:
  /// **'Nobody has asked. Copy last updated just now.'**
  String get emergencyUiIdleJustNow;

  /// No description provided for @emergencyUiIdleUpdated.
  ///
  /// In en, this message translates to:
  /// **'Nobody has asked. Copy last updated {day}.'**
  String emergencyUiIdleUpdated(String day);

  /// No description provided for @emergencyUiWaiting.
  ///
  /// In en, this message translates to:
  /// **'{who} asked on {day}. They can open the copy in {left} unless you deny it.'**
  String emergencyUiWaiting(String who, String day, String left);

  /// No description provided for @emergencyUiReleased.
  ///
  /// In en, this message translates to:
  /// **'{who} asked and the wait is over: they can open the copy now. Deny to stop that.'**
  String emergencyUiReleased(String who);

  /// No description provided for @emergencyUiContactIs.
  ///
  /// In en, this message translates to:
  /// **'Emergency contact: {who}'**
  String emergencyUiContactIs(String who);

  /// No description provided for @emergencyUiDenied.
  ///
  /// In en, this message translates to:
  /// **'Denied. They can\'t open your accounts. They can ask again later.'**
  String get emergencyUiDenied;

  /// No description provided for @emergencyUiCopyUpdated.
  ///
  /// In en, this message translates to:
  /// **'Copy updated.'**
  String get emergencyUiCopyUpdated;

  /// No description provided for @emergencyUiCouldntUpdate.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t update the copy.'**
  String get emergencyUiCouldntUpdate;

  /// No description provided for @emergencyUiUpdateNow.
  ///
  /// In en, this message translates to:
  /// **'Update copy now'**
  String get emergencyUiUpdateNow;

  /// No description provided for @emergencyUiGiveCode.
  ///
  /// In en, this message translates to:
  /// **'Give {who} this code. In Tanooki Auth they go to Settings > Emergency access > \"Add a code someone gave you\".'**
  String emergencyUiGiveCode(String who);

  /// No description provided for @emergencyUiCodeTheyGave.
  ///
  /// In en, this message translates to:
  /// **'Code they gave you'**
  String get emergencyUiCodeTheyGave;

  /// No description provided for @emergencyUiNotEmergencyCodeShort.
  ///
  /// In en, this message translates to:
  /// **'That isn\'t a Tanooki Auth emergency code.'**
  String get emergencyUiNotEmergencyCodeShort;

  /// No description provided for @emergencyUiAddedTheir.
  ///
  /// In en, this message translates to:
  /// **'Added. You can ask for their accounts here if you ever need to.'**
  String get emergencyUiAddedTheir;

  /// No description provided for @emergencyUiAddedNamed.
  ///
  /// In en, this message translates to:
  /// **'Added. You can ask for {name}\'s accounts here if you ever need to.'**
  String emergencyUiAddedNamed(String name);

  /// No description provided for @emergencyUiTheOwner.
  ///
  /// In en, this message translates to:
  /// **'the owner'**
  String get emergencyUiTheOwner;

  /// No description provided for @emergencyUiAskTitle.
  ///
  /// In en, this message translates to:
  /// **'Ask for emergency access?'**
  String get emergencyUiAskTitle;

  /// No description provided for @emergencyUiAskBody.
  ///
  /// In en, this message translates to:
  /// **'{who} gets a notification and has 7 days to say no. If they don\'t, you can open a copy of their accounts here. Only ask if you really need it.'**
  String emergencyUiAskBody(String who);

  /// No description provided for @emergencyUiAsk.
  ///
  /// In en, this message translates to:
  /// **'Ask'**
  String get emergencyUiAsk;

  /// No description provided for @emergencyUiAsked.
  ///
  /// In en, this message translates to:
  /// **'Asked. The 7-day wait has started.'**
  String get emergencyUiAsked;

  /// No description provided for @emergencyUiAddTheirAccounts.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Add their 1 account?} other{Add their {count} accounts?}}'**
  String emergencyUiAddTheirAccounts(int count);

  /// No description provided for @emergencyUiAddNamedAccounts.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Add {name}\'s 1 account?} other{Add {name}\'s {count} accounts?}}'**
  String emergencyUiAddNamedAccounts(int count, String name);

  /// No description provided for @emergencyUiSomeone.
  ///
  /// In en, this message translates to:
  /// **'Someone'**
  String get emergencyUiSomeone;

  /// No description provided for @emergencyUiCheckingShort.
  ///
  /// In en, this message translates to:
  /// **'Checking…'**
  String get emergencyUiCheckingShort;

  /// No description provided for @emergencyUiNotAsked.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t asked.'**
  String get emergencyUiNotAsked;

  /// No description provided for @emergencyUiRequestAccess.
  ///
  /// In en, this message translates to:
  /// **'Request access'**
  String get emergencyUiRequestAccess;

  /// No description provided for @emergencyUiOpensIn.
  ///
  /// In en, this message translates to:
  /// **'You asked. Opens in {left} ({day}), unless they say no.'**
  String emergencyUiOpensIn(String left, String day);

  /// No description provided for @emergencyUiWaitOver.
  ///
  /// In en, this message translates to:
  /// **'The wait is over.'**
  String get emergencyUiWaitOver;

  /// No description provided for @emergencyUiOpenCopy.
  ///
  /// In en, this message translates to:
  /// **'Open emergency copy'**
  String get emergencyUiOpenCopy;

  /// No description provided for @emergencyUiPersonAccounts.
  ///
  /// In en, this message translates to:
  /// **'{who}\'s accounts'**
  String emergencyUiPersonAccounts(String who);

  /// No description provided for @emergencyUiYourContactCode.
  ///
  /// In en, this message translates to:
  /// **'Your contact code'**
  String get emergencyUiYourContactCode;

  /// No description provided for @emergencyUiShowThis.
  ///
  /// In en, this message translates to:
  /// **'If someone wants you as their emergency contact, show them this. It holds no secrets.'**
  String get emergencyUiShowThis;

  /// No description provided for @emergencyUiYourNameItsYou.
  ///
  /// In en, this message translates to:
  /// **'Your name (so they know it\'s you)'**
  String get emergencyUiYourNameItsYou;

  /// No description provided for @emergencyUiShowMyCode.
  ///
  /// In en, this message translates to:
  /// **'Show my contact code'**
  String get emergencyUiShowMyCode;

  /// No description provided for @emergencyUiLetThemScan.
  ///
  /// In en, this message translates to:
  /// **'Let them scan this in Tanooki Auth, or copy it and send it to them.'**
  String get emergencyUiLetThemScan;

  /// No description provided for @emergencyUiAddCodeGiven.
  ///
  /// In en, this message translates to:
  /// **'Add a code someone gave you'**
  String get emergencyUiAddCodeGiven;

  /// No description provided for @emergencyUiAddCodeGivenHow.
  ///
  /// In en, this message translates to:
  /// **'After they chose you, their app shows a code for you'**
  String get emergencyUiAddCodeGivenHow;

  /// No description provided for @emergencyUiTitle.
  ///
  /// In en, this message translates to:
  /// **'Emergency access'**
  String get emergencyUiTitle;

  /// No description provided for @emergencyUiYourEmergencyContact.
  ///
  /// In en, this message translates to:
  /// **'Your emergency contact'**
  String get emergencyUiYourEmergencyContact;

  /// No description provided for @emergencyUiPeopleWhoChoseYou.
  ///
  /// In en, this message translates to:
  /// **'People who chose you'**
  String get emergencyUiPeopleWhoChoseYou;

  /// No description provided for @securityUiProofWindows.
  ///
  /// In en, this message translates to:
  /// **'Windows Hello'**
  String get securityUiProofWindows;

  /// No description provided for @securityUiProofMac.
  ///
  /// In en, this message translates to:
  /// **'Touch ID or your password'**
  String get securityUiProofMac;

  /// No description provided for @securityUiProofIos.
  ///
  /// In en, this message translates to:
  /// **'Face ID or passcode'**
  String get securityUiProofIos;

  /// No description provided for @securityUiProofOther.
  ///
  /// In en, this message translates to:
  /// **'fingerprint or PIN'**
  String get securityUiProofOther;

  /// No description provided for @securityUiPasscodeAtLeast.
  ///
  /// In en, this message translates to:
  /// **'Passcode (at least {count} numbers)'**
  String securityUiPasscodeAtLeast(int count);

  /// No description provided for @securityUiTypeAgain.
  ///
  /// In en, this message translates to:
  /// **'Type it again'**
  String get securityUiTypeAgain;

  /// No description provided for @securityUiPasscodesDontMatch.
  ///
  /// In en, this message translates to:
  /// **'The two passcodes don\'t match.'**
  String get securityUiPasscodesDontMatch;

  /// No description provided for @securityUiPickDifferent.
  ///
  /// In en, this message translates to:
  /// **'Pick a different passcode from your other one.'**
  String get securityUiPickDifferent;

  /// No description provided for @securityUiEnterPasscode.
  ///
  /// In en, this message translates to:
  /// **'Enter your app passcode'**
  String get securityUiEnterPasscode;

  /// No description provided for @securityUiPasscode.
  ///
  /// In en, this message translates to:
  /// **'Passcode'**
  String get securityUiPasscode;

  /// No description provided for @securityUiWrongPasscode.
  ///
  /// In en, this message translates to:
  /// **'That\'s not your passcode.'**
  String get securityUiWrongPasscode;

  /// No description provided for @securityUiCheckupTitle.
  ///
  /// In en, this message translates to:
  /// **'Security check-up'**
  String get securityUiCheckupTitle;

  /// No description provided for @securityUiAllGood.
  ///
  /// In en, this message translates to:
  /// **'All good'**
  String get securityUiAllGood;

  /// No description provided for @securityUiAllGoodBody.
  ///
  /// In en, this message translates to:
  /// **'Your app is locked, you have a recent backup, and every account has recovery codes.'**
  String get securityUiAllGoodBody;

  /// No description provided for @securityUiLockOffTitle.
  ///
  /// In en, this message translates to:
  /// **'The app isn\'t locked'**
  String get securityUiLockOffTitle;

  /// No description provided for @securityUiLockOffBody.
  ///
  /// In en, this message translates to:
  /// **'Anyone who picks up your unlocked device can see your codes. Turn on \"Lock the app\" or an app passcode in Settings.'**
  String get securityUiLockOffBody;

  /// No description provided for @securityUiNoPasscodeTitle.
  ///
  /// In en, this message translates to:
  /// **'No app passcode'**
  String get securityUiNoPasscodeTitle;

  /// No description provided for @securityUiNoPasscodeBody.
  ///
  /// In en, this message translates to:
  /// **'A passcode lets you open Tanooki Auth even if Face ID or your fingerprint stops working. Set one in Settings.'**
  String get securityUiNoPasscodeBody;

  /// No description provided for @securityUiAutoBackupFailed.
  ///
  /// In en, this message translates to:
  /// **'Automatic backup failed'**
  String get securityUiAutoBackupFailed;

  /// No description provided for @securityUiOpenAutoBackups.
  ///
  /// In en, this message translates to:
  /// **'Open automatic backups'**
  String get securityUiOpenAutoBackups;

  /// No description provided for @securityUiNoBackupTitle.
  ///
  /// In en, this message translates to:
  /// **'No backup in the last 30 days'**
  String get securityUiNoBackupTitle;

  /// No description provided for @securityUiNoBackupBody.
  ///
  /// In en, this message translates to:
  /// **'If this device is lost or broken, a backup is the only way to get your accounts back.'**
  String get securityUiNoBackupBody;

  /// No description provided for @securityUiMakeBackupNow.
  ///
  /// In en, this message translates to:
  /// **'Make a backup now'**
  String get securityUiMakeBackupNow;

  /// No description provided for @securityUiNoRecoveryTitle.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 account has no recovery codes} other{{count} accounts have no recovery codes}}'**
  String securityUiNoRecoveryTitle(int count);

  /// No description provided for @securityUiNoRecoveryBody.
  ///
  /// In en, this message translates to:
  /// **'Recovery codes get you into a website if you lose this app. Find them in each site\'s security settings, then add them with ⋯ > Recovery codes on the account.\n\n{names}'**
  String securityUiNoRecoveryBody(String names);

  /// No description provided for @securityUiRecoveryKit.
  ///
  /// In en, this message translates to:
  /// **'Your recovery kit'**
  String get securityUiRecoveryKit;

  /// No description provided for @securityUiRecoveryKitSub.
  ///
  /// In en, this message translates to:
  /// **'Backup, recovery codes and a paper copy, step by step'**
  String get securityUiRecoveryKitSub;

  /// No description provided for @securityUiBreachSnack.
  ///
  /// In en, this message translates to:
  /// **'{sites} had a data breach. Change your password there.'**
  String securityUiBreachSnack(String sites);

  /// No description provided for @securityUiBreachDownloadFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t download the breach list. Check your internet connection and try again.'**
  String get securityUiBreachDownloadFailed;

  /// No description provided for @securityUiBreachAlerts.
  ///
  /// In en, this message translates to:
  /// **'Breach alerts'**
  String get securityUiBreachAlerts;

  /// No description provided for @securityUiBreachAlertsPremium.
  ///
  /// In en, this message translates to:
  /// **'Breach alerts (Premium)'**
  String get securityUiBreachAlertsPremium;

  /// No description provided for @securityUiBreachAlertsSub.
  ///
  /// In en, this message translates to:
  /// **'Once a week, tells you if a website you use had a data breach'**
  String get securityUiBreachAlertsSub;

  /// No description provided for @securityUiBreachHow.
  ///
  /// In en, this message translates to:
  /// **'How it works: Tanooki Auth downloads the public list of known breaches from haveibeenpwned.com and compares it with your saved websites on this device. Nothing about you or your accounts is sent: it\'s the same download for everyone. This is the only time the app goes on the internet, apart from sync and buying Premium.'**
  String get securityUiBreachHow;

  /// No description provided for @securityUiNoWebsite.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 of your accounts has no website saved, so it can\'t be checked. Add one with ⋯ > Edit.} other{{count} of your accounts have no website saved, so they can\'t be checked. Add one with ⋯ > Edit.}}'**
  String securityUiNoWebsite(int count);

  /// No description provided for @securityUiCheckNow.
  ///
  /// In en, this message translates to:
  /// **'Check now'**
  String get securityUiCheckNow;

  /// No description provided for @securityUiNoBreaches.
  ///
  /// In en, this message translates to:
  /// **'No known breaches for your saved websites.'**
  String get securityUiNoBreaches;

  /// No description provided for @securityUiBreached.
  ///
  /// In en, this message translates to:
  /// **'Breached. If you made your password before then, change it there.'**
  String get securityUiBreached;

  /// No description provided for @securityUiBreachedOn.
  ///
  /// In en, this message translates to:
  /// **'Breached {date}. If you made your password before then, change it there.'**
  String securityUiBreachedOn(String date);

  /// No description provided for @securityUiBreachedLeaked.
  ///
  /// In en, this message translates to:
  /// **'Breached. Leaked: {data}. If you made your password before then, change it there.'**
  String securityUiBreachedLeaked(String data);

  /// No description provided for @securityUiBreachedOnLeaked.
  ///
  /// In en, this message translates to:
  /// **'Breached {date}. Leaked: {data}. If you made your password before then, change it there.'**
  String securityUiBreachedOnLeaked(String date, String data);

  /// No description provided for @securityUiKitIntro.
  ///
  /// In en, this message translates to:
  /// **'If you lose this device, these are how you get back into your accounts. Each takes a minute. If you haven\'t added any accounts yet, add them first, then come back here from Settings > Security check-up.'**
  String get securityUiKitIntro;

  /// No description provided for @securityUiKitBackupTitle.
  ///
  /// In en, this message translates to:
  /// **'Make a backup'**
  String get securityUiKitBackupTitle;

  /// No description provided for @securityUiKitBackupBody.
  ///
  /// In en, this message translates to:
  /// **'An encrypted file, locked with a passphrase you choose. Keep it somewhere other than this device, like iCloud Drive, Google Drive, or a USB stick.'**
  String get securityUiKitBackupBody;

  /// No description provided for @securityUiKitBackupButton.
  ///
  /// In en, this message translates to:
  /// **'Make a backup'**
  String get securityUiKitBackupButton;

  /// No description provided for @securityUiKitCodesTitle.
  ///
  /// In en, this message translates to:
  /// **'Save your recovery codes'**
  String get securityUiKitCodesTitle;

  /// No description provided for @securityUiKitCodesBody.
  ///
  /// In en, this message translates to:
  /// **'When you turn on two-factor login, most websites give you a list of one-time recovery codes. Add them to each account with ⋯ > Recovery codes, so they\'re in your backup too.'**
  String get securityUiKitCodesBody;

  /// No description provided for @securityUiKitPaperTitle.
  ///
  /// In en, this message translates to:
  /// **'Print a paper backup'**
  String get securityUiKitPaperTitle;

  /// No description provided for @securityUiKitPaperBody.
  ///
  /// In en, this message translates to:
  /// **'Optional. A printed page of QR codes works even if every device is gone. Keep it locked away: anyone with it can make your codes.'**
  String get securityUiKitPaperBody;

  /// No description provided for @securityUiKitPaperButton.
  ///
  /// In en, this message translates to:
  /// **'Print paper backup'**
  String get securityUiKitPaperButton;

  /// No description provided for @securityUiSkipForNow.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get securityUiSkipForNow;

  /// No description provided for @securityExtrasPrivacy.
  ///
  /// In en, this message translates to:
  /// **'No account, no tracking. Your setup keys are stored encrypted on this device. The app goes online only for: a clock check (it asks the Tanooki Auth server for the time, at most once an hour while codes are on screen and when you tap \"Codes not working?\"; nothing about you or your accounts is sent), breach alerts if you turn them on (downloads the public breach list), sync, phone link and emergency access if you set them up (they carry only encrypted data the server can\'t read), buying Premium, and feedback you choose to send (your message, your email if you type one, and the app version and device type if you leave that ticked; never your accounts, codes or anything else in the app). 2FA guides open in your web browser.'**
  String get securityExtrasPrivacy;

  /// No description provided for @securityExtrasMonthlyBody.
  ///
  /// In en, this message translates to:
  /// **'Your monthly security summary is ready. Open Tanooki Auth to see it.'**
  String get securityExtrasMonthlyBody;

  /// No description provided for @securityExtrasNotificationsOffIos.
  ///
  /// In en, this message translates to:
  /// **'Notifications are turned off for Tanooki Auth. Turn them on in the iPhone Settings app, under Notifications, then try again.'**
  String get securityExtrasNotificationsOffIos;

  /// No description provided for @securityExtrasNotificationsOffMac.
  ///
  /// In en, this message translates to:
  /// **'Notifications are turned off for Tanooki Auth. Turn them on in System Settings, under Notifications, then try again.'**
  String get securityExtrasNotificationsOffMac;

  /// No description provided for @securityExtrasReminderFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t set the reminder ({reason}).'**
  String securityExtrasReminderFailed(String reason);

  /// No description provided for @securityExtrasRemindersUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Reminders aren\'t available on this device yet.'**
  String get securityExtrasRemindersUnavailable;

  /// No description provided for @securityExtrasDayTime.
  ///
  /// In en, this message translates to:
  /// **'{day}, {time}'**
  String securityExtrasDayTime(String day, String time);

  /// No description provided for @securityExtrasClearTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear activity history?'**
  String get securityExtrasClearTitle;

  /// No description provided for @securityExtrasClearBody.
  ///
  /// In en, this message translates to:
  /// **'Every entry is removed from this device. Your accounts aren\'t touched.'**
  String get securityExtrasClearBody;

  /// No description provided for @securityExtrasActivityTitle.
  ///
  /// In en, this message translates to:
  /// **'Activity history'**
  String get securityExtrasActivityTitle;

  /// No description provided for @securityExtrasActivityPitch.
  ///
  /// In en, this message translates to:
  /// **'Activity history is part of Premium. It keeps the last {count} times a code was copied, filled into a website, typed, shown as a QR code or exported, on this device only.'**
  String securityExtrasActivityPitch(int count);

  /// No description provided for @securityExtrasNothingYet.
  ///
  /// In en, this message translates to:
  /// **'Nothing yet. Copying, filling, typing, showing a QR code or exporting shows up here.'**
  String get securityExtrasNothingYet;

  /// No description provided for @securityExtrasAllAccounts.
  ///
  /// In en, this message translates to:
  /// **'All accounts'**
  String get securityExtrasAllAccounts;

  /// No description provided for @securityExtrasDeletedAccount.
  ///
  /// In en, this message translates to:
  /// **'A deleted account'**
  String get securityExtrasDeletedAccount;

  /// No description provided for @securityExtrasActivityLine.
  ///
  /// In en, this message translates to:
  /// **'{kind}: {what}'**
  String securityExtrasActivityLine(String kind, String what);

  /// No description provided for @securityExtrasGetPremium.
  ///
  /// In en, this message translates to:
  /// **'Get Premium'**
  String get securityExtrasGetPremium;

  /// No description provided for @securityExtrasAddKey.
  ///
  /// In en, this message translates to:
  /// **'Add a security key'**
  String get securityExtrasAddKey;

  /// No description provided for @securityExtrasAddKeyPremium.
  ///
  /// In en, this message translates to:
  /// **'Add a security key (Premium)'**
  String get securityExtrasAddKeyPremium;

  /// No description provided for @securityExtrasAddKeyIos.
  ///
  /// In en, this message translates to:
  /// **'Next, hold the key to the top of your iPhone, or plug it in, when asked. You may need to touch it twice.'**
  String get securityExtrasAddKeyIos;

  /// No description provided for @securityExtrasAddKeyOther.
  ///
  /// In en, this message translates to:
  /// **'Next, plug the key in and touch it when it blinks. You may need to touch it twice, and type its PIN if it has one.'**
  String get securityExtrasAddKeyOther;

  /// No description provided for @securityExtrasKeyName.
  ///
  /// In en, this message translates to:
  /// **'Name (so you can tell your keys apart)'**
  String get securityExtrasKeyName;

  /// No description provided for @securityExtrasKeyAdded.
  ///
  /// In en, this message translates to:
  /// **'Added \"{name}\". You can now unlock Tanooki Auth with it on this device.'**
  String securityExtrasKeyAdded(String name);

  /// No description provided for @securityExtrasKeyRemoved.
  ///
  /// In en, this message translates to:
  /// **'Removed \"{name}\". It can\'t unlock Tanooki Auth any more.'**
  String securityExtrasKeyRemoved(String name);

  /// No description provided for @securityExtrasKeysTitle.
  ///
  /// In en, this message translates to:
  /// **'Security keys'**
  String get securityExtrasKeysTitle;

  /// No description provided for @securityExtrasKeysIntro.
  ///
  /// In en, this message translates to:
  /// **'A security key (like a YubiKey) can unlock Tanooki Auth instead of {usual}. The key holds a secret that never leaves it, and the app uses it to lock away the key to your accounts. Lose the key and you can still unlock the usual way.'**
  String securityExtrasKeysIntro(String usual);

  /// No description provided for @securityExtrasKeyAddedOn.
  ///
  /// In en, this message translates to:
  /// **'Added {day}'**
  String securityExtrasKeyAddedOn(String day);

  /// No description provided for @securityExtrasLockOffNote.
  ///
  /// In en, this message translates to:
  /// **'The app lock is off, so the app opens without asking. Turn on \"Lock the app\" or a passcode in Settings to use your key.'**
  String get securityExtrasLockOffNote;

  /// No description provided for @securityExtrasLockWordWindows.
  ///
  /// In en, this message translates to:
  /// **'Windows Hello or your passcode'**
  String get securityExtrasLockWordWindows;

  /// No description provided for @securityExtrasLockWordMac.
  ///
  /// In en, this message translates to:
  /// **'Touch ID or your passcode'**
  String get securityExtrasLockWordMac;

  /// No description provided for @securityExtrasLockWordOther.
  ///
  /// In en, this message translates to:
  /// **'Face ID or your passcode'**
  String get securityExtrasLockWordOther;

  /// No description provided for @securityLockImmediately.
  ///
  /// In en, this message translates to:
  /// **'Immediately'**
  String get securityLockImmediately;

  /// No description provided for @securityLockAfter30s.
  ///
  /// In en, this message translates to:
  /// **'After 30 seconds'**
  String get securityLockAfter30s;

  /// No description provided for @securityLockAfter1m.
  ///
  /// In en, this message translates to:
  /// **'After 1 minute'**
  String get securityLockAfter1m;

  /// No description provided for @securityLockAfter5m.
  ///
  /// In en, this message translates to:
  /// **'After 5 minutes'**
  String get securityLockAfter5m;

  /// No description provided for @securityNumbersOnly.
  ///
  /// In en, this message translates to:
  /// **'Use numbers only.'**
  String get securityNumbersOnly;

  /// No description provided for @securityAtLeastNumbers.
  ///
  /// In en, this message translates to:
  /// **'Use at least {count} numbers.'**
  String securityAtLeastNumbers(int count);

  /// No description provided for @securitySameNumber.
  ///
  /// In en, this message translates to:
  /// **'Don\'t use the same number over and over.'**
  String get securitySameNumber;

  /// No description provided for @securityNumbersInRow.
  ///
  /// In en, this message translates to:
  /// **'Don\'t use numbers in a row like 123456.'**
  String get securityNumbersInRow;

  /// No description provided for @securityPanicNeedsPasscode.
  ///
  /// In en, this message translates to:
  /// **'Set an app passcode first. Panic wipe counts wrong passcodes.'**
  String get securityPanicNeedsPasscode;

  /// No description provided for @securityPanicNeedsBackup.
  ///
  /// In en, this message translates to:
  /// **'Make a backup first (Settings > Export backup). Panic wipe erases every account, so it only turns on if you made a backup in the last 30 days.'**
  String get securityPanicNeedsBackup;

  /// No description provided for @securityKeyDefaultName.
  ///
  /// In en, this message translates to:
  /// **'Security key'**
  String get securityKeyDefaultName;

  /// No description provided for @securityKeyNotYours.
  ///
  /// In en, this message translates to:
  /// **'That security key isn\'t one you added to Tanooki Auth on this device.'**
  String get securityKeyNotYours;

  /// No description provided for @securityKeyNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Not available on this device yet.'**
  String get securityKeyNotAvailable;

  /// No description provided for @securityKeyWindowsTooOld.
  ///
  /// In en, this message translates to:
  /// **'Not available on this version of Windows yet. Install the latest Windows 11 updates.'**
  String get securityKeyWindowsTooOld;

  /// No description provided for @securityKeyIosTooOld.
  ///
  /// In en, this message translates to:
  /// **'Needs iOS 26.4 or newer. Update in the Settings app, then try again.'**
  String get securityKeyIosTooOld;

  /// No description provided for @securityKeyMacTooOld.
  ///
  /// In en, this message translates to:
  /// **'Needs macOS 26.4 or newer. Update in the Settings app, then try again.'**
  String get securityKeyMacTooOld;

  /// No description provided for @securityKeyDidntWork.
  ///
  /// In en, this message translates to:
  /// **'The security key didn\'t work. Try again.'**
  String get securityKeyDidntWork;

  /// No description provided for @securityKeyDidntWorkWhy.
  ///
  /// In en, this message translates to:
  /// **'The security key didn\'t work ({reason}). Try again.'**
  String securityKeyDidntWorkWhy(String reason);

  /// No description provided for @securityKeyCanceled.
  ///
  /// In en, this message translates to:
  /// **'Canceled. Nothing changed.'**
  String get securityKeyCanceled;

  /// No description provided for @securityKeyNoPrf.
  ///
  /// In en, this message translates to:
  /// **'This security key can\'t unlock apps this way (it doesn\'t have the \"hmac-secret\" feature). YubiKey 5 series and most FIDO2 keys from the last few years do.'**
  String get securityKeyNoPrf;

  /// No description provided for @securityKeyNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'The security key didn\'t answer, or it isn\'t one added here. Plug it in (or hold it to the top of your phone) and touch it when it blinks.'**
  String get securityKeyNotAllowed;

  /// No description provided for @securityKeyNotAssociated.
  ///
  /// In en, this message translates to:
  /// **'This copy of Tanooki Auth isn\'t allowed to use security keys yet: Apple needs the app linked to auth.tanookistudios.com first. That\'s on our side, not yours.'**
  String get securityKeyNotAssociated;

  /// No description provided for @securityKeyExists.
  ///
  /// In en, this message translates to:
  /// **'This security key is already added.'**
  String get securityKeyExists;

  /// No description provided for @securityKeyPin.
  ///
  /// In en, this message translates to:
  /// **'The security key needs its PIN, and it wasn\'t entered. Try again and type the key\'s PIN when asked.'**
  String get securityKeyPin;

  /// No description provided for @securityKeyVaultKeyMissing.
  ///
  /// In en, this message translates to:
  /// **'The key that unlocks your accounts is missing, so a security key can\'t be added.'**
  String get securityKeyVaultKeyMissing;

  /// No description provided for @securityKeyNoneAdded.
  ///
  /// In en, this message translates to:
  /// **'No security key is added on this device.'**
  String get securityKeyNoneAdded;

  /// No description provided for @securityKeyBeforeReset.
  ///
  /// In en, this message translates to:
  /// **'That security key was added before your accounts were reset, so it can\'t open them. Remove it and add it again.'**
  String get securityKeyBeforeReset;

  /// No description provided for @backupUiChoosePassphrase.
  ///
  /// In en, this message translates to:
  /// **'Choose a backup passphrase'**
  String get backupUiChoosePassphrase;

  /// No description provided for @backupUiPassphraseTitle.
  ///
  /// In en, this message translates to:
  /// **'Backup passphrase'**
  String get backupUiPassphraseTitle;

  /// No description provided for @backupUiPassphraseWarning.
  ///
  /// In en, this message translates to:
  /// **'You\'ll need this to restore the backup. Nobody, including us, can recover it if you forget it. Write it down somewhere safe.'**
  String get backupUiPassphraseWarning;

  /// No description provided for @backupUiPassphrase.
  ///
  /// In en, this message translates to:
  /// **'Passphrase'**
  String get backupUiPassphrase;

  /// No description provided for @backupUiTypeAgain.
  ///
  /// In en, this message translates to:
  /// **'Type it again'**
  String get backupUiTypeAgain;

  /// No description provided for @backupUiTooShort.
  ///
  /// In en, this message translates to:
  /// **'Use at least 8 characters. A few random words works well.'**
  String get backupUiTooShort;

  /// No description provided for @backupUiNoMatch.
  ///
  /// In en, this message translates to:
  /// **'The two passphrases don\'t match.'**
  String get backupUiNoMatch;

  /// No description provided for @backupUiTypePassphrase.
  ///
  /// In en, this message translates to:
  /// **'Type the passphrase.'**
  String get backupUiTypePassphrase;

  /// No description provided for @backupUiNothingToBackUp.
  ///
  /// In en, this message translates to:
  /// **'There are no accounts to back up yet.'**
  String get backupUiNothingToBackUp;

  /// No description provided for @backupUiEncrypting.
  ///
  /// In en, this message translates to:
  /// **'Encrypting backup…'**
  String get backupUiEncrypting;

  /// No description provided for @backupUiSaved.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Backup of 1 account saved.} other{Backup of {count} accounts saved.}}'**
  String backupUiSaved(int count);

  /// No description provided for @backupUiNotABackup.
  ///
  /// In en, this message translates to:
  /// **'That file isn\'t a Tanooki Auth backup.'**
  String get backupUiNotABackup;

  /// No description provided for @backupUiUnlocking.
  ///
  /// In en, this message translates to:
  /// **'Unlocking backup…'**
  String get backupUiUnlocking;

  /// No description provided for @backupUiImported.
  ///
  /// In en, this message translates to:
  /// **'Imported {count}.'**
  String backupUiImported(int count);

  /// No description provided for @backupUiImportedSkipped.
  ///
  /// In en, this message translates to:
  /// **'Imported {added}, skipped {skipped}.'**
  String backupUiImportedSkipped(int added, int skipped);

  /// No description provided for @backupUiImportedSkippedAlready.
  ///
  /// In en, this message translates to:
  /// **'Imported {added}, skipped {skipped} already in your list.'**
  String backupUiImportedSkippedAlready(int added, int skipped);

  /// No description provided for @backupUiAdded.
  ///
  /// In en, this message translates to:
  /// **'Added {count}.'**
  String backupUiAdded(int count);

  /// No description provided for @backupUiAddedSkipped.
  ///
  /// In en, this message translates to:
  /// **'Added {added}, skipped {skipped}.'**
  String backupUiAddedSkipped(int added, int skipped);

  /// No description provided for @backupUiAddedSkippedAlready.
  ///
  /// In en, this message translates to:
  /// **'Added {added}, skipped {skipped} already in your list.'**
  String backupUiAddedSkippedAlready(int added, int skipped);

  /// No description provided for @backupUiAlreadyInList.
  ///
  /// In en, this message translates to:
  /// **'• {count} already in your list'**
  String backupUiAlreadyInList(int count);

  /// No description provided for @backupUiImport.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get backupUiImport;

  /// No description provided for @backupUiImportFromGoogle.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Import 1 from Google Authenticator?} other{Import {count} from Google Authenticator?}}'**
  String backupUiImportFromGoogle(int count);

  /// No description provided for @backupUiGoogleMoreCodes.
  ///
  /// In en, this message translates to:
  /// **'If Google Authenticator showed more than one QR code, scan each of them.'**
  String get backupUiGoogleMoreCodes;

  /// No description provided for @backupUiNothingToExport.
  ///
  /// In en, this message translates to:
  /// **'There are no accounts to export yet.'**
  String get backupUiNothingToExport;

  /// No description provided for @backupUiPlainWhat.
  ///
  /// In en, this message translates to:
  /// **'This saves every setup key as plain text, for moving to another authenticator app.'**
  String get backupUiPlainWhat;

  /// No description provided for @backupUiPlainTitle.
  ///
  /// In en, this message translates to:
  /// **'Export unencrypted?'**
  String get backupUiPlainTitle;

  /// No description provided for @backupUiPlainBody.
  ///
  /// In en, this message translates to:
  /// **'{what} Anyone who gets this file can make your login codes. Import it, then delete it straight away. For a normal backup, use \"Export backup\" instead.'**
  String backupUiPlainBody(String what);

  /// No description provided for @backupUiUnderstandExport.
  ///
  /// In en, this message translates to:
  /// **'I understand, export'**
  String get backupUiUnderstandExport;

  /// No description provided for @backupUiNothingToPrint.
  ///
  /// In en, this message translates to:
  /// **'There are no accounts to print yet.'**
  String get backupUiNothingToPrint;

  /// No description provided for @backupUiPaperTitle.
  ///
  /// In en, this message translates to:
  /// **'Print a paper backup?'**
  String get backupUiPaperTitle;

  /// No description provided for @backupUiPaperBody.
  ///
  /// In en, this message translates to:
  /// **'This makes a PDF with a QR code for every account, plus your unused recovery codes. Anyone who sees or photographs that paper can make your login codes, forever, without your phone or password.\n\nPrint it, then delete the PDF. Keep the paper somewhere locked, like a safe or with important documents. Don\'t email it, and don\'t save it to a shared folder.'**
  String get backupUiPaperBody;

  /// No description provided for @backupUiUnderstandPdf.
  ///
  /// In en, this message translates to:
  /// **'I understand, make the PDF'**
  String get backupUiUnderstandPdf;

  /// No description provided for @backupUiMakingPdf.
  ///
  /// In en, this message translates to:
  /// **'Making the PDF…'**
  String get backupUiMakingPdf;

  /// No description provided for @backupUiPdfReady.
  ///
  /// In en, this message translates to:
  /// **'PDF ready. Print it, then delete the file.'**
  String get backupUiPdfReady;

  /// No description provided for @backupUiWorksTitle.
  ///
  /// In en, this message translates to:
  /// **'Backup works'**
  String get backupUiWorksTitle;

  /// No description provided for @backupUiWorksBody.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{This backup opens fine and has 1 account. Nothing was added or changed.} other{This backup opens fine and has {count} accounts. Nothing was added or changed.}}'**
  String backupUiWorksBody(int count);

  /// No description provided for @backupWrongVersion.
  ///
  /// In en, this message translates to:
  /// **'This backup was made by a newer version of Tanooki Auth. Update the app and try again.'**
  String get backupWrongVersion;

  /// No description provided for @backupWrongPassphrase.
  ///
  /// In en, this message translates to:
  /// **'Wrong passphrase, or the backup file is damaged.'**
  String get backupWrongPassphrase;

  /// No description provided for @backupDamaged.
  ///
  /// In en, this message translates to:
  /// **'The backup unlocked but its contents are damaged.'**
  String get backupDamaged;

  /// No description provided for @paperBackupTitle.
  ///
  /// In en, this message translates to:
  /// **'Tanooki Auth paper backup'**
  String get paperBackupTitle;

  /// No description provided for @paperBackupHeader.
  ///
  /// In en, this message translates to:
  /// **'Tanooki Auth paper backup, {date}'**
  String paperBackupHeader(String date);

  /// No description provided for @paperBackupWarning.
  ///
  /// In en, this message translates to:
  /// **'KEEP THIS SECRET. Anyone with this paper can make your login codes. Store it somewhere locked; shred it when you make a new one. To restore: in any authenticator app, choose \"Scan QR code\" and scan each code below.'**
  String get paperBackupWarning;

  /// No description provided for @paperBackupSetupKey.
  ///
  /// In en, this message translates to:
  /// **'Setup key: {key}'**
  String paperBackupSetupKey(String key);

  /// No description provided for @paperBackupRecoveryCodes.
  ///
  /// In en, this message translates to:
  /// **'Recovery codes (each works once):'**
  String get paperBackupRecoveryCodes;

  /// No description provided for @autoBackupUiChooseFolderDialog.
  ///
  /// In en, this message translates to:
  /// **'Choose a folder for automatic backups'**
  String get autoBackupUiChooseFolderDialog;

  /// No description provided for @autoBackupUiToday.
  ///
  /// In en, this message translates to:
  /// **'Today at {time}'**
  String autoBackupUiToday(String time);

  /// No description provided for @autoBackupUiYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday at {time}'**
  String autoBackupUiYesterday(String time);

  /// No description provided for @autoBackupUiOnDay.
  ///
  /// In en, this message translates to:
  /// **'{date} at {time}'**
  String autoBackupUiOnDay(String date, String time);

  /// No description provided for @autoBackupUiBackingUp.
  ///
  /// In en, this message translates to:
  /// **'Backing up…'**
  String get autoBackupUiBackingUp;

  /// No description provided for @autoBackupUiBackedUp.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Backed up 1 account.} other{Backed up {count} accounts.}}'**
  String autoBackupUiBackedUp(int count);

  /// No description provided for @autoBackupUiCouldntUseFolder.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t use that folder.'**
  String get autoBackupUiCouldntUseFolder;

  /// No description provided for @autoBackupUiCouldntUseFolderWhy.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t use that folder. {reason}'**
  String autoBackupUiCouldntUseFolderWhy(String reason);

  /// No description provided for @autoBackupUiTurnOffTitle.
  ///
  /// In en, this message translates to:
  /// **'Turn off automatic backups?'**
  String get autoBackupUiTurnOffTitle;

  /// No description provided for @autoBackupUiTurnOffBody.
  ///
  /// In en, this message translates to:
  /// **'Backups already in the folder stay there. The backup passphrase is forgotten, so you\'ll choose a new one if you turn this on again.'**
  String get autoBackupUiTurnOffBody;

  /// No description provided for @autoBackupUiTitle.
  ///
  /// In en, this message translates to:
  /// **'Automatic backups'**
  String get autoBackupUiTitle;

  /// No description provided for @autoBackupUiTitlePremium.
  ///
  /// In en, this message translates to:
  /// **'Automatic backups (Premium)'**
  String get autoBackupUiTitlePremium;

  /// No description provided for @autoBackupUiIntro.
  ///
  /// In en, this message translates to:
  /// **'Once a day, Tanooki Auth saves an encrypted backup to a folder you choose. Pick your iCloud Drive, Google Drive or Dropbox folder and your backups are off this device too. The newest {count} are kept; older ones are deleted.\n\nRestore one with Settings > Import backup and your backup passphrase.'**
  String autoBackupUiIntro(int count);

  /// No description provided for @autoBackupUiLastFailed.
  ///
  /// In en, this message translates to:
  /// **'The last automatic backup failed'**
  String get autoBackupUiLastFailed;

  /// No description provided for @autoBackupUiChooseFolder.
  ///
  /// In en, this message translates to:
  /// **'Choose a folder'**
  String get autoBackupUiChooseFolder;

  /// No description provided for @autoBackupUiBackupFolder.
  ///
  /// In en, this message translates to:
  /// **'Backup folder'**
  String get autoBackupUiBackupFolder;

  /// No description provided for @autoBackupUiNoBackupYet.
  ///
  /// In en, this message translates to:
  /// **'No backup yet'**
  String get autoBackupUiNoBackupYet;

  /// No description provided for @autoBackupUiLastBackup.
  ///
  /// In en, this message translates to:
  /// **'Last backup: {when}'**
  String autoBackupUiLastBackup(String when);

  /// No description provided for @autoBackupUiBackUpNow.
  ///
  /// In en, this message translates to:
  /// **'Back up now'**
  String get autoBackupUiBackUpNow;

  /// No description provided for @autoBackupUiChangeFolder.
  ///
  /// In en, this message translates to:
  /// **'Change folder'**
  String get autoBackupUiChangeFolder;

  /// No description provided for @autoBackupUiOffSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Off. A daily encrypted backup to iCloud Drive, Google Drive, Dropbox or any folder.'**
  String get autoBackupUiOffSubtitle;

  /// No description provided for @autoBackupUiOnNoBackup.
  ///
  /// In en, this message translates to:
  /// **'On, to {folder}. No backup yet.'**
  String autoBackupUiOnNoBackup(String folder);

  /// No description provided for @autoBackupUiOnLast.
  ///
  /// In en, this message translates to:
  /// **'On, to {folder}. Last backup: {when}.'**
  String autoBackupUiOnLast(String folder, String when);

  /// No description provided for @autoBackupFolderGone.
  ///
  /// In en, this message translates to:
  /// **'The backup folder is gone. It may have been deleted, renamed outside the app, or its drive is unplugged. Choose the folder again.'**
  String get autoBackupFolderGone;

  /// No description provided for @autoBackupPermissionLost.
  ///
  /// In en, this message translates to:
  /// **'Tanooki Auth is no longer allowed to write to the backup folder. Choose the folder again to give permission back.'**
  String get autoBackupPermissionLost;

  /// No description provided for @autoBackupDiskFull.
  ///
  /// In en, this message translates to:
  /// **'The backup folder\'s drive is full. Free up some space, then tap Back up now.'**
  String get autoBackupDiskFull;

  /// No description provided for @autoBackupOther.
  ///
  /// In en, this message translates to:
  /// **'The backup couldn\'t be saved. Tap Back up now to try again.'**
  String get autoBackupOther;

  /// No description provided for @autoBackupOtherWhy.
  ///
  /// In en, this message translates to:
  /// **'The backup couldn\'t be saved ({reason}). Tap Back up now to try again.'**
  String autoBackupOtherWhy(String reason);

  /// No description provided for @importUiDeleteNote.
  ///
  /// In en, this message translates to:
  /// **'When you\'re done, delete the export file: anyone who gets it can make your codes.'**
  String get importUiDeleteNote;

  /// No description provided for @importUiStepsAegis.
  ///
  /// In en, this message translates to:
  /// **'In Aegis on your Android phone:\n\n1. Tap ⋮, then Settings, then \"Import & Export\".\n2. Tap \"Export\", choose \"Aegis (.JSON)\".\n3. Keep \"Encrypt the vault\" on if you like; you\'ll type that password here.\n4. Save the file somewhere this device can open (for example Google Drive or email it to yourself).\n\nThen pick that file here.'**
  String get importUiStepsAegis;

  /// No description provided for @importUiStepsTwoFas.
  ///
  /// In en, this message translates to:
  /// **'In 2FAS:\n\n1. Open Settings, then \"2FAS Backup\".\n2. Tap \"Export to file\". If it asks for a password, you\'ll type the same one here.\n3. Save the .2fas file somewhere this device can open.\n\nThen pick that file here.'**
  String get importUiStepsTwoFas;

  /// No description provided for @importUiStepsAuthy.
  ///
  /// In en, this message translates to:
  /// **'Authy has no export button, and Authy for computers was shut down in 2024.\n\nIf you already got your accounts out with a tool such as \"authy-export\", pick the file it made (a .json file, or a .txt list of otpauth:// links).\n\nIf not, the safe way is one account at a time: log in to each website, turn two-factor login off and back on, and scan the new QR code with Tanooki Auth. Keep Authy until every account works here.'**
  String get importUiStepsAuthy;

  /// No description provided for @importUiStepsBitwarden.
  ///
  /// In en, this message translates to:
  /// **'In Bitwarden (website or desktop app):\n\n1. Go to Tools, then \"Export vault\".\n2. Choose \".json\" or \".csv\". Not \"encrypted\".\n3. Save the file.\n\nThen pick that file here. Only logins with an authenticator key come across; your passwords are ignored.'**
  String get importUiStepsBitwarden;

  /// No description provided for @importUiStepsOnePassword.
  ///
  /// In en, this message translates to:
  /// **'In the 1Password app for Mac or Windows:\n\n1. Click File, then Export, then pick your account.\n2. Choose \"CSV\" as the format and save.\n\nThen pick that file here. Only items with a one-time password come across; your passwords are ignored.'**
  String get importUiStepsOnePassword;

  /// No description provided for @importUiStepsApple.
  ///
  /// In en, this message translates to:
  /// **'You need a Mac for this; iPhone can\'t save the file.\n\nOn a Mac with macOS Sequoia or newer:\n1. Open the Passwords app.\n2. In the menu bar, click File, then \"Export All Passwords…\".\n3. Click \"Export Passwords\", type your Mac password if asked, and save the file.\n\nOn an older Mac: open Safari, then Safari > Settings > Passwords, click the ⋯ button, and choose \"Export All Passwords…\".\n\nThen pick that file here. Only items with a verification code come across; your passwords are ignored.'**
  String get importUiStepsApple;

  /// No description provided for @importUiStepsMicrosoft.
  ///
  /// In en, this message translates to:
  /// **'Microsoft Authenticator can\'t export your accounts, so they can\'t be moved in one go.\n\nFor each account:\n1. Log in to that website on a computer.\n2. Find its security or two-factor settings.\n3. Turn two-factor login off and back on (or choose \"add a new authenticator app\").\n4. Scan the new QR code with Tanooki Auth and type in the code it shows to finish.\n\nKeep Microsoft Authenticator until every account works in Tanooki Auth. Your Microsoft account itself can also use Tanooki Auth: add it at account.microsoft.com, under Security.'**
  String get importUiStepsMicrosoft;

  /// No description provided for @importUiTitle.
  ///
  /// In en, this message translates to:
  /// **'Move from another app'**
  String get importUiTitle;

  /// No description provided for @importUiCantExport.
  ///
  /// In en, this message translates to:
  /// **'Can\'t export: how to move each account'**
  String get importUiCantExport;

  /// No description provided for @importUiFromExportFile.
  ///
  /// In en, this message translates to:
  /// **'From an export file'**
  String get importUiFromExportFile;

  /// No description provided for @importUiMoveFrom.
  ///
  /// In en, this message translates to:
  /// **'Move from {app}'**
  String importUiMoveFrom(String app);

  /// No description provided for @importUiGotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get importUiGotIt;

  /// No description provided for @importUiPickFile.
  ///
  /// In en, this message translates to:
  /// **'Pick file'**
  String get importUiPickFile;

  /// No description provided for @importUiCouldntRead.
  ///
  /// In en, this message translates to:
  /// **'That file couldn\'t be read.'**
  String get importUiCouldntRead;

  /// No description provided for @importUiReading.
  ///
  /// In en, this message translates to:
  /// **'Reading {app} export…'**
  String importUiReading(String app);

  /// No description provided for @importUiNoAccountsInFile.
  ///
  /// In en, this message translates to:
  /// **'No two-factor accounts were in that file.'**
  String get importUiNoAccountsInFile;

  /// No description provided for @importUiImportFrom.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Import 1 from {app}?} other{Import {count} from {app}?}}'**
  String importUiImportFrom(int count, String app);

  /// No description provided for @importUiExportPassword.
  ///
  /// In en, this message translates to:
  /// **'{app} export password'**
  String importUiExportPassword(String app);

  /// No description provided for @importUiPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'The password you chose when exporting'**
  String get importUiPasswordHint;

  /// No description provided for @importersNotAnExport.
  ///
  /// In en, this message translates to:
  /// **'That file isn\'t a {app} export.'**
  String importersNotAnExport(String app);

  /// No description provided for @importersLine.
  ///
  /// In en, this message translates to:
  /// **'Line {line}: {problem}'**
  String importersLine(String line, String problem);

  /// No description provided for @importersEmpty.
  ///
  /// In en, this message translates to:
  /// **'That file is empty.'**
  String get importersEmpty;

  /// No description provided for @importersNotAuthy.
  ///
  /// In en, this message translates to:
  /// **'That file isn\'t an Authy export.'**
  String get importersNotAuthy;

  /// No description provided for @importersAnAccount.
  ///
  /// In en, this message translates to:
  /// **'An account'**
  String get importersAnAccount;

  /// No description provided for @importersQuoted.
  ///
  /// In en, this message translates to:
  /// **'\"{name}\"'**
  String importersQuoted(String name);

  /// No description provided for @importersProblemColon.
  ///
  /// In en, this message translates to:
  /// **'{name}: {problem}'**
  String importersProblemColon(String name, String problem);

  /// No description provided for @importersProblem.
  ///
  /// In en, this message translates to:
  /// **'{name} {problem}'**
  String importersProblem(String name, String problem);

  /// No description provided for @importersAegisPassword.
  ///
  /// In en, this message translates to:
  /// **'This Aegis export is protected with a password.'**
  String get importersAegisPassword;

  /// No description provided for @importersAegisBiometricOnly.
  ///
  /// In en, this message translates to:
  /// **'This Aegis export can only be opened with a fingerprint on the phone that made it. In Aegis, export again and choose a password.'**
  String get importersAegisBiometricOnly;

  /// No description provided for @importersAegisWrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Wrong password for this Aegis export.'**
  String get importersAegisWrongPassword;

  /// No description provided for @importersAegisDamaged.
  ///
  /// In en, this message translates to:
  /// **'The Aegis export unlocked but its contents are damaged.'**
  String get importersAegisDamaged;

  /// No description provided for @importersNotAegis.
  ///
  /// In en, this message translates to:
  /// **'That file isn\'t an Aegis export.'**
  String get importersNotAegis;

  /// No description provided for @importersUnsupportedType.
  ///
  /// In en, this message translates to:
  /// **'uses {type} codes, which Tanooki Auth doesn\'t support'**
  String importersUnsupportedType(String type);

  /// No description provided for @importersNotTwoFas.
  ///
  /// In en, this message translates to:
  /// **'That file isn\'t a 2FAS backup.'**
  String get importersNotTwoFas;

  /// No description provided for @importersTwoFasPassword.
  ///
  /// In en, this message translates to:
  /// **'This 2FAS backup is protected with a password.'**
  String get importersTwoFasPassword;

  /// No description provided for @importersTwoFasDamaged.
  ///
  /// In en, this message translates to:
  /// **'This 2FAS backup is damaged.'**
  String get importersTwoFasDamaged;

  /// No description provided for @importersTwoFasWrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Wrong password for this 2FAS backup.'**
  String get importersTwoFasWrongPassword;

  /// No description provided for @importersBitwardenEncrypted.
  ///
  /// In en, this message translates to:
  /// **'That Bitwarden export is encrypted. In Bitwarden, export again and choose the \".json\" format (not \"encrypted\").'**
  String get importersBitwardenEncrypted;

  /// No description provided for @importersOnePux.
  ///
  /// In en, this message translates to:
  /// **'That looks like a 1Password .1pux file. In 1Password, export again and choose CSV.'**
  String get importersOnePux;

  /// No description provided for @importersNoCodeColumn.
  ///
  /// In en, this message translates to:
  /// **'That file has no one-time code column, so it isn\'t a {app} export with codes in it.'**
  String importersNoCodeColumn(String app);

  /// No description provided for @importersCantReadCode.
  ///
  /// In en, this message translates to:
  /// **'has a one-time code Tanooki Auth can\'t read ({reason})'**
  String importersCantReadCode(String reason);

  /// No description provided for @importersNoSecret.
  ///
  /// In en, this message translates to:
  /// **'has no secret'**
  String get importersNoSecret;

  /// No description provided for @importersBadSecret.
  ///
  /// In en, this message translates to:
  /// **'has a secret that isn\'t valid'**
  String get importersBadSecret;

  /// No description provided for @importersUnsupportedDigits.
  ///
  /// In en, this message translates to:
  /// **'uses {count}-digit codes, which Tanooki Auth doesn\'t support'**
  String importersUnsupportedDigits(int count);

  /// No description provided for @importersBadPeriod.
  ///
  /// In en, this message translates to:
  /// **'has a broken time period'**
  String get importersBadPeriod;

  /// No description provided for @importersUnsupportedAlgorithm.
  ///
  /// In en, this message translates to:
  /// **'uses the {algorithm} algorithm, which Tanooki Auth doesn\'t support'**
  String importersUnsupportedAlgorithm(String algorithm);

  /// No description provided for @exportUiTitle.
  ///
  /// In en, this message translates to:
  /// **'Move to another app'**
  String get exportUiTitle;

  /// No description provided for @exportUiAegisLocked.
  ///
  /// In en, this message translates to:
  /// **'Aegis, with a password'**
  String get exportUiAegisLocked;

  /// No description provided for @exportUiAegisLockedSub.
  ///
  /// In en, this message translates to:
  /// **'Safest. Aegis asks for the password when you import.'**
  String get exportUiAegisLockedSub;

  /// No description provided for @exportUiAegisPlain.
  ///
  /// In en, this message translates to:
  /// **'Aegis, not encrypted'**
  String get exportUiAegisPlain;

  /// No description provided for @exportUiAegisPlainSub.
  ///
  /// In en, this message translates to:
  /// **'For apps that read Aegis files but can\'t open locked ones.'**
  String get exportUiAegisPlainSub;

  /// No description provided for @exportUiTwoFasSub.
  ///
  /// In en, this message translates to:
  /// **'A .2fas file without a password.'**
  String get exportUiTwoFasSub;

  /// No description provided for @exportUiGoogleSub.
  ///
  /// In en, this message translates to:
  /// **'QR codes to scan with Google Authenticator.'**
  String get exportUiGoogleSub;

  /// No description provided for @exportUiLinks.
  ///
  /// In en, this message translates to:
  /// **'Setup links (plain text)'**
  String get exportUiLinks;

  /// No description provided for @exportUiLinksSub.
  ///
  /// In en, this message translates to:
  /// **'One otpauth:// link per line, for any other app.'**
  String get exportUiLinksSub;

  /// No description provided for @exportUiConfirmReason.
  ///
  /// In en, this message translates to:
  /// **'Export your accounts'**
  String get exportUiConfirmReason;

  /// No description provided for @exportUiEncryptingAegis.
  ///
  /// In en, this message translates to:
  /// **'Encrypting for Aegis…'**
  String get exportUiEncryptingAegis;

  /// No description provided for @exportUiAegisPlainWhat.
  ///
  /// In en, this message translates to:
  /// **'This saves every setup key in an unencrypted Aegis file.'**
  String get exportUiAegisPlainWhat;

  /// No description provided for @exportUiTwoFasWhat.
  ///
  /// In en, this message translates to:
  /// **'This saves every setup key in a 2FAS file without a password.'**
  String get exportUiTwoFasWhat;

  /// No description provided for @exportUiGoogleTitle.
  ///
  /// In en, this message translates to:
  /// **'Show QR codes for Google Authenticator?'**
  String get exportUiGoogleTitle;

  /// No description provided for @exportUiGoogleBody.
  ///
  /// In en, this message translates to:
  /// **'The next screen shows QR codes holding every setup key. Anyone who sees or photographs them can make your login codes. Do this somewhere private.\n\nIn Google Authenticator: tap +, then \"Scan a QR code\", and scan each code in turn.'**
  String get exportUiGoogleBody;

  /// No description provided for @exportUiShowCodes.
  ///
  /// In en, this message translates to:
  /// **'Show the codes'**
  String get exportUiShowCodes;

  /// No description provided for @exportUiExported.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Exported 1 account. Import the file in the other app, then delete it.} other{Exported {count} accounts. Import the file in the other app, then delete it.}}'**
  String exportUiExported(int count);

  /// No description provided for @exportUiNoneForGoogle.
  ///
  /// In en, this message translates to:
  /// **'None of your accounts can go into Google Authenticator.'**
  String get exportUiNoneForGoogle;

  /// No description provided for @exportUiScanThisCode.
  ///
  /// In en, this message translates to:
  /// **'Scan this code'**
  String get exportUiScanThisCode;

  /// No description provided for @exportUiCodeOf.
  ///
  /// In en, this message translates to:
  /// **'Code {n} of {total}'**
  String exportUiCodeOf(int n, int total);

  /// No description provided for @exportUiNextCode.
  ///
  /// In en, this message translates to:
  /// **'Next code'**
  String get exportUiNextCode;

  /// No description provided for @exportUiLeftOut.
  ///
  /// In en, this message translates to:
  /// **'Left out ({count}). Google Authenticator can\'t make these codes, so add them to another app:'**
  String exportUiLeftOut(int count);

  /// No description provided for @appIconClassic.
  ///
  /// In en, this message translates to:
  /// **'Classic'**
  String get appIconClassic;

  /// No description provided for @appIconPink.
  ///
  /// In en, this message translates to:
  /// **'Pastel Pink'**
  String get appIconPink;

  /// No description provided for @appIconBlue.
  ///
  /// In en, this message translates to:
  /// **'Pastel Blue'**
  String get appIconBlue;

  /// No description provided for @appIconLavender.
  ///
  /// In en, this message translates to:
  /// **'Lavender'**
  String get appIconLavender;

  /// No description provided for @appIconMint.
  ///
  /// In en, this message translates to:
  /// **'Mint'**
  String get appIconMint;

  /// No description provided for @appIconMidnight.
  ///
  /// In en, this message translates to:
  /// **'Midnight'**
  String get appIconMidnight;

  /// No description provided for @appIconSunset.
  ///
  /// In en, this message translates to:
  /// **'Sunset'**
  String get appIconSunset;

  /// No description provided for @appIconSpooky.
  ///
  /// In en, this message translates to:
  /// **'Spooky (fall)'**
  String get appIconSpooky;

  /// No description provided for @appIconCozy.
  ///
  /// In en, this message translates to:
  /// **'Cozy (winter)'**
  String get appIconCozy;

  /// No description provided for @appIconSpring.
  ///
  /// In en, this message translates to:
  /// **'Spring'**
  String get appIconSpring;

  /// No description provided for @serverBrowserExtension.
  ///
  /// In en, this message translates to:
  /// **'Browser extension'**
  String get serverBrowserExtension;

  /// No description provided for @serverBadRequest.
  ///
  /// In en, this message translates to:
  /// **'Tanooki Auth didn\'t understand that request.'**
  String get serverBadRequest;

  /// No description provided for @serverLocked.
  ///
  /// In en, this message translates to:
  /// **'Tanooki Auth is locked. Unlock it, then try again.'**
  String get serverLocked;

  /// No description provided for @serverNotPaired.
  ///
  /// In en, this message translates to:
  /// **'This app isn\'t paired with Tanooki Auth.'**
  String get serverNotPaired;

  /// No description provided for @serverNotFound.
  ///
  /// In en, this message translates to:
  /// **'That account isn\'t in Tanooki Auth any more.'**
  String get serverNotFound;

  /// No description provided for @serverRateLimited.
  ///
  /// In en, this message translates to:
  /// **'Too many requests.'**
  String get serverRateLimited;

  /// No description provided for @serverDenied.
  ///
  /// In en, this message translates to:
  /// **'Not allowed: this account asks first, and Tanooki Auth wasn\'t unlocked for it.'**
  String get serverDenied;

  /// No description provided for @serverUnknownScreen.
  ///
  /// In en, this message translates to:
  /// **'Unknown screen.'**
  String get serverUnknownScreen;

  /// No description provided for @serverNoWebsite.
  ///
  /// In en, this message translates to:
  /// **'No website given.'**
  String get serverNoWebsite;

  /// No description provided for @serverUnknownRequest.
  ///
  /// In en, this message translates to:
  /// **'Unknown request \"{type}\".'**
  String serverUnknownRequest(String type);

  /// No description provided for @serverPairingTimedOut.
  ///
  /// In en, this message translates to:
  /// **'Pairing timed out or was closed. Start pairing again.'**
  String get serverPairingTimedOut;

  /// No description provided for @serverThreeWrongCodes.
  ///
  /// In en, this message translates to:
  /// **'Three wrong codes. Start pairing again.'**
  String get serverThreeWrongCodes;

  /// No description provided for @serverWrongCode.
  ///
  /// In en, this message translates to:
  /// **'That code doesn\'t match. Check the code shown in Tanooki Auth.'**
  String get serverWrongCode;

  /// No description provided for @serverNoLink.
  ///
  /// In en, this message translates to:
  /// **'No otpauth:// link was sent.'**
  String get serverNoLink;

  /// No description provided for @serverAlreadyThere.
  ///
  /// In en, this message translates to:
  /// **'That account is already in Tanooki Auth.'**
  String get serverAlreadyThere;

  /// No description provided for @serverAlreadyThereMany.
  ///
  /// In en, this message translates to:
  /// **'Those accounts are already in Tanooki Auth.'**
  String get serverAlreadyThereMany;

  /// No description provided for @autoBackupNotSupported.
  ///
  /// In en, this message translates to:
  /// **'not supported on this device'**
  String get autoBackupNotSupported;

  /// No description provided for @homeProveCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy the code for {name}'**
  String homeProveCopy(String name);

  /// No description provided for @homeProveReadAloud.
  ///
  /// In en, this message translates to:
  /// **'Read aloud the code for {name}'**
  String homeProveReadAloud(String name);

  /// No description provided for @homeProveEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit {name}'**
  String homeProveEdit(String name);

  /// No description provided for @homeProveShare.
  ///
  /// In en, this message translates to:
  /// **'Share {name}'**
  String homeProveShare(String name);

  /// No description provided for @homeCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied {name} code. The clipboard clears in 30 seconds.'**
  String homeCopied(String name);

  /// No description provided for @homeEditAccount.
  ///
  /// In en, this message translates to:
  /// **'Edit account'**
  String get homeEditAccount;

  /// No description provided for @homeShowQrFor.
  ///
  /// In en, this message translates to:
  /// **'Show the QR code for {name}'**
  String homeShowQrFor(String name);

  /// No description provided for @homeMovedToTrash.
  ///
  /// In en, this message translates to:
  /// **'Moved {name} to Trash. You can restore it from Settings for 30 days.'**
  String homeMovedToTrash(String name);

  /// No description provided for @homeUndo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get homeUndo;

  /// No description provided for @homeAccountCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 account} other{{count} accounts}}'**
  String homeAccountCount(int count);

  /// No description provided for @homeAddTagTo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Add a tag to 1 account} other{Add a tag to {count} accounts}}'**
  String homeAddTagTo(int count);

  /// No description provided for @homeTagHint.
  ///
  /// In en, this message translates to:
  /// **'Tag (e.g. work)'**
  String get homeTagHint;

  /// No description provided for @homeAddTag.
  ///
  /// In en, this message translates to:
  /// **'Add tag'**
  String get homeAddTag;

  /// No description provided for @homeTagged.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Tagged 1 account \"{tag}\".} other{Tagged {count} accounts \"{tag}\".}}'**
  String homeTagged(int count, String tag);

  /// No description provided for @homeMoveToFolderTitle.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Move 1 account to a folder} other{Move {count} accounts to a folder}}'**
  String homeMoveToFolderTitle(int count);

  /// No description provided for @homeNoFolder.
  ///
  /// In en, this message translates to:
  /// **'No folder'**
  String get homeNoFolder;

  /// No description provided for @homeNewFolderHint.
  ///
  /// In en, this message translates to:
  /// **'Or a new folder (e.g. Work)'**
  String get homeNewFolderHint;

  /// No description provided for @homeMoveToNewFolder.
  ///
  /// In en, this message translates to:
  /// **'Move to new folder'**
  String get homeMoveToNewFolder;

  /// No description provided for @homeTookOut.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Took 1 account out of their folders.} other{Took {count} accounts out of their folders.}}'**
  String homeTookOut(int count);

  /// No description provided for @homeMovedTo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Moved 1 account to {folder}.} other{Moved {count} accounts to {folder}.}}'**
  String homeMovedTo(int count, String folder);

  /// No description provided for @homeAddedToFavorites.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Added 1 account to favorites.} other{Added {count} accounts to favorites.}}'**
  String homeAddedToFavorites(int count);

  /// No description provided for @homeRemovedFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Removed 1 account from favorites.} other{Removed {count} accounts from favorites.}}'**
  String homeRemovedFromFavorites(int count);

  /// No description provided for @homeBulkTrashed.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Moved 1 account to Trash. You can restore them from Settings for 30 days.} other{Moved {count} accounts to Trash. You can restore them from Settings for 30 days.}}'**
  String homeBulkTrashed(int count);

  /// No description provided for @homeDoneSelecting.
  ///
  /// In en, this message translates to:
  /// **'Done selecting'**
  String get homeDoneSelecting;

  /// No description provided for @homeTapToSelect.
  ///
  /// In en, this message translates to:
  /// **'Tap accounts to select'**
  String get homeTapToSelect;

  /// No description provided for @homeSelectedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String homeSelectedCount(int count);

  /// No description provided for @homeSelectNone.
  ///
  /// In en, this message translates to:
  /// **'Select none'**
  String get homeSelectNone;

  /// No description provided for @homeSelectAll.
  ///
  /// In en, this message translates to:
  /// **'Select all'**
  String get homeSelectAll;

  /// No description provided for @homeAddATag.
  ///
  /// In en, this message translates to:
  /// **'Add a tag'**
  String get homeAddATag;

  /// No description provided for @homeMoveToFolder.
  ///
  /// In en, this message translates to:
  /// **'Move to folder'**
  String get homeMoveToFolder;

  /// No description provided for @homeRemoveFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get homeRemoveFromFavorites;

  /// No description provided for @homeAddToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get homeAddToFavorites;

  /// No description provided for @homeMoveToTrash.
  ///
  /// In en, this message translates to:
  /// **'Move to Trash'**
  String get homeMoveToTrash;

  /// No description provided for @homeSelectFirst.
  ///
  /// In en, this message translates to:
  /// **'Select some accounts first: tap them in the list.'**
  String get homeSelectFirst;

  /// No description provided for @homeSectionOpen.
  ///
  /// In en, this message translates to:
  /// **'{name}, {accounts}, tap to fold away'**
  String homeSectionOpen(String name, String accounts);

  /// No description provided for @homeSectionClosed.
  ///
  /// In en, this message translates to:
  /// **'{name}, {accounts}, tap to show'**
  String homeSectionClosed(String name, String accounts);

  /// No description provided for @homeSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search accounts or websites…'**
  String get homeSearchHint;

  /// No description provided for @homeAllTags.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get homeAllTags;

  /// No description provided for @homeNoAccountsYet.
  ///
  /// In en, this message translates to:
  /// **'No accounts yet.\nAdd one to scan a setup QR code.'**
  String get homeNoAccountsYet;

  /// No description provided for @homeNoTagMatches.
  ///
  /// In en, this message translates to:
  /// **'No accounts with this tag.'**
  String get homeNoTagMatches;

  /// No description provided for @homeNoSearchMatches.
  ///
  /// In en, this message translates to:
  /// **'No accounts match your search.'**
  String get homeNoSearchMatches;

  /// No description provided for @homeSelectAccounts.
  ///
  /// In en, this message translates to:
  /// **'Select accounts'**
  String get homeSelectAccounts;

  /// No description provided for @homeSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get homeSettings;

  /// No description provided for @homeAddAccount.
  ///
  /// In en, this message translates to:
  /// **'Add account'**
  String get homeAddAccount;

  /// No description provided for @homeAccounts.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get homeAccounts;

  /// No description provided for @homeYourAccounts.
  ///
  /// In en, this message translates to:
  /// **'Your accounts'**
  String get homeYourAccounts;

  /// No description provided for @homeSelect.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get homeSelect;

  /// No description provided for @homeKeysTouch.
  ///
  /// In en, this message translates to:
  /// **'Tap (Copy) · Enter (Copy) · Arrows (Navigate)'**
  String get homeKeysTouch;

  /// No description provided for @homeKeysClick.
  ///
  /// In en, this message translates to:
  /// **'Click (Copy) · Enter (Copy) · Arrows (Navigate)'**
  String get homeKeysClick;

  /// No description provided for @homePickOnLeft.
  ///
  /// In en, this message translates to:
  /// **'Pick an account on the left to see it here.'**
  String get homePickOnLeft;

  /// No description provided for @homeQrFor.
  ///
  /// In en, this message translates to:
  /// **'QR code for {name}'**
  String homeQrFor(String name);

  /// No description provided for @homeQrWarning.
  ///
  /// In en, this message translates to:
  /// **'Scan this with another authenticator app to add the same account there. Anyone who sees or photographs it can make your codes, so keep it private.'**
  String get homeQrWarning;

  /// No description provided for @homeVersionNote.
  ///
  /// In en, this message translates to:
  /// **'v{version} · stays on this device'**
  String homeVersionNote(Object version);

  /// No description provided for @homeSelectName.
  ///
  /// In en, this message translates to:
  /// **'Select {name}'**
  String homeSelectName(String name);

  /// No description provided for @homeMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get homeMore;

  /// No description provided for @homeRecoveryCodes.
  ///
  /// In en, this message translates to:
  /// **'Recovery codes'**
  String get homeRecoveryCodes;

  /// No description provided for @homeRecoveryCodesLeft.
  ///
  /// In en, this message translates to:
  /// **'Recovery codes ({count} left)'**
  String homeRecoveryCodesLeft(int count);

  /// No description provided for @homeShareSecurely.
  ///
  /// In en, this message translates to:
  /// **'Share securely'**
  String get homeShareSecurely;

  /// No description provided for @homeShowQr.
  ///
  /// In en, this message translates to:
  /// **'Show QR code'**
  String get homeShowQr;

  /// No description provided for @homeMoveEarlier.
  ///
  /// In en, this message translates to:
  /// **'Move earlier'**
  String get homeMoveEarlier;

  /// No description provided for @homeMoveLater.
  ///
  /// In en, this message translates to:
  /// **'Move later'**
  String get homeMoveLater;

  /// No description provided for @homeNextCodeShort.
  ///
  /// In en, this message translates to:
  /// **'Next {code}'**
  String homeNextCodeShort(String code);

  /// No description provided for @homeNextCode.
  ///
  /// In en, this message translates to:
  /// **'Next code'**
  String get homeNextCode;

  /// No description provided for @homeFavorite.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get homeFavorite;

  /// No description provided for @homeCodeHiddenAsk.
  ///
  /// In en, this message translates to:
  /// **'Code hidden until you confirm it is you'**
  String get homeCodeHiddenAsk;

  /// No description provided for @homeCodeHidden.
  ///
  /// In en, this message translates to:
  /// **'Code hidden'**
  String get homeCodeHidden;

  /// No description provided for @homeNextCodeSpoken.
  ///
  /// In en, this message translates to:
  /// **'Next code {code}'**
  String homeNextCodeSpoken(String code);

  /// No description provided for @homeKindTotp.
  ///
  /// In en, this message translates to:
  /// **'TOTP · {count, plural, =1{1 digit} other{{count} digits}} · {seconds}s'**
  String homeKindTotp(int count, int seconds);

  /// No description provided for @homeKindSteam.
  ///
  /// In en, this message translates to:
  /// **'Steam · 5 characters · {seconds}s'**
  String homeKindSteam(int seconds);

  /// No description provided for @homeKindHotp.
  ///
  /// In en, this message translates to:
  /// **'HOTP · {count, plural, =1{1 digit} other{{count} digits}} · #{counter}'**
  String homeKindHotp(int count, String counter);

  /// No description provided for @homeAccountHeading.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get homeAccountHeading;

  /// No description provided for @homeHintUnselect.
  ///
  /// In en, this message translates to:
  /// **'unselect'**
  String get homeHintUnselect;

  /// No description provided for @homeHintSelect.
  ///
  /// In en, this message translates to:
  /// **'select'**
  String get homeHintSelect;

  /// No description provided for @homeHintCopy.
  ///
  /// In en, this message translates to:
  /// **'copy the code'**
  String get homeHintCopy;

  /// No description provided for @homeReadCodeAloud.
  ///
  /// In en, this message translates to:
  /// **'Read code aloud'**
  String get homeReadCodeAloud;

  /// No description provided for @homeMoreOptions.
  ///
  /// In en, this message translates to:
  /// **'More options'**
  String get homeMoreOptions;

  /// No description provided for @mainPairRaycastTitle.
  ///
  /// In en, this message translates to:
  /// **'Pair with Raycast'**
  String get mainPairRaycastTitle;

  /// No description provided for @mainPairRaycastBody.
  ///
  /// In en, this message translates to:
  /// **'Type this code into Raycast:'**
  String get mainPairRaycastBody;

  /// No description provided for @mainPairRaycastWarning.
  ///
  /// In en, this message translates to:
  /// **'Only do this if you just started pairing in Raycast yourself.'**
  String get mainPairRaycastWarning;

  /// No description provided for @mainPairAlfredTitle.
  ///
  /// In en, this message translates to:
  /// **'Pair with Alfred'**
  String get mainPairAlfredTitle;

  /// No description provided for @mainPairAlfredBody.
  ///
  /// In en, this message translates to:
  /// **'Type 2fa-pair and this code into Alfred:'**
  String get mainPairAlfredBody;

  /// No description provided for @mainPairAlfredWarning.
  ///
  /// In en, this message translates to:
  /// **'Only do this if you just typed 2fa-pair in Alfred yourself.'**
  String get mainPairAlfredWarning;

  /// No description provided for @mainPairPowerToysTitle.
  ///
  /// In en, this message translates to:
  /// **'Pair with PowerToys'**
  String get mainPairPowerToysTitle;

  /// No description provided for @mainPairPowerToysBody.
  ///
  /// In en, this message translates to:
  /// **'Type this code into PowerToys Command Palette:'**
  String get mainPairPowerToysBody;

  /// No description provided for @mainPairPowerToysWarning.
  ///
  /// In en, this message translates to:
  /// **'Only do this if you just started pairing in PowerToys yourself.'**
  String get mainPairPowerToysWarning;

  /// No description provided for @mainPairBrowserTitle.
  ///
  /// In en, this message translates to:
  /// **'Pair with your browser'**
  String get mainPairBrowserTitle;

  /// No description provided for @mainPairBrowserBody.
  ///
  /// In en, this message translates to:
  /// **'Type this code into the Tanooki Auth browser extension:'**
  String get mainPairBrowserBody;

  /// No description provided for @mainPairBrowserWarning.
  ///
  /// In en, this message translates to:
  /// **'Only do this if you just clicked \"Pair\" in the extension yourself.'**
  String get mainPairBrowserWarning;

  /// No description provided for @mainSendCodeTo.
  ///
  /// In en, this message translates to:
  /// **'Send the code for {name} to {client}'**
  String mainSendCodeTo(String name, String client);

  /// No description provided for @mainWrongPasscodeLeft.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Wrong passcode. 1 more wrong try erases everything.} other{Wrong passcode. {count} more wrong tries erase everything.}}'**
  String mainWrongPasscodeLeft(int count);

  /// No description provided for @mainWrongPasscode.
  ///
  /// In en, this message translates to:
  /// **'Wrong passcode.'**
  String get mainWrongPasscode;

  /// No description provided for @mainBiometricWindows.
  ///
  /// In en, this message translates to:
  /// **'Windows Hello'**
  String get mainBiometricWindows;

  /// No description provided for @mainBiometricMac.
  ///
  /// In en, this message translates to:
  /// **'Touch ID'**
  String get mainBiometricMac;

  /// No description provided for @mainBiometricOther.
  ///
  /// In en, this message translates to:
  /// **'Face ID or fingerprint'**
  String get mainBiometricOther;

  /// No description provided for @mainLockTitle.
  ///
  /// In en, this message translates to:
  /// **'Lock Tanooki Auth?'**
  String get mainLockTitle;

  /// No description provided for @mainLockBody.
  ///
  /// In en, this message translates to:
  /// **'Ask for your face, fingerprint, or passcode when the app opens, so someone holding your unlocked phone can\'t read your codes. You can change this later in Settings.'**
  String get mainLockBody;

  /// No description provided for @mainTurnOnLock.
  ///
  /// In en, this message translates to:
  /// **'Turn on lock'**
  String get mainTurnOnLock;

  /// No description provided for @mainUnlockReason.
  ///
  /// In en, this message translates to:
  /// **'Unlock Tanooki Auth'**
  String get mainUnlockReason;

  /// No description provided for @mainStartOverTitle.
  ///
  /// In en, this message translates to:
  /// **'Start a new, empty vault?'**
  String get mainStartOverTitle;

  /// No description provided for @mainStartOverBody.
  ///
  /// In en, this message translates to:
  /// **'This permanently replaces whatever is left of your old accounts. Only do this if you have no backup to restore, or you have already turned off two-factor login on those sites.'**
  String get mainStartOverBody;

  /// No description provided for @mainEraseStartOver.
  ///
  /// In en, this message translates to:
  /// **'Erase and start over'**
  String get mainEraseStartOver;

  /// No description provided for @mainRestoreFromBackup.
  ///
  /// In en, this message translates to:
  /// **'Restore from backup'**
  String get mainRestoreFromBackup;

  /// No description provided for @mainStartNewVault.
  ///
  /// In en, this message translates to:
  /// **'Start a new, empty vault'**
  String get mainStartNewVault;

  /// No description provided for @mainLocked.
  ///
  /// In en, this message translates to:
  /// **'Tanooki Auth is locked'**
  String get mainLocked;

  /// No description provided for @mainUseBiometric.
  ///
  /// In en, this message translates to:
  /// **'Use {method}'**
  String mainUseBiometric(String method);

  /// No description provided for @mainUseSecurityKey.
  ///
  /// In en, this message translates to:
  /// **'Use security key'**
  String get mainUseSecurityKey;

  /// No description provided for @homeHidesIn.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Hides in 1 second} other{Hides in {count} seconds}}'**
  String homeHidesIn(int count);

  /// No description provided for @homeCardsMonth.
  ///
  /// In en, this message translates to:
  /// **'{month, select, m1{January} m2{February} m3{March} m4{April} m5{May} m6{June} m7{July} m8{August} m9{September} m10{October} m11{November} m12{December} other{}}'**
  String homeCardsMonth(String month);

  /// No description provided for @homeCardsDay.
  ///
  /// In en, this message translates to:
  /// **'{month} {day}'**
  String homeCardsDay(String month, String day);

  /// No description provided for @homeCardsDenied.
  ///
  /// In en, this message translates to:
  /// **'Denied. They can\'t open your accounts. They can ask again later, and you\'ll be asked again.'**
  String get homeCardsDenied;

  /// No description provided for @homeCardsClockRight.
  ///
  /// In en, this message translates to:
  /// **'Your clock is right now. Codes should work.'**
  String get homeCardsClockRight;

  /// No description provided for @homeCardsCheckAgain.
  ///
  /// In en, this message translates to:
  /// **'Check again'**
  String get homeCardsCheckAgain;

  /// No description provided for @homeCardsYourContact.
  ///
  /// In en, this message translates to:
  /// **'Your emergency contact'**
  String get homeCardsYourContact;

  /// No description provided for @homeCardsEmergencyWaiting.
  ///
  /// In en, this message translates to:
  /// **'{who} asked for emergency access to your accounts. Unless you deny it, they can open a copy in {left} ({day}).'**
  String homeCardsEmergencyWaiting(String who, String left, String day);

  /// No description provided for @homeCardsEmergencyReleased.
  ///
  /// In en, this message translates to:
  /// **'{who} asked for emergency access and the 7-day wait is over, so they can open a copy of your accounts now. Deny to stop that.'**
  String homeCardsEmergencyReleased(String who);

  /// No description provided for @homeCardsBackupNudge.
  ///
  /// In en, this message translates to:
  /// **'Your accounts changed since your last backup. A backup file is how you get them back if this device is lost.'**
  String get homeCardsBackupNudge;

  /// No description provided for @homeCardsBackUpNow.
  ///
  /// In en, this message translates to:
  /// **'Back up now'**
  String get homeCardsBackUpNow;

  /// No description provided for @homeCardsSummaryNew.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Your {month} summary: 1 new account.} other{Your {month} summary: {count} new accounts.}}'**
  String homeCardsSummaryNew(int count, String month);

  /// No description provided for @homeCardsSummaryNoBackup.
  ///
  /// In en, this message translates to:
  /// **'No backup yet.'**
  String get homeCardsSummaryNoBackup;

  /// No description provided for @homeCardsSummaryLastBackup.
  ///
  /// In en, this message translates to:
  /// **'Last backup {day}.'**
  String homeCardsSummaryLastBackup(String day);

  /// No description provided for @homeCardsSummaryAllCodes.
  ///
  /// In en, this message translates to:
  /// **'Every account has recovery codes.'**
  String get homeCardsSummaryAllCodes;

  /// No description provided for @homeCardsSummaryMissingCodes.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 account without recovery codes.} other{{count} accounts without recovery codes.}}'**
  String homeCardsSummaryMissingCodes(int count);

  /// No description provided for @homeCardsSummaryCheckupGood.
  ///
  /// In en, this message translates to:
  /// **'Security check-up: all good.'**
  String get homeCardsSummaryCheckupGood;

  /// No description provided for @homeCardsSummaryCheckupFix.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Security check-up: 1 thing to fix.} other{Security check-up: {count} things to fix.}}'**
  String homeCardsSummaryCheckupFix(int count);

  /// No description provided for @homeCardsOpenCheckup.
  ///
  /// In en, this message translates to:
  /// **'Open check-up'**
  String get homeCardsOpenCheckup;

  /// No description provided for @quickPickSelf.
  ///
  /// In en, this message translates to:
  /// **'Tanooki Auth was still in front, so nothing was typed. Click into the box you want to fill, then use the menu bar icon again.'**
  String get quickPickSelf;

  /// No description provided for @quickPickTypeFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t type the code ({reason}). Copy it instead.'**
  String quickPickTypeFailed(String reason);

  /// No description provided for @quickPickTypeUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Typing codes isn\'t available on this computer. Copy it instead.'**
  String get quickPickTypeUnavailable;

  /// No description provided for @quickPickUseCodeFor.
  ///
  /// In en, this message translates to:
  /// **'Use the code for {name}'**
  String quickPickUseCodeFor(String name);

  /// No description provided for @quickPickAllowTitle.
  ///
  /// In en, this message translates to:
  /// **'Allow Tanooki Auth to type'**
  String get quickPickAllowTitle;

  /// No description provided for @quickPickAllowBody.
  ///
  /// In en, this message translates to:
  /// **'To type a code into another app, your Mac needs to let Tanooki Auth press keys for you.\n\n1. Click \"Open System Settings\" below.\n2. You\'ll see a list called Accessibility. Find Tanooki Auth and turn its switch on (blue).\n3. If your Mac asks for your password or Touch ID, give it.\n4. Come back here and click Type again.\n\nTanooki Auth only presses keys when you click Type, and only types the code.'**
  String get quickPickAllowBody;

  /// No description provided for @quickPickOpenSystemSettings.
  ///
  /// In en, this message translates to:
  /// **'Open System Settings'**
  String get quickPickOpenSystemSettings;

  /// No description provided for @quickPickTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick pick'**
  String get quickPickTitle;

  /// No description provided for @quickPickSearch.
  ///
  /// In en, this message translates to:
  /// **'Search accounts'**
  String get quickPickSearch;

  /// No description provided for @quickPickLinuxNote.
  ///
  /// In en, this message translates to:
  /// **'Typing codes into other apps isn\'t available on Linux. Click an account to copy its code.'**
  String get quickPickLinuxNote;

  /// No description provided for @quickPickNoMatches.
  ///
  /// In en, this message translates to:
  /// **'No matching accounts'**
  String get quickPickNoMatches;

  /// No description provided for @quickPickAsksFirst.
  ///
  /// In en, this message translates to:
  /// **'••• •••  (asks first)'**
  String get quickPickAsksFirst;

  /// No description provided for @quickPickHiddenAsks.
  ///
  /// In en, this message translates to:
  /// **'Code hidden, asks first'**
  String get quickPickHiddenAsks;

  /// No description provided for @quickPickType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get quickPickType;

  /// No description provided for @codeViewRing.
  ///
  /// In en, this message translates to:
  /// **'Ring'**
  String get codeViewRing;

  /// No description provided for @codeViewBar.
  ///
  /// In en, this message translates to:
  /// **'Bar'**
  String get codeViewBar;

  /// No description provided for @codeViewNumber.
  ///
  /// In en, this message translates to:
  /// **'Number'**
  String get codeViewNumber;

  /// No description provided for @codeViewSpoken.
  ///
  /// In en, this message translates to:
  /// **'Code {code}'**
  String codeViewSpoken(String code);

  /// No description provided for @codeViewSpokenLeft.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Code {code}, 1 second left} other{Code {code}, {count} seconds left}}'**
  String codeViewSpokenLeft(int count, String code);

  /// No description provided for @codeViewReadAloud.
  ///
  /// In en, this message translates to:
  /// **'Read code aloud'**
  String get codeViewReadAloud;

  /// No description provided for @codeViewSecondsShort.
  ///
  /// In en, this message translates to:
  /// **'{count}s'**
  String codeViewSecondsShort(int count);

  /// No description provided for @codeViewColorBlue.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get codeViewColorBlue;

  /// No description provided for @codeViewColorPurple.
  ///
  /// In en, this message translates to:
  /// **'Purple'**
  String get codeViewColorPurple;

  /// No description provided for @codeViewColorPink.
  ///
  /// In en, this message translates to:
  /// **'Pink'**
  String get codeViewColorPink;

  /// No description provided for @codeViewColorRed.
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get codeViewColorRed;

  /// No description provided for @codeViewColorOrange.
  ///
  /// In en, this message translates to:
  /// **'Orange'**
  String get codeViewColorOrange;

  /// No description provided for @codeViewColorGold.
  ///
  /// In en, this message translates to:
  /// **'Gold'**
  String get codeViewColorGold;

  /// No description provided for @codeViewColorGreen.
  ///
  /// In en, this message translates to:
  /// **'Green'**
  String get codeViewColorGreen;

  /// No description provided for @codeViewColorTeal.
  ///
  /// In en, this message translates to:
  /// **'Teal'**
  String get codeViewColorTeal;

  /// No description provided for @codeViewColorGray.
  ///
  /// In en, this message translates to:
  /// **'Gray'**
  String get codeViewColorGray;

  /// No description provided for @trashRestored.
  ///
  /// In en, this message translates to:
  /// **'{name} is back in your list.'**
  String trashRestored(String name);

  /// No description provided for @trashDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete {name} for good?'**
  String trashDeleteTitle(String name);

  /// No description provided for @trashDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'This can\'t be undone. Before deleting, turn off two-factor login on that website or make sure you have its recovery codes, or you could be locked out.'**
  String get trashDeleteBody;

  /// No description provided for @trashDeleteForGood.
  ///
  /// In en, this message translates to:
  /// **'Delete for good'**
  String get trashDeleteForGood;

  /// No description provided for @trashTitle.
  ///
  /// In en, this message translates to:
  /// **'Trash'**
  String get trashTitle;

  /// No description provided for @trashEmpty.
  ///
  /// In en, this message translates to:
  /// **'Trash is empty.\nDeleted accounts stay here for 30 days.'**
  String get trashEmpty;

  /// No description provided for @trashNote.
  ///
  /// In en, this message translates to:
  /// **'Deleted accounts stay here for 30 days, then they\'re removed for good.'**
  String get trashNote;

  /// No description provided for @trashRemovedNextOpen.
  ///
  /// In en, this message translates to:
  /// **'Removed next time the app opens'**
  String get trashRemovedNextOpen;

  /// No description provided for @trashDaysLeft.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day left} other{{count} days left}}'**
  String trashDaysLeft(int count);

  /// No description provided for @trashRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get trashRestore;

  /// No description provided for @recoveryAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add recovery codes'**
  String get recoveryAddTitle;

  /// No description provided for @recoveryPasteHint.
  ///
  /// In en, this message translates to:
  /// **'Paste the codes the website gave you, one per line'**
  String get recoveryPasteHint;

  /// No description provided for @recoveryNoneNew.
  ///
  /// In en, this message translates to:
  /// **'No new codes found in what you pasted.'**
  String get recoveryNoneNew;

  /// No description provided for @recoveryAdded.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Added 1 code.} other{Added {count} codes.}}'**
  String recoveryAdded(int count);

  /// No description provided for @recoveryCopiedUsed.
  ///
  /// In en, this message translates to:
  /// **'Copied. Heads up: you marked this code as used, so it probably won\'t work again.'**
  String get recoveryCopiedUsed;

  /// No description provided for @recoveryCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied. The clipboard clears in 30 seconds. Mark it used once you\'ve signed in.'**
  String get recoveryCopied;

  /// No description provided for @recoveryRemoveTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove this code?'**
  String get recoveryRemoveTitle;

  /// No description provided for @recoveryRemoveBody.
  ///
  /// In en, this message translates to:
  /// **'{code}\n\nOnly remove it if the website no longer accepts it.'**
  String recoveryRemoveBody(String code);

  /// No description provided for @recoveryTitle.
  ///
  /// In en, this message translates to:
  /// **'{name} recovery codes'**
  String recoveryTitle(String name);

  /// No description provided for @recoveryAddCodes.
  ///
  /// In en, this message translates to:
  /// **'Add codes'**
  String get recoveryAddCodes;

  /// No description provided for @recoveryIntro.
  ///
  /// In en, this message translates to:
  /// **'When you turn on two-factor login, most websites also give you a list of backup codes. Each one gets you in once if you ever lose this app. Paste them here so they\'re kept safe with the account.'**
  String get recoveryIntro;

  /// No description provided for @recoveryUnusedOf.
  ///
  /// In en, this message translates to:
  /// **'{unused} of {total} unused. Tap a code to copy it, and tick it once you\'ve used it.'**
  String recoveryUnusedOf(String unused, int total);

  /// No description provided for @recoveryUsed.
  ///
  /// In en, this message translates to:
  /// **'Used'**
  String get recoveryUsed;

  /// No description provided for @detailsEditAccount.
  ///
  /// In en, this message translates to:
  /// **'Edit account'**
  String get detailsEditAccount;

  /// No description provided for @detailsCopyCode.
  ///
  /// In en, this message translates to:
  /// **'Copy code'**
  String get detailsCopyCode;

  /// No description provided for @detailsReadAloud.
  ///
  /// In en, this message translates to:
  /// **'Read aloud'**
  String get detailsReadAloud;

  /// No description provided for @detailsFolderAndTags.
  ///
  /// In en, this message translates to:
  /// **'Folder and tags'**
  String get detailsFolderAndTags;

  /// No description provided for @detailsWebsites.
  ///
  /// In en, this message translates to:
  /// **'Websites'**
  String get detailsWebsites;

  /// No description provided for @detailsNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get detailsNotes;

  /// No description provided for @detailsNotesHidden.
  ///
  /// In en, this message translates to:
  /// **'Hidden until you confirm it\'s you.'**
  String get detailsNotesHidden;

  /// No description provided for @detailsNoNotes.
  ///
  /// In en, this message translates to:
  /// **'No notes. Add some with Edit.'**
  String get detailsNoNotes;

  /// No description provided for @accountSortCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom (drag to arrange)'**
  String get accountSortCustom;

  /// No description provided for @accountSortRecent.
  ///
  /// In en, this message translates to:
  /// **'Recently used'**
  String get accountSortRecent;

  /// No description provided for @accountSortName.
  ///
  /// In en, this message translates to:
  /// **'A to Z'**
  String get accountSortName;

  /// No description provided for @activityCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get activityCopied;

  /// No description provided for @activityFilled.
  ///
  /// In en, this message translates to:
  /// **'Filled'**
  String get activityFilled;

  /// No description provided for @activityTyped.
  ///
  /// In en, this message translates to:
  /// **'Typed'**
  String get activityTyped;

  /// No description provided for @activityShownQr.
  ///
  /// In en, this message translates to:
  /// **'Showed QR code'**
  String get activityShownQr;

  /// No description provided for @activityExported.
  ///
  /// In en, this message translates to:
  /// **'Exported'**
  String get activityExported;

  /// No description provided for @totpBadCharacter.
  ///
  /// In en, this message translates to:
  /// **'Not a valid base32 secret (bad character \"{char}\")'**
  String totpBadCharacter(String char);

  /// No description provided for @totpEmpty.
  ///
  /// In en, this message translates to:
  /// **'Secret is empty'**
  String get totpEmpty;

  /// No description provided for @vaultFileMissing.
  ///
  /// In en, this message translates to:
  /// **'Your accounts file is missing. If you have a backup, restore it. Otherwise you can start a new, empty vault.'**
  String get vaultFileMissing;

  /// No description provided for @vaultKeyMissing.
  ///
  /// In en, this message translates to:
  /// **'The key that unlocks your accounts is missing from this device\'s secure storage. Restore a backup to get your accounts back.'**
  String get vaultKeyMissing;

  /// No description provided for @vaultDecryptFailed.
  ///
  /// In en, this message translates to:
  /// **'Your accounts file could not be unlocked. It may be damaged or was changed outside the app. Restore a backup.'**
  String get vaultDecryptFailed;

  /// No description provided for @vaultBadJson.
  ///
  /// In en, this message translates to:
  /// **'Your accounts file unlocked but its contents are damaged. Restore a backup.'**
  String get vaultBadJson;

  /// No description provided for @clockCheckBadAnswer.
  ///
  /// In en, this message translates to:
  /// **'The time server sent an answer the app doesn\'t understand (HTTP {status}).'**
  String clockCheckBadAnswer(String status);

  /// No description provided for @clockCheckOff.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Your device clock is about 1 minute off, so codes won\'t work. Turn on automatic time in Settings.} other{Your device clock is about {count} minutes off, so codes won\'t work. Turn on automatic time in Settings.}}'**
  String clockCheckOff(int count);

  /// No description provided for @backupUiBullet.
  ///
  /// In en, this message translates to:
  /// **'• {item}'**
  String backupUiBullet(String item);

  /// No description provided for @backupUiAccountWithLabel.
  ///
  /// In en, this message translates to:
  /// **'{title} ({label})'**
  String backupUiAccountWithLabel(String title, String label);

  /// No description provided for @exportUiLeftOutLine.
  ///
  /// In en, this message translates to:
  /// **'• {account}: {reason}'**
  String exportUiLeftOutLine(String account, String reason);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'es', 'fr', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'ja':
      return AppLocalizationsJa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
