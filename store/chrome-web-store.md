# Chrome Web Store listing — Tanooki Auth

Upload: `dist/Tanooki-Auth-0.1.0-extension.zip`
Privacy policy URL: https://tanooki-auth-premium.kirbymail.workers.dev/privacy
Category: Productivity · Language: English (United States)

## Short description (132 chars max)
Fills your two-factor codes from the Tanooki Auth desktop app — only on the exact website each account belongs to.

## Description
Tanooki Auth fills six-digit two-factor codes for you, straight from the free Tanooki Auth app on your Mac or Windows PC.

• Opens a login that asks for a code? It's filled in for you — but only on the website that account was saved for, so lookalike phishing sites get nothing.
• Setting up two-factor on a new site? Click "Add to Tanooki Auth" next to the QR code, or "Scan page for QR code" in the popup.
• Your setup keys never enter the browser. The extension talks only to the Tanooki Auth app on your own computer (or your linked phone) and receives one current code at a time.
• No account, no ads, no analytics, no tracking.

Optional Tanooki Auth Premium ($5 once, or $10 once for a family of up to 5 people — never a subscription):
• Approve from your phone: on a computer without the app, the extension asks your phone, you tap Approve, and the code fills in. End-to-end encrypted; the relay in between sees only scrambled data.
• Sync your accounts across your devices, end-to-end encrypted.
• Breach alerts when a website you use is in a known data breach, checked on your device.
• Share one account securely with someone you trust, with a QR code and a 6-digit code.
• More themes and app icons.
• Family plan: one key unlocks Premium for up to 5 people.
Everything above the Premium list stays free.

Requires the Tanooki Auth app, on the same computer or (with Premium) on your phone.

## Single purpose
Fill two-factor (TOTP) codes from the user's Tanooki Auth desktop app into login pages, and add accounts from two-factor setup QR codes.

## Permission justifications
- **Host permission (all sites):** login pages and two-factor setup pages can be on any website, so the extension must be able to look for a code box or setup QR code on whatever site the user is on. It only reads pages to find those; nothing is collected or sent anywhere.
- **storage:** keeps the pairing token that lets the extension talk to the user's own desktop app.
- **Remote code:** none. All code ships in the package.
- **Network:** 127.0.0.1 (the user's own computer), ports 41984–41993; and, only if the user links their phone (Premium), the Tanooki relay at tanooki-auth-relay.kirbymail.workers.dev, which carries end-to-end encrypted messages it cannot read.

## Data usage disclosures
Collects nothing. Tick none of the data categories. Certify: not sold, not used for unrelated purposes, not used for creditworthiness.
