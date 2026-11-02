# Chrome Web Store listing: Tanooki Auth

Ready to submit, not submitted. Build the package with `bash extension/build.sh`.

- **Upload:** `dist/Tanooki-Auth-0.1.0-chrome.zip`
- **Images:** `store/images/` (regenerate with `NODE_PATH="$(npm root -g)" node store/make-images.cjs`)
  - Screenshots (1280 × 800): `screenshot-1-fill.png`, `screenshot-2-accounts.png`, `screenshot-3-add.png`, `screenshot-4-themes.png`
  - Small promo tile (440 × 280): `promo-tile-440x280.png`
  - Store icon (128 × 128): `extension/icons/icon128.png`
- **Category:** Privacy & Security
- **Language:** English (United States). The package also carries German, Spanish, French and Japanese text.
- **Homepage URL:** https://auth.tanookistudios.com/
- **Support URL:** https://tanookistudios.com/support
- **Privacy policy URL:** https://tanooki-auth-premium.kirbymail.workers.dev/privacy

## Name
Tanooki Auth

(Comes from the package, `extName` in `extension/_locales/en/messages.json`.)

## Summary (132 characters max)
Comes from the package (`extDescription`), 121 characters:

Fills two-factor codes from the Tanooki Auth desktop app, or from your phone, only on the website each account belongs to.

## Description
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

## Privacy practices tab

### Single purpose
Fill two-factor (TOTP) codes from the user's Tanooki Auth app into login pages, and add accounts from two-factor setup QR codes.

### Permission justifications
One for every permission in `manifest.json`:

- **storage:** Keeps the pairing token that lets the extension talk to the user's own Tanooki Auth desktop app, and, if the user links their phone, the phone link's keys. Stored only in the browser on this computer.
- **contextMenus:** Adds one right-click menu item, "Add to Tanooki Auth", on images, so the user can add an account from a two-factor setup QR code.
- **Host permission (`<all_urls>`), and the content script on all http and https pages:** Login pages and two-factor setup pages can be on any website, so the extension must be able to find a code box or a setup QR code on whichever site the user is on. It reads pages only to find those, and fills a code only on the site the account was saved for. Nothing from the page is collected or sent to us.

### Are you using remote code?
No, I am not using remote code. All code ships in the package. The two bundled libraries are readable, unminified copies: jsQR 1.4.0 (Apache-2.0, reads QR codes; identical to the npm release's dist/jsQR.js) and qrcode-generator 1.4.4 (MIT, draws QR codes).

### Data usage
What user data do you plan to collect: **tick none of the boxes.**

Why that's accurate: the extension sends the current site's address to the Tanooki Auth app on the same computer (127.0.0.1, ports 41984–41993) so the app can pick the right code. That never leaves the user's computer. If the user links their phone (Premium), the request goes through the Tanooki relay (tanooki-auth-relay.kirbymail.workers.dev) end-to-end encrypted, so the relay can't read it, and it's deleted once delivered.

Tick all three certifications:
- I do not sell or transfer user data to third parties, outside of the approved use cases.
- I do not use or transfer user data for purposes that are unrelated to my item's single purpose.
- I do not use or transfer user data to determine creditworthiness or for lending purposes.

## Test instructions for the reviewer
The extension needs the free Tanooki Auth desktop app to show codes. Install it from https://auth.tanookistudios.com (Mac or Windows), open it and add any account. Then click the extension icon and click Pair: the app shows a 6-digit code, and you type it into the extension's popup. After that, any login page for that account's website gets its code filled in. Without the app, the popup says "Tanooki Auth isn't running."
