// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonOk => 'OK';

  @override
  String get commonRemove => 'Remove';

  @override
  String get commonUnlock => 'Unlock';

  @override
  String get commonTurnOff => 'Turn off';

  @override
  String get commonNotNow => 'Not now';

  @override
  String get commonNext => 'Next';

  @override
  String get commonDone => 'Done';

  @override
  String get commonDeny => 'Deny';

  @override
  String get commonAllow => 'Allow';

  @override
  String get commonTryAgain => 'Try again';

  @override
  String get commonStop => 'Stop';

  @override
  String get commonShare => 'Share';

  @override
  String get commonOpen => 'Open';

  @override
  String get commonCopy => 'Copy';

  @override
  String get commonContinueLabel => 'Continue';

  @override
  String get commonClear => 'Clear';

  @override
  String get commonBack => 'Back';

  @override
  String get commonAdd => 'Add';

  @override
  String get commonSave => 'Save';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonClose => 'Close';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonYes => 'Yes';

  @override
  String get commonNo => 'No';

  @override
  String get commonSeePremium => 'See Premium';

  @override
  String get commonPremiumBadge => 'Premium';

  @override
  String get commonAppName => 'Tanooki Auth';

  @override
  String get googleMigrationUnreadable =>
      'That Google Authenticator code couldn\'t be read.';

  @override
  String get googleMigrationDamaged =>
      'That Google Authenticator code is damaged.';

  @override
  String get googleMigrationEmpty =>
      'That Google Authenticator code has no accounts in it.';

  @override
  String get googleMigrationNoSecret =>
      'An account in that code has no secret.';

  @override
  String get googleMigrationMd5 =>
      'An account in that code uses MD5, which Tanooki Auth doesn\'t support.';

  @override
  String get googleCantTakeSteam => 'Steam codes';

  @override
  String googleCantTakeDigits(int digits) {
    return '$digits-digit codes';
  }

  @override
  String googleCantTakePeriod(int seconds) {
    return 'codes that change every $seconds seconds';
  }

  @override
  String get otpauthNotALink => 'That is not an otpauth:// link.';

  @override
  String get otpauthNoSecret => 'The link has no secret.';

  @override
  String otpauthUnsupportedType(String type) {
    return 'Unsupported code type \"$type\".';
  }

  @override
  String otpauthUnsupportedAlgorithm(String algorithm) {
    return 'Unsupported algorithm \"$algorithm\".';
  }

  @override
  String get otpauthBadDigits => 'Digits must be 6, 7 or 8.';

  @override
  String get otpauthBadPeriod => 'Period must be a positive number.';

  @override
  String get otpauthBadCounter => 'Counter must be zero or more.';

  @override
  String get phoneLinkNotAPairingCode =>
      'That isn\'t a Tanooki Auth browser pairing code.';

  @override
  String phoneLinkNotSavedFor(String host) {
    return 'That account isn\'t saved for $host.';
  }

  @override
  String get phoneLinkPushNotSetUp =>
      'Notifications aren\'t set up on the Tanooki Auth server yet, so requests only show up while the app is open.';

  @override
  String phoneLinkPushFailed(int status) {
    return 'Couldn\'t turn on notifications (HTTP $status).';
  }

  @override
  String get qrImageNotAPicture =>
      'That file is not a picture this app can read.';

  @override
  String get qrImageNoQr => 'No QR code found in that picture.';

  @override
  String relayBadAnswer(int status) {
    return 'The sync server sent an answer the app doesn\'t understand (HTTP $status).';
  }

  @override
  String get relayUnreachable =>
      'Can\'t reach the sync server. Check your internet connection.';

  @override
  String get relayTimeout =>
      'The sync server didn\'t answer in time. Check your internet connection.';

  @override
  String get relayInsecure =>
      'Couldn\'t make a secure connection to the sync server.';

  @override
  String relaySaidNo(int status) {
    return 'The sync server said no (HTTP $status).';
  }

  @override
  String get shareNotAShare => 'That isn\'t a Tanooki Auth shared account.';

  @override
  String get shareExpired =>
      'This share has expired (they only last 24 hours). Ask for a new one.';

  @override
  String get shareWrongCode =>
      'Wrong code, or the share is damaged. Check the 6 digits and try again.';

  @override
  String get storeServerUnreachable =>
      'Can\'t reach the Tanooki Auth server. Check your internet connection and try again.';

  @override
  String get storeBadKey =>
      'The server sent a license key this app doesn\'t accept.';

  @override
  String storeReportedProblem(String problem) {
    return 'The store reported a problem: $problem';
  }

  @override
  String get storeGooglePlayUnavailable =>
      'Google Play isn\'t available on this device, so Premium can\'t be bought here. If you bought Premium elsewhere, enter your license key below.';

  @override
  String get storeAppStoreUnavailable =>
      'The App Store isn\'t available right now. Check your internet connection and try again.';

  @override
  String storeNotListed(String store) {
    return 'The $store didn\'t list Premium just now. Try again in a little while.';
  }

  @override
  String storeNotListedWithError(String store, String problem) {
    return 'The $store didn\'t list Premium just now ($problem). Try again in a little while.';
  }

  @override
  String storePricesFailed(String problem) {
    return 'Couldn\'t load prices from the store: $problem';
  }

  @override
  String storePurchaseCouldNotStart(String problem) {
    return 'The purchase couldn\'t start: $problem';
  }

  @override
  String storeNothingToRestore(String store) {
    return 'No Premium purchase was found for this $store account.';
  }

  @override
  String storeRestoreFailed(String problem) {
    return 'Couldn\'t restore purchases: $problem';
  }

  @override
  String get storePending =>
      'Waiting for the payment to be approved. Premium unlocks as soon as it is.';

  @override
  String get storeCanceled => 'Purchase canceled. You weren\'t charged.';

  @override
  String storeFailed(String problem) {
    return 'The purchase didn\'t go through: $problem. You weren\'t charged.';
  }

  @override
  String get storeFailedNoReason =>
      'The purchase didn\'t go through: the store gave no reason. You weren\'t charged.';

  @override
  String get storeUnlocked => 'Premium unlocked. Thank you so much!';

  @override
  String get storeUnlockedWithKey =>
      'Premium unlocked. Your license key for your computers is below.';

  @override
  String storeUnlockedKeyFailed(String problem) {
    return 'Premium is unlocked on this device. The key for your computers couldn\'t be made yet: $problem Tap Restore Purchases later to try again.';
  }

  @override
  String storeServerSaidNo(int status) {
    return 'The server said no (HTTP $status).';
  }

  @override
  String get syncGroupExists =>
      'A sync group with this passphrase already exists. On a device that\'s already syncing, tap \"Add a device\" and scan its code instead.';

  @override
  String get syncNotASyncCode =>
      'That isn\'t a Tanooki Auth sync code. On a device that\'s already syncing, open Settings, Sync, Add a device.';

  @override
  String get syncWrongPassphrase =>
      'That passphrase doesn\'t match the one your other devices use. Check it and try again.';

  @override
  String get syncICloudOtherPassphrase =>
      'Your other Apple devices sync with a different passphrase. Type that one, or start fresh with this one.';

  @override
  String get syncErrorRemoved =>
      'This device was removed from sync on another device. Turn sync off, then on again to rejoin.';

  @override
  String get syncErrorTurnedOff =>
      'Sync was turned off from another device. Turn it off here too, then on again to start over.';

  @override
  String get syncErrorTooOften =>
      'Syncing too often. It will try again in a few minutes.';

  @override
  String get syncErrorLimit =>
      'You\'ve reached the sync limit (2,000 accounts, including deleted ones).';

  @override
  String syncErrorICloud(String problem) {
    return 'iCloud Drive had a problem: $problem.';
  }

  @override
  String syncErrorUnexpected(String problem) {
    return 'Sync stopped because of an unexpected problem: $problem';
  }

  @override
  String get syncICloudAppleOnly =>
      'iCloud only works on iPhone, iPad and Mac.';

  @override
  String get syncICloudSignedOut =>
      'iCloud Drive is off on this device. Sign in to iCloud and turn on iCloud Drive in Settings to use it.';

  @override
  String get syncICloudNotInBuild =>
      'iCloud sync isn\'t switched on in this version of Tanooki Auth yet. Use the Tanooki relay for now; it works on every device.';

  @override
  String get teamKeyUnopenable =>
      'The team key sent to this device couldn\'t be opened. Ask the team admin to remove this device and invite it again.';

  @override
  String get teamNotAnInvite =>
      'That isn\'t a Tanooki Auth team invite. Ask the team admin for a new invite link or QR code.';

  @override
  String get teamNotInTeam => 'This device isn\'t in a team.';

  @override
  String get teamDeletedByAdmin => 'This team was deleted by its admin.';

  @override
  String get teamDeviceRemoved => 'This device was removed from the team.';

  @override
  String get teamAlreadyInTeam => 'This device is already in a team.';

  @override
  String get teamNotALicense =>
      'That isn\'t a team license. It starts with TT1. and comes from the page Stripe shows after you subscribe.';

  @override
  String get teamAlreadyInTeamLeaveFirst =>
      'This device is already in a team. Leave it first.';

  @override
  String get teamGone =>
      'That team doesn\'t exist any more. Ask the team admin for a new invite.';

  @override
  String get teamInviteUsed =>
      'That invite has already been used or has expired (they last 7 days and work once). Ask the team admin for a new one.';

  @override
  String get teamFull =>
      'That team is full (10 people). The admin has to remove someone first.';

  @override
  String get aboutTitle => 'About Maddie';

  @override
  String get aboutP1 =>
      'I\'m Maddie, an autistic developer who cares, maybe a little too much, about getting the small things right.';

  @override
  String get aboutP2 =>
      'I\'m a big believer in privacy. The keys that protect your accounts are about as personal as data gets, so Tanooki Auth keeps them encrypted on your own device. No account, no ads, no tracking, and nothing is ever sent to me.';

  @override
  String get aboutP3 =>
      'Tanooki Auth is free, and I want it to stay that way. Your support is what lets me keep making free privacy apps like this one. If Tanooki Auth suits you, the rest might too — they\'re at madilynthomas.com.';

  @override
  String get aboutP4 =>
      'So, from me to you: thank you. You\'re not just using an app — you\'re making this whole way of living possible.';

  @override
  String get aboutSupportAddress =>
      'Support my work: tanookistudios.com/support';

  @override
  String get aboutSupport => 'Support my work';

  @override
  String get aboutCredits => 'Credits';

  @override
  String get aboutCreditsBody =>
      'QR codes are read with jsQR (Apache 2.0) in the browser extension and ZXing in the app. Not affiliated with Google, Twilio or Authy; Google Authenticator is a trademark of Google LLC.';

  @override
  String get addFromBrowserOne => 'Add from your browser?';

  @override
  String addFromBrowserMany(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Add $count accounts from your browser?',
      one: 'Add 1 account from your browser?',
    );
    return '$_temp0';
  }

  @override
  String get addFromGoogleTransfer =>
      'From a Google Authenticator transfer code:';

  @override
  String addCount(int count) {
    return 'Add $count';
  }

  @override
  String get addNoColor => 'No color';

  @override
  String addColorName(String name) {
    return '$name color';
  }

  @override
  String get addServiceLabel => 'Service (e.g. GitHub)';

  @override
  String get addAccountLabel => 'Account (e.g. your email)';

  @override
  String get addWebsiteLabel => 'Website (optional)';

  @override
  String get addWebsiteHelp =>
      'e.g. github.com. The browser extension only fills codes here.';

  @override
  String get addTagsLabel => 'Tags (optional)';

  @override
  String get addTagsHelp => 'e.g. work, games. Separate with commas.';

  @override
  String get addFolderLabel => 'Folder (optional)';

  @override
  String get addFolderHelp => 'e.g. Work. Leave empty for no folder.';

  @override
  String get addPickFolder => 'Pick a folder';

  @override
  String get addNoFolder => 'No folder';

  @override
  String get addNotesLabel => 'Notes (optional)';

  @override
  String get addColorLabel => 'Color (optional)';

  @override
  String get addEmojiLabel => 'Emoji (optional)';

  @override
  String get addEmojiHelp =>
      'Shown instead of the logo, here and on widgets and the watch.';

  @override
  String addUseEmoji(String emoji) {
    return 'Use $emoji';
  }

  @override
  String addRequireAuth(String proof) {
    return 'Ask for $proof before showing this code';
  }

  @override
  String get addRequireAuthHelp =>
      'The code stays hidden on the list, and widgets, the watch and Quick pick never show it.';

  @override
  String get addTravelHide => 'Hide in travel mode';

  @override
  String get addTravelHidePremium => 'Hide in travel mode (Premium)';

  @override
  String get addTravelHideHelp =>
      'When travel mode is on (Settings), this account disappears from the app until you turn it off.';

  @override
  String get addTravelNeedsPremium =>
      'Travel mode is part of Premium. Get it in Settings > Get Premium.';

  @override
  String get addAdvanced => 'Advanced';

  @override
  String get addAdvancedExisting =>
      'Only change these if the website told you to. Wrong settings make wrong codes, and the website will refuse them.';

  @override
  String get addAdvancedNew =>
      'Most websites use the normal settings. Only change these if the website told you to.';

  @override
  String get addType => 'Type';

  @override
  String get addTypeTotp => 'Time-based (normal)';

  @override
  String get addTypeHotp => 'Counter-based (new code when you ask)';

  @override
  String get addDigits => 'Digits';

  @override
  String get addAlgorithm => 'Algorithm';

  @override
  String get addSha1Normal => 'SHA-1 (normal)';

  @override
  String get addPeriod => 'New code every';

  @override
  String addSeconds(int seconds) {
    return '$seconds seconds';
  }

  @override
  String get addCounter => 'Counter';

  @override
  String get addCounterHelp => 'How many codes have been used so far';

  @override
  String get addNotASharedFile =>
      'That file isn\'t a Tanooki Auth shared account. Ask the person to share it again.';

  @override
  String addAlreadyInList(String name) {
    return '$name is already in your list.';
  }

  @override
  String get addThisAccount => 'Add this account?';

  @override
  String get addNoCameraWindows =>
      'Windows can\'t use a camera in Tanooki Auth. Open a picture of the QR code or paste the setup link instead.';

  @override
  String get addFromGoogle => 'Move from Google Authenticator';

  @override
  String get addFromGoogleSteps =>
      'On the device with Google Authenticator:\n\n1. Open Google Authenticator.\n2. Tap the menu (☰ or ⋮), then \"Transfer accounts\", then \"Export accounts\".\n3. Pick the accounts and tap Next. It shows a QR code.\n\nThen scan that QR code here. If it shows several QR codes, scan each one.';

  @override
  String get addScan => 'Scan';

  @override
  String get addOpenPicture => 'Open picture';

  @override
  String get addLookingOnScreen => 'Looking for a QR code on your screen…';

  @override
  String get addScreenNoQr =>
      'No QR code found on your screen. Make sure the whole code is showing and not covered by another window, then try again.';

  @override
  String get addScreenUnsupported =>
      'Scanning the screen needs macOS 14 (Sonoma) or newer. Take a screenshot and use \"Open a picture\" instead.';

  @override
  String get addScreenFailed =>
      'Couldn\'t take a picture of the screen. Take a screenshot and use \"Open a picture\" instead.';

  @override
  String get addScreenWrongQr =>
      'Found a QR code on your screen, but it isn\'t a two-factor setup code.';

  @override
  String get addScreenPermissionTitle => 'Let Tanooki Auth see your screen';

  @override
  String get addScreenPermissionSteps =>
      'To read a QR code off your screen, your Mac needs to let Tanooki Auth take a picture of it. Tanooki Auth only looks when you press \"Scan my screen\", and the picture never leaves this Mac.\n\n1. Open System Settings (the gear icon in the Dock, or Apple menu > System Settings).\n2. Click \"Privacy & Security\" in the left column.\n3. Click \"Screen & System Audio Recording\".\n4. Turn on the switch next to Tanooki Auth. If it isn\'t in the list, click +, pick Tanooki Auth from Applications, and turn it on.\n5. Your Mac will ask to quit Tanooki Auth. Click \"Quit & Reopen\", then press \"Scan my screen\" again.';

  @override
  String get addPasteLinksTitle => 'Paste setup links';

  @override
  String get addPasteLinksHint =>
      'otpauth://totp/...\nOne link per line. You can paste many at once.';

  @override
  String addManyTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Add $count accounts?',
      one: 'Add 1 account?',
    );
    return '$_temp0';
  }

  @override
  String addManyBadLines(int count) {
    return '$count line(s) can\'t be used; you\'ll see which after.';
  }

  @override
  String get addEnterKey => 'Enter setup key';

  @override
  String get addSetupKey => 'Setup key';

  @override
  String get addSetupKeyHelp => 'The letters and numbers the website shows';

  @override
  String get addBadKey =>
      'That setup key isn\'t valid. It should only contain letters A–Z and numbers 2–7.';

  @override
  String get addTitle => 'Add account';

  @override
  String get addScanQr => 'Scan QR code';

  @override
  String get addScanQrHelp => 'Point the camera at the code the website shows';

  @override
  String addNoCameraOn(String platform) {
    return 'No camera support on $platform';
  }

  @override
  String get addScanScreen => 'Scan my screen';

  @override
  String get addScanScreenHelp =>
      'Reads a QR code showing anywhere on your screen';

  @override
  String get addScanScreenLinux =>
      'Not available on Linux yet. Open a screenshot of the QR code instead.';

  @override
  String get addFromPhotos => 'Scan a QR code from your photos';

  @override
  String get addFromPicture => 'Open a picture of a QR code';

  @override
  String get addFromPhotosHelp => 'Pick a screenshot of the setup page';

  @override
  String get addFromPictureHelp => 'A screenshot of the setup page works';

  @override
  String get addPasteLink => 'Paste setup link';

  @override
  String get addPasteLinkHelp => 'Links starting with otpauth://, one or many';

  @override
  String get addOpenShared => 'Open a shared account';

  @override
  String addOpenSharedHelp(String extension) {
    return 'A .$extension file someone sent you';
  }

  @override
  String get addFromGoogleHelp => 'Bring all your accounts across at once';

  @override
  String get addFromOtherApp => 'Move from another app';

  @override
  String get addFromOtherAppHelp =>
      'Aegis, 2FAS, Authy, Bitwarden, 1Password, Apple Passwords, Microsoft';

  @override
  String get addEnterKeyHelp =>
      'Type the key shown under \"can\'t scan the code?\"';

  @override
  String get addWrongQr => 'That QR code isn\'t a two-factor setup code.';

  @override
  String get addCameraDenied =>
      'Tanooki Auth isn\'t allowed to use the camera. Turn on camera access for Tanooki Auth in your device\'s Settings, or go back and use a picture or the setup key instead.';

  @override
  String addCameraFailed(String problem) {
    return 'The camera couldn\'t start ($problem). Go back and use a picture or the setup key instead.';
  }

  @override
  String get helpNew030a =>
      'Step-by-step guides for turning on 2FA at 40 popular sites. When you add or edit an account we have a guide for, there\'s a link to it.';

  @override
  String get helpNew030b =>
      'A short welcome tour the first time you open the app. See it again in Settings > Help.';

  @override
  String get helpNew030c =>
      'Send feedback from Settings > Help. It never includes your accounts or codes.';

  @override
  String get helpNew030d => 'This What\'s new page.';

  @override
  String get helpNew030e =>
      'Import from Apple Passwords, and move your accounts to Aegis, 2FAS or Google Authenticator.';

  @override
  String get helpNew030f =>
      'Steam Guard codes, counter-based codes with a \"Next code\" button, and advanced code settings with a live preview.';

  @override
  String get helpNew030g =>
      'Folders, select many accounts at once, sort A to Z or by recently used, and \"Tidy account names\".';

  @override
  String get helpNew030h =>
      'Show an account\'s QR code (after Face ID or your passcode) to move it to another device.';

  @override
  String get helpNew030i =>
      'Unlock with a security key such as a YubiKey (Premium), on newer iPhones, Macs and Windows PCs.';

  @override
  String get helpNew030j =>
      '\"Ask first\" accounts that need Face ID or your passcode before showing the code, and travel mode to hide chosen accounts (Premium).';

  @override
  String get helpNew030k =>
      'Activity history (Premium), \"Codes not working?\" clock check, Test a backup, lock on sleep, and backup reminders.';

  @override
  String get helpNew030l =>
      'Emergency access: let someone you trust ask for your accounts, with days for you to say no.';

  @override
  String get helpNew030m =>
      'Spotlight search, a copied-code Live Activity and a watch face complication (Premium), Copy on open, and Mac \"Clear after one paste\".';

  @override
  String get helpNew030n =>
      'Countdown styles, a color or emoji for each account, Read aloud, an easy-to-read font, and better screen reader support.';

  @override
  String get helpNew030o =>
      'A wide layout for big windows, and seasonal Premium icons.';

  @override
  String get helpNew030p =>
      'Buy Premium inside the app on iPhone and Android, gift it, and invite friends.';

  @override
  String get helpNew030q =>
      'Team vault for sharing codes with up to 10 people. The team plan itself is coming soon.';

  @override
  String get helpNew030r => 'The Family plan is coming soon.';

  @override
  String get helpNew030s =>
      'The desktop app now runs on Linux too. Linux downloads are coming soon.';

  @override
  String get helpNew020a =>
      'Sync between your devices, phone link for the browser extension, and secure sharing of one account.';

  @override
  String get helpNew020b =>
      'Passcode, auto-lock, panic wipe, decoy passcode, screenshot blocking, check-up and breach alerts.';

  @override
  String get helpNew020c =>
      'Widgets, Apple Watch and Wear OS apps, the Mac menu bar and Windows tray, and automatic encrypted backups (Premium).';

  @override
  String get helpNew020d =>
      'Importers for Aegis, 2FAS, Authy, Bitwarden and 1Password, plus favorites, tags, notes, recovery codes and Trash.';

  @override
  String get helpNew010a =>
      'The first version: scan or paste accounts, see codes, encrypted backups, and the browser extension.';

  @override
  String helpNoBrowser(String url) {
    return 'Couldn\'t open your web browser. The page is $url';
  }

  @override
  String helpGuideFor(String name) {
    return 'How to turn on 2FA for $name';
  }

  @override
  String get helpTourWelcome => 'Welcome to Tanooki Auth';

  @override
  String get helpTourWelcomeBody =>
      'Lots of websites can ask for a 6-digit code as well as your password. That\'s two-factor authentication, or 2FA. Tanooki Auth makes those codes for you, right here on your device, so someone with only your password still can\'t get in.';

  @override
  String get helpTourAdd => 'Add your first account';

  @override
  String get helpTourAddBody =>
      'Turn on 2FA in a website\'s security settings. It shows a QR code: scan it here, or copy its setup link and paste it. Already using another authenticator app? Bring your accounts across in one go.';

  @override
  String get helpTourScanOrPaste => 'Scan a QR code or paste a link';

  @override
  String get helpTourImport => 'Import from another app';

  @override
  String get helpTourPopular => 'Popular sites to protect first';

  @override
  String get helpTourPopularBody =>
      'Your email, your social media and anywhere with your money matter most. Our step-by-step guides show where the 2FA setting is on each site.';

  @override
  String get helpAllGuides => 'All 2FA guides';

  @override
  String helpTourStep(int step, int total) {
    return 'Step $step of $total';
  }

  @override
  String get helpTourSkip => 'Skip tour';

  @override
  String get helpWhatsNew => 'What\'s new';

  @override
  String helpVersion(String version) {
    return 'Version $version';
  }

  @override
  String helpVersionThis(String version) {
    return 'Version $version (this version)';
  }

  @override
  String get helpFeedbackEmpty => 'Type a message first.';

  @override
  String get helpFeedbackSent => 'Sent. Thank you! Maddie reads every message.';

  @override
  String get helpFeedbackTooLong =>
      'That\'s too long to send. Please make it shorter (about 4,000 letters at most).';

  @override
  String get helpFeedbackTooMany =>
      'You\'ve sent a lot of feedback in the last hour. Please try again in an hour.';

  @override
  String get helpFeedbackOffline =>
      'Couldn\'t reach the internet. Check your connection and try again. Your message is still here.';

  @override
  String get helpFeedbackServerError =>
      'The feedback server had a problem and didn\'t take your message. Please try again later. Your message is still here.';

  @override
  String get helpFeedbackTitle => 'Send feedback';

  @override
  String get helpFeedbackIntro =>
      'Found a bug, or wish the app did something? Tell Maddie here.';

  @override
  String get helpFeedbackMessage => 'Your message';

  @override
  String get helpFeedbackEmail => 'Your email (optional)';

  @override
  String get helpFeedbackEmailHelp => 'Only if you\'d like a reply.';

  @override
  String get helpFeedbackDevice => 'Include app version and device type';

  @override
  String get helpFeedbackDeviceHelp =>
      'For example \"0.3.0\" and \"iOS\". It helps track down bugs.';

  @override
  String get helpFeedbackNeverSent =>
      'Never sent: your accounts, their names, codes, setup keys, tags, notes, or anything else in the app.';

  @override
  String get helpFeedbackSend => 'Send';

  @override
  String get phoneUiPushAndroid =>
      'Notifications on Android aren\'t set up yet, so requests show up while Tanooki Auth is open.';

  @override
  String get phoneUiPushThisDevice =>
      'This device gets requests while Tanooki Auth is open.';

  @override
  String get phoneUiPushNoToken =>
      'iPhone didn\'t give the app a notification token.';

  @override
  String get phoneUiPushDenied =>
      'Notifications are turned off for Tanooki Auth. Turn them on in the iPhone Settings app, under Notifications, to get requests when the app is closed.';

  @override
  String phoneUiPushFailed(String problem) {
    return 'Couldn\'t turn on notifications: $problem. Requests still show up while Tanooki Auth is open.';
  }

  @override
  String get phoneUiPushNotInBuild =>
      'Notifications aren\'t available in this build. Requests show up while Tanooki Auth is open.';

  @override
  String get phoneUiPushChecking => 'Checking whether notifications work…';

  @override
  String get phoneUiRequest => 'Sign-in code request';

  @override
  String get phoneUiNoAccount =>
      'No account is saved for this website, so there\'s nothing to send. If you expected one, this might be a fake site pretending to be a real one.';

  @override
  String get phoneUiWantsCode =>
      'Your paired browser wants the code for this website. Only approve if you\'re signing in right now.';

  @override
  String get phoneUiApprove => 'Approve';

  @override
  String phoneUiApproveAccount(String name) {
    return 'Approve: $name';
  }

  @override
  String get phoneUiScanTitle => 'Scan the browser\'s code';

  @override
  String get phoneUiScanWrong =>
      'That isn\'t a browser pairing code. In the browser, click the Tanooki Auth extension, then \"Use my phone instead\".';

  @override
  String get phoneUiPasteTitle => 'Paste the pairing link';

  @override
  String get phoneUiPair => 'Pair';

  @override
  String get phoneUiPaired =>
      'Paired. When that browser asks for a code, you\'ll see it here.';

  @override
  String get phoneUiExpired =>
      'That code has expired. In the browser, make a new one and scan it again.';

  @override
  String get phoneUiPremium =>
      'Using your phone with a browser is part of Premium';

  @override
  String get phoneUiIntro =>
      'Fill codes in a browser on any computer, even one without the Tanooki Auth app. The browser extension asks, and you tap Approve here. Codes travel end-to-end encrypted, and only for the website each account is saved for.';

  @override
  String get phoneUiPairBrowser => 'Pair a browser';

  @override
  String get phoneUiPairHelp =>
      'In the browser, click the Tanooki Auth extension, then \"Use my phone instead\" to show the code.';

  @override
  String get phoneUiPairedBrowsers => 'Paired browsers';

  @override
  String get phoneUiNoneYet => 'None yet';

  @override
  String get phoneUiBrowser => 'Browser';

  @override
  String phoneUiPairedOn(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Paired $dateString';
  }

  @override
  String get phoneUiUnpair => 'Unpair';

  @override
  String get phoneUiPushOn => 'Notifications on';

  @override
  String get phoneUiPushOff => 'Requests show while the app is open';

  @override
  String get phoneUiPushOnHelp =>
      'You\'ll get a notification for each request, even when Tanooki Auth is closed.';

  @override
  String phoneUiSendCodeFor(String name) {
    return 'Send the code for $name';
  }

  @override
  String get phoneUiActivityWhere => 'Browser, through this phone';

  @override
  String get premiumFiveOnce => '\$5 once';

  @override
  String get premiumPayOnce => 'Pay once';

  @override
  String get premiumCheckoutSoon =>
      'Checkout isn\'t open yet; it\'s coming very soon. Thank you for wanting to support Tanooki Auth!';

  @override
  String get premiumEnterKeyTitle => 'Enter license key';

  @override
  String get premiumEnterKeyHint => 'TA1.…  (from your purchase email)';

  @override
  String get premiumBadKey =>
      'That license key isn\'t valid. Copy the whole key from your purchase email and try again.';

  @override
  String premiumInvitesNowFamily(int count) {
    return '$count friends bought Premium with your link, so your key is now a Family key for up to 5 people. It\'s installed on this device. Copy the new key below and enter it on your other devices too.';
  }

  @override
  String premiumInvitesAlreadyFamily(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count friends have bought Premium with your link. Your key is already a Family key.',
      one: '1 friend has bought Premium with your link. Your key is already a Family key.',
    );
    return '$_temp0';
  }

  @override
  String premiumInvitesProgress(int count, int needed, int left) {
    return '$count of $needed friends have bought Premium with your link. $left more and your key becomes a Family key.';
  }

  @override
  String get premiumInviteLinkCopied => 'Invite link copied.';

  @override
  String get premiumKeyCopied => 'License key copied.';

  @override
  String premiumJustMe(String price) {
    return 'Just me — $price';
  }

  @override
  String premiumFamilyPrice(String price) {
    return 'Family (up to 5 people) — $price';
  }

  @override
  String get premiumFamilyApple =>
      'Family: shared with your Apple family through Family Sharing, plus a license key for up to 5 people on any device.';

  @override
  String get premiumFamilyKey =>
      'Family: one license key you share with up to 4 other people.';

  @override
  String get premiumYourKey => 'Your license key';

  @override
  String get premiumYourKeyHelp =>
      'Enter it on your other devices: Settings → Get Premium → \"Already bought it? Enter your license key\".';

  @override
  String get premiumCopyKey => 'Copy key';

  @override
  String get premiumInviteFriends => 'Invite friends';

  @override
  String get premiumInviteHelp =>
      'Friends get 20% off. When 3 friends buy, your key becomes a Family key.';

  @override
  String get premiumGetInvite => 'Get my invite link';

  @override
  String get premiumCheckInvites => 'Check my invites';

  @override
  String get premiumYouHave => 'You have Premium';

  @override
  String get premiumTitle => 'Tanooki Auth Premium';

  @override
  String get premiumOwnedFamily =>
      'Family plan: share your license key with up to 4 other people (5 in all). Thank you for supporting Tanooki Auth.';

  @override
  String get premiumOwnedThanks => 'Thank you for supporting Tanooki Auth.';

  @override
  String get premiumPitchStripe =>
      '\$5 once, or \$10 for your whole family. Yours forever.';

  @override
  String get premiumPitchStore =>
      'Pay once for you, or once for your whole family. Yours forever.';

  @override
  String get premiumPerkThemes => 'Every Premium theme';

  @override
  String premiumPerkThemesBody(int count) {
    return 'Pastel Pink, Pastel Blue and $count more, plus every theme added later.';
  }

  @override
  String get premiumPerkIcons => 'App icons';

  @override
  String premiumPerkIconsBody(int count) {
    return 'Pick a different home-screen icon on iPhone and Android, in Pastel Pink, Pastel Blue and $count more colors, plus seasonal ones for fall, winter and spring. On a Mac it changes the Dock icon while the app is open.';
  }

  @override
  String get premiumPerkSync => 'Sync across your devices';

  @override
  String get premiumPerkSyncBody =>
      'Add an account on one device and see it on all of them, end-to-end encrypted. Through iCloud on Apple devices, or the Tanooki relay for any mix.';

  @override
  String get premiumPerkApprove => 'Approve codes from your phone';

  @override
  String get premiumPerkApproveBody =>
      'Use the browser extension on any computer: it asks your phone, you tap Approve, and the code fills in.';

  @override
  String get premiumPerkBreach => 'Breach alerts';

  @override
  String get premiumPerkBreachBody =>
      'Get told when a website you have an account for is in a known data breach. Checked on your device; nothing about you is sent.';

  @override
  String get premiumPerkShare => 'Share an account securely';

  @override
  String get premiumPerkShareBody =>
      'Give one account to someone you trust with a QR code and a 6-digit code. Locked, expires in 24 hours, no server.';

  @override
  String get premiumPerkFamily => 'Family plan';

  @override
  String get premiumPerkFamilyStripe =>
      'For \$10 instead of \$5, one key unlocks Premium for up to 5 people. Send it to your family and they enter it like you do.';

  @override
  String get premiumPerkFamilyStore =>
      'One family purchase unlocks Premium for up to 5 people. Send them your license key and they enter it like you do.';

  @override
  String get premiumPerkFuture => 'Every future Premium feature';

  @override
  String get premiumPerkFutureBody =>
      'Pay once and get whatever Premium grows into. No subscription, ever.';

  @override
  String get premiumPerkFree => 'Keeps privacy apps free';

  @override
  String get premiumPerkFreeStripe =>
      'Your \$5 is what lets me keep making free apps that don\'t track you.';

  @override
  String get premiumPerkFreeStore =>
      'Buying Premium is what lets me keep making free apps that don\'t track you.';

  @override
  String get premiumFreeForever =>
      'Free forever, with or without Premium: unlimited accounts, scanning, backups, the browser extension, and the app lock.';

  @override
  String get premiumFamilySoon => 'Family plan coming soon';

  @override
  String get premiumFamilyKeyEach =>
      'Family: one license key you share with up to 4 other people. Each of them enters it in their own Tanooki Auth.';

  @override
  String get premiumRestore => 'Restore Purchases';

  @override
  String get premiumAlreadyBought =>
      'Already bought it? Enter your license key';

  @override
  String get premiumDesktopKeySoon =>
      'Desktop key coming soon for Android purchases. Premium is unlocked on this phone now; a license key for your computers will show up here in a later update.';

  @override
  String premiumGift(String price) {
    return 'Give Premium as a gift — $price';
  }

  @override
  String premiumGiftFamily(String price) {
    return 'Give the Family plan as a gift — $price';
  }

  @override
  String get premiumGiftHelp =>
      'After paying you get a printable gift card with a key for them.';

  @override
  String get settingsIconFailed =>
      'Couldn\'t change the app icon. Try again, or restart the app.';

  @override
  String settingsIconFailedWhy(String problem) {
    return 'Couldn\'t change the app icon ($problem). Try again, or restart the app.';
  }

  @override
  String settingsIconSemantic(String name) {
    return '$name app icon';
  }

  @override
  String settingsIconSemanticPremium(String name) {
    return '$name app icon, Premium';
  }

  @override
  String get settingsAppIcon => 'App icon';

  @override
  String get settingsAppIconPremium => 'App icon (Premium)';

  @override
  String get settingsAppIconIos => 'The icon on your home screen.';

  @override
  String get settingsAppIconAndroid =>
      'The icon on your home screen. It may disappear for a moment while your phone swaps it.';

  @override
  String get settingsAppIconMac =>
      'Changes the Dock icon while Tanooki Auth is open. Macs can\'t keep a different icon after the app quits, so Finder and Launchpad keep the blue one.';

  @override
  String get settingsAppIconOther =>
      'App icons can be changed on iPhone and Android.';

  @override
  String get settingsLockNameMac => 'Touch ID or your Mac password';

  @override
  String get settingsLockNamePhone => 'Face ID, fingerprint, or passcode';

  @override
  String settingsNoLockSetUp(String lock) {
    return 'This device has no $lock set up, so the app can\'t be locked. Set one up in your system settings first.';
  }

  @override
  String get settingsLockReasonOn => 'Turn on the app lock';

  @override
  String get settingsLockReasonOff => 'Turn off the app lock';

  @override
  String get settingsSetPasscode => 'Set an app passcode';

  @override
  String get settingsSetPasscodeIntro =>
      'Type this to open Tanooki Auth. It also works when Face ID or your fingerprint doesn\'t. If you forget it, the only way back in is a backup.';

  @override
  String get settingsPasscodeOn => 'App passcode on.';

  @override
  String get settingsPasscode => 'App passcode';

  @override
  String get settingsChangePasscode => 'Change passcode';

  @override
  String get settingsPasscodeOff => 'Turn passcode off';

  @override
  String get settingsNewPasscode => 'New app passcode';

  @override
  String get settingsPasscodeChanged => 'Passcode changed.';

  @override
  String get settingsPasscodeIsOff => 'App passcode off.';

  @override
  String get settingsRemoveDecoyTitle => 'Remove the decoy passcode?';

  @override
  String get settingsRemoveDecoyBody =>
      'The decoy accounts are erased. Your real accounts aren\'t touched.';

  @override
  String get settingsSetDecoy => 'Set a decoy passcode';

  @override
  String get settingsSetDecoyIntro =>
      'If someone forces you to open Tanooki Auth, type this one instead. It opens a separate, empty set of accounts, and nothing on screen shows it isn\'t the real one. Add a couple of harmless accounts there so it looks used.\n\nYour real passcode keeps opening your real accounts.';

  @override
  String get settingsDecoySet => 'Decoy passcode set.';

  @override
  String settingsWipeTitle(int count) {
    return 'Erase everything after $count wrong passcodes?';
  }

  @override
  String settingsWipeBody(int count) {
    return 'If anyone types the wrong app passcode $count times in a row, Tanooki Auth erases every account on this device. There is no undo and no way to stop it once it starts.';
  }

  @override
  String get settingsWipeSureTitle => 'Are you sure?';

  @override
  String get settingsWipeSureBody =>
      'A child playing with your phone, or you on a bad day, can trigger this. After an erase, the only way back is your backup file. Without it you could be locked out of every website that uses these codes.';

  @override
  String get settingsWipeTurnOn => 'Turn on panic wipe';

  @override
  String get settingsTravelOffReason => 'Turn off travel mode';

  @override
  String get settingsTravelOnNone =>
      'Travel mode on, but no account is marked \"Hide in travel mode\" yet. Mark them with ⋯ > Edit first.';

  @override
  String settingsTravelOn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Travel mode on. $count accounts are hidden.',
      one: 'Travel mode on. 1 account is hidden.',
    );
    return '$_temp0';
  }

  @override
  String get settingsTravelOff => 'Travel mode off. Every account is back.';

  @override
  String get settingsCheckingClock => 'Checking your clock…';

  @override
  String get settingsClockRight =>
      'Your clock is right, so that\'s not it. Check the account\'s settings (⋯ > Edit > Advanced) match what the website said.';

  @override
  String settingsClockFailed(String problem) {
    return 'Couldn\'t check the clock: $problem';
  }

  @override
  String get settingsLockApp => 'Lock the app';

  @override
  String settingsLockAppHelp(String lock) {
    return 'Ask for $lock when the app opens';
  }

  @override
  String get settingsPasscodeOnHelp => 'On. Tap to change or turn off.';

  @override
  String settingsPasscodeOffHelp(String lock) {
    return 'Off. Numbers you type to open the app, instead of or as well as $lock.';
  }

  @override
  String get settingsLockAgain => 'Lock again';

  @override
  String settingsLockAgainHelp(String time) {
    return '$time in the background';
  }

  @override
  String get settingsLockFirst => 'Turn on the lock or a passcode first';

  @override
  String get settingsDecoy => 'Decoy passcode';

  @override
  String get settingsDecoyOn =>
      'On. Opens a separate set of accounts. Tap to remove.';

  @override
  String get settingsDecoyOff =>
      'A second passcode that opens a separate, empty set of accounts';

  @override
  String settingsWipe(int count) {
    return 'Erase after $count wrong passcodes';
  }

  @override
  String get settingsWipeHelp =>
      'Panic wipe. Needs a backup made in the last 30 days.';

  @override
  String get settingsLockOnSleep => 'Lock when the computer sleeps';

  @override
  String get settingsLockOnSleepHelp =>
      'Also when the screen locks or you log out for a moment';

  @override
  String get settingsLockOnSleepNeedsLock =>
      'Turn on \"Lock the app\" or an app passcode first, so there is something to lock.';

  @override
  String get settingsTravel => 'Travel mode';

  @override
  String get settingsTravelPremium => 'Travel mode (Premium)';

  @override
  String get settingsTravelOnHelp =>
      'On. Accounts marked \"Hide in travel mode\" are gone from this device\'s screens, widgets, watch, extension and exports until you turn it off. They aren\'t deleted.';

  @override
  String settingsTravelOffHelp(String proof) {
    return 'Before a border crossing: hides the accounts you marked \"Hide in travel mode\" (⋯ > Edit). Turning it off asks for $proof.';
  }

  @override
  String get settingsKeys => 'Security keys';

  @override
  String get settingsKeysPremium => 'Security keys (Premium)';

  @override
  String get settingsKeysHelp => 'Unlock with a YubiKey or other security key';

  @override
  String get settingsActivity => 'Activity history';

  @override
  String get settingsActivityPremium => 'Activity history (Premium)';

  @override
  String get settingsActivityHelp =>
      'Which codes were copied, filled, typed or exported, and when. Kept on this device only.';

  @override
  String get settingsEmergency => 'Emergency access';

  @override
  String get settingsEmergencyPremium => 'Emergency access (Premium)';

  @override
  String get settingsEmergencyHelp =>
      'Let one trusted person get your accounts if something happens to you, after a 7-day wait you can stop';

  @override
  String get settingsTeamHelp =>
      'Share sign-in codes with up to 10 people, end-to-end encrypted';

  @override
  String get settingsMonthly => 'Monthly summary notification';

  @override
  String get settingsMonthlyPremium => 'Monthly summary notification (Premium)';

  @override
  String get settingsMonthlyHelp =>
      'A reminder on the 1st of each month to look at your summary card. It never says anything about your accounts.';

  @override
  String get settingsBlockShots => 'Block screenshots';

  @override
  String get settingsBlockShotsDesktop =>
      'Hides this window from screenshots, screen recording and screen sharing';

  @override
  String get settingsBlockShotsPhone =>
      'Keeps codes out of screenshots, screen recording and the app switcher';

  @override
  String get settingsCheckup => 'Security check-up';

  @override
  String get settingsCheckupHelp =>
      'Things worth fixing, and your recovery kit';

  @override
  String get settingsBreachPremium => 'Breach alerts (Premium)';

  @override
  String get settingsBreachOn => 'On. Checks the public breach list weekly.';

  @override
  String get settingsBreachOff =>
      'Off. When on, the app downloads the public breach list once a week.';

  @override
  String settingsThemeSemantic(String name) {
    return '$name theme';
  }

  @override
  String settingsThemeSemanticPremium(String name) {
    return '$name theme, Premium';
  }

  @override
  String get settingsPremiumThanks => 'Premium: thank you!';

  @override
  String get settingsGetPremium => 'Get Premium';

  @override
  String get settingsPremiumThanksHelp =>
      'Every theme and future Premium feature is yours.';

  @override
  String settingsGetPremiumHelp(String payOnce) {
    return '$payOnce: every theme, sync across your devices, and more.';
  }

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsCountdown => 'Countdown style';

  @override
  String get settingsCountdownHelp => 'How the time left on each code is shown';

  @override
  String get settingsEasyFont => 'Easy-to-read font';

  @override
  String get settingsEasyFontHelp =>
      'Atkinson Hyperlegible, made by the Braille Institute so letters and numbers are hard to mix up';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageSystem => 'System';

  @override
  String get settingsAccountsList => 'Accounts list';

  @override
  String get settingsCompact => 'Compact cards';

  @override
  String get settingsCompactHelp =>
      'Smaller cards, so more accounts fit on screen';

  @override
  String get settingsSort => 'Sort accounts';

  @override
  String settingsSortHelp(String sort) {
    return '$sort. Favorites always come first.';
  }

  @override
  String get settingsSortCustom =>
      'Your own order. Press and hold a card, then drag it.';

  @override
  String get settingsSortRecent =>
      'Accounts you just copied a code from move to the top';

  @override
  String get settingsSortName => 'By service name';

  @override
  String get settingsTidyHelp =>
      'Turns names like \"google.com:you@gmail.com\" into \"Google\". You see every change first.';

  @override
  String get settingsHideCodes => 'Hide codes until tapped';

  @override
  String get settingsHideCodesHelp =>
      'Shows dots instead of codes, so people nearby can\'t read them';

  @override
  String get settingsShareCodes => 'Show codes on widgets and watch';

  @override
  String get settingsShareCodesHelp =>
      'Your favorites\' codes show on your Home Screen, Lock Screen and watch without opening this app, so anyone holding your unlocked phone or your watch can read them. Star an account to make it a favorite.';

  @override
  String get settingsTrash => 'Trash';

  @override
  String settingsTrashCount(int count) {
    return 'Trash ($count)';
  }

  @override
  String get settingsTrashHelp => 'Deleted accounts stay here for 30 days';

  @override
  String get settingsWatchFace => 'Watch face favorite';

  @override
  String get settingsWatchFacePremium => 'Watch face favorite (Premium)';

  @override
  String get settingsWatchFaceNoFavorites =>
      'Star an account on the main list first. Only favorites can go on the watch face.';

  @override
  String get settingsNone => 'None';

  @override
  String get settingsCopying => 'Copying and shortcuts';

  @override
  String get settingsCopyOnOpen => 'Copy on open';

  @override
  String get settingsCopyOnOpenHelp =>
      'Opening or unlocking the app copies the code of the account you used last. Accounts that ask before showing their code are skipped.';

  @override
  String get settingsPasteOnce => 'Clear after one paste';

  @override
  String get settingsPasteOnceHelp =>
      'The copied code works for one paste, then the clipboard empties. Clipboard history apps can count as that one paste. On Windows, codes clear after 30 seconds instead.';

  @override
  String get settingsSpotlight => 'Show accounts in Spotlight';

  @override
  String get settingsSpotlightHelp =>
      'Search for an account\'s name from anywhere and jump straight to it. Only names are shared, never codes.';

  @override
  String get settingsLiveActivity => 'Code on Lock Screen after copying';

  @override
  String get settingsLiveActivityPremium =>
      'Code on Lock Screen after copying (Premium)';

  @override
  String get settingsLiveActivityHelp =>
      'After you copy a code, it shows on your Lock Screen and Dynamic Island with a countdown until it expires.';

  @override
  String get settingsWatchFaceHelp =>
      'Pick one favorite whose code shows on your Apple Watch face. Needs \"Show codes on widgets and watch\" on.';

  @override
  String settingsWatchFaceChosen(String name) {
    return '$name. Add the Tanooki Auth complication to your watch face to see it.';
  }

  @override
  String get settingsBrowserSection => 'Browser extension and launchers';

  @override
  String get settingsBridgeOff => 'Not running';

  @override
  String get settingsBridgeOn => 'Ready for the browser extension';

  @override
  String settingsBridgeOffHelp(String first, String last) {
    return 'Ports $first–$last are all in use by other programs, so the extension can\'t connect. Restart your computer and try again.';
  }

  @override
  String settingsBridgeOnHelp(String port) {
    return 'Listening on this computer only (127.0.0.1:$port). Works while Tanooki Auth is open.';
  }

  @override
  String settingsPairedClient(String name) {
    return 'Paired: $name';
  }

  @override
  String get settingsPairedBrowser => 'Paired browser';

  @override
  String settingsExtensionId(String id) {
    return 'Extension $id';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsSecurity => 'Security';

  @override
  String get settingsBackup => 'Backup';

  @override
  String get settingsExport => 'Export backup';

  @override
  String get settingsExportHelp =>
      'An encrypted file, locked with a passphrase you choose';

  @override
  String get settingsImport => 'Import backup';

  @override
  String get settingsImportHelp =>
      'Adds accounts from a backup file; skips ones you already have';

  @override
  String get settingsTestBackup => 'Test a backup';

  @override
  String get settingsTestBackupHelp =>
      'Checks a backup file opens with your passphrase. Changes nothing.';

  @override
  String get settingsMoveOut => 'Move to another app';

  @override
  String get settingsMoveOutHelp =>
      'Aegis, 2FAS, Google Authenticator, or plain setup links';

  @override
  String get settingsPaper => 'Print paper backup';

  @override
  String get settingsPaperHelp =>
      'A PDF of QR codes and recovery codes to keep somewhere locked';

  @override
  String get settingsHelp => 'Help';

  @override
  String get settingsGuidesHelp =>
      'Step-by-step help turning on 2FA at popular sites, on our website';

  @override
  String get settingsTour => 'Show the welcome tour';

  @override
  String get settingsFeedbackHelp =>
      'Tell Maddie about a bug or an idea. Never includes your accounts or codes.';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsAboutMaddieHelp =>
      'A note from the person who makes Tanooki Auth';

  @override
  String get settingsCodesNotWorking => 'Codes not working?';

  @override
  String settingsCodesNotWorkingHelp(String time) {
    return 'Device time $time. Codes depend on the clock: tap to check it against the internet.';
  }

  @override
  String shareUiConfirmTitle(String name) {
    return 'Share $name?';
  }

  @override
  String get shareUiConfirmBody =>
      'The person you share this with gets full access: their phone will make the same codes as yours, for as long as they keep it. Only share with someone you trust completely, like family.\n\nRemoving it from your list later does not take it back from them. To cut them off, turn two-factor off and on again on the website.';

  @override
  String get shareUiConfirmButton => 'I understand, share it';

  @override
  String get shareUiLocking => 'Locking the share…';

  @override
  String shareUiTitle(String name) {
    return 'Share $name';
  }

  @override
  String get shareUiInstructions =>
      'On their device: open Tanooki Auth, tap Add account, then \"Scan QR code\" (or \"Open a shared account\" for the file). Then they type this code:';

  @override
  String get shareUiTellCode =>
      'Tell them the code yourself, out loud or in a different app from the file.';

  @override
  String get shareUiSendFile => 'Send as a file instead';

  @override
  String get shareUiCopyLink => 'Copy as a link';

  @override
  String get shareUiCopied =>
      'Copied. They paste it with \"Paste setup link\".';

  @override
  String get shareUiWorksFor =>
      'Works for 24 hours, and only with the code. Nothing goes through a server.';

  @override
  String get shareUiOpenTitle => 'Shared account';

  @override
  String get shareUiOpenBody =>
      'Type the 6-digit code the person who shared it gave you.';

  @override
  String get shareUiUnlocking => 'Unlocking…';

  @override
  String get signatureLabel => 'Signed, Maddie';

  @override
  String get syncUiQrCode => 'QR code';

  @override
  String get syncUiNotYet => 'Not yet';

  @override
  String get syncUiJustNow => 'Just now';

  @override
  String syncUiMinutesAgo(int minutes) {
    return '$minutes min ago';
  }

  @override
  String syncUiHoursAgo(int hours) {
    return '$hours h ago';
  }

  @override
  String syncUiDate(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString';
  }

  @override
  String get syncUiThisDevice => 'This device';

  @override
  String get syncUiAnotherDevice => 'Another device';

  @override
  String syncUiAdded(String when) {
    return 'Added $when';
  }

  @override
  String syncUiThisDeviceNamed(String name) {
    return 'This device ($name)';
  }

  @override
  String syncUiLastSyncedAgo(String when) {
    return 'Last synced $when';
  }

  @override
  String get syncUiWhere => 'Where should your devices sync?';

  @override
  String get syncUiICloudHelp =>
      'For iPhone, iPad and Mac only. Uses your own iCloud Drive.';

  @override
  String get syncUiRelay => 'Tanooki relay';

  @override
  String get syncUiRelayHelp =>
      'Works with every device, including Android and Windows. The server only stores scrambled data.';

  @override
  String get syncUiStartFreshTitle => 'Start fresh?';

  @override
  String get syncUiStartFreshBody =>
      'If you\'ve forgotten the passphrase your other Apple devices use, you can start a new sync with this one. Your other devices then need to turn sync off and on again with the new passphrase.';

  @override
  String get syncUiStartFresh => 'Start fresh';

  @override
  String get syncUiOn => 'Sync is on.';

  @override
  String get syncUiScanTitle => 'Scan the sync code';

  @override
  String get syncUiScanWrong =>
      'That isn\'t a sync code. On your other device, open Settings, Sync, Add a device.';

  @override
  String get syncUiNowSyncing => 'This device is now syncing.';

  @override
  String get syncUiPasteTitle => 'Paste the sync link';

  @override
  String get syncUiPasteHint =>
      'tanookiauth://sync?…  (from Add a device on your other device)';

  @override
  String get syncUiAddApple => 'Add an Apple device';

  @override
  String get syncUiAddAppleBody =>
      'On your other iPhone, iPad or Mac (signed in to the same Apple ID, with iCloud Drive on), open Tanooki Auth, go to Settings, then Sync, tap \"Turn on sync\", pick iCloud and type the same sync passphrase.\n\nWant to add an Android phone or a Windows PC? Turn sync off on every device, then turn it on again with the Tanooki relay.';

  @override
  String get syncUiAddDevice => 'Add a device';

  @override
  String get syncUiAddDeviceBody =>
      'On the new device, open Tanooki Auth, go to Settings, then Sync, and tap \"Join from another device\". Scan this code, then type your sync passphrase there.';

  @override
  String get syncUiAddDeviceNote =>
      'Works once, for 24 hours. Someone with only this code can\'t read anything without your passphrase.';

  @override
  String get syncUiLinkCopied => 'Link copied. Paste it on the new device.';

  @override
  String get syncUiCopyLink => 'Copy link instead';

  @override
  String get syncUiRemoveTitle => 'Remove this device from sync?';

  @override
  String get syncUiRemoveBody =>
      'It stops getting changes. If the device was lost or stolen, also change your sync passphrase: turn sync off on every device, then on again with a new passphrase, because the lost device still knows the old one.';

  @override
  String get syncUiTurnOffTitle => 'Turn off sync on this device?';

  @override
  String get syncUiTurnOffBody =>
      'Your accounts stay on this device. It just stops sending and getting changes. Your other devices keep syncing with each other.';

  @override
  String get syncUiOff => 'Sync is off on this device.';

  @override
  String get syncUiPremium => 'Sync is part of Premium';

  @override
  String syncUiPremiumBody(String payOnce) {
    return 'Add an account on one device and it shows up on all of them, end-to-end encrypted. $payOnce, no subscription.';
  }

  @override
  String get syncUiIntro =>
      'Sync keeps your accounts the same on all your devices. Before anything leaves this device it\'s locked with your sync passphrase, so iCloud or our server only ever stores scrambled data. Nobody else can read it, including us.';

  @override
  String get syncUiTurnOn => 'Turn on sync';

  @override
  String get syncUiJoin => 'Join from another device';

  @override
  String get syncUiJoinHelp =>
      'Use \"Join\" when another device already syncs with the Tanooki relay.';

  @override
  String get syncUiSyncingRelay => 'Syncing with the Tanooki relay';

  @override
  String get syncUiSyncingICloud => 'Syncing with iCloud';

  @override
  String get syncUiSyncingNow => 'Syncing now…';

  @override
  String syncUiSkipped(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count synced items couldn\'t be read',
      one: '1 synced item couldn\'t be read',
    );
    return '$_temp0';
  }

  @override
  String get syncUiSkippedHelp =>
      'They may have been changed by someone else or made with another passphrase. Nothing was deleted because of them.';

  @override
  String get syncUiDevices => 'Devices';

  @override
  String get syncUiLoading => 'Loading…';

  @override
  String get syncUiAddDeviceRelay => 'Shows a code to scan on the new device';

  @override
  String get syncUiAddDeviceApple => 'Another iPhone, iPad or Mac';

  @override
  String get syncUiTurnOffButton => 'Turn off sync on this device';

  @override
  String get syncUiPassphraseNoteRelay =>
      'Your sync passphrase can\'t be recovered. If you forget it, turn sync off on every device and start again with a new one. Your accounts stay put.';

  @override
  String get syncUiPassphraseNoteICloud =>
      'Sync uses your iCloud Drive. Your sync passphrase can\'t be recovered; if you forget it, start fresh with a new one. Your accounts stay put.';

  @override
  String get syncUiTitle => 'Sync';

  @override
  String get syncUiTooShort =>
      'Use at least 10 characters. A few random words works well.';

  @override
  String get syncUiMismatch => 'The two passphrases don\'t match.';

  @override
  String get syncUiChoosePassphrase => 'Choose a sync passphrase';

  @override
  String get syncUiTypePassphrase => 'Type your sync passphrase';

  @override
  String get syncUiChooseHelp =>
      'You\'ll type this once on each device you add. It locks your accounts before they leave this device.\n\nWrite it down somewhere safe. It can\'t be recovered or reset, by you or by us.';

  @override
  String get syncUiTypeHelp =>
      'The same passphrase you chose when you turned on sync on your first device.';

  @override
  String get syncUiPassphrase => 'Sync passphrase';

  @override
  String get syncUiTypeAgain => 'Type it again';

  @override
  String get syncUiSectionTitle => 'Sync and phone';

  @override
  String get syncUiTitlePremium => 'Sync (Premium)';

  @override
  String get syncUiOnRelay => 'On, with the Tanooki relay';

  @override
  String get syncUiOnICloud => 'On, with iCloud';

  @override
  String get syncUiOffHelp => 'Keep your accounts the same on all your devices';

  @override
  String get syncUiBrowser => 'Use with a browser';

  @override
  String get syncUiBrowserPremium => 'Use with a browser (Premium)';

  @override
  String get syncUiBrowserHelp =>
      'Approve codes on this phone for a browser on any computer';

  @override
  String get teamUiCreateTitle => 'Create your team';

  @override
  String get teamUiCreateHint => 'TT1.…  (from the page after you subscribed)';

  @override
  String get teamUiCreateButton => 'Create team';

  @override
  String get teamUiReady =>
      'Your team is ready. Invite people with \"Invite someone\".';

  @override
  String get teamUiScanTitle => 'Scan the team invite';

  @override
  String get teamUiScanWrong =>
      'That isn\'t a team invite. Ask the team admin to open Settings, Team vault, Invite someone.';

  @override
  String get teamUiJoinTitle => 'Join a team';

  @override
  String get teamUiJoinHint =>
      'tanookiauth://team?…  (the invite link from the team admin)';

  @override
  String get teamUiJoinButton => 'Join';

  @override
  String get teamUiJoinedTeam =>
      'You\'re in the team. Team accounts appear once the admin\'s app shares the team key with this device.';

  @override
  String get teamUiInvite => 'Invite someone';

  @override
  String get teamUiInviteHelp =>
      'On their device: Settings, Team vault, then \"Scan an invite QR code\" or \"Paste an invite link\". The invite works once and lasts 7 days.';

  @override
  String get teamUiRemovePersonTitle => 'Remove this person?';

  @override
  String get teamUiRemovePersonBody =>
      'They lose access straight away, and the team gets a new key so they can\'t read anything added or changed from now on. They may have kept copies of the codes they could already see, so change the two-factor setup of any account that matters.';

  @override
  String get teamUiRemoved => 'Removed. The team has a new key.';

  @override
  String get teamUiDeleteTitle => 'Delete the team?';

  @override
  String get teamUiLeaveTitle => 'Leave the team?';

  @override
  String get teamUiDeleteBody =>
      'Every team account is deleted for everyone in the team. Everyone\'s own accounts are not touched.';

  @override
  String get teamUiLeaveBody =>
      'The team\'s accounts disappear from this device. Your own accounts are not touched.';

  @override
  String get teamUiDeleteButton => 'Delete team';

  @override
  String get teamUiLeaveButton => 'Leave';

  @override
  String get teamUiDeleted => 'Team deleted.';

  @override
  String get teamUiLeft => 'You left the team.';

  @override
  String get teamUiAddFirst =>
      'Add the account to Tanooki Auth first, then copy it into the team here.';

  @override
  String get teamUiCopyInTitle => 'Copy one of your accounts into the team';

  @override
  String teamUiCopiedIn(String name) {
    return '$name is now in the team. Your own copy stays where it was.';
  }

  @override
  String get teamUiRenameTitle => 'Rename team account';

  @override
  String get teamUiRenameHint => 'Name, e.g. AWS';

  @override
  String teamUiRemoveAccountTitle(String name) {
    return 'Remove $name from the team?';
  }

  @override
  String get teamUiRemoveAccountBody =>
      'It disappears for everyone in the team.';

  @override
  String get teamUiIntro =>
      'A team vault shares sign-in codes with up to 10 people, for \$20 a year. Everyone in the team can see, add and change team accounts. They\'re encrypted on your devices with a key only the team has, so our server can\'t read them. Team accounts sit in their own Team section and never mix with your own accounts.';

  @override
  String get teamUiStart => 'Start a team';

  @override
  String get teamUiBuy => 'Buy a team plan — \$20 a year';

  @override
  String get teamUiPlanSoon => 'Team plan coming soon';

  @override
  String get teamUiHaveLicense => 'I have a team license: create the team';

  @override
  String get teamUiJoinHelp =>
      'Ask the team admin for an invite. Joining is free.';

  @override
  String get teamUiScanInvite => 'Scan an invite QR code';

  @override
  String get teamUiPasteInvite => 'Paste an invite link';

  @override
  String get teamUiYouRun => 'You run this team';

  @override
  String get teamUiYoureIn => 'You\'re in a team';

  @override
  String teamUiPeopleCount(int count, int max) {
    return '$count of $max people';
  }

  @override
  String teamUiLastSynced(String when) {
    return 'Last synced: $when';
  }

  @override
  String teamUiPaidUntil(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Paid until $dateString';
  }

  @override
  String get teamUiSyncNow => 'Sync now';

  @override
  String get teamUiWaitingForKey =>
      'Waiting for the team admin\'s app to share the team key with this device. It happens the next time the admin opens Tanooki Auth.';

  @override
  String get teamUiAccounts => 'Team accounts';

  @override
  String get teamUiAddMine => 'Add one of mine';

  @override
  String get teamUiNoAccounts => 'No team accounts yet.';

  @override
  String get teamUiChange => 'Change';

  @override
  String get teamUiRename => 'Rename';

  @override
  String get teamUiRemoveFromTeam => 'Remove from team';

  @override
  String get teamUiPeople => 'People';

  @override
  String get teamUiThisDevice => 'This device (admin)';

  @override
  String teamUiDevice(String id) {
    return 'Device $id';
  }

  @override
  String teamUiJoined(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Joined $dateString';
  }

  @override
  String teamUiJoinedGettingKey(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Joined $dateString · getting the team key';
  }

  @override
  String get teamUiDeleteTeam => 'Delete the team';

  @override
  String get teamUiLeaveTeam => 'Leave the team';

  @override
  String get teamUiTitle => 'Team vault';

  @override
  String teamUiCopiedCode(String name) {
    return 'Copied $name code. The clipboard clears in 30 seconds.';
  }

  @override
  String teamUiSection(int count) {
    return 'Team · $count';
  }

  @override
  String get teamUiWaitingShort =>
      'Waiting for the team admin to share the team key with this device.';

  @override
  String get teamUiNoAccountsHint =>
      'No team accounts yet. Add them in Settings, Team vault.';

  @override
  String get themeAuto => 'Auto';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeLight => 'Light';

  @override
  String get themePink => 'Pastel Pink';

  @override
  String get themeBlue => 'Pastel Blue';

  @override
  String get themeLavender => 'Lavender';

  @override
  String get themeMint => 'Mint';

  @override
  String get themeMidnight => 'Midnight';

  @override
  String get themeSunset => 'Sunset';

  @override
  String get themePeach => 'Peach';

  @override
  String get themeForest => 'Forest';

  @override
  String get themeOcean => 'Ocean';

  @override
  String get themeMono => 'Mono';

  @override
  String get tidyNoName => '(no name)';

  @override
  String tidyDone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tidied $count names.',
      one: 'Tidied 1 name.',
    );
    return '$_temp0';
  }

  @override
  String get tidyTitle => 'Tidy account names';

  @override
  String get tidyNothing => 'All your account names are already tidy.';

  @override
  String get tidyIntro =>
      'These names have website addresses or extra bits in them. Untick any you want to keep as they are, then tap Apply. Your codes don\'t change.';

  @override
  String tidyWas(String name) {
    return 'Was: $name';
  }

  @override
  String get tidyNothingTicked => 'Nothing ticked';

  @override
  String tidyApply(int count) {
    return 'Apply $count';
  }

  @override
  String get emergencyNotContactCode =>
      'That isn\'t a Tanooki Auth contact code. Ask them to open Tanooki Auth, go to Settings > Emergency access, and share their contact code.';

  @override
  String get emergencyCopyWontOpen =>
      'The emergency copy couldn\'t be opened with this device\'s key. It was made for a different device, or it is damaged.';

  @override
  String get emergencyGone =>
      'This emergency copy doesn\'t exist any more. The owner removed it.';

  @override
  String get emergencyWaitNotOver => 'The 7-day wait isn\'t over yet.';

  @override
  String get emergencyNotOwnerOrContact =>
      'This device isn\'t the owner or the contact for that emergency copy.';

  @override
  String get emergencyNoRequestToDeny =>
      'There is no request to deny any more.';

  @override
  String get emergencyAskFirst => 'Ask for access first.';

  @override
  String get emergencyTooBig =>
      'Your accounts are too big to leave as an emergency copy (the limit is about 500 KB).';

  @override
  String get emergencyTooManyTries =>
      'Too many tries in a minute. Wait a minute and try again.';

  @override
  String emergencyServerSaidNo(String status) {
    return 'The sync server said no (HTTP $status).';
  }

  @override
  String emergencyServerSaidNoWhy(String status, String reason) {
    return 'The sync server said no (HTTP $status: $reason).';
  }

  @override
  String get emergencyNotEmergencyCode =>
      'That isn\'t a Tanooki Auth emergency code. Ask the person who chose you to send it again from Settings > Emergency access.';

  @override
  String get emergencyLessThanMinute => 'less than a minute';

  @override
  String emergencyDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String emergencyHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hours',
      one: '1 hour',
    );
    return '$_temp0';
  }

  @override
  String emergencyMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes',
      one: '1 minute',
    );
    return '$_temp0';
  }

  @override
  String emergencyDaysHours(int days, int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '1 day',
    );
    String _temp1 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours hours',
      one: '1 hour',
    );
    return '$_temp0 $_temp1';
  }

  @override
  String get emergencyUiExplainer =>
      'Pick one person you trust. If something happens to you, they can ask for your accounts. Your devices get a notification and you have 7 days to say no. If nobody says no, they get a copy.\n\nThe Tanooki Auth server only enforces the 7-day wait. The copy is locked with a key that only their device has, so the server can\'t read it, and neither can anyone who breaks into the server.';

  @override
  String emergencyUiPushNotWorking(String reason) {
    return 'Notifications aren\'t working yet ($reason). Tanooki Auth checks for requests each time you open it.';
  }

  @override
  String get emergencyUiScanTheirQr => 'Scan their QR code';

  @override
  String get emergencyUiPasteCode => 'Paste a code they sent';

  @override
  String get emergencyUiWrongCode => 'That isn\'t the right code.';

  @override
  String get emergencyUiCopiedCode =>
      'Copied. Send it to them however you like: it holds no secrets.';

  @override
  String get emergencyUiCopyAsText => 'Copy as text';

  @override
  String get emergencyUiTheirContactCode => 'Their contact code';

  @override
  String get emergencyUiNotContactCodeShort =>
      'That isn\'t a Tanooki Auth contact code.';

  @override
  String get emergencyUiMakeThemContact => 'Make them your emergency contact?';

  @override
  String emergencyUiMakeNamedContact(String name) {
    return 'Make $name your emergency contact?';
  }

  @override
  String get emergencyUiCopyLeftOnServer =>
      'A copy of all your accounts is locked to their device and left on the Tanooki Auth server. It updates when you change your accounts.';

  @override
  String get emergencyUiYourNameWhose =>
      'Your name (so they know whose copy it is)';

  @override
  String get emergencyUiDoneGiveCode =>
      'Done. Now give them the code on this screen.';

  @override
  String get emergencyUiStopTitle => 'Stop emergency access?';

  @override
  String get emergencyUiStopBody =>
      'The copy is deleted from the server, and they can\'t ask for it any more.';

  @override
  String get emergencyUiChooseContact => 'Choose an emergency contact';

  @override
  String get emergencyUiChooseContactPremium =>
      'Choose an emergency contact (Premium)';

  @override
  String get emergencyUiChooseContactHow =>
      'They open Tanooki Auth on their device, go to Settings > Emergency access, and show you their contact code.';

  @override
  String get emergencyUiYourContact => 'Your contact';

  @override
  String get emergencyUiChecking => 'Checking with the server…';

  @override
  String get emergencyUiIdleJustNow =>
      'Nobody has asked. Copy last updated just now.';

  @override
  String emergencyUiIdleUpdated(String day) {
    return 'Nobody has asked. Copy last updated $day.';
  }

  @override
  String emergencyUiWaiting(String who, String day, String left) {
    return '$who asked on $day. They can open the copy in $left unless you deny it.';
  }

  @override
  String emergencyUiReleased(String who) {
    return '$who asked and the wait is over: they can open the copy now. Deny to stop that.';
  }

  @override
  String emergencyUiContactIs(String who) {
    return 'Emergency contact: $who';
  }

  @override
  String get emergencyUiDenied =>
      'Denied. They can\'t open your accounts. They can ask again later.';

  @override
  String get emergencyUiCopyUpdated => 'Copy updated.';

  @override
  String get emergencyUiCouldntUpdate => 'Couldn\'t update the copy.';

  @override
  String get emergencyUiUpdateNow => 'Update copy now';

  @override
  String emergencyUiGiveCode(String who) {
    return 'Give $who this code. In Tanooki Auth they go to Settings > Emergency access > \"Add a code someone gave you\".';
  }

  @override
  String get emergencyUiCodeTheyGave => 'Code they gave you';

  @override
  String get emergencyUiNotEmergencyCodeShort =>
      'That isn\'t a Tanooki Auth emergency code.';

  @override
  String get emergencyUiAddedTheir =>
      'Added. You can ask for their accounts here if you ever need to.';

  @override
  String emergencyUiAddedNamed(String name) {
    return 'Added. You can ask for $name\'s accounts here if you ever need to.';
  }

  @override
  String get emergencyUiTheOwner => 'the owner';

  @override
  String get emergencyUiAskTitle => 'Ask for emergency access?';

  @override
  String emergencyUiAskBody(String who) {
    return '$who gets a notification and has 7 days to say no. If they don\'t, you can open a copy of their accounts here. Only ask if you really need it.';
  }

  @override
  String get emergencyUiAsk => 'Ask';

  @override
  String get emergencyUiAsked => 'Asked. The 7-day wait has started.';

  @override
  String emergencyUiAddTheirAccounts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Add their $count accounts?',
      one: 'Add their 1 account?',
    );
    return '$_temp0';
  }

  @override
  String emergencyUiAddNamedAccounts(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Add $name\'s $count accounts?',
      one: 'Add $name\'s 1 account?',
    );
    return '$_temp0';
  }

  @override
  String get emergencyUiSomeone => 'Someone';

  @override
  String get emergencyUiCheckingShort => 'Checking…';

  @override
  String get emergencyUiNotAsked => 'You haven\'t asked.';

  @override
  String get emergencyUiRequestAccess => 'Request access';

  @override
  String emergencyUiOpensIn(String left, String day) {
    return 'You asked. Opens in $left ($day), unless they say no.';
  }

  @override
  String get emergencyUiWaitOver => 'The wait is over.';

  @override
  String get emergencyUiOpenCopy => 'Open emergency copy';

  @override
  String emergencyUiPersonAccounts(String who) {
    return '$who\'s accounts';
  }

  @override
  String get emergencyUiYourContactCode => 'Your contact code';

  @override
  String get emergencyUiShowThis =>
      'If someone wants you as their emergency contact, show them this. It holds no secrets.';

  @override
  String get emergencyUiYourNameItsYou => 'Your name (so they know it\'s you)';

  @override
  String get emergencyUiShowMyCode => 'Show my contact code';

  @override
  String get emergencyUiLetThemScan =>
      'Let them scan this in Tanooki Auth, or copy it and send it to them.';

  @override
  String get emergencyUiAddCodeGiven => 'Add a code someone gave you';

  @override
  String get emergencyUiAddCodeGivenHow =>
      'After they chose you, their app shows a code for you';

  @override
  String get emergencyUiTitle => 'Emergency access';

  @override
  String get emergencyUiYourEmergencyContact => 'Your emergency contact';

  @override
  String get emergencyUiPeopleWhoChoseYou => 'People who chose you';

  @override
  String get securityUiProofWindows => 'Windows Hello';

  @override
  String get securityUiProofMac => 'Touch ID or your password';

  @override
  String get securityUiProofIos => 'Face ID or passcode';

  @override
  String get securityUiProofOther => 'fingerprint or PIN';

  @override
  String securityUiPasscodeAtLeast(int count) {
    return 'Passcode (at least $count numbers)';
  }

  @override
  String get securityUiTypeAgain => 'Type it again';

  @override
  String get securityUiPasscodesDontMatch => 'The two passcodes don\'t match.';

  @override
  String get securityUiPickDifferent =>
      'Pick a different passcode from your other one.';

  @override
  String get securityUiEnterPasscode => 'Enter your app passcode';

  @override
  String get securityUiPasscode => 'Passcode';

  @override
  String get securityUiWrongPasscode => 'That\'s not your passcode.';

  @override
  String get securityUiCheckupTitle => 'Security check-up';

  @override
  String get securityUiAllGood => 'All good';

  @override
  String get securityUiAllGoodBody =>
      'Your app is locked, you have a recent backup, and every account has recovery codes.';

  @override
  String get securityUiLockOffTitle => 'The app isn\'t locked';

  @override
  String get securityUiLockOffBody =>
      'Anyone who picks up your unlocked device can see your codes. Turn on \"Lock the app\" or an app passcode in Settings.';

  @override
  String get securityUiNoPasscodeTitle => 'No app passcode';

  @override
  String get securityUiNoPasscodeBody =>
      'A passcode lets you open Tanooki Auth even if Face ID or your fingerprint stops working. Set one in Settings.';

  @override
  String get securityUiAutoBackupFailed => 'Automatic backup failed';

  @override
  String get securityUiOpenAutoBackups => 'Open automatic backups';

  @override
  String get securityUiNoBackupTitle => 'No backup in the last 30 days';

  @override
  String get securityUiNoBackupBody =>
      'If this device is lost or broken, a backup is the only way to get your accounts back.';

  @override
  String get securityUiMakeBackupNow => 'Make a backup now';

  @override
  String securityUiNoRecoveryTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count accounts have no recovery codes',
      one: '1 account has no recovery codes',
    );
    return '$_temp0';
  }

  @override
  String securityUiNoRecoveryBody(String names) {
    return 'Recovery codes get you into a website if you lose this app. Find them in each site\'s security settings, then add them with ⋯ > Recovery codes on the account.\n\n$names';
  }

  @override
  String get securityUiRecoveryKit => 'Your recovery kit';

  @override
  String get securityUiRecoveryKitSub =>
      'Backup, recovery codes and a paper copy, step by step';

  @override
  String securityUiBreachSnack(String sites) {
    return '$sites had a data breach. Change your password there.';
  }

  @override
  String get securityUiBreachDownloadFailed =>
      'Couldn\'t download the breach list. Check your internet connection and try again.';

  @override
  String get securityUiBreachAlerts => 'Breach alerts';

  @override
  String get securityUiBreachAlertsPremium => 'Breach alerts (Premium)';

  @override
  String get securityUiBreachAlertsSub =>
      'Once a week, tells you if a website you use had a data breach';

  @override
  String get securityUiBreachHow =>
      'How it works: Tanooki Auth downloads the public list of known breaches from haveibeenpwned.com and compares it with your saved websites on this device. Nothing about you or your accounts is sent: it\'s the same download for everyone. This is the only time the app goes on the internet, apart from sync and buying Premium.';

  @override
  String securityUiNoWebsite(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count of your accounts have no website saved, so they can\'t be checked. Add one with ⋯ > Edit.',
      one: '1 of your accounts has no website saved, so it can\'t be checked. Add one with ⋯ > Edit.',
    );
    return '$_temp0';
  }

  @override
  String get securityUiCheckNow => 'Check now';

  @override
  String get securityUiNoBreaches =>
      'No known breaches for your saved websites.';

  @override
  String get securityUiBreached =>
      'Breached. If you made your password before then, change it there.';

  @override
  String securityUiBreachedOn(String date) {
    return 'Breached $date. If you made your password before then, change it there.';
  }

  @override
  String securityUiBreachedLeaked(String data) {
    return 'Breached. Leaked: $data. If you made your password before then, change it there.';
  }

  @override
  String securityUiBreachedOnLeaked(String date, String data) {
    return 'Breached $date. Leaked: $data. If you made your password before then, change it there.';
  }

  @override
  String get securityUiKitIntro =>
      'If you lose this device, these are how you get back into your accounts. Each takes a minute. If you haven\'t added any accounts yet, add them first, then come back here from Settings > Security check-up.';

  @override
  String get securityUiKitBackupTitle => 'Make a backup';

  @override
  String get securityUiKitBackupBody =>
      'An encrypted file, locked with a passphrase you choose. Keep it somewhere other than this device, like iCloud Drive, Google Drive, or a USB stick.';

  @override
  String get securityUiKitBackupButton => 'Make a backup';

  @override
  String get securityUiKitCodesTitle => 'Save your recovery codes';

  @override
  String get securityUiKitCodesBody =>
      'When you turn on two-factor login, most websites give you a list of one-time recovery codes. Add them to each account with ⋯ > Recovery codes, so they\'re in your backup too.';

  @override
  String get securityUiKitPaperTitle => 'Print a paper backup';

  @override
  String get securityUiKitPaperBody =>
      'Optional. A printed page of QR codes works even if every device is gone. Keep it locked away: anyone with it can make your codes.';

  @override
  String get securityUiKitPaperButton => 'Print paper backup';

  @override
  String get securityUiSkipForNow => 'Skip for now';

  @override
  String get securityExtrasPrivacy =>
      'No account, no tracking. Your setup keys are stored encrypted on this device. The app goes online only for: a clock check (it asks the Tanooki Auth server for the time, at most once an hour while codes are on screen and when you tap \"Codes not working?\"; nothing about you or your accounts is sent), breach alerts if you turn them on (downloads the public breach list), sync, phone link and emergency access if you set them up (they carry only encrypted data the server can\'t read), buying Premium, and feedback you choose to send (your message, your email if you type one, and the app version and device type if you leave that ticked; never your accounts, codes or anything else in the app). 2FA guides open in your web browser.';

  @override
  String get securityExtrasMonthlyBody =>
      'Your monthly security summary is ready. Open Tanooki Auth to see it.';

  @override
  String get securityExtrasNotificationsOffIos =>
      'Notifications are turned off for Tanooki Auth. Turn them on in the iPhone Settings app, under Notifications, then try again.';

  @override
  String get securityExtrasNotificationsOffMac =>
      'Notifications are turned off for Tanooki Auth. Turn them on in System Settings, under Notifications, then try again.';

  @override
  String securityExtrasReminderFailed(String reason) {
    return 'Couldn\'t set the reminder ($reason).';
  }

  @override
  String get securityExtrasRemindersUnavailable =>
      'Reminders aren\'t available on this device yet.';

  @override
  String securityExtrasDayTime(String day, String time) {
    return '$day, $time';
  }

  @override
  String get securityExtrasClearTitle => 'Clear activity history?';

  @override
  String get securityExtrasClearBody =>
      'Every entry is removed from this device. Your accounts aren\'t touched.';

  @override
  String get securityExtrasActivityTitle => 'Activity history';

  @override
  String securityExtrasActivityPitch(int count) {
    return 'Activity history is part of Premium. It keeps the last $count times a code was copied, filled into a website, typed, shown as a QR code or exported, on this device only.';
  }

  @override
  String get securityExtrasNothingYet =>
      'Nothing yet. Copying, filling, typing, showing a QR code or exporting shows up here.';

  @override
  String get securityExtrasAllAccounts => 'All accounts';

  @override
  String get securityExtrasDeletedAccount => 'A deleted account';

  @override
  String securityExtrasActivityLine(String kind, String what) {
    return '$kind: $what';
  }

  @override
  String get securityExtrasGetPremium => 'Get Premium';

  @override
  String get securityExtrasAddKey => 'Add a security key';

  @override
  String get securityExtrasAddKeyPremium => 'Add a security key (Premium)';

  @override
  String get securityExtrasAddKeyIos =>
      'Next, hold the key to the top of your iPhone, or plug it in, when asked. You may need to touch it twice.';

  @override
  String get securityExtrasAddKeyOther =>
      'Next, plug the key in and touch it when it blinks. You may need to touch it twice, and type its PIN if it has one.';

  @override
  String get securityExtrasKeyName => 'Name (so you can tell your keys apart)';

  @override
  String securityExtrasKeyAdded(String name) {
    return 'Added \"$name\". You can now unlock Tanooki Auth with it on this device.';
  }

  @override
  String securityExtrasKeyRemoved(String name) {
    return 'Removed \"$name\". It can\'t unlock Tanooki Auth any more.';
  }

  @override
  String get securityExtrasKeysTitle => 'Security keys';

  @override
  String securityExtrasKeysIntro(String usual) {
    return 'A security key (like a YubiKey) can unlock Tanooki Auth instead of $usual. The key holds a secret that never leaves it, and the app uses it to lock away the key to your accounts. Lose the key and you can still unlock the usual way.';
  }

  @override
  String securityExtrasKeyAddedOn(String day) {
    return 'Added $day';
  }

  @override
  String get securityExtrasLockOffNote =>
      'The app lock is off, so the app opens without asking. Turn on \"Lock the app\" or a passcode in Settings to use your key.';

  @override
  String get securityExtrasLockWordWindows => 'Windows Hello or your passcode';

  @override
  String get securityExtrasLockWordMac => 'Touch ID or your passcode';

  @override
  String get securityExtrasLockWordOther => 'Face ID or your passcode';

  @override
  String get securityLockImmediately => 'Immediately';

  @override
  String get securityLockAfter30s => 'After 30 seconds';

  @override
  String get securityLockAfter1m => 'After 1 minute';

  @override
  String get securityLockAfter5m => 'After 5 minutes';

  @override
  String get securityNumbersOnly => 'Use numbers only.';

  @override
  String securityAtLeastNumbers(int count) {
    return 'Use at least $count numbers.';
  }

  @override
  String get securitySameNumber => 'Don\'t use the same number over and over.';

  @override
  String get securityNumbersInRow => 'Don\'t use numbers in a row like 123456.';

  @override
  String get securityPanicNeedsPasscode =>
      'Set an app passcode first. Panic wipe counts wrong passcodes.';

  @override
  String get securityPanicNeedsBackup =>
      'Make a backup first (Settings > Export backup). Panic wipe erases every account, so it only turns on if you made a backup in the last 30 days.';

  @override
  String get securityKeyDefaultName => 'Security key';

  @override
  String get securityKeyNotYours =>
      'That security key isn\'t one you added to Tanooki Auth on this device.';

  @override
  String get securityKeyNotAvailable => 'Not available on this device yet.';

  @override
  String get securityKeyWindowsTooOld =>
      'Not available on this version of Windows yet. Install the latest Windows 11 updates.';

  @override
  String get securityKeyIosTooOld =>
      'Needs iOS 26.4 or newer. Update in the Settings app, then try again.';

  @override
  String get securityKeyMacTooOld =>
      'Needs macOS 26.4 or newer. Update in the Settings app, then try again.';

  @override
  String get securityKeyDidntWork =>
      'The security key didn\'t work. Try again.';

  @override
  String securityKeyDidntWorkWhy(String reason) {
    return 'The security key didn\'t work ($reason). Try again.';
  }

  @override
  String get securityKeyCanceled => 'Canceled. Nothing changed.';

  @override
  String get securityKeyNoPrf =>
      'This security key can\'t unlock apps this way (it doesn\'t have the \"hmac-secret\" feature). YubiKey 5 series and most FIDO2 keys from the last few years do.';

  @override
  String get securityKeyNotAllowed =>
      'The security key didn\'t answer, or it isn\'t one added here. Plug it in (or hold it to the top of your phone) and touch it when it blinks.';

  @override
  String get securityKeyNotAssociated =>
      'This copy of Tanooki Auth isn\'t allowed to use security keys yet: Apple needs the app linked to auth.tanookistudios.com first. That\'s on our side, not yours.';

  @override
  String get securityKeyExists => 'This security key is already added.';

  @override
  String get securityKeyPin =>
      'The security key needs its PIN, and it wasn\'t entered. Try again and type the key\'s PIN when asked.';

  @override
  String get securityKeyVaultKeyMissing =>
      'The key that unlocks your accounts is missing, so a security key can\'t be added.';

  @override
  String get securityKeyNoneAdded => 'No security key is added on this device.';

  @override
  String get securityKeyBeforeReset =>
      'That security key was added before your accounts were reset, so it can\'t open them. Remove it and add it again.';

  @override
  String get backupUiChoosePassphrase => 'Choose a backup passphrase';

  @override
  String get backupUiPassphraseTitle => 'Backup passphrase';

  @override
  String get backupUiPassphraseWarning =>
      'You\'ll need this to restore the backup. Nobody, including us, can recover it if you forget it. Write it down somewhere safe.';

  @override
  String get backupUiPassphrase => 'Passphrase';

  @override
  String get backupUiTypeAgain => 'Type it again';

  @override
  String get backupUiTooShort =>
      'Use at least 8 characters. A few random words works well.';

  @override
  String get backupUiNoMatch => 'The two passphrases don\'t match.';

  @override
  String get backupUiTypePassphrase => 'Type the passphrase.';

  @override
  String get backupUiNothingToBackUp => 'There are no accounts to back up yet.';

  @override
  String get backupUiEncrypting => 'Encrypting backup…';

  @override
  String backupUiSaved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Backup of $count accounts saved.',
      one: 'Backup of 1 account saved.',
    );
    return '$_temp0';
  }

  @override
  String get backupUiNotABackup => 'That file isn\'t a Tanooki Auth backup.';

  @override
  String get backupUiUnlocking => 'Unlocking backup…';

  @override
  String backupUiImported(int count) {
    return 'Imported $count.';
  }

  @override
  String backupUiImportedSkipped(int added, int skipped) {
    return 'Imported $added, skipped $skipped.';
  }

  @override
  String backupUiImportedSkippedAlready(int added, int skipped) {
    return 'Imported $added, skipped $skipped already in your list.';
  }

  @override
  String backupUiAdded(int count) {
    return 'Added $count.';
  }

  @override
  String backupUiAddedSkipped(int added, int skipped) {
    return 'Added $added, skipped $skipped.';
  }

  @override
  String backupUiAddedSkippedAlready(int added, int skipped) {
    return 'Added $added, skipped $skipped already in your list.';
  }

  @override
  String backupUiAlreadyInList(int count) {
    return '• $count already in your list';
  }

  @override
  String get backupUiImport => 'Import';

  @override
  String backupUiImportFromGoogle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Import $count from Google Authenticator?',
      one: 'Import 1 from Google Authenticator?',
    );
    return '$_temp0';
  }

  @override
  String get backupUiGoogleMoreCodes =>
      'If Google Authenticator showed more than one QR code, scan each of them.';

  @override
  String get backupUiNothingToExport => 'There are no accounts to export yet.';

  @override
  String get backupUiPlainWhat =>
      'This saves every setup key as plain text, for moving to another authenticator app.';

  @override
  String get backupUiPlainTitle => 'Export unencrypted?';

  @override
  String backupUiPlainBody(String what) {
    return '$what Anyone who gets this file can make your login codes. Import it, then delete it straight away. For a normal backup, use \"Export backup\" instead.';
  }

  @override
  String get backupUiUnderstandExport => 'I understand, export';

  @override
  String get backupUiNothingToPrint => 'There are no accounts to print yet.';

  @override
  String get backupUiPaperTitle => 'Print a paper backup?';

  @override
  String get backupUiPaperBody =>
      'This makes a PDF with a QR code for every account, plus your unused recovery codes. Anyone who sees or photographs that paper can make your login codes, forever, without your phone or password.\n\nPrint it, then delete the PDF. Keep the paper somewhere locked, like a safe or with important documents. Don\'t email it, and don\'t save it to a shared folder.';

  @override
  String get backupUiUnderstandPdf => 'I understand, make the PDF';

  @override
  String get backupUiMakingPdf => 'Making the PDF…';

  @override
  String get backupUiPdfReady => 'PDF ready. Print it, then delete the file.';

  @override
  String get backupUiWorksTitle => 'Backup works';

  @override
  String backupUiWorksBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'This backup opens fine and has $count accounts. Nothing was added or changed.',
      one: 'This backup opens fine and has 1 account. Nothing was added or changed.',
    );
    return '$_temp0';
  }

  @override
  String get backupWrongVersion =>
      'This backup was made by a newer version of Tanooki Auth. Update the app and try again.';

  @override
  String get backupWrongPassphrase =>
      'Wrong passphrase, or the backup file is damaged.';

  @override
  String get backupDamaged =>
      'The backup unlocked but its contents are damaged.';

  @override
  String get paperBackupTitle => 'Tanooki Auth paper backup';

  @override
  String paperBackupHeader(String date) {
    return 'Tanooki Auth paper backup, $date';
  }

  @override
  String get paperBackupWarning =>
      'KEEP THIS SECRET. Anyone with this paper can make your login codes. Store it somewhere locked; shred it when you make a new one. To restore: in any authenticator app, choose \"Scan QR code\" and scan each code below.';

  @override
  String paperBackupSetupKey(String key) {
    return 'Setup key: $key';
  }

  @override
  String get paperBackupRecoveryCodes => 'Recovery codes (each works once):';

  @override
  String get autoBackupUiChooseFolderDialog =>
      'Choose a folder for automatic backups';

  @override
  String autoBackupUiToday(String time) {
    return 'Today at $time';
  }

  @override
  String autoBackupUiYesterday(String time) {
    return 'Yesterday at $time';
  }

  @override
  String autoBackupUiOnDay(String date, String time) {
    return '$date at $time';
  }

  @override
  String get autoBackupUiBackingUp => 'Backing up…';

  @override
  String autoBackupUiBackedUp(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Backed up $count accounts.',
      one: 'Backed up 1 account.',
    );
    return '$_temp0';
  }

  @override
  String get autoBackupUiCouldntUseFolder => 'Couldn\'t use that folder.';

  @override
  String autoBackupUiCouldntUseFolderWhy(String reason) {
    return 'Couldn\'t use that folder. $reason';
  }

  @override
  String get autoBackupUiTurnOffTitle => 'Turn off automatic backups?';

  @override
  String get autoBackupUiTurnOffBody =>
      'Backups already in the folder stay there. The backup passphrase is forgotten, so you\'ll choose a new one if you turn this on again.';

  @override
  String get autoBackupUiTitle => 'Automatic backups';

  @override
  String get autoBackupUiTitlePremium => 'Automatic backups (Premium)';

  @override
  String autoBackupUiIntro(int count) {
    return 'Once a day, Tanooki Auth saves an encrypted backup to a folder you choose. Pick your iCloud Drive, Google Drive or Dropbox folder and your backups are off this device too. The newest $count are kept; older ones are deleted.\n\nRestore one with Settings > Import backup and your backup passphrase.';
  }

  @override
  String get autoBackupUiLastFailed => 'The last automatic backup failed';

  @override
  String get autoBackupUiChooseFolder => 'Choose a folder';

  @override
  String get autoBackupUiBackupFolder => 'Backup folder';

  @override
  String get autoBackupUiNoBackupYet => 'No backup yet';

  @override
  String autoBackupUiLastBackup(String when) {
    return 'Last backup: $when';
  }

  @override
  String get autoBackupUiBackUpNow => 'Back up now';

  @override
  String get autoBackupUiChangeFolder => 'Change folder';

  @override
  String get autoBackupUiOffSubtitle =>
      'Off. A daily encrypted backup to iCloud Drive, Google Drive, Dropbox or any folder.';

  @override
  String autoBackupUiOnNoBackup(String folder) {
    return 'On, to $folder. No backup yet.';
  }

  @override
  String autoBackupUiOnLast(String folder, String when) {
    return 'On, to $folder. Last backup: $when.';
  }

  @override
  String get autoBackupFolderGone =>
      'The backup folder is gone. It may have been deleted, renamed outside the app, or its drive is unplugged. Choose the folder again.';

  @override
  String get autoBackupPermissionLost =>
      'Tanooki Auth is no longer allowed to write to the backup folder. Choose the folder again to give permission back.';

  @override
  String get autoBackupDiskFull =>
      'The backup folder\'s drive is full. Free up some space, then tap Back up now.';

  @override
  String get autoBackupOther =>
      'The backup couldn\'t be saved. Tap Back up now to try again.';

  @override
  String autoBackupOtherWhy(String reason) {
    return 'The backup couldn\'t be saved ($reason). Tap Back up now to try again.';
  }

  @override
  String get importUiDeleteNote =>
      'When you\'re done, delete the export file: anyone who gets it can make your codes.';

  @override
  String get importUiStepsAegis =>
      'In Aegis on your Android phone:\n\n1. Tap ⋮, then Settings, then \"Import & Export\".\n2. Tap \"Export\", choose \"Aegis (.JSON)\".\n3. Keep \"Encrypt the vault\" on if you like; you\'ll type that password here.\n4. Save the file somewhere this device can open (for example Google Drive or email it to yourself).\n\nThen pick that file here.';

  @override
  String get importUiStepsTwoFas =>
      'In 2FAS:\n\n1. Open Settings, then \"2FAS Backup\".\n2. Tap \"Export to file\". If it asks for a password, you\'ll type the same one here.\n3. Save the .2fas file somewhere this device can open.\n\nThen pick that file here.';

  @override
  String get importUiStepsAuthy =>
      'Authy has no export button, and Authy for computers was shut down in 2024.\n\nIf you already got your accounts out with a tool such as \"authy-export\", pick the file it made (a .json file, or a .txt list of otpauth:// links).\n\nIf not, the safe way is one account at a time: log in to each website, turn two-factor login off and back on, and scan the new QR code with Tanooki Auth. Keep Authy until every account works here.';

  @override
  String get importUiStepsBitwarden =>
      'In Bitwarden (website or desktop app):\n\n1. Go to Tools, then \"Export vault\".\n2. Choose \".json\" or \".csv\". Not \"encrypted\".\n3. Save the file.\n\nThen pick that file here. Only logins with an authenticator key come across; your passwords are ignored.';

  @override
  String get importUiStepsOnePassword =>
      'In the 1Password app for Mac or Windows:\n\n1. Click File, then Export, then pick your account.\n2. Choose \"CSV\" as the format and save.\n\nThen pick that file here. Only items with a one-time password come across; your passwords are ignored.';

  @override
  String get importUiStepsApple =>
      'You need a Mac for this; iPhone can\'t save the file.\n\nOn a Mac with macOS Sequoia or newer:\n1. Open the Passwords app.\n2. In the menu bar, click File, then \"Export All Passwords…\".\n3. Click \"Export Passwords\", type your Mac password if asked, and save the file.\n\nOn an older Mac: open Safari, then Safari > Settings > Passwords, click the ⋯ button, and choose \"Export All Passwords…\".\n\nThen pick that file here. Only items with a verification code come across; your passwords are ignored.';

  @override
  String get importUiStepsMicrosoft =>
      'Microsoft Authenticator can\'t export your accounts, so they can\'t be moved in one go.\n\nFor each account:\n1. Log in to that website on a computer.\n2. Find its security or two-factor settings.\n3. Turn two-factor login off and back on (or choose \"add a new authenticator app\").\n4. Scan the new QR code with Tanooki Auth and type in the code it shows to finish.\n\nKeep Microsoft Authenticator until every account works in Tanooki Auth. Your Microsoft account itself can also use Tanooki Auth: add it at account.microsoft.com, under Security.';

  @override
  String get importUiTitle => 'Move from another app';

  @override
  String get importUiCantExport => 'Can\'t export: how to move each account';

  @override
  String get importUiFromExportFile => 'From an export file';

  @override
  String importUiMoveFrom(String app) {
    return 'Move from $app';
  }

  @override
  String get importUiGotIt => 'Got it';

  @override
  String get importUiPickFile => 'Pick file';

  @override
  String get importUiCouldntRead => 'That file couldn\'t be read.';

  @override
  String importUiReading(String app) {
    return 'Reading $app export…';
  }

  @override
  String get importUiNoAccountsInFile =>
      'No two-factor accounts were in that file.';

  @override
  String importUiImportFrom(int count, String app) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Import $count from $app?',
      one: 'Import 1 from $app?',
    );
    return '$_temp0';
  }

  @override
  String importUiExportPassword(String app) {
    return '$app export password';
  }

  @override
  String get importUiPasswordHint => 'The password you chose when exporting';

  @override
  String importersNotAnExport(String app) {
    return 'That file isn\'t a $app export.';
  }

  @override
  String importersLine(String line, String problem) {
    return 'Line $line: $problem';
  }

  @override
  String get importersEmpty => 'That file is empty.';

  @override
  String get importersNotAuthy => 'That file isn\'t an Authy export.';

  @override
  String get importersAnAccount => 'An account';

  @override
  String importersQuoted(String name) {
    return '\"$name\"';
  }

  @override
  String importersProblemColon(String name, String problem) {
    return '$name: $problem';
  }

  @override
  String importersProblem(String name, String problem) {
    return '$name $problem';
  }

  @override
  String get importersAegisPassword =>
      'This Aegis export is protected with a password.';

  @override
  String get importersAegisBiometricOnly =>
      'This Aegis export can only be opened with a fingerprint on the phone that made it. In Aegis, export again and choose a password.';

  @override
  String get importersAegisWrongPassword =>
      'Wrong password for this Aegis export.';

  @override
  String get importersAegisDamaged =>
      'The Aegis export unlocked but its contents are damaged.';

  @override
  String get importersNotAegis => 'That file isn\'t an Aegis export.';

  @override
  String importersUnsupportedType(String type) {
    return 'uses $type codes, which Tanooki Auth doesn\'t support';
  }

  @override
  String get importersNotTwoFas => 'That file isn\'t a 2FAS backup.';

  @override
  String get importersTwoFasPassword =>
      'This 2FAS backup is protected with a password.';

  @override
  String get importersTwoFasDamaged => 'This 2FAS backup is damaged.';

  @override
  String get importersTwoFasWrongPassword =>
      'Wrong password for this 2FAS backup.';

  @override
  String get importersBitwardenEncrypted =>
      'That Bitwarden export is encrypted. In Bitwarden, export again and choose the \".json\" format (not \"encrypted\").';

  @override
  String get importersOnePux =>
      'That looks like a 1Password .1pux file. In 1Password, export again and choose CSV.';

  @override
  String importersNoCodeColumn(String app) {
    return 'That file has no one-time code column, so it isn\'t a $app export with codes in it.';
  }

  @override
  String importersCantReadCode(String reason) {
    return 'has a one-time code Tanooki Auth can\'t read ($reason)';
  }

  @override
  String get importersNoSecret => 'has no secret';

  @override
  String get importersBadSecret => 'has a secret that isn\'t valid';

  @override
  String importersUnsupportedDigits(int count) {
    return 'uses $count-digit codes, which Tanooki Auth doesn\'t support';
  }

  @override
  String get importersBadPeriod => 'has a broken time period';

  @override
  String importersUnsupportedAlgorithm(String algorithm) {
    return 'uses the $algorithm algorithm, which Tanooki Auth doesn\'t support';
  }

  @override
  String get exportUiTitle => 'Move to another app';

  @override
  String get exportUiAegisLocked => 'Aegis, with a password';

  @override
  String get exportUiAegisLockedSub =>
      'Safest. Aegis asks for the password when you import.';

  @override
  String get exportUiAegisPlain => 'Aegis, not encrypted';

  @override
  String get exportUiAegisPlainSub =>
      'For apps that read Aegis files but can\'t open locked ones.';

  @override
  String get exportUiTwoFasSub => 'A .2fas file without a password.';

  @override
  String get exportUiGoogleSub => 'QR codes to scan with Google Authenticator.';

  @override
  String get exportUiLinks => 'Setup links (plain text)';

  @override
  String get exportUiLinksSub =>
      'One otpauth:// link per line, for any other app.';

  @override
  String get exportUiConfirmReason => 'Export your accounts';

  @override
  String get exportUiEncryptingAegis => 'Encrypting for Aegis…';

  @override
  String get exportUiAegisPlainWhat =>
      'This saves every setup key in an unencrypted Aegis file.';

  @override
  String get exportUiTwoFasWhat =>
      'This saves every setup key in a 2FAS file without a password.';

  @override
  String get exportUiGoogleTitle => 'Show QR codes for Google Authenticator?';

  @override
  String get exportUiGoogleBody =>
      'The next screen shows QR codes holding every setup key. Anyone who sees or photographs them can make your login codes. Do this somewhere private.\n\nIn Google Authenticator: tap +, then \"Scan a QR code\", and scan each code in turn.';

  @override
  String get exportUiShowCodes => 'Show the codes';

  @override
  String exportUiExported(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Exported $count accounts. Import the file in the other app, then delete it.',
      one: 'Exported 1 account. Import the file in the other app, then delete it.',
    );
    return '$_temp0';
  }

  @override
  String get exportUiNoneForGoogle =>
      'None of your accounts can go into Google Authenticator.';

  @override
  String get exportUiScanThisCode => 'Scan this code';

  @override
  String exportUiCodeOf(int n, int total) {
    return 'Code $n of $total';
  }

  @override
  String get exportUiNextCode => 'Next code';

  @override
  String exportUiLeftOut(int count) {
    return 'Left out ($count). Google Authenticator can\'t make these codes, so add them to another app:';
  }

  @override
  String get appIconClassic => 'Classic';

  @override
  String get appIconPink => 'Pastel Pink';

  @override
  String get appIconBlue => 'Pastel Blue';

  @override
  String get appIconLavender => 'Lavender';

  @override
  String get appIconMint => 'Mint';

  @override
  String get appIconMidnight => 'Midnight';

  @override
  String get appIconSunset => 'Sunset';

  @override
  String get appIconSpooky => 'Spooky (fall)';

  @override
  String get appIconCozy => 'Cozy (winter)';

  @override
  String get appIconSpring => 'Spring';

  @override
  String get serverBrowserExtension => 'Browser extension';

  @override
  String get serverBadRequest =>
      'Tanooki Auth didn\'t understand that request.';

  @override
  String get serverLocked =>
      'Tanooki Auth is locked. Unlock it, then try again.';

  @override
  String get serverNotPaired => 'This app isn\'t paired with Tanooki Auth.';

  @override
  String get serverNotFound => 'That account isn\'t in Tanooki Auth any more.';

  @override
  String get serverRateLimited => 'Too many requests.';

  @override
  String get serverDenied =>
      'Not allowed: this account asks first, and Tanooki Auth wasn\'t unlocked for it.';

  @override
  String get serverUnknownScreen => 'Unknown screen.';

  @override
  String get serverNoWebsite => 'No website given.';

  @override
  String serverUnknownRequest(String type) {
    return 'Unknown request \"$type\".';
  }

  @override
  String get serverPairingTimedOut =>
      'Pairing timed out or was closed. Start pairing again.';

  @override
  String get serverThreeWrongCodes => 'Three wrong codes. Start pairing again.';

  @override
  String get serverWrongCode =>
      'That code doesn\'t match. Check the code shown in Tanooki Auth.';

  @override
  String get serverNoLink => 'No otpauth:// link was sent.';

  @override
  String get serverAlreadyThere => 'That account is already in Tanooki Auth.';

  @override
  String get serverAlreadyThereMany =>
      'Those accounts are already in Tanooki Auth.';

  @override
  String get autoBackupNotSupported => 'not supported on this device';

  @override
  String homeProveCopy(String name) {
    return 'Copy the code for $name';
  }

  @override
  String homeProveReadAloud(String name) {
    return 'Read aloud the code for $name';
  }

  @override
  String homeProveEdit(String name) {
    return 'Edit $name';
  }

  @override
  String homeProveShare(String name) {
    return 'Share $name';
  }

  @override
  String homeCopied(String name) {
    return 'Copied $name code. The clipboard clears in 30 seconds.';
  }

  @override
  String get homeEditAccount => 'Edit account';

  @override
  String homeShowQrFor(String name) {
    return 'Show the QR code for $name';
  }

  @override
  String homeMovedToTrash(String name) {
    return 'Moved $name to Trash. You can restore it from Settings for 30 days.';
  }

  @override
  String get homeUndo => 'Undo';

  @override
  String homeAccountCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count accounts',
      one: '1 account',
    );
    return '$_temp0';
  }

  @override
  String homeAddTagTo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Add a tag to $count accounts',
      one: 'Add a tag to 1 account',
    );
    return '$_temp0';
  }

  @override
  String get homeTagHint => 'Tag (e.g. work)';

  @override
  String get homeAddTag => 'Add tag';

  @override
  String homeTagged(int count, String tag) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tagged $count accounts \"$tag\".',
      one: 'Tagged 1 account \"$tag\".',
    );
    return '$_temp0';
  }

  @override
  String homeMoveToFolderTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Move $count accounts to a folder',
      one: 'Move 1 account to a folder',
    );
    return '$_temp0';
  }

  @override
  String get homeNoFolder => 'No folder';

  @override
  String get homeNewFolderHint => 'Or a new folder (e.g. Work)';

  @override
  String get homeMoveToNewFolder => 'Move to new folder';

  @override
  String homeTookOut(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Took $count accounts out of their folders.',
      one: 'Took 1 account out of their folders.',
    );
    return '$_temp0';
  }

  @override
  String homeMovedTo(int count, String folder) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Moved $count accounts to $folder.',
      one: 'Moved 1 account to $folder.',
    );
    return '$_temp0';
  }

  @override
  String homeAddedToFavorites(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Added $count accounts to favorites.',
      one: 'Added 1 account to favorites.',
    );
    return '$_temp0';
  }

  @override
  String homeRemovedFromFavorites(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Removed $count accounts from favorites.',
      one: 'Removed 1 account from favorites.',
    );
    return '$_temp0';
  }

  @override
  String homeBulkTrashed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Moved $count accounts to Trash. You can restore them from Settings for 30 days.',
      one: 'Moved 1 account to Trash. You can restore them from Settings for 30 days.',
    );
    return '$_temp0';
  }

  @override
  String get homeDoneSelecting => 'Done selecting';

  @override
  String get homeTapToSelect => 'Tap accounts to select';

  @override
  String homeSelectedCount(int count) {
    return '$count selected';
  }

  @override
  String get homeSelectNone => 'Select none';

  @override
  String get homeSelectAll => 'Select all';

  @override
  String get homeAddATag => 'Add a tag';

  @override
  String get homeMoveToFolder => 'Move to folder';

  @override
  String get homeRemoveFromFavorites => 'Remove from favorites';

  @override
  String get homeAddToFavorites => 'Add to favorites';

  @override
  String get homeMoveToTrash => 'Move to Trash';

  @override
  String get homeSelectFirst =>
      'Select some accounts first: tap them in the list.';

  @override
  String homeSectionOpen(String name, String accounts) {
    return '$name, $accounts, tap to fold away';
  }

  @override
  String homeSectionClosed(String name, String accounts) {
    return '$name, $accounts, tap to show';
  }

  @override
  String get homeSearchHint => 'Search accounts or websites…';

  @override
  String get homeAllTags => 'All';

  @override
  String get homeNoAccountsYet =>
      'No accounts yet.\nAdd one to scan a setup QR code.';

  @override
  String get homeNoTagMatches => 'No accounts with this tag.';

  @override
  String get homeNoSearchMatches => 'No accounts match your search.';

  @override
  String get homeSelectAccounts => 'Select accounts';

  @override
  String get homeSettings => 'Settings';

  @override
  String get homeAddAccount => 'Add account';

  @override
  String get homeAccounts => 'Accounts';

  @override
  String get homeYourAccounts => 'Your accounts';

  @override
  String get homeSelect => 'Select';

  @override
  String get homeKeysTouch => 'Tap (Copy) · Enter (Copy) · Arrows (Navigate)';

  @override
  String get homeKeysClick => 'Click (Copy) · Enter (Copy) · Arrows (Navigate)';

  @override
  String get homePickOnLeft => 'Pick an account on the left to see it here.';

  @override
  String homeQrFor(String name) {
    return 'QR code for $name';
  }

  @override
  String get homeQrWarning =>
      'Scan this with another authenticator app to add the same account there. Anyone who sees or photographs it can make your codes, so keep it private.';

  @override
  String homeVersionNote(Object version) {
    return 'v$version · stays on this device';
  }

  @override
  String homeSelectName(String name) {
    return 'Select $name';
  }

  @override
  String get homeMore => 'More';

  @override
  String get homeRecoveryCodes => 'Recovery codes';

  @override
  String homeRecoveryCodesLeft(int count) {
    return 'Recovery codes ($count left)';
  }

  @override
  String get homeShareSecurely => 'Share securely';

  @override
  String get homeShowQr => 'Show QR code';

  @override
  String get homeMoveEarlier => 'Move earlier';

  @override
  String get homeMoveLater => 'Move later';

  @override
  String homeNextCodeShort(String code) {
    return 'Next $code';
  }

  @override
  String get homeNextCode => 'Next code';

  @override
  String get homeFavorite => 'Favorite';

  @override
  String get homeCodeHiddenAsk => 'Code hidden until you confirm it is you';

  @override
  String get homeCodeHidden => 'Code hidden';

  @override
  String homeNextCodeSpoken(String code) {
    return 'Next code $code';
  }

  @override
  String homeKindTotp(int count, int seconds) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count digits',
      one: '1 digit',
    );
    return 'TOTP · $_temp0 · ${seconds}s';
  }

  @override
  String homeKindSteam(int seconds) {
    return 'Steam · 5 characters · ${seconds}s';
  }

  @override
  String homeKindHotp(int count, String counter) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count digits',
      one: '1 digit',
    );
    return 'HOTP · $_temp0 · #$counter';
  }

  @override
  String get homeAccountHeading => 'Account';

  @override
  String get homeHintUnselect => 'unselect';

  @override
  String get homeHintSelect => 'select';

  @override
  String get homeHintCopy => 'copy the code';

  @override
  String get homeReadCodeAloud => 'Read code aloud';

  @override
  String get homeMoreOptions => 'More options';

  @override
  String get mainPairRaycastTitle => 'Pair with Raycast';

  @override
  String get mainPairRaycastBody => 'Type this code into Raycast:';

  @override
  String get mainPairRaycastWarning =>
      'Only do this if you just started pairing in Raycast yourself.';

  @override
  String get mainPairAlfredTitle => 'Pair with Alfred';

  @override
  String get mainPairAlfredBody => 'Type 2fa-pair and this code into Alfred:';

  @override
  String get mainPairAlfredWarning =>
      'Only do this if you just typed 2fa-pair in Alfred yourself.';

  @override
  String get mainPairPowerToysTitle => 'Pair with PowerToys';

  @override
  String get mainPairPowerToysBody =>
      'Type this code into PowerToys Command Palette:';

  @override
  String get mainPairPowerToysWarning =>
      'Only do this if you just started pairing in PowerToys yourself.';

  @override
  String get mainPairBrowserTitle => 'Pair with your browser';

  @override
  String get mainPairBrowserBody =>
      'Type this code into the Tanooki Auth browser extension:';

  @override
  String get mainPairBrowserWarning =>
      'Only do this if you just clicked \"Pair\" in the extension yourself.';

  @override
  String mainSendCodeTo(String name, String client) {
    return 'Send the code for $name to $client';
  }

  @override
  String mainWrongPasscodeLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Wrong passcode. $count more wrong tries erase everything.',
      one: 'Wrong passcode. 1 more wrong try erases everything.',
    );
    return '$_temp0';
  }

  @override
  String get mainWrongPasscode => 'Wrong passcode.';

  @override
  String get mainBiometricWindows => 'Windows Hello';

  @override
  String get mainBiometricMac => 'Touch ID';

  @override
  String get mainBiometricOther => 'Face ID or fingerprint';

  @override
  String get mainLockTitle => 'Lock Tanooki Auth?';

  @override
  String get mainLockBody =>
      'Ask for your face, fingerprint, or passcode when the app opens, so someone holding your unlocked phone can\'t read your codes. You can change this later in Settings.';

  @override
  String get mainTurnOnLock => 'Turn on lock';

  @override
  String get mainUnlockReason => 'Unlock Tanooki Auth';

  @override
  String get mainStartOverTitle => 'Start a new, empty vault?';

  @override
  String get mainStartOverBody =>
      'This permanently replaces whatever is left of your old accounts. Only do this if you have no backup to restore, or you have already turned off two-factor login on those sites.';

  @override
  String get mainEraseStartOver => 'Erase and start over';

  @override
  String get mainRestoreFromBackup => 'Restore from backup';

  @override
  String get mainStartNewVault => 'Start a new, empty vault';

  @override
  String get mainLocked => 'Tanooki Auth is locked';

  @override
  String mainUseBiometric(String method) {
    return 'Use $method';
  }

  @override
  String get mainUseSecurityKey => 'Use security key';

  @override
  String homeHidesIn(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hides in $count seconds',
      one: 'Hides in 1 second',
    );
    return '$_temp0';
  }

  @override
  String homeCardsMonth(String month) {
    String _temp0 = intl.Intl.selectLogic(month, {
      'm1': 'January',
      'm2': 'February',
      'm3': 'March',
      'm4': 'April',
      'm5': 'May',
      'm6': 'June',
      'm7': 'July',
      'm8': 'August',
      'm9': 'September',
      'm10': 'October',
      'm11': 'November',
      'm12': 'December',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String homeCardsDay(String month, String day) {
    return '$month $day';
  }

  @override
  String get homeCardsDenied =>
      'Denied. They can\'t open your accounts. They can ask again later, and you\'ll be asked again.';

  @override
  String get homeCardsClockRight =>
      'Your clock is right now. Codes should work.';

  @override
  String get homeCardsCheckAgain => 'Check again';

  @override
  String get homeCardsYourContact => 'Your emergency contact';

  @override
  String homeCardsEmergencyWaiting(String who, String left, String day) {
    return '$who asked for emergency access to your accounts. Unless you deny it, they can open a copy in $left ($day).';
  }

  @override
  String homeCardsEmergencyReleased(String who) {
    return '$who asked for emergency access and the 7-day wait is over, so they can open a copy of your accounts now. Deny to stop that.';
  }

  @override
  String get homeCardsBackupNudge =>
      'Your accounts changed since your last backup. A backup file is how you get them back if this device is lost.';

  @override
  String get homeCardsBackUpNow => 'Back up now';

  @override
  String homeCardsSummaryNew(int count, String month) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Your $month summary: $count new accounts.',
      one: 'Your $month summary: 1 new account.',
    );
    return '$_temp0';
  }

  @override
  String get homeCardsSummaryNoBackup => 'No backup yet.';

  @override
  String homeCardsSummaryLastBackup(String day) {
    return 'Last backup $day.';
  }

  @override
  String get homeCardsSummaryAllCodes => 'Every account has recovery codes.';

  @override
  String homeCardsSummaryMissingCodes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count accounts without recovery codes.',
      one: '1 account without recovery codes.',
    );
    return '$_temp0';
  }

  @override
  String get homeCardsSummaryCheckupGood => 'Security check-up: all good.';

  @override
  String homeCardsSummaryCheckupFix(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Security check-up: $count things to fix.',
      one: 'Security check-up: 1 thing to fix.',
    );
    return '$_temp0';
  }

  @override
  String get homeCardsOpenCheckup => 'Open check-up';

  @override
  String get quickPickSelf =>
      'Tanooki Auth was still in front, so nothing was typed. Click into the box you want to fill, then use the menu bar icon again.';

  @override
  String quickPickTypeFailed(String reason) {
    return 'Couldn\'t type the code ($reason). Copy it instead.';
  }

  @override
  String get quickPickTypeUnavailable =>
      'Typing codes isn\'t available on this computer. Copy it instead.';

  @override
  String quickPickUseCodeFor(String name) {
    return 'Use the code for $name';
  }

  @override
  String get quickPickAllowTitle => 'Allow Tanooki Auth to type';

  @override
  String get quickPickAllowBody =>
      'To type a code into another app, your Mac needs to let Tanooki Auth press keys for you.\n\n1. Click \"Open System Settings\" below.\n2. You\'ll see a list called Accessibility. Find Tanooki Auth and turn its switch on (blue).\n3. If your Mac asks for your password or Touch ID, give it.\n4. Come back here and click Type again.\n\nTanooki Auth only presses keys when you click Type, and only types the code.';

  @override
  String get quickPickOpenSystemSettings => 'Open System Settings';

  @override
  String get quickPickTitle => 'Quick pick';

  @override
  String get quickPickSearch => 'Search accounts';

  @override
  String get quickPickLinuxNote =>
      'Typing codes into other apps isn\'t available on Linux. Click an account to copy its code.';

  @override
  String get quickPickNoMatches => 'No matching accounts';

  @override
  String get quickPickAsksFirst => '••• •••  (asks first)';

  @override
  String get quickPickHiddenAsks => 'Code hidden, asks first';

  @override
  String get quickPickType => 'Type';

  @override
  String get codeViewRing => 'Ring';

  @override
  String get codeViewBar => 'Bar';

  @override
  String get codeViewNumber => 'Number';

  @override
  String codeViewSpoken(String code) {
    return 'Code $code';
  }

  @override
  String codeViewSpokenLeft(int count, String code) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Code $code, $count seconds left',
      one: 'Code $code, 1 second left',
    );
    return '$_temp0';
  }

  @override
  String get codeViewReadAloud => 'Read code aloud';

  @override
  String codeViewSecondsShort(int count) {
    return '${count}s';
  }

  @override
  String get codeViewColorBlue => 'Blue';

  @override
  String get codeViewColorPurple => 'Purple';

  @override
  String get codeViewColorPink => 'Pink';

  @override
  String get codeViewColorRed => 'Red';

  @override
  String get codeViewColorOrange => 'Orange';

  @override
  String get codeViewColorGold => 'Gold';

  @override
  String get codeViewColorGreen => 'Green';

  @override
  String get codeViewColorTeal => 'Teal';

  @override
  String get codeViewColorGray => 'Gray';

  @override
  String trashRestored(String name) {
    return '$name is back in your list.';
  }

  @override
  String trashDeleteTitle(String name) {
    return 'Delete $name for good?';
  }

  @override
  String get trashDeleteBody =>
      'This can\'t be undone. Before deleting, turn off two-factor login on that website or make sure you have its recovery codes, or you could be locked out.';

  @override
  String get trashDeleteForGood => 'Delete for good';

  @override
  String get trashTitle => 'Trash';

  @override
  String get trashEmpty =>
      'Trash is empty.\nDeleted accounts stay here for 30 days.';

  @override
  String get trashNote =>
      'Deleted accounts stay here for 30 days, then they\'re removed for good.';

  @override
  String get trashRemovedNextOpen => 'Removed next time the app opens';

  @override
  String trashDaysLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days left',
      one: '1 day left',
    );
    return '$_temp0';
  }

  @override
  String get trashRestore => 'Restore';

  @override
  String get recoveryAddTitle => 'Add recovery codes';

  @override
  String get recoveryPasteHint =>
      'Paste the codes the website gave you, one per line';

  @override
  String get recoveryNoneNew => 'No new codes found in what you pasted.';

  @override
  String recoveryAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Added $count codes.',
      one: 'Added 1 code.',
    );
    return '$_temp0';
  }

  @override
  String get recoveryCopiedUsed =>
      'Copied. Heads up: you marked this code as used, so it probably won\'t work again.';

  @override
  String get recoveryCopied =>
      'Copied. The clipboard clears in 30 seconds. Mark it used once you\'ve signed in.';

  @override
  String get recoveryRemoveTitle => 'Remove this code?';

  @override
  String recoveryRemoveBody(String code) {
    return '$code\n\nOnly remove it if the website no longer accepts it.';
  }

  @override
  String recoveryTitle(String name) {
    return '$name recovery codes';
  }

  @override
  String get recoveryAddCodes => 'Add codes';

  @override
  String get recoveryIntro =>
      'When you turn on two-factor login, most websites also give you a list of backup codes. Each one gets you in once if you ever lose this app. Paste them here so they\'re kept safe with the account.';

  @override
  String recoveryUnusedOf(String unused, int total) {
    return '$unused of $total unused. Tap a code to copy it, and tick it once you\'ve used it.';
  }

  @override
  String get recoveryUsed => 'Used';

  @override
  String get detailsEditAccount => 'Edit account';

  @override
  String get detailsCopyCode => 'Copy code';

  @override
  String get detailsReadAloud => 'Read aloud';

  @override
  String get detailsFolderAndTags => 'Folder and tags';

  @override
  String get detailsWebsites => 'Websites';

  @override
  String get detailsNotes => 'Notes';

  @override
  String get detailsNotesHidden => 'Hidden until you confirm it\'s you.';

  @override
  String get detailsNoNotes => 'No notes. Add some with Edit.';

  @override
  String get accountSortCustom => 'Custom (drag to arrange)';

  @override
  String get accountSortRecent => 'Recently used';

  @override
  String get accountSortName => 'A to Z';

  @override
  String get activityCopied => 'Copied';

  @override
  String get activityFilled => 'Filled';

  @override
  String get activityTyped => 'Typed';

  @override
  String get activityShownQr => 'Showed QR code';

  @override
  String get activityExported => 'Exported';

  @override
  String totpBadCharacter(String char) {
    return 'Not a valid base32 secret (bad character \"$char\")';
  }

  @override
  String get totpEmpty => 'Secret is empty';

  @override
  String get vaultFileMissing =>
      'Your accounts file is missing. If you have a backup, restore it. Otherwise you can start a new, empty vault.';

  @override
  String get vaultKeyMissing =>
      'The key that unlocks your accounts is missing from this device\'s secure storage. Restore a backup to get your accounts back.';

  @override
  String get vaultDecryptFailed =>
      'Your accounts file could not be unlocked. It may be damaged or was changed outside the app. Restore a backup.';

  @override
  String get vaultBadJson =>
      'Your accounts file unlocked but its contents are damaged. Restore a backup.';

  @override
  String clockCheckBadAnswer(String status) {
    return 'The time server sent an answer the app doesn\'t understand (HTTP $status).';
  }

  @override
  String clockCheckOff(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Your device clock is about $count minutes off, so codes won\'t work. Turn on automatic time in Settings.',
      one: 'Your device clock is about 1 minute off, so codes won\'t work. Turn on automatic time in Settings.',
    );
    return '$_temp0';
  }

  @override
  String backupUiBullet(String item) {
    return '• $item';
  }

  @override
  String backupUiAccountWithLabel(String title, String label) {
    return '$title ($label)';
  }

  @override
  String exportUiLeftOutLine(String account, String reason) {
    return '• $account: $reason';
  }
}
