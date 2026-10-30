# Tanooki Auth — overnight feature plan (2026-10-29)

## Context
Maddie picked 46 of the 50 suggested features for an overnight build in `~/Downloads/tanooki-auth`
(Flutter app in `app/`, Chrome extension in `extension/`, Cloudflare Workers in `worker/` and `site/`).
Read `PLAN.md` status block first; it is the source of truth for what exists.
Skipped by Maddie: 5 (duplicate detection), 11 (big text), 20 (Siri), 25 (global hotkey).
She chose 35 (panic wipe) and 36 (decoy vault) against advice: build them, opt-in only, loud warnings.

Answers she gave:
- 29, 30 and 32: full version tonight. Relay on her Cloudflare account, phone notifications, and
  iCloud sync for Apple devices.
- 41: "pick a folder" auto-backup (point it at iCloud Drive / Google Drive / Dropbox folder).
- 50: family plan, $10 once, up to 5 people (second Stripe link + family license key).
- Output: commit and push to the public GitHub repo; release nothing (no TestFlight, no site downloads).
  Deploying the new relay Worker is allowed because 29/30/32 can't be tested without it.

Rules: Maddie writes no code. American English. TanookiStudios remote only (`git remote -v` before
every push). `flutter analyze` + `flutter test` clean after every edit. One commit per phase.
Never touch her real vault: tests use `--dart-define=TA_STORAGE=<name>` (see `app/lib/main.dart:20`).
Premium gating reuses `premium` ValueNotifier in `app/lib/ui/premium.dart`. Settings live in
`vault.settings` (pattern: `'lock'` in `app/lib/main.dart:125`).

Already done, only extend: 1 (Google Authenticator import in `core/google_migration.dart`),
7 (search in `ui/home.dart:149`), 33 (lock exists; add timer), 38 (clipboard clear in `ui/clipboard.dart`),
45 (themes in `ui/theme.dart`), 47 (Auto theme follows system).

## Phases (do all, in order; each ends committed and pushed)

### A. Data model + list basics (free)
Extend `core/account.dart` with optional fields, defaulted so old vaults load: `favorite`, `tags`,
`notes`, `recoveryCodes`, `lastUsedAt`, `iconDomain`, `deletedAt`. Round-trip test with an old vault JSON.
- 8 favorites pinned top. 13 recently used floats up (Settings toggle, default off).
- 9 show next code when under 5 s left. 10 copy toast (exists; confirm on all platforms).
- 12 hide codes until tapped (Settings toggle). 14 tags + filter chips. 15 notes. 16 recovery codes
  (tap-to-copy, marks one used). 44 trash: soft delete, restore, purge after 30 days.
- 48 compact/roomy layout toggle. 6 issuer logos: bundled icon set for top ~200 sites by domain,
  letter avatar fallback; no network fetch.

### B. Getting accounts in (free)
- 1 importers: Authy (desktop export JSON), Aegis (plain + encrypted JSON), 2FAS (.2fas),
  Microsoft Authenticator (not exportable: show how-to), 1Password/Bitwarden (CSV/JSON otpauth columns).
  Each gets a fixture file in `test/fixtures/` and a parser test.
- 2 scan QR from photo library on phones (reuse `core/qr_image.dart`).
- 3 "Scan my screen" button on Mac/Windows (no hotkey): Mac screen capture permission, Windows
  GDI capture, then reuse `qr_image.dart`.
- 4 paste many otpauth links at once; report "added X, skipped Y bad lines".

### C. Security (mostly free)
- 33 auto-lock timer (immediately/30 s/1 min/5 min). 34 separate app passcode (Argon2id hash in vault).
- 35 panic wipe after N wrong passcodes, opt-in, two warnings, requires a backup first.
- 36 decoy vault: second passcode opens a separate empty vault file; no UI hint it exists.
- 37 block screenshots: `FLAG_SECURE` Android, secure-field trick iOS, `sharingType = none` macOS,
  `SetWindowDisplayAffinity` Windows. Settings toggle, default on for phones.
- 39 security check-up screen (no recovery codes, no backup in 30 days, lock off).
- 40 breach alerts (Premium): opt-in fetch of the public HIBP breaches list (no key, no account data
  sent), match by saved domain. Only network call outside sync; say so in Settings and privacy page.
- 42 printable paper backup: PDF of QR codes + recovery codes, behind confirmation.
- 43 recovery-kit walkthrough on first run (backup, recovery codes, print).

### D. Platform extras
- 17 home widgets, 19 iOS lock-screen widget, 21 iOS Control Center control, 22 Android quick
  settings tile, 23 haptics on copy. Widgets compute codes natively (Swift/Kotlin TOTP, tested
  against RFC vectors) from favorites shared via App Group keychain / Android encrypted prefs.
  Widgets show codes only when the device is unlocked.
- 18 Apple Watch app (SwiftUI, WatchConnectivity) and Wear OS app (Data Layer). Favorites only.
- 24 Mac menu bar + Windows tray (`tray_manager`): search, click to copy.
- 26 auto-type into focused box: Mac via Accessibility keystroke, Windows `SendInput`.
- 27 Raycast extension + Alfred workflow in `integrations/`, talking to the existing bridge
  (`app/lib/bridge/server.dart`) with its pairing flow.
App Group / watch / widget bundle IDs registered via the App Store Connect API key already used by
`scripts/release-ios.sh`.

### E. Browser extension
- 28 Firefox (manifest tweaks, `browser_specific_settings`), Edge (same zip), Safari
  (`xcrun safari-web-extension-converter` into an Xcode wrapper). Run `extension/test/e2e.cjs`
  in Chromium, Firefox and Edge.
- 31 lookalike warning: compare page host to saved domains (edit distance, homoglyphs, punycode);
  banner, never fill.

### F. Relay, phone link and sync (Premium)
New Worker `relay/` on her Cloudflare account (Durable Objects, SQLite). Server only ever sees
encrypted blobs and opaque device IDs.
- 32 sync: vault entries encrypted with a sync key derived from a sync passphrase (Argon2id),
  per-account last-writer-wins merge with tombstones (reuse 44's `deletedAt`). Transports:
  iCloud Drive ubiquity container on Apple devices, relay for Android/Windows and mixed setups.
  Merge logic is pure Dart with heavy tests (offline edits on two devices, delete vs edit).
- 29 extension uses the paired phone when no desktop app: extension ↔ relay ↔ phone, end-to-end
  encrypted with X25519 keys exchanged at pairing (QR shown in extension popup).
- 30 approve on phone: fill request → push notification → Approve/Deny → code returned.
  APNs for iPhone, FCM for Android. Until push keys exist, it works only with the app open.
- Deploy relay with wrangler; `relay/test.mjs` hits the deployed URL end to end.

### G. Sharing, family, looks (Premium)
- 49 share one account: encrypted share QR/file with a 6-digit one-time code; receiver imports.
  No server.
- 50 family plan: second Stripe Payment Link ($10, created via Stripe API with the restricted
  key if it has rights, else morning task), `worker/` issues family keys (license payload
  `seats: 5`), Premium screen shows both options. Turn on Family Sharing note for future iOS IAP.
- 45 more Premium themes (keep Pastel Pink and Pastel Blue first). 46 alternate app icons
  (iOS `setAlternateIconName`, Android activity-alias); Mac/Windows icon not switchable, say so.
- Update `PremiumScreen` perks list, `store/` copy and site feature list (site not deployed).

## Morning list for Maddie (things only her accounts can do)
Each explained click by click in the final report, with why it's her:
1. Apple: create an APNs key and an iCloud container if the API couldn't (developer portal login).
2. Google: Firebase project for Android push (her Google login).
3. Stripe: family $10 link if the restricted key lacked rights.
4. Firefox Add-ons / Edge Add-ons / Safari publishing: not tonight.

## Verification
- `flutter test` (new: model round-trip, importers with fixtures, merge, passcode, panic wipe,
  decoy, share round-trip, license seats) and native widget TOTP vs RFC 6238 vectors.
  Break one TOTP/merge rule on purpose once to prove the tests go red.
- Integration tests on iPhone simulator, Android emulator, Mac, Windows (GitHub Actions workflow).
- Watch simulator and Wear OS emulator show a favorite's code matching the phone.
- Extension e2e in Chromium, Firefox, Edge incl. lookalike negative.
- Relay: two simulator devices sync an add, an edit and a delete; extension gets a code via phone.
- Real-device checks (iPhone, Android phone, push approval) go on the morning list, not claimed.
- Update `PLAN.md` status block: what's done, what's verified how, what's waiting on Maddie.
