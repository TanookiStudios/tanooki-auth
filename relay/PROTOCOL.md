# Tanooki Auth relay protocol, version 1

Base URL: `https://tanooki-auth-relay.kirbymail.workers.dev` (Cloudflare Worker `tanooki-auth-relay`, source in `relay/src/`).
End-to-end test with working client crypto for every flow below: `node relay/test.mjs <base-url>`. When this
document and `test.mjs` disagree, `test.mjs` is what was actually run against the server.

The relay is untrusted. It only ever sees random IDs, public keys, and ciphertext. All encryption,
decryption, merging and key derivation happen on the clients. Nothing here may carry a TOTP secret,
an account name, or a site name in the clear.

## 0. Common rules

- **Encoding.** Every binary value on the wire (IDs, keys, signatures, nonces, ciphertext) is
  **base64url without padding** (RFC 4648 section 5, `A-Z a-z 0-9 - _`, no `=`).
- **IDs.** Sync group IDs and link room IDs are exactly 32 bytes = 43 base64url characters. Anything else is 404.
- **Bodies** are JSON objects (`content-type: application/json`), at most **1 MiB**. An empty body counts as `{}`.
- **Errors** are `{"error": "<plain sentence>", ...}` with a meaningful status. One message per failure mode;
  clients may show `error` to the user. Statuses used: 400 malformed input, 401 authentication failed,
  403 authenticated but not allowed, 404 not found, 409 state conflict, 410 pairing window closed,
  413 too large, 426 WebSocket upgrade expected, 429 rate limit, 503 push not configured, 507 group full.
- **CORS** is open (`access-control-allow-origin: *`); no cookies are used anywhere.
- **Rate limits.**
  - Per client IP: 300 requests / 60 s (Cloudflare rate-limit binding; approximate, enforced per data center). Over: 429.
  - Per sync group: 600 requests / 60 s. Per link room: 120 requests / 60 s. Over: 429.
  - On 429 back off (start at 2 s, double, cap 60 s).
- `GET /` returns `{"service":"tanooki-auth-relay","protocol":1}`.
- `GET /health` returns `{"ok":true,"service":"tanooki-auth-relay","time":"<ISO 8601>"}` with CORS `*`, for the
  status page. It is answered before the per-IP limit and touches no Durable Object.

## 1. Sync store (feature 32)

### 1.1 Client-side keys (the relay never sees these)

| Name | How the client gets it |
|---|---|
| `root` | 32-byte sync root key. Recommended: `Argon2id(passphrase, salt, m=64 MiB, t=3, p=1, len=32)` with a 16-byte random `salt` created by the first device. The salt travels to new devices inside the invite QR (section 1.4), **never** through the relay, so the relay cannot brute-force the passphrase. |
| `groupId` | `HKDF-SHA256(ikm=root, salt=empty, info="TA-SYNC-GROUP-ID-1", L=32)`, base64url. A new device recomputes it from the typed passphrase and compares with the invite's `groupId`: a mismatch means a wrong passphrase. |
| `recordKey` | `HKDF-SHA256(ikm=root, salt=empty, info="TA-SYNC-RECORD-KEY-1", L=32)`. AES-256-GCM key. |
| `recordId` | `HKDF-SHA256(ikm=root, salt=UTF8(accountUuid), info="TA-SYNC-RECORD-ID-1", L=32)`, base64url (43 chars). Stable per account, unlinkable without `root`. |
| device key | An **Ed25519** key pair made on each device and kept in its keychain. Public key = raw 32 bytes, base64url. This is the device's identity in the group. |

`HKDF` is RFC 5869 with SHA-256; "salt=empty" means a zero-length salt.

### 1.2 Record encryption

```
plaintext  = UTF8(JSON of the account, including the client's updatedAt / deletedAt for merging)
nonce      = 12 random bytes
aad        = UTF8("TA-SYNC-1|" + groupId + "|" + recordId)
ciphertext = base64url(nonce || AES-256-GCM(recordKey, nonce, plaintext, aad))   // tag (16 bytes) at the end
```

The AAD binds a record to its ID and group, so the relay cannot swap records around. Decryption failure
means "tampered or wrong key": skip that record and report it; never treat it as a delete.

### 1.3 Signed requests

Every sync request except the WebSocket carries four headers:

| Header | Value |
|---|---|
| `x-ta-device` | device public key (43 chars) |
| `x-ta-timestamp` | current time, Unix **milliseconds**, integer |
| `x-ta-nonce` | 16 random bytes, base64url (16 to 64 chars accepted) |
| `x-ta-signature` | Ed25519 signature (64 bytes, base64url) over the string below |

```
TA-RELAY-1\n<METHOD>\n<PATH>\n<TIMESTAMP>\n<NONCE>\n<BODYHASH>
```

- `\n` is a single line feed (0x0A). No trailing newline.
- `METHOD` uppercase (`GET`, `POST`, `DELETE`).
- `PATH` is the request path **plus the query string exactly as sent**, e.g. `/v1/sync/<groupId>/changes?since=12`.
- `TIMESTAMP` and `NONCE` exactly as in the headers.
- `BODYHASH` = base64url(SHA-256(the exact body bytes sent)). For no body, the hash of zero bytes
  (`47DEQpj8HBSa-_TImW-5JCeuQeRkm5NMpJWZG3hSuFU`).

The server rejects (401):
- `missing or malformed signature headers`
- `timestamp outside the allowed 5 minute window` (response includes `serverTime`; clients may retry once with the clock offset)
- `bad signature` (any change to method, path, query, timestamp, nonce or body breaks it)
- `replayed request (nonce already used)` (nonces are remembered per group for timestamp + 6 minutes)

Then 404 `sync group not found` if the group does not exist, or 403 `device is not in this sync group`.

### 1.4 Group lifecycle

**Create** — `POST /v1/sync/<groupId>/create`, signed by the first device, body `{}`.
→ `201 {"ok":true,"cursor":0}`; `409 sync group already exists`.

**Invite** (offline, no server call). An existing member signs:

```
TA-INVITE-1\n<groupId>\n<inviteNonce>\n<expiresAt>
```

with `inviteNonce` = 16 random bytes base64url and `expiresAt` = Unix ms, at most 24 hours ahead.
The invite object is `{"inviter": <member public key>, "nonce": inviteNonce, "expiresAt": expiresAt, "sig": <signature>}`.
The inviting device shows it as a QR together with the relay URL, `groupId` and the Argon2id `salt`, e.g.
`tanookiauth://sync?v=1&relay=<url-encoded base>&group=<groupId>&salt=<b64u>&invite=<b64u(JSON of invite)>`.
The QR never goes to the relay. The passphrase is typed on the new device, so a photo of the QR alone
cannot decrypt anything.

**Join** — `POST /v1/sync/<groupId>/join`, signed by the **new** device's key, body `{"invite": {...}}`.
→ `201 {"ok":true,"cursor":<current cursor>}`. Refusals: `400 invite is malformed`,
`403 invite was signed by a device that is not in this group`, `403 invite signature is not valid`,
`403 invite has expired`, `403 invite lifetime is longer than 24 hours`, `403 invite was already used`
(each invite works once), `409 device is already in this group`, `507 device limit reached (20 per group)`.
After joining, the new device pulls everything with `changes?since=0`.

**List devices** — `GET /v1/sync/<groupId>/devices` → `{"devices":[{"key":"...","added":<ms>}]}`.

**Remove a device** (lost phone) — `DELETE /v1/sync/<groupId>/devices/<deviceKey>`, any member may remove any
member including itself. Its WebSockets are closed with code 4001. Removing the last device deletes the group.
Note: a removed device still knows `root`; to lock it out of future data the remaining devices must move to a
new passphrase (new group). Removal only stops it talking to the relay.

**Delete group** — `DELETE /v1/sync/<groupId>` → `{"ok":true}`. Everything is erased; sockets closed with 4002.

### 1.5 Records

Server-side record shape (all the server knows):

```json
{"id":"<recordId>","version":3,"deleted":false,"updatedAt":1793322371412,"ciphertext":"<b64u>","seq":17}
```

- `version`: per-record counter, starts at 1, +1 on every accepted write. Used only for optimistic concurrency.
- `deleted`: tombstone flag. A tombstone still carries a ciphertext (recommended: encrypted `{"deletedAt":...}`).
- `updatedAt`: server time of the last write (ms). Merge on the client's own encrypted timestamps, not this.
- `seq`: group-wide change number. The group's `cursor` is the highest `seq`.

**Push (create, edit, delete)** — `POST /v1/sync/<groupId>/push`

```json
{"records":[{"id":"<recordId>","baseVersion":0,"deleted":false,"ciphertext":"<b64u>"}]}
```

- 1 to 100 records per call; each `id` once per call; `id` is 1 to 64 base64url characters.
- `baseVersion` = the version this client last saw (0 for a record it believes is new).
- `ciphertext` required (non-empty) unless `deleted` is true; at most 65,536 characters.
- At most **2,000 records per group, tombstones included** (`507 record limit reached`, with `count`).

Response `200`:

```json
{"results":[
  {"id":"...","status":"ok","version":1,"seq":5},
  {"id":"...","status":"conflict","current":{<record>}}   // current is null if the record does not exist
],"cursor":5}
```

A conflict means someone else wrote first: decrypt `current`, merge (last-writer-wins on the encrypted
`updatedAt`/`deletedAt`), then push again with `baseVersion = current.version`. Records in one call are
independent; some can succeed while others conflict.

**Get one** — `GET /v1/sync/<groupId>/records/<recordId>` → the record, or `404 no such record`.

**Changes since cursor** — `GET /v1/sync/<groupId>/changes?since=<cursor>&limit=<1..500>`
→ `{"records":[...ordered by seq...],"cursor":<seq of last record returned, or since>,"more":<bool>}`.
Each record appears once, at its latest version. Loop while `more` is true. Store `cursor` only after
the page is merged and saved locally.

### 1.6 Change notifications (WebSocket)

`GET wss://<host>/v1/sync/<groupId>/ws?device=<pub>&ts=<ms>&nonce=<nonce>&sig=<sig>`

The signature is the normal request signature with `METHOD=GET`, `PATH=/v1/sync/<groupId>/ws` (**without** the
query string, since the query carries the signature) and the empty-body hash. Nonce and timestamp rules are the same.

Server → client messages (JSON text):
- `{"type":"hello","cursor":N}` right after connecting.
- `{"type":"changed","cursor":N}` after any successful push by any device (including your own).

On `changed`, call `changes?since=<your cursor>`. The client may send the text `ping` and gets `pong`
(use every 30 s to keep the socket alive). Nothing else is accepted from clients. Close codes: 4001 device
removed, 4002 group deleted. If the socket drops, reconnect with a fresh signature and pull changes; polling
`changes` every few minutes is a valid fallback. At most 50 sockets per group.

## 2. Phone link (features 29, 30)

A room is a mailbox between one extension and one phone. The relay authenticates each side with a random
bearer token it issued, and stores only SHA-256 hashes of the tokens (compared in constant time).

### 2.1 Pairing

1. **Extension** makes `roomId` (32 random bytes), an **X25519** key pair (`extPub`, raw 32 bytes) and a
   `pairSecret` (32 random bytes).
2. `POST /v1/link/rooms/<roomId>/create`, body `{}` → `201 {"roomId":"...","extToken":"<43 chars>","pairBy":<ms>}`.
   `409 room already exists`. Keep `extToken` secret (extension storage).
3. Extension shows a QR:
   `tanookiauth://link?v=1&relay=<url-encoded base>&room=<roomId>&key=<extPub>&secret=<pairSecret>`.
   `pairSecret` is never sent to the relay.
4. **Phone** scans it, makes its own X25519 key pair (`phonePub`), and calls
   `POST /v1/link/rooms/<roomId>/join` with `{"phoneKey":"<phonePub>"}` → `201 {"roomId":"...","phoneToken":"..."}`.
   Refusals: `409 room is already paired` (one phone per room), `410 pairing window has closed; make a new QR code`
   (10 minutes after create; unpaired rooms are then erased), `404 room not found`.
5. The extension learns `phonePub` from the WebSocket event `{"type":"joined","phoneKey":"..."}` or from
   `GET /v1/link/rooms/<roomId>` (`phoneKey` field).
6. The phone immediately sends a `hello` message (2.4). The extension shows "Paired" only after it decrypts it;
   that proves both sides derived the same keys.

### 2.2 Keys

```
shared = X25519(myPrivate, peerPublic)                       // 32 bytes
okm    = HKDF-SHA256(ikm=shared, salt=pairSecret,
                     info=UTF8("TA-LINK-1|" + roomId + "|" + extPub + "|" + phonePub), L=64)
keyE2P = okm[0..32]    // extension -> phone
keyP2E = okm[32..64]   // phone -> extension
```

Because `pairSecret` only travels in the QR, a relay that swapped in its own public key still could not derive the keys.

### 2.3 Message encryption

```
nonce      = 12 random bytes
aad        = UTF8("TA-LINK-1|" + roomId + "|" + dir)       // dir = "e2p" or "p2e"
ciphertext = base64url(nonce || AES-256-GCM(key for dir, nonce, UTF8(JSON), aad))
```

### 2.4 Inner messages (inside the ciphertext; the relay never sees these)

Every message has `t` (type), `id` (16 random bytes, base64url) and `ts` (sender's Unix ms).
Receivers **must** drop a message whose `ts` is more than 120 s old or 30 s in the future, and drop an
`id` they have already seen in the last 5 minutes (replay protection against the relay).

| `t` | Direction | Fields |
|---|---|---|
| `hello` | phone → ext | `device` (display name, e.g. "Maddie's iPhone") |
| `fill-request` | ext → phone | `host` (page host, e.g. `github.com`), optional `accountHint` |
| `code` | phone → ext | `re` (the request `id`), `code` (digits), optional `expiresIn` (seconds left in the period); the app also sends `domain` (the account's saved domain that matched `host`) and `issuer`, and the extension fills only when the page is on `domain` |
| `deny` | phone → ext | `re` |

Flow: extension sends `fill-request` with `notify: true` → phone shows Approve / Deny for `host` → on Approve
it sends `code`, on Deny `deny`. The extension ignores a `code` whose `re` it did not ask for. The phone should
only offer accounts whose saved domain matches `host`.

### 2.5 Room endpoints

All except create and join need `authorization: Bearer <extToken or phoneToken>`; wrong or missing → `401 missing or wrong room token`.

**Status** — `GET /v1/link/rooms/<roomId>` → `{"paired":true,"phoneKey":"...","created":<ms>,"push":"apns"|"fcm"|null}`.

**Send** — `POST /v1/link/rooms/<roomId>/messages`, body `{"ciphertext":"<b64u>","ttl":120,"notify":false}`
- `ttl` seconds, 1 to 120, default 120. Messages are deleted when it runs out (never served after).
- `ciphertext` at most 16,384 characters. At most 50 unexpired messages per sender (`429`).
- `notify: true` (extension only) sends a push to the phone, see 2.6.
- `409 phone has not joined this room yet` before pairing.
- → `201 {"id":7,"expiresAt":<ms>,"push":"..."}` where `push` is one of `not-requested`, `no-token`,
  `not-configured`, `sent`, `token-dead` (token was dropped; phone must register again), `failed:<reason>`.
  A push failure never fails the send; the message is still delivered by WebSocket or polling.

**Receive (poll)** — `GET /v1/link/rooms/<roomId>/messages?after=<id>` → `{"messages":[{"id":7,"from":"ext","ciphertext":"...","expiresAt":<ms>}],"cursor":7}`.
Only the other side's unexpired messages, oldest first, up to 100. Pass the returned `cursor` next time.

**Acknowledge** — `DELETE /v1/link/rooms/<roomId>/messages/<id>` deletes a message the caller received
(recommended right after handling a `fill-request` or `code`).

**Unpair** — `DELETE /v1/link/rooms/<roomId>` (either side) erases the room. The other side's sockets get
`{"type":"unpaired"}` then close code 4002. To pair again, make a new room.

**WebSocket** — `GET wss://<host>/v1/link/rooms/<roomId>/ws`. The first client message must be
`{"type":"auth","token":"<extToken or phoneToken>"}` (the token never goes in the URL). Server replies
`{"type":"ready","role":"ext"|"phone","paired":bool}`; a wrong token closes with 4001. Server → client events:
- `{"type":"joined","phoneKey":"..."}` (extension only)
- `{"type":"message","message":{"id":..,"from":..,"ciphertext":..,"expiresAt":..}}` (messages from the other side)
- `{"type":"unpaired"}`
Text `ping` → `pong`. Close 4003: room never paired before the window closed. Max 10 sockets per room.
After a reconnect, poll `messages?after=<last id>` to catch anything missed.

### 2.6 Push (feature 30)

**Register** (phone only) — `POST /v1/link/rooms/<roomId>/push`, body
`{"platform":"apns"|"fcm","token":"<device token>","environment":"production"|"sandbox"}`
(`environment` matters for APNs only: debug builds from Xcode use `sandbox`, TestFlight/App Store use `production`).
- `503 {"error":"push not configured","platform":"apns"}` when the relay has no keys for that platform.
  The app should then rely on the WebSocket (works while the app is open) and say so in its UI.
- `403 only the phone registers a push token`; `400` for a bad platform, token or environment.
- Registering again replaces the token. Re-register whenever the OS hands the app a new token.

**What is sent.** The relay sends a fixed alert, with no room ID, site, code or account:
- APNs: `{"aps":{"alert":{"title":"Tanooki Auth","body":"Approve sign-in code request"},"sound":"default","category":"TA_FILL_REQUEST"}}`,
  topic `com.tanookistudios.auth`, push type `alert`, priority 10, expires after 120 s.
- FCM HTTP v1: `notification {title:"Tanooki Auth", body:"Approve sign-in code request"}`, `data {"type":"fill-request"}`,
  Android priority high, ttl 120 s.

When opened from the notification, the app connects (WebSocket or `GET messages`) and fetches the encrypted request itself.
The iOS app should register the notification category `TA_FILL_REQUEST`.

**Server secrets** (`npx wrangler secret put NAME` in `relay/`): `APNS_KEY` (full text of the `.p8` file),
`APNS_KEY_ID`, `APNS_TEAM_ID`, `FCM_SERVICE_ACCOUNT` (the whole service-account JSON). Checked from Cloudflare's
network with throwaway keys on 2026-10-29: Apple's push server and Google's token server both answer the relay
(rejecting the fake keys), so only real keys are missing. A real delivery has not been tested yet.

## 3. Emergency access (feature 26)

A person (the **owner**) leaves an encrypted copy of their vault for one trusted **contact**. The contact can ask
for it at any time; the owner's devices get a notification and have **7 days to deny**. If nobody denies, the
contact can download the copy. **The relay only enforces the waiting period.** It cannot read the copy, cannot
check what is inside it, and cannot stop the owner from changing or deleting it.

### 3.1 Client-side sealing (the relay never sees this)

The contact gives the owner two public keys (for example by QR): their Ed25519 device key (`contactKey`, used to
sign requests) and an X25519 key for sealing. The owner seals a vault snapshot to the X25519 key, for example:
ephemeral X25519 key pair, `shared = X25519(ephemeral, contactX25519)`,
`key = HKDF-SHA256(ikm=shared, salt=empty, info="TA-EMERGENCY-1", L=32)`, then AES-256-GCM with
`aad = "TA-EMERGENCY-1"`, and sends `blob = base64url(...)` holding the ephemeral public key, nonce and
ciphertext. `test.mjs` does exactly this. Any sealing the app already uses (`core/share.dart`) works as well:
the relay treats `blob` as opaque.

### 3.2 Endpoints

`grantId` is 32 random bytes made by the owner (43 base64url chars). Every request is signed exactly as in 1.3
(same headers, same string, nonces remembered per grant). Limit: 120 requests / 60 s per grant.

| Request | Who | Effect |
|---|---|---|
| `POST /v1/emergency/<grantId>` `{"contactKey","blob"}` | first signer becomes owner; then owner only | Creates (201) or replaces (200) the sealed blob. Naming a different `contactKey` cancels any pending request. `blob` max 786,432 chars. |
| `GET /v1/emergency/<grantId>` | owner or contact | Status (below). Never includes the blob. |
| `POST /v1/emergency/<grantId>/push` `{"platform","token","environment"}` | owner | Registers an owner device for the "someone asked" notification (same rules as 2.6; up to 10 devices, newest kept). 503 `push not configured` without push keys. |
| `POST /v1/emergency/<grantId>/request` `{}` | contact | Starts the 7-day wait and notifies every registered owner device. 201 with status plus `push: {sent, tokens}`. Asking again while waiting or released returns 200 with the same status and sends nothing. |
| `POST /v1/emergency/<grantId>/deny` | owner | Cancels a waiting (or released) request: back to `idle`. 409 `there is no request to deny` otherwise. The contact may ask again later. |
| `GET /v1/emergency/<grantId>/blob` | contact | 200 `{"blob","updatedAt"}` once released. 409 if the contact has not asked; 403 `the waiting period has not ended` with `releaseAt` while waiting. |
| `DELETE /v1/emergency/<grantId>` | owner | Deletes everything for this grant. |

Status: `{"owner","contactKey","state":"idle"|"waiting"|"released","requestedAt","releaseAt","updatedAt","blobLength"}`
(times in Unix ms; `requestedAt`/`releaseAt` are `null` when idle). Other errors: 404 `grant not found`,
403 `device is neither the owner nor the contact of this grant`, 403 `only the owner can change this grant`,
400 for a malformed `contactKey` or `blob` (or a contact equal to the owner).

**Notification.** The same channel as 2.6, with a different fixed sentence and no grant ID, name or account:
APNs `{"aps":{"alert":{"title":"Tanooki Auth","body":"Someone asked for emergency access to your accounts. Open the app to deny it."},"sound":"default","category":"TA_EMERGENCY_REQUEST"}}`,
expiring after 7 days; FCM `data {"type":"emergency-request"}`, ttl 7 days. The app should also poll
`GET /v1/emergency/<grantId>` when opened, since a push can be missed.

**Testing.** The relay honors `{"delaySeconds": n}` in `request` **only** when its `TEST_MODE` variable is set,
which only happens for a local `npx wrangler dev --var TEST_MODE:1`. The deployed relay ignores it and always
waits 7 days; `test.mjs` run without `TEST_MODE=1` checks that.

## 4. Team vault (feature 42)

A team is up to **10** devices that share a team key. The admin wraps the team key separately for each member
(the relay stores the wrapped copies as opaque blobs) and entries are ciphertext under it. The relay sees
device public keys, wrapped keys, entry IDs, timestamps and ciphertext only.

### 4.1 Client-side keys (the relay never sees these)

- Each member has its Ed25519 device key (signs requests, as in 1.3) and an X25519 `boxKey` sent at create/join.
- `teamKey`: 32 random bytes made by the admin. A new one is made for every **epoch** (rotation).
- Wrapped key for a member, as in `test.mjs`: ephemeral X25519 with the member's `boxKey`,
  `HKDF-SHA256(shared, salt=empty, info="TA-TEAM-WRAP-1", L=32)`, AES-256-GCM, sent as
  `base64url(ephemeralPub || nonce || ciphertext)` (max 1,024 chars).
- Entry ciphertext: `base64url(nonce || AES-256-GCM(teamKey, nonce, plaintext, aad))` with
  `aad = "TA-TEAM-1|" + teamId + "|" + entryId + "|" + epoch`.

### 4.2 Team license

Creating a team needs a **team license** from the Premium worker (`GET /team-license?session_id=` after the
$20/year Stripe subscription, `POST /team-license/refresh` later):
`TT1.<base64url "team1|<subscriptionId>|<periodEnd Unix seconds>">.<base64url Ed25519 signature>`, signed by the
same key as Premium license keys. The relay checks it with its `LICENSE_PUBLIC` variable. A Premium key (`TA1.`)
is not a team license. 402 errors: `team license is malformed`, `team license signature is not valid`,
`team license has expired; refresh it in the app`.

Writes (`join`, `invites`, `entries`) keep working until **14 days after** the license period ends, then return
402 until the admin posts a refreshed license. Reading always works, so a lapsed team can still get its data out.

### 4.3 Endpoints

`teamId` is 32 random bytes from the admin. Every request is signed as in 1.3. Limit: 600 requests / 60 s per team.

| Request | Who | Effect |
|---|---|---|
| `POST /v1/team/<teamId>/create` `{"license","boxKey"}` | anyone with a license | Creates the team with the signer as admin, epoch 1. 201 + status. 409 if it exists. |
| `GET /v1/team/<teamId>` | member | Status: `{"admin","epoch","needsRotation","licenseEnd","cursor","members":[{"key","role","boxKey","added","hasKey"}]}` (`hasKey`: has a wrapped key for the current epoch). |
| `POST /v1/team/<teamId>/license` `{"license"}` | admin | Stores a refreshed license (the later end date wins). |
| `POST /v1/team/<teamId>/invites` | admin | 201 `{"invite","expiresAt"}`: a random single-use token, valid 7 days (relay keeps only its SHA-256). Max 20 unused. Put it in the invite link with the `teamId`. |
| `POST /v1/team/<teamId>/join` `{"invite","boxKey"}` | new device | Joins as `member`. 403 `invite is not valid, expired, or already used`; 507 `team is full (10 members)`; 409 if already a member. |
| `POST /v1/team/<teamId>/keys` `{"epoch","keys":{"<memberKey>":"<wrapped>"}}` | admin | `epoch` = current: adds/replaces wrapped keys for the listed members (after someone joins). `epoch` = current + 1: **rotation**; must include every member (400 with `missing` otherwise), replaces all wrapped keys and clears `needsRotation`. Anything else: 409 with the current `epoch`. |
| `GET /v1/team/<teamId>/key` | member | `{"epoch","wrapped"}` for the caller at the current epoch; 404 until the admin has wrapped one for it. |
| `POST /v1/team/<teamId>/entries` `{"entries":[{"id","updatedAt","deleted","epoch","ciphertext"}]}` | member | 1 to 100 entries. Last writer wins by `updatedAt` (ms), like sync's merge: each result is `ok` (with `seq`) or `stale` (with `current`). `epoch` must be the current epoch, else 409 `the team key has changed` with `epoch`. Max 2,000 entries per team (deleted ones count), 65,536 chars each. |
| `GET /v1/team/<teamId>/entries?since=<seq>` | member | Up to 500 entries after `seq`, each with its `epoch`; `{"entries","cursor","more"}`. |
| `DELETE /v1/team/<teamId>/members/<memberKey>` | admin, or a member removing itself | Removes the member **immediately** (every later request from it is 403) and sets `needsRotation`. The admin cannot leave (409); it deletes the team instead. |
| `DELETE /v1/team/<teamId>` | admin | Deletes the team and everything in it. |

### 4.4 Removing someone and rotating the key

1. The admin removes the member. From that moment the relay refuses every request from that device.
2. `needsRotation` is now true. The admin's app makes a new `teamKey`, wraps it for every remaining member and
   posts it with `epoch = current + 1`.
3. **Old-epoch entries stay as they are** (still encrypted with the old key, and listed with their old `epoch`).
   New writes must use the new epoch. The admin's app (or any member) should then re-encrypt every old-epoch entry
   with the new key and push it with the **same** `updatedAt` and the new epoch: the relay accepts a same-time
   write only when it moves an entry onto the current epoch, so this never overwrites a newer edit.
4. Members keep the old team key locally until re-encryption is done, so they can still read old-epoch entries.
   A member who joins after the rotation cannot read old-epoch entries until they are re-encrypted.

Rotation protects **future** changes only. A removed member may have kept copies of everything they could see
before, so the app should suggest changing the secrets in shared entries that matter.

## 5. Known limits

- Tombstones count toward the 2,000-record cap and are never pruned by the server.
- Removing a device does not rotate the group key (see 1.4).
- Emergency access: the relay enforces only the waiting period. Someone who controls the relay could release
  the blob early, but still could not read it.
- Team vault: one team license can create more than one team (the relay does not keep a global list of
  subscriptions). Rotation after removal is the admin app's job; until it happens, new entries use the old key.
- The per-IP limit is approximate (Cloudflare's limiter is per data center and eventually consistent);
  the per-group and per-room limits are exact.
