# Bridge changes needed for Raycast, Alfred and PowerToys

**PowerToys (added later):** the Command Palette extension in `powertoys/` uses the same protocol with the
Origin `tanooki-integration://powertoys`. Add it to `integrationOrigins`, name it `'PowerToys'` in
`bridgeClientName`, and title its pairing dialog "Pair with PowerToys" / "Type this code into PowerToys
Command Palette:" / "Only do this if you just started pairing in PowerToys yourself." Until then the
extension says "Tanooki Auth is running but doesn't accept PowerToys yet. Update Tanooki Auth".

The Raycast extension and Alfred workflow in this folder speak the bridge protocol in
`app/lib/bridge/server.dart` unchanged (same ports, `ping`/`pair`/`accounts`/`codes`/`code`,
token per Origin). The app only needs to let them in and name them properly.

## 1. Accept two more Origins

Each integration sends a fixed Origin header:

| Integration | Origin header                     | Keychain item (service / account)   |
|-------------|-----------------------------------|-------------------------------------|
| Raycast     | `tanooki-integration://raycast`   | `Tanooki Auth bridge` / `raycast`   |
| Alfred      | `tanooki-integration://alfred`    | `Tanooki Auth bridge` / `alfred`    |

In `BridgeServer._onRequest`, accept exactly these two strings **in addition to** the browser
extension Origins (someone is adding `moz-extension://` and `safari-web-extension://` there
right now, so add to that check rather than replacing it):

```dart
const integrationOrigins = {'tanooki-integration://raycast', 'tanooki-integration://alfred'};

// in _onRequest, before the existing Origin check:
final allowed = integrationOrigins.contains(origin) || /* existing extension-origin check */;
```

Exact match only: no prefix match, no case folding, nothing else under `tanooki-integration://`.

Keep the order the app has today: a refused Origin gets **403**, an accepted Origin that isn't a
WebSocket upgrade gets **400**. The integrations probe each port with a plain HTTP request and use
that difference to tell "Tanooki Auth isn't running" apart from "Tanooki Auth is running but too
old to accept Raycast/Alfred — update it".

Why this is safe: a web page can't set its Origin to a custom scheme, so the Origin check still
keeps websites out, which is its only job. Any program on the Mac could already fake a
`chrome-extension://` Origin; the real gate is the 6-digit pairing code the user reads off the
app's screen, and the 32-byte token after that. Nothing about that changes.

## 2. Label the pairing dialog

`showPairingCode(code, origin)` in `app/lib/main.dart` always says "Pair with your browser" and
"Type this code into the Tanooki Auth browser extension". For the new Origins it should say:

| Origin                           | Dialog title             | Body line                                         | Warning line                                                     |
|----------------------------------|--------------------------|---------------------------------------------------|------------------------------------------------------------------|
| `tanooki-integration://raycast`  | Pair with Raycast        | Type this code into Raycast:                      | Only do this if you just started pairing in Raycast yourself.    |
| `tanooki-integration://alfred`   | Pair with Alfred         | Type `2fa-pair` and this code into Alfred:        | Only do this if you just typed 2fa-pair in Alfred yourself.      |
| anything else (extensions)       | unchanged                | unchanged                                         | unchanged                                                        |

A shared helper keeps the dialog and Settings in step:

```dart
String bridgeClientName(String origin) => switch (origin) {
      'tanooki-integration://raycast' => 'Raycast',
      'tanooki-integration://alfred' => 'Alfred',
      _ => 'Browser extension',
    };
```

## 3. Label them in Settings

`_browserSection()` in `app/lib/ui/settings.dart` lists every pairing as "Paired browser /
Extension <last 8 chars>". For the new Origins show the title `Paired: Raycast` / `Paired: Alfred`
with no subtitle (the last 8 characters of the Origin mean nothing there). Unpair works as is,
since pairings are stored per Origin. Consider renaming the section from "Browser extension" to
"Browser extension and launchers".

## 4. Optional: neutral "not paired" wording

The bridge's `notPaired` message says "This browser isn't paired with Tanooki Auth." Both
integrations replace it with their own wording ("Raycast isn't paired…"), so this is cosmetic,
but "This app isn't paired with Tanooki Auth." would read right for every client.

## 5. Tests to add in `app/test/bridge_test.dart`

- `tanooki-integration://raycast` and `tanooki-integration://alfred` can pair and list accounts.
- `tanooki-integration://evil`, `tanooki-integration://raycast.evil`, `Tanooki-Integration://raycast`
  and `tanooki-integration://raycast/` are refused.
- Raycast's token doesn't work from the Alfred Origin (pairings are per Origin).

## What the integrations already do (no app change needed)

- Rate limit: Alfred re-runs once a second while open (one `accounts` + one `codes` request),
  well under 5 code requests per second.
- HOTP: listing never spends a counter code; one is made only when the user copies or pastes.
- When the app answers `notPaired` (for example after Unpair), the integration deletes its
  keychain token and shows the pairing prompt again.

## Checking it end to end once applied

Integration tests (`node --test integrations/test/integrations.test.mjs`) run against a fake
bridge already following rule 1. To check the real app: open Tanooki Auth, type `2fa` in Alfred.
"Pair Alfred with Tanooki Auth" means the Origin is accepted; "doesn't accept Alfred yet" means it
is still refused (403).
