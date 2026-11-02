# Firefox Add-ons (addons.mozilla.org) listing: Tanooki Auth

Ready to submit, not submitted. Build the package with `bash extension/build.sh`.
Submitting needs a free Firefox account at https://addons.mozilla.org/developers/

- **Upload:** `dist/Tanooki-Auth-0.1.0-firefox.zip`
- **Where to list it:** On this site (public listing).
- **Platforms:** tick Windows, Mac and Linux; leave Android unticked. On Windows and Mac it talks to the Tanooki Auth app on the same computer. There's no Linux app, so on Linux it only works through a linked phone (Premium).
- **Add-on ID:** `auth@tanookistudios.com` (from the package). Needs Firefox 142 or newer.
- **Validated:** `npx web-ext lint` on the unzipped package reports 0 errors, 0 notices, 0 warnings (checked November 2, 2026).
- **Source code:** not required. Our own code is hand-written and unminified. The only generated file is `jsqr.js`, which is byte-for-byte the official `dist/jsQR.js` from the npm package jsqr 1.4.0 (checked with `cmp`). The full source is public at https://github.com/TanookiStudios/tanooki-auth

## Describe add-on
- **Name:** Tanooki Auth
- **Add-on URL:** https://addons.mozilla.org/firefox/addon/tanooki-auth/
- **Summary (250 characters max):**
  Fills two-factor codes from the Tanooki Auth desktop app, or from your phone, only on the website each account belongs to. Your setup keys never enter the browser. No account, no ads, no tracking.
- **Categories (up to two):** Privacy & Security
- **Support email:** leave blank or use your support address
- **Support website:** https://tanookistudios.com/support
- **Homepage:** https://auth.tanookistudios.com/
- **License:** GNU General Public License v3.0
- **Privacy policy:** tick "This add-on has a privacy policy" and paste the text from https://tanooki-auth-premium.kirbymail.workers.dev/privacy (AMO wants the full text, not a link).
- **Tags:** two-factor, 2fa, authenticator, security, otp

### Description
Tanooki Auth fills six-digit two-factor codes for you, straight from the free Tanooki Auth app on your Mac or Windows PC.

• Opens a login that asks for a code? It's filled in for you, but only on the website that account was saved for, so lookalike phishing sites get nothing.
• Setting up two-factor on a new site? Right-click the QR code and pick "Add to Tanooki Auth", or click "Scan page for QR code" in the popup.
• Your setup keys never enter the browser. The extension talks only to the Tanooki Auth app on your own computer (or your linked phone) and receives one current code at a time.
• No account, no ads, no analytics, no tracking.

Optional Tanooki Auth Premium ($5 once, or $10 once for a family of up to 5 people, never a subscription):
• Approve from your phone: on a computer without the app, the extension asks your phone, you tap Approve, and the code fills in. End-to-end encrypted; the relay in between sees only scrambled data.
• Sync your accounts across your devices, end-to-end encrypted.
• Breach alerts when a website you use is in a known data breach, checked on your device.
• Share one account securely with someone you trust, with a QR code and a 6-digit code.
• More themes and app icons.
• Family plan: one key unlocks Premium for up to 5 people.
Everything above the Premium list stays free.

Requires the Tanooki Auth app, on the same computer or (with Premium) on your phone. Get it at https://auth.tanookistudios.com

Open source (GPL-3.0): https://github.com/TanookiStudios/tanooki-auth

## Data collection (asked during upload)
The package declares `data_collection_permissions: none`, which matches what the extension does.
Why that's accurate: the extension sends the current site's address to the Tanooki Auth app on the same computer (127.0.0.1, ports 41984–41993) so the app can pick the right code. That never leaves the user's computer. If the user links their phone (Premium), the request goes through the Tanooki relay (tanooki-auth-relay.kirbymail.workers.dev) end-to-end encrypted, so the relay can't read it, and it's deleted once delivered.

## Permissions shown to users, and why
- **storage:** Keeps the pairing token that lets the extension talk to the user's own Tanooki Auth desktop app, and, if the user links their phone, the phone link's keys. Stored only in the browser on this computer.
- **contextMenus:** Adds one right-click menu item, "Add to Tanooki Auth", on images, so the user can add an account from a two-factor setup QR code.
- **Host permission (`<all_urls>`), and the content script on all http and https pages:** Login pages and two-factor setup pages can be on any website, so the extension must be able to find a code box or a setup QR code on whichever site the user is on. It reads pages only to find those, and fills a code only on the site the account was saved for. Nothing from the page is collected or sent to us.

## Images
- **Icon:** comes from the package (`icons/icon48.png` and up).
- **Screenshots** (1280 × 800 recommended): the four `store/images/screenshot-*.png` files. Suggested captions:
  1. Codes filled in for you, only on the right website.
  2. Your codes stay on your device.
  3. Add an account from its QR code.
  4. Free, with optional Premium themes.

## Notes to reviewer
The extension needs the free Tanooki Auth desktop app to show codes. Install it from https://auth.tanookistudios.com (Mac or Windows), open it and add any account. Then click the extension icon and click Pair: the app shows a 6-digit code, and you type it into the extension's popup. After that, any login page for that account's website gets its code filled in. Without the app, the popup says "Tanooki Auth isn't running."
The bundled libraries are jsQR 1.4.0 (Apache-2.0, https://github.com/cozmo/jsQR, identical to the npm package's dist/jsQR.js) and qrcode-generator 1.4.4 (MIT, https://github.com/kazuhikoarase/qrcode-generator), unmodified.
