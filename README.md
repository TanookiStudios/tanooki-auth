# Tanooki Auth

A free two-factor authenticator for Mac, Windows and Android (iPhone and iPad coming), with a browser
extension that fills codes in for you. Your codes stay on your own devices, encrypted.

Download: **https://auth.tanookistudios.com**

## The privacy promise, and where to check it

| Promise | Where it lives in the code |
| --- | --- |
| No account. There is nothing to sign up for. | The app has no login and no server of ours to talk to. |
| Nothing leaves your device. Codes sit in one file, locked with AES-256-GCM; the key is in the system's secure storage (Keychain, DPAPI, Android Keystore). | `app/lib/core/vault.dart` |
| No ads, no analytics. | `app/pubspec.yaml` lists every dependency; none of them is a tracking or ads SDK. |
| Works offline. Codes come from the device clock (RFC 6238 / RFC 4226). | `app/lib/core/totp.dart` |
| One automatic network call: a clock check. At most once an hour while codes are on screen, and when you tap "Codes not working?", the app asks the Tanooki Auth relay's `/health` for the time, to warn you if your device clock is off (codes fail when it is). Nothing about you or your accounts is sent. Everything else that goes online (breach alerts, sync, phone link, emergency access, buying Premium) only happens if you turn it on, and sync, phone link and emergency access carry only encrypted data the server can't read. | `app/lib/core/clock_check.dart`, `relay/src/index.js` |
| The browser extension talks only to the app on the same computer, over a local connection you pair once with a 6-digit code, and fills a code only on the exact site it is saved for. | `app/lib/bridge/server.dart`, `extension/sw.js`, `extension/content.js` |
| Backups are encrypted with a password only you know (PBKDF2-SHA256, 600,000 rounds, then AES-256-GCM). | `app/lib/core/backup.dart` |

## What's here

- `app/`: the Flutter app for Mac, Windows, Android, iPhone and iPad.
- `extension/`: the Manifest V3 browser extension for Chrome, Brave and Edge.
- `worker/`: the small Cloudflare Worker that turns a paid Premium checkout into a license key.
- `site/`: the website at auth.tanookistudios.com.
- `scripts/`, `windows-installer/`: release builds.

## Build it yourself

You need Flutter 3.47 or newer.

```bash
cd app
flutter pub get
flutter test
flutter run -d macos   # or windows, or an Android device
```

The extension loads unpacked from the `extension/` folder (`chrome://extensions`, Developer mode, Load unpacked).
Its end-to-end test runs with `node extension/test/e2e.cjs` (it needs Playwright).

Release signing keys and store credentials are not in this repo and never will be.

## Premium

Everything is free except extra themes. Premium is $5 once and helps pay for this work. If you build
the app yourself, you can remove the check, and that's your right under the license. If it's useful
to you, please consider buying Premium or [donating to Tanooki Studios](https://tanookistudios.com/SupportMe).

## Reporting a security problem

Please report it privately with the **Security** tab of this repository ("Report a vulnerability"),
not as a public issue.

## License

GPL-3.0. See `LICENSE`. The Tanooki Auth name and the shield icon are not covered by the license;
please use your own if you ship a fork. `extension/jsqr.js` is jsQR, Apache-2.0 (see `extension/jsqr.LICENSE`).
