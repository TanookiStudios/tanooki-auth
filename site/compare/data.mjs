// Facts for the compare pages. Every fact about another app carries the official page it came from (src),
// read on the `checked` date. A fact that official pages didn't confirm says exactly 'Not sure'.
// Rebuild after editing: node site/compare/build.mjs

export const checked = '2026-11-02';

// The rows of every table, in order.
export const rows = [
  ['platforms', 'Platforms'],
  ['openSource', 'Open source'],
  ['backup', 'Encrypted backup'],
  ['export', 'Export your accounts'],
  ['desktop', 'Desktop app'],
  ['extension', 'Browser extension'],
  ['price', 'Price'],
];

const GH = 'https://github.com/TanookiStudios/tanooki-auth';
export const tanooki = {
  name: 'Tanooki Auth',
  platforms: { v: 'Mac, Windows, Android. iPhone and iPad are coming to the App Store.', src: '/press/' },
  openSource: { v: 'Yes, GPL-3.0', src: GH },
  backup: { v: 'Yes. A backup file encrypted with a password only you know. Optional end-to-end encrypted sync with Premium.', src: '/press/' },
  export: { v: 'Yes: Google Authenticator transfer QR codes, Aegis and 2FAS files, or otpauth:// links', src: GH },
  desktop: { v: 'Yes, Mac and Windows', src: '/press/' },
  extension: { v: 'Yes, for Chrome, Brave and Edge. It fills a code only on the site the account belongs to.', src: '/press/' },
  price: { v: 'Free. Optional Premium is $5 once (no subscription).', src: '/press/' },
};

export const apps = [
  {
    slug: 'authy',
    name: 'Authy',
    maker: 'Twilio',
    site: 'https://www.authy.com/',
    platforms: { v: 'iPhone, iPad, Apple Watch and Android. The Mac, Windows and Linux apps were shut down on March 19, 2024.', src: 'https://www.twilio.com/en-us/changelog/end-of-life--eol--of-twilio-authy-desktop-apps' },
    openSource: { v: 'Not sure', note: 'We found no official statement either way.', src: 'https://www.authy.com/' },
    backup: { v: 'Yes. Cloud backup encrypted on your device with a password you set; Twilio never gets the password.', src: 'https://www.twilio.com/en-us/blog/how-the-authy-two-factor-backups-work' },
    export: { v: 'Not sure', note: 'Authy’s own pages we could read don’t mention an export option.', src: 'https://www.authy.com/features/' },
    desktop: { v: 'No (shut down March 19, 2024)', src: 'https://www.twilio.com/en-us/changelog/end-of-life--eol--of-twilio-authy-desktop-apps' },
    extension: { v: 'No. The Chrome app and extension were retired in 2020.', src: 'https://www.twilio.com/en-us/blog/products/authy-chrome-app-extension-end-life' },
    price: { v: 'Free', src: 'https://apps.apple.com/us/app/twilio-authy/id494168017' },
    doesWell: [
      { t: 'Keeps your codes in sync across several phones and tablets, and lets you remove a lost device.', src: 'https://www.authy.com/features/' },
      { t: 'Its cloud backup is encrypted with your own password before it leaves your phone.', src: 'https://www.twilio.com/en-us/blog/how-the-authy-two-factor-backups-work' },
    ],
    moving: 'We couldn’t find an export option in Authy’s documentation. The safe way to move is one account at a time: on each website, turn two-factor off and back on, and scan the new QR code with Tanooki Auth. Keep Authy until every account works.',
  },
  {
    slug: 'google-authenticator',
    name: 'Google Authenticator',
    maker: 'Google',
    site: 'https://support.google.com/accounts/answer/1066447?hl=en',
    platforms: { v: 'Android, iPhone and iPad', src: 'https://support.google.com/accounts/answer/1066447?hl=en' },
    openSource: { v: 'No. Google’s old open-source version is archived and says the store app is not open source.', src: 'https://github.com/google/google-authenticator-android' },
    backup: { v: 'Yes. Optional sync to your Google Account, encrypted in transit and at rest. Google doesn’t describe a separate password you set.', src: 'https://support.google.com/accounts/answer/1066447?hl=en' },
    export: { v: 'Yes, as transfer QR codes for another phone', src: 'https://support.google.com/accounts/answer/1066447?hl=en&co=GENIE.Platform%3DiOS' },
    desktop: { v: 'No', src: 'https://apps.apple.com/us/app/google-authenticator/id388497605' },
    extension: { v: 'Not sure', note: 'Google’s help page doesn’t mention one, and we found no official extension.', src: 'https://support.google.com/accounts/answer/1066447?hl=en' },
    price: { v: 'Free', src: 'https://apps.apple.com/us/app/google-authenticator/id388497605' },
    doesWell: [
      { t: 'If you sign in, your codes sync to your Google Account, so a lost phone doesn’t mean lost codes.', src: 'https://support.google.com/accounts/answer/1066447?hl=en' },
      { t: 'Moving to a new phone is simple: the old phone shows QR codes and the new one scans them, with or without a Google Account.', src: 'https://support.google.com/accounts/answer/1066447?hl=en&co=GENIE.Platform%3DiOS' },
    ],
    moving: 'Tanooki Auth reads Google Authenticator’s transfer QR codes. In Google Authenticator, open the menu, then Transfer accounts, then Export accounts, and in Tanooki Auth tap Add account, then Move from Google Authenticator, and scan each QR code it shows.',
  },
  {
    slug: 'microsoft-authenticator',
    name: 'Microsoft Authenticator',
    maker: 'Microsoft',
    site: 'https://support.microsoft.com/en-us/account-billing/about-microsoft-authenticator-9783c865-0308-42fb-a519-8cf666fe0acc',
    platforms: { v: 'iPhone, iPad and Android. Microsoft says it isn’t available for PC or Mac.', src: 'https://support.microsoft.com/en-us/account-billing/download-microsoft-authenticator-351498fc-850a-45da-b7b6-27e523b8702a' },
    openSource: { v: 'Not sure', note: 'We found no official statement either way.', src: 'https://support.microsoft.com/en-us/account-billing/about-microsoft-authenticator-9783c865-0308-42fb-a519-8cf666fe0acc' },
    backup: { v: 'Cloud backup: iCloud on iPhone; a personal Microsoft account on Android, moving to Google One starting January 2027. Microsoft’s page doesn’t say how it’s encrypted. Restores only to the same kind of phone.', src: 'https://support.microsoft.com/en-us/authenticator/back-up-your-accounts-in-microsoft-authenticator' },
    export: { v: 'Not sure', note: 'Microsoft’s backup page describes no way to export codes.', src: 'https://support.microsoft.com/en-us/authenticator/back-up-your-accounts-in-microsoft-authenticator' },
    desktop: { v: 'No', src: 'https://support.microsoft.com/en-us/account-billing/download-microsoft-authenticator-351498fc-850a-45da-b7b6-27e523b8702a' },
    extension: { v: 'Not sure', note: 'None of Microsoft’s Authenticator pages we read mention one.', src: 'https://support.microsoft.com/en-us/account-billing/about-microsoft-authenticator-9783c865-0308-42fb-a519-8cf666fe0acc' },
    price: { v: 'Free', src: 'https://support.microsoft.com/en-us/account-billing/about-microsoft-authenticator-9783c865-0308-42fb-a519-8cf666fe0acc' },
    doesWell: [
      { t: 'Passwordless sign-in for Microsoft accounts: type your username, then approve with your face, fingerprint or PIN.', src: 'https://support.microsoft.com/en-us/account-billing/about-microsoft-authenticator-9783c865-0308-42fb-a519-8cf666fe0acc' },
      { t: 'Push approvals: a sign-in request pops up on your phone and you tap to approve it.', src: 'https://apps.apple.com/us/app/microsoft-authenticator/id983156458' },
    ],
    moving: 'We couldn’t find an export option in Microsoft’s documentation. The safe way to move is one account at a time: on each website, turn two-factor off and back on (or add a new authenticator app), and scan the new QR code with Tanooki Auth. Keep Microsoft Authenticator until every account works.',
  },
  {
    slug: '2fas',
    name: '2FAS',
    maker: '2FAS',
    site: 'https://2fas.com/',
    platforms: { v: 'iPhone and Android, plus Apple Watch', src: 'https://2fas.com/' },
    openSource: { v: 'Yes, GPL-3.0', src: 'https://github.com/twofas/2fas-android' },
    backup: { v: 'Yes. Optional iCloud or Google Drive backup, end-to-end encrypted, with an optional extra password you set.', src: 'https://2fas.com/support/2fas-auth-security-privacy/is-2fas-backup-safe/' },
    export: { v: 'Yes, a .2fas file, encrypted if you give it a password', src: 'https://2fas.com/support/2fas-auth-mobile-app/2fas-auth-app-tutorial/' },
    desktop: { v: 'No', src: 'https://2fas.com/auth/' },
    extension: { v: 'Yes: Chrome, Brave, Firefox, Edge, Opera and Safari. You approve each code on your phone.', src: 'https://2fas.com/auth/browser-extension/' },
    price: { v: 'Free', src: 'https://2fas.com/auth/' },
    doesWell: [
      { t: 'No account, phone number or email needed, and it works offline.', src: 'https://2fas.com/auth/' },
      { t: 'A browser extension for many browsers, end-to-end encrypted between your phone and the browser.', src: 'https://2fas.com/auth/browser-extension/' },
    ],
    moving: 'Tanooki Auth opens 2FAS backup files. In 2FAS, open Settings, then 2FAS Backup, and export to a file. Then in Tanooki Auth tap Add account, then Move from another app, and pick that file.',
  },
  {
    slug: 'aegis',
    name: 'Aegis',
    maker: 'Beem Development',
    site: 'https://getaegis.app/',
    platforms: { v: 'Android only. Its FAQ says there are no plans for iPhone, Windows or Mac versions.', src: 'https://github.com/beemdevelopment/Aegis/blob/master/FAQ.md' },
    openSource: { v: 'Yes, GPL-3.0', src: 'https://github.com/beemdevelopment/Aegis' },
    backup: { v: 'Yes. Automatic backups to a folder you choose, encrypted with your vault password. No built-in cloud.', src: 'https://github.com/beemdevelopment/Aegis/blob/master/FAQ.md' },
    export: { v: 'Yes, a JSON file, encrypted or plain', src: 'https://github.com/beemdevelopment/Aegis' },
    desktop: { v: 'No', src: 'https://github.com/beemdevelopment/Aegis/blob/master/FAQ.md' },
    extension: { v: 'No', src: 'https://github.com/beemdevelopment/Aegis/blob/master/FAQ.md' },
    price: { v: 'Free, no ads', src: 'https://getaegis.app/' },
    doesWell: [
      { t: 'An encrypted vault you unlock with a password or fingerprint, and the app never goes online.', src: 'https://github.com/beemdevelopment/Aegis' },
      { t: 'Imports from many other apps, including Google Authenticator, Authy, Microsoft Authenticator and 2FAS.', src: 'https://github.com/beemdevelopment/Aegis' },
    ],
    moving: 'Tanooki Auth opens Aegis export files, encrypted or not. In Aegis, open Settings, then Import & Export, and export as Aegis (.JSON). Then in Tanooki Auth tap Add account, then Move from another app, and pick that file.',
  },
];
