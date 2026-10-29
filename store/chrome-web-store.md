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
• Your setup keys never enter the browser. The extension talks only to the Tanooki Auth app on your own computer and receives one current code at a time.
• No account, no ads, no analytics, no tracking.

Requires the Tanooki Auth desktop app, running on the same computer.

## Single purpose
Fill two-factor (TOTP) codes from the user's Tanooki Auth desktop app into login pages, and add accounts from two-factor setup QR codes.

## Permission justifications
- **Host permission (all sites):** login pages and two-factor setup pages can be on any website, so the extension must be able to look for a code box or setup QR code on whatever site the user is on. It only reads pages to find those; nothing is collected or sent anywhere.
- **storage:** keeps the pairing token that lets the extension talk to the user's own desktop app.
- **Remote code:** none. All code ships in the package.
- **Network:** only 127.0.0.1 (the user's own computer), ports 41984–41993.

## Data usage disclosures
Collects nothing. Tick none of the data categories. Certify: not sold, not used for unrelated purposes, not used for creditworthiness.
