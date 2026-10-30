// End-to-end test of the relay with real client crypto (Ed25519, X25519, HKDF, AES-256-GCM), as PROTOCOL.md describes.
//   node relay/test.mjs http://localhost:8787
//   node relay/test.mjs https://tanooki-auth-relay.kirbymail.workers.dev
// Set EXPECT_PUSH=1 once push secrets are installed: the push-token check then expects 200 instead of 503.
// Set TEST_MODE=1 when the relay runs with `npx wrangler dev --var TEST_MODE:1`: emergency access is then released
// after 2 s. Without it the test checks the deployed relay ignores the shortcut and keeps the 7-day wait.
// Team tests sign team licenses with the real key in ~/.tanooki-auth-signing/license_ed25519.json (or TA_LICENSE_FILE).
const BASE = (process.argv[2] || 'http://localhost:8787').replace(/\/$/, '');
const { subtle } = globalThis.crypto;
const te = new TextEncoder();
const td = new TextDecoder();
const b64u = (b) => Buffer.from(b instanceof ArrayBuffer ? new Uint8Array(b) : b).toString('base64url');
const unb64u = (s) => new Uint8Array(Buffer.from(s, 'base64url'));
const rand = (n) => crypto.getRandomValues(new Uint8Array(n));
const sleep = (ms) => new Promise((r) => setTimeout(r, ms));

let passed = 0;
let failed = 0;
function check(name, cond, detail = '') {
  if (cond) { passed++; console.log(`  ok   ${name}`); }
  else { failed++; console.log(`  FAIL ${name} ${detail}`); }
  return cond;
}

// ---------- crypto helpers (what the app / extension implement) ----------
async function ed25519Device() {
  const kp = await subtle.generateKey({ name: 'Ed25519' }, true, ['sign', 'verify']);
  return { kp, pub: b64u(await subtle.exportKey('raw', kp.publicKey)) };
}
const sign = async (dev, text) => b64u(await subtle.sign({ name: 'Ed25519' }, dev.kp.privateKey, te.encode(text)));
const sha = async (bytes) => b64u(await subtle.digest('SHA-256', bytes));
async function hkdf(ikm, salt, info, bytes) {
  const k = await subtle.importKey('raw', ikm, 'HKDF', false, ['deriveBits']);
  return new Uint8Array(await subtle.deriveBits({ name: 'HKDF', hash: 'SHA-256', salt, info: te.encode(info) }, k, bytes * 8));
}
async function seal(keyBytes, plaintext, aad) {
  const key = await subtle.importKey('raw', keyBytes, 'AES-GCM', false, ['encrypt']);
  const iv = rand(12);
  const ct = new Uint8Array(await subtle.encrypt({ name: 'AES-GCM', iv, additionalData: te.encode(aad) }, key, te.encode(JSON.stringify(plaintext))));
  return b64u(Buffer.concat([iv, ct]));
}
async function open(keyBytes, ciphertext, aad) {
  const key = await subtle.importKey('raw', keyBytes, 'AES-GCM', false, ['decrypt']);
  const all = unb64u(ciphertext);
  return JSON.parse(td.decode(await subtle.decrypt({ name: 'AES-GCM', iv: all.slice(0, 12), additionalData: te.encode(aad) }, key, all.slice(12))));
}

// Signed sync request. `mutate` lets a test break the request after signing.
async function signedRequest(dev, method, path, body, mutate = (x) => x) {
  const bytes = body === undefined ? new Uint8Array() : te.encode(JSON.stringify(body));
  const ts = Date.now();
  const nonce = b64u(rand(16));
  const sig = await sign(dev, `TA-RELAY-1\n${method}\n${path}\n${ts}\n${nonce}\n${await sha(bytes)}`);
  const req = mutate({ method, path, bytes, headers: { 'content-type': 'application/json', 'x-ta-device': dev.pub, 'x-ta-timestamp': String(ts), 'x-ta-nonce': nonce, 'x-ta-signature': sig } });
  return req;
}
async function send(req) {
  const r = await fetch(BASE + req.path, { method: req.method, headers: req.headers, body: req.method === 'GET' || req.method === 'DELETE' && !req.bytes.length ? undefined : req.bytes });
  return { status: r.status, body: await r.json().catch(() => null) };
}
const call = async (dev, method, path, body, mutate) => send(await signedRequest(dev, method, path, body, mutate));
const room = async (method, path, token, body) => {
  const r = await fetch(BASE + path, { method, headers: { 'content-type': 'application/json', ...(token ? { authorization: `Bearer ${token}` } : {}) }, body: body ? JSON.stringify(body) : undefined });
  return { status: r.status, body: await r.json().catch(() => null) };
};
function socket(url) {
  const ws = new WebSocket(url.replace(/^http/, 'ws'));
  const queue = [];
  const waiters = [];
  ws.addEventListener('message', (e) => {
    const m = String(e.data) === 'pong' ? 'pong' : JSON.parse(e.data);
    const w = waiters.shift();
    w ? w(m) : queue.push(m);
  });
  const next = (ms = 8000) => (queue.length ? Promise.resolve(queue.shift()) : new Promise((res) => {
    const t = setTimeout(() => { waiters.splice(waiters.indexOf(f), 1); res(null); }, ms);
    const f = (m) => { clearTimeout(t); res(m); };
    waiters.push(f);
  }));
  const ready = new Promise((res, rej) => { ws.addEventListener('open', res); ws.addEventListener('error', rej); });
  return { ws, next, ready };
}

// ---------- sync ----------
async function syncTests() {
  console.log('sync store');
  const root = rand(32); // sync root key: Argon2id output in the app, random here
  const groupId = b64u(await hkdf(root, new Uint8Array(), 'TA-SYNC-GROUP-ID-1', 32));
  const recordKey = await hkdf(root, new Uint8Array(), 'TA-SYNC-RECORD-KEY-1', 32);
  const G = `/v1/sync/${groupId}`;
  const A = await ed25519Device();
  const B = await ed25519Device();
  const C = await ed25519Device();

  let r = await call(A, 'POST', `${G}/create`, {});
  check('create group', r.status === 201, JSON.stringify(r));
  r = await call(B, 'POST', `${G}/create`, {});
  check('second create is refused (409)', r.status === 409, JSON.stringify(r));
  r = await call(B, 'GET', `${G}/changes?since=0`);
  check('stranger device cannot read (403)', r.status === 403, JSON.stringify(r));

  const invite = async (by, life = 3600_000) => {
    const nonce = b64u(rand(16));
    const expiresAt = Date.now() + life;
    return { inviter: by.pub, nonce, expiresAt, sig: await sign(by, `TA-INVITE-1\n${groupId}\n${nonce}\n${expiresAt}`) };
  };
  const inv = await invite(A);
  r = await call(B, 'POST', `${G}/join`, { invite: inv });
  check('join with invite signed by a member', r.status === 201, JSON.stringify(r));
  r = await call(C, 'POST', `${G}/join`, { invite: inv });
  check('invite is single-use (403)', r.status === 403 && /already used/.test(r.body?.error), JSON.stringify(r));
  r = await call(C, 'POST', `${G}/join`, { invite: await invite(C) });
  check('invite signed by a non-member is refused (403)', r.status === 403, JSON.stringify(r));
  const forged = await invite(A);
  forged.expiresAt += 1000; // signature no longer matches
  r = await call(C, 'POST', `${G}/join`, { invite: forged });
  check('tampered invite is refused (403)', r.status === 403 && /signature/.test(r.body?.error), JSON.stringify(r));
  r = await call(C, 'POST', `${G}/join`, { invite: await invite(A, 48 * 3600_000) });
  check('invite longer than 24 h is refused (403)', r.status === 403, JSON.stringify(r));
  r = await call(A, 'GET', `${G}/devices`);
  check('device list has exactly A and B', r.status === 200 && r.body.devices.map((d) => d.key).sort().join() === [A.pub, B.pub].sort().join(), JSON.stringify(r));

  // B listens for change notifications
  const ts = Date.now();
  const nonce = b64u(rand(16));
  const wsSig = await sign(B, `TA-RELAY-1\nGET\n${G}/ws\n${ts}\n${nonce}\n${await sha(new Uint8Array())}`);
  const bws = socket(`${BASE}${G}/ws?device=${B.pub}&ts=${ts}&nonce=${nonce}&sig=${wsSig}`);
  await bws.ready;
  const hello = await bws.next();
  check('sync WebSocket says hello with cursor', hello?.type === 'hello' && hello.cursor === 0, JSON.stringify(hello));

  const recordId = b64u(await hkdf(root, te.encode('account-uuid-1'), 'TA-SYNC-RECORD-ID-1', 32));
  const account = { issuer: 'GitHub', label: 'maddie', secret: 'JBSWY3DPEHPK3PXP', updatedAt: Date.now() };
  const aad = `TA-SYNC-1|${groupId}|${recordId}`;
  r = await call(A, 'POST', `${G}/push`, { records: [{ id: recordId, baseVersion: 0, deleted: false, ciphertext: await seal(recordKey, account, aad) }] });
  check('put new record (version 1)', r.status === 200 && r.body.results[0].status === 'ok' && r.body.results[0].version === 1, JSON.stringify(r));
  const note = await bws.next();
  check('B is notified over WebSocket', note?.type === 'changed' && note.cursor === r.body.cursor, JSON.stringify(note));

  r = await call(B, 'GET', `${G}/records/${recordId}`);
  check('B gets the record and decrypts it', r.status === 200 && (await open(recordKey, r.body.ciphertext, aad)).secret === account.secret, JSON.stringify(r));

  r = await call(B, 'POST', `${G}/push`, { records: [{ id: recordId, baseVersion: 0, deleted: false, ciphertext: await seal(recordKey, { ...account, label: 'stale' }, aad) }] });
  check('stale baseVersion gets conflict + current record', r.status === 200 && r.body.results[0].status === 'conflict' && r.body.results[0].current.version === 1, JSON.stringify(r));
  r = await call(B, 'POST', `${G}/push`, { records: [{ id: recordId, baseVersion: 1, deleted: false, ciphertext: await seal(recordKey, { ...account, label: 'edited' }, aad) }] });
  check('edit with right baseVersion (version 2)', r.body?.results?.[0]?.version === 2, JSON.stringify(r));

  r = await call(A, 'GET', `${G}/changes?since=0`);
  const cursor1 = r.body?.cursor;
  check('changes since 0 returns the one record at version 2', r.status === 200 && r.body.records.length === 1 && r.body.records[0].version === 2 && r.body.more === false, JSON.stringify(r));
  check('A decrypts the edit', (await open(recordKey, r.body.records[0].ciphertext, aad)).label === 'edited');
  r = await call(A, 'GET', `${G}/changes?since=${cursor1}`);
  check('changes since cursor is empty', r.status === 200 && r.body.records.length === 0 && r.body.cursor === cursor1, JSON.stringify(r));

  r = await call(A, 'POST', `${G}/push`, { records: [{ id: recordId, baseVersion: 2, deleted: true, ciphertext: await seal(recordKey, { deletedAt: Date.now() }, aad) }] });
  check('tombstone accepted (version 3)', r.body?.results?.[0]?.version === 3, JSON.stringify(r));
  r = await call(B, 'GET', `${G}/changes?since=${cursor1}`);
  check('tombstone shows up in changes as deleted', r.body?.records?.length === 1 && r.body.records[0].deleted === true && r.body.records[0].version === 3, JSON.stringify(r));

  r = await call(A, 'POST', `${G}/push`, { records: [{ id: 'x', baseVersion: 0, ciphertext: 'A'.repeat(70_000) }] });
  check('oversized record is refused (413)', r.status === 413, JSON.stringify(r));
  r = await call(A, 'POST', `${G}/push`, { records: Array.from({ length: 101 }, (_, i) => ({ id: `r${i}`, baseVersion: 0, ciphertext: 'AA' })) });
  check('batch over 100 is refused (400)', r.status === 400, JSON.stringify(r));

  r = await call(A, 'GET', `${G}/changes?since=0`, undefined, (q) => ({ ...q, headers: { ...q.headers, 'x-ta-signature': b64u(rand(64)) } }));
  check('bad signature is refused (401)', r.status === 401 && /bad signature/.test(r.body?.error), JSON.stringify(r));
  r = await call(A, 'POST', `${G}/push`, { records: [{ id: 'evil', baseVersion: 0, ciphertext: 'AA' }] }, (q) => ({ ...q, bytes: te.encode(JSON.stringify({ records: [{ id: 'evil2', baseVersion: 0, ciphertext: 'AA' }] })) }));
  check('body changed after signing is refused (401)', r.status === 401, JSON.stringify(r));
  const once = await signedRequest(A, 'GET', `${G}/changes?since=0`);
  const first = await send(once);
  const replay = await send(once);
  check('replayed request is refused (401)', first.status === 200 && replay.status === 401 && /replayed/.test(replay.body?.error), JSON.stringify(replay));
  r = await call(A, 'GET', `${G}/changes?since=0`, undefined, (q) => q); // fresh nonce still fine
  check('fresh request after replay still works', r.status === 200);
  const old = await signedRequest(A, 'GET', `${G}/changes?since=0`);
  const oldTs = Date.now() - 10 * 60_000;
  old.headers['x-ta-timestamp'] = String(oldTs);
  old.headers['x-ta-signature'] = await sign(A, `TA-RELAY-1\nGET\n${G}/changes?since=0\n${oldTs}\n${old.headers['x-ta-nonce']}\n${await sha(new Uint8Array())}`);
  r = await send(old);
  check('10-minute-old timestamp is refused (401)', r.status === 401 && /timestamp/.test(r.body?.error), JSON.stringify(r));

  r = await call(A, 'DELETE', `${G}/devices/${B.pub}`);
  check('A removes B', r.status === 200);
  r = await call(B, 'GET', `${G}/changes?since=0`);
  check('removed device is refused (403)', r.status === 403, JSON.stringify(r));
  bws.ws.close();
  r = await call(A, 'DELETE', G);
  check('delete group', r.status === 200);
  r = await call(A, 'GET', `${G}/devices`);
  check('deleted group is gone (404)', r.status === 404, JSON.stringify(r));
}

// ---------- phone link ----------
async function linkTests() {
  console.log('phone link');
  const roomId = b64u(rand(32));
  const R = `/v1/link/rooms/${roomId}`;
  const ext = await subtle.generateKey({ name: 'X25519' }, true, ['deriveBits']);
  const extPub = b64u(await subtle.exportKey('raw', ext.publicKey));
  const pairSecret = rand(32); // in the QR only, never sent to the relay

  let r = await room('POST', `${R}/create`);
  const extToken = r.body?.extToken;
  check('extension creates room', r.status === 201 && typeof extToken === 'string', JSON.stringify(r));
  check('second create is refused (409)', (await room('POST', `${R}/create`)).status === 409);
  r = await room('POST', `${R}/messages`, extToken, { ciphertext: 'AA' });
  check('message before phone joins is refused (409)', r.status === 409, JSON.stringify(r));

  const ews = socket(`${BASE}${R}/ws`);
  await ews.ready;
  ews.ws.send(JSON.stringify({ type: 'auth', token: extToken }));
  const ready = await ews.next();
  check('extension WebSocket authenticates', ready?.type === 'ready' && ready.role === 'ext', JSON.stringify(ready));

  // Phone scans the QR: tanookiauth://link?v=1&relay=...&room=<roomId>&key=<extPub>&secret=<pairSecret>
  const phone = await subtle.generateKey({ name: 'X25519' }, true, ['deriveBits']);
  const phonePub = b64u(await subtle.exportKey('raw', phone.publicKey));
  r = await room('POST', `${R}/join`, null, { phoneKey: phonePub });
  const phoneToken = r.body?.phoneToken;
  check('phone joins', r.status === 201 && typeof phoneToken === 'string', JSON.stringify(r));
  check('second join is refused (409)', (await room('POST', `${R}/join`, null, { phoneKey: phonePub })).status === 409);
  const joined = await ews.next();
  check('extension hears joined + phone key', joined?.type === 'joined' && joined.phoneKey === phonePub, JSON.stringify(joined));
  r = await room('GET', R, 'wrong-token');
  check('wrong token is refused (401)', r.status === 401, JSON.stringify(r));

  const linkKeys = async (priv, peerPub) => {
    const peer = await subtle.importKey('raw', unb64u(peerPub), { name: 'X25519' }, false, []);
    const shared = new Uint8Array(await subtle.deriveBits({ name: 'X25519', public: peer }, priv, 256));
    const okm = await hkdf(shared, pairSecret, `TA-LINK-1|${roomId}|${extPub}|${phonePub}`, 64);
    return { e2p: okm.slice(0, 32), p2e: okm.slice(32) };
  };
  const extKeys = await linkKeys(ext.privateKey, joined.phoneKey);
  const phoneKeys = await linkKeys(phone.privateKey, extPub);
  const aad = (dir) => `TA-LINK-1|${roomId}|${dir}`;

  const pws = socket(`${BASE}${R}/ws`);
  await pws.ready;
  pws.ws.send(JSON.stringify({ type: 'auth', token: phoneToken }));
  check('phone WebSocket authenticates', (await pws.next())?.role === 'phone');

  r = await room('POST', `${R}/messages`, phoneToken, { ciphertext: await seal(phoneKeys.p2e, { t: 'hello', id: b64u(rand(16)), ts: Date.now(), device: 'Test phone' }, aad('p2e')) });
  check('phone sends hello', r.status === 201, JSON.stringify(r));
  const helloMsg = await ews.next();
  check('extension decrypts hello (keys agree)', helloMsg?.type === 'message' && (await open(extKeys.p2e, helloMsg.message.ciphertext, aad('p2e'))).t === 'hello', JSON.stringify(helloMsg));

  const reqId = b64u(rand(16));
  r = await room('POST', `${R}/messages`, extToken, { ciphertext: await seal(extKeys.e2p, { t: 'fill-request', id: reqId, ts: Date.now(), host: 'github.com' }, aad('e2p')), notify: true });
  check('extension sends fill-request; push says no-token', r.status === 201 && r.body.push === 'no-token', JSON.stringify(r));
  const fill = await pws.next();
  const fillPlain = fill && (await open(phoneKeys.e2p, fill.message.ciphertext, aad('e2p')));
  check('phone receives and decrypts fill-request', fillPlain?.t === 'fill-request' && fillPlain.host === 'github.com', JSON.stringify(fill));
  r = await room('GET', `${R}/messages?after=0`, phoneToken);
  check('phone can also poll it', r.status === 200 && r.body.messages.length === 1 && r.body.messages[0].from === 'ext', JSON.stringify(r));
  r = await room('GET', `${R}/messages?after=0`, extToken);
  check('extension does not get its own messages back', r.body?.messages?.length === 1 && r.body.messages[0].from === 'phone', JSON.stringify(r));

  r = await room('POST', `${R}/messages`, phoneToken, { ciphertext: await seal(phoneKeys.p2e, { t: 'code', id: b64u(rand(16)), ts: Date.now(), re: reqId, code: '123456' }, aad('p2e')) });
  const codeMsg = await ews.next();
  const codePlain = codeMsg && (await open(extKeys.p2e, codeMsg.message.ciphertext, aad('p2e')));
  check('approve: extension decrypts the code reply', codePlain?.t === 'code' && codePlain.re === reqId && codePlain.code === '123456', JSON.stringify(codeMsg));
  let tamperRejected = false;
  try { await open(extKeys.e2p, codeMsg.message.ciphertext, aad('p2e')); } catch { tamperRejected = true; }
  check('wrong-direction key cannot decrypt', tamperRejected);

  r = await room('POST', `${R}/push`, phoneToken, { platform: 'apns', token: 'a'.repeat(64), environment: 'sandbox' });
  if (process.env.EXPECT_PUSH) {
    check('push token registers (200)', r.status === 200, JSON.stringify(r));
    // Apple only says "bad device token" after it has accepted our signing key; a bad key gives failed:apns-403.
    r = await room('POST', `${R}/messages`, extToken, { ciphertext: await seal(extKeys.e2p, { t: 'fill-request', id: b64u(rand(16)), ts: Date.now(), host: 'github.com' }, aad('e2p')), notify: true });
    check('Apple accepts the push key (fake device -> token-dead)', r.status === 201 && r.body.push === 'token-dead', JSON.stringify(r));
  }
  else check('push token without secrets: 503 "push not configured"', r.status === 503 && r.body?.error === 'push not configured', JSON.stringify(r));
  r = await room('POST', `${R}/push`, phoneToken, { platform: 'fcm', token: 'f'.repeat(64) });
  if (!process.env.EXPECT_PUSH) check('FCM token without secrets: 503 too', r.status === 503, JSON.stringify(r));
  r = await room('POST', `${R}/push`, extToken, { platform: 'fcm', token: 'f'.repeat(64) });
  check('extension cannot register a push token (403)', r.status === 403, JSON.stringify(r));

  r = await room('POST', `${R}/messages`, extToken, { ciphertext: 'AA', ttl: 121 });
  check('ttl over 120 s is refused (400)', r.status === 400, JSON.stringify(r));
  r = await room('POST', `${R}/messages`, extToken, { ciphertext: 'AAAA', ttl: 2 });
  const shortId = r.body?.id;
  r = await room('GET', `${R}/messages?after=${shortId - 1}`, phoneToken);
  check('short-lived message is there before expiry', r.body?.messages?.some((m) => m.id === shortId), JSON.stringify(r));
  await sleep(3000);
  r = await room('GET', `${R}/messages?after=${shortId - 1}`, phoneToken);
  check('message is gone after it expires', r.status === 200 && !r.body.messages.some((m) => m.id === shortId), JSON.stringify(r));

  r = await room('DELETE', R, phoneToken);
  check('phone unpairs (room deleted)', r.status === 200);
  const unpaired = await ews.next();
  check('extension hears unpaired', unpaired?.type === 'unpaired', JSON.stringify(unpaired));
  r = await room('GET', R, extToken);
  check('deleted room is gone (404)', r.status === 404, JSON.stringify(r));
  ews.ws.close();
  pws.ws.close();
}

// ---------- health ----------
async function healthTests() {
  console.log('health');
  const r = await fetch(`${BASE}/health`);
  const b = await r.json().catch(() => null);
  check('GET /health is ok with service and time', r.status === 200 && b?.ok === true && b.service === 'tanooki-auth-relay' && !Number.isNaN(Date.parse(b.time)), JSON.stringify(b));
  check('/health allows any origin (CORS *)', r.headers.get('access-control-allow-origin') === '*');
}

// ---------- emergency access ----------
async function emergencyTests() {
  console.log('emergency access');
  const E = `/v1/emergency/${b64u(rand(32))}`;
  const owner = await ed25519Device();
  const contact = await ed25519Device();
  const stranger = await ed25519Device();
  const contactBox = await subtle.generateKey({ name: 'X25519' }, true, ['deriveBits']);
  const contactBoxPub = b64u(await subtle.exportKey('raw', contactBox.publicKey));
  // Owner seals a snapshot to the contact's X25519 key (ephemeral ECDH + HKDF + AES-GCM); the relay only stores it.
  const sealTo = async (peerPub, plain, info) => {
    const eph = await subtle.generateKey({ name: 'X25519' }, true, ['deriveBits']);
    const peer = await subtle.importKey('raw', unb64u(peerPub), { name: 'X25519' }, false, []);
    const shared = new Uint8Array(await subtle.deriveBits({ name: 'X25519', public: peer }, eph.privateKey, 256));
    const ephPub = b64u(await subtle.exportKey('raw', eph.publicKey));
    return `${ephPub}.${await seal(await hkdf(shared, new Uint8Array(), info, 32), plain, info)}`;
  };
  const openFrom = async (priv, blob, info) => {
    const [ephPub, ct] = blob.split('.');
    const peer = await subtle.importKey('raw', unb64u(ephPub), { name: 'X25519' }, false, []);
    const shared = new Uint8Array(await subtle.deriveBits({ name: 'X25519', public: peer }, priv, 256));
    return open(await hkdf(shared, new Uint8Array(), info, 32), ct, info);
  };
  const snapshot = { accounts: [{ issuer: 'GitHub', secret: 'JBSWY3DPEHPK3PXP' }] };
  const blob = (await sealTo(contactBoxPub, snapshot, 'TA-EMERGENCY-1')).replace('.', '_'); // one base64url string on the wire
  const unwire = (b) => `${b.slice(0, 43)}.${b.slice(44)}`;

  let r = await call(owner, 'GET', E);
  check('unknown grant is 404', r.status === 404, JSON.stringify(r));
  r = await call(owner, 'POST', E, { contactKey: contact.pub, blob });
  check('owner uploads sealed blob (201)', r.status === 201 && r.body.state === 'idle' && r.body.owner === owner.pub, JSON.stringify(r));
  check('status does not include the blob', !JSON.stringify(r.body).includes(blob.slice(0, 40)));
  r = await call(stranger, 'POST', E, { contactKey: stranger.pub, blob: 'AAAA' });
  check('stranger cannot replace it (403)', r.status === 403, JSON.stringify(r));
  r = await call(stranger, 'GET', E);
  check('stranger cannot read status (403)', r.status === 403, JSON.stringify(r));
  r = await call(contact, 'GET', `${E}/blob`);
  check('contact cannot download before asking (409)', r.status === 409, JSON.stringify(r));
  r = await call(contact, 'POST', `${E}/deny`);
  check('contact cannot deny (404 for contact)', r.status === 404, JSON.stringify(r));
  r = await call(owner, 'POST', `${E}/push`, { platform: 'apns', token: 'a'.repeat(64), environment: 'sandbox' });
  check(process.env.EXPECT_PUSH ? 'owner registers a push token' : 'push token without secrets: 503', r.status === (process.env.EXPECT_PUSH ? 200 : 503), JSON.stringify(r));

  r = await call(contact, 'POST', `${E}/request`, { delaySeconds: 2 });
  const wait = r.body?.releaseAt - r.body?.requestedAt;
  check('contact asks: 201, waiting', r.status === 201 && r.body.state === 'waiting', JSON.stringify(r));
  if (process.env.TEST_MODE) check('TEST_MODE relay shortens the wait to 2 s', wait === 2000, String(wait));
  else check('relay ignores delaySeconds: wait is 7 days', wait === 7 * 86400_000, String(wait));
  if (process.env.EXPECT_PUSH) check('owner push attempted (fake token is dead, 0 sent)', r.body.push?.tokens === 1 && r.body.push.sent === 0, JSON.stringify(r.body.push));
  else check('no push service: 0 tokens', r.body?.push?.tokens === 0, JSON.stringify(r.body?.push));
  r = await call(contact, 'GET', `${E}/blob`);
  check('blob locked while waiting (403 + releaseAt)', r.status === 403 && r.body.releaseAt > Date.now(), JSON.stringify(r));
  r = await call(owner, 'POST', `${E}/deny`);
  check('owner denies: back to idle', r.status === 200 && r.body.state === 'idle' && r.body.releaseAt === null, JSON.stringify(r));
  r = await call(owner, 'POST', `${E}/deny`);
  check('second deny: nothing to deny (409)', r.status === 409, JSON.stringify(r));
  r = await call(contact, 'GET', `${E}/blob`);
  check('denied: blob not available (409)', r.status === 409, JSON.stringify(r));

  r = await call(contact, 'POST', `${E}/request`, { delaySeconds: 2 });
  const releaseAt = r.body?.releaseAt;
  check('contact asks again (201)', r.status === 201, JSON.stringify(r));
  r = await call(contact, 'POST', `${E}/request`, { delaySeconds: 0 });
  check('asking twice keeps the first timer (200, no new push)', r.status === 200 && r.body.releaseAt === releaseAt && r.body.push === undefined, JSON.stringify(r));
  if (process.env.TEST_MODE) {
    await sleep(2500);
    r = await call(contact, 'GET', `${E}/blob`);
    check('after the wait the contact downloads and opens it', r.status === 200 && (await openFrom(contactBox.privateKey, unwire(r.body.blob), 'TA-EMERGENCY-1')).accounts[0].secret === snapshot.accounts[0].secret, JSON.stringify(r).slice(0, 200));
    r = await call(owner, 'GET', E);
    check('status says released', r.body?.state === 'released', JSON.stringify(r));
  } else {
    r = await call(contact, 'GET', `${E}/blob`);
    check('deployed relay still locks the blob (403)', r.status === 403, JSON.stringify(r));
  }

  const newContact = await ed25519Device();
  r = await call(owner, 'POST', E, { contactKey: newContact.pub, blob: 'BBBB' });
  check('owner switches contact: 200, request cleared', r.status === 200 && r.body.state === 'idle', JSON.stringify(r));
  r = await call(contact, 'GET', `${E}/blob`);
  check('old contact is locked out (403)', r.status === 403, JSON.stringify(r));
  r = await call(owner, 'POST', E, { contactKey: owner.pub, blob: 'BBBB' });
  check('owner cannot name itself as contact (400)', r.status === 400, JSON.stringify(r));
  r = await call(newContact, 'GET', E, undefined, (q) => ({ ...q, headers: { ...q.headers, 'x-ta-signature': b64u(rand(64)) } }));
  check('bad signature is refused (401)', r.status === 401, JSON.stringify(r));
  r = await call(owner, 'DELETE', E);
  check('owner deletes the grant', r.status === 200);
  r = await call(newContact, 'GET', E);
  check('deleted grant is gone (404)', r.status === 404, JSON.stringify(r));
}

// ---------- team vault ----------
async function teamTests() {
  console.log('team vault');
  const { readFileSync } = await import('node:fs');
  let lic;
  try { lic = JSON.parse(readFileSync(process.env.TA_LICENSE_FILE || `${process.env.HOME}/.tanooki-auth-signing/license_ed25519.json`, 'utf8')); } catch {}
  if (!check('license signing file found (needed to make team licenses)', !!lic)) return;
  const std2u = (s) => Buffer.from(s, 'base64').toString('base64url');
  const signer = async (seed, pub) => subtle.importKey('jwk', { kty: 'OKP', crv: 'Ed25519', d: std2u(seed), x: std2u(pub) }, { name: 'Ed25519' }, false, ['sign']);
  const realKey = await signer(lic.seed, lic.public);
  const teamLicense = async (payload, key = realKey, tag = 'TT1') =>
    `${tag}.${b64u(te.encode(payload))}.${b64u(await subtle.sign({ name: 'Ed25519' }, key, te.encode(payload)))}`;
  const yearOut = Math.floor(Date.now() / 1000) + 365 * 86400;
  const T = `/v1/team/${b64u(rand(32))}`;
  const box = async () => {
    const kp = await subtle.generateKey({ name: 'X25519' }, true, ['deriveBits']);
    return { kp, pub: b64u(await subtle.exportKey('raw', kp.publicKey)) };
  };
  const person = async () => ({ ...(await ed25519Device()), box: await box() });
  // Wrap the team key for one member: ephemeral X25519 + HKDF + AES-GCM, all on the client.
  const wrap = async (teamKey, memberBoxPub) => {
    const eph = await subtle.generateKey({ name: 'X25519' }, true, ['deriveBits']);
    const peer = await subtle.importKey('raw', unb64u(memberBoxPub), { name: 'X25519' }, false, []);
    const shared = new Uint8Array(await subtle.deriveBits({ name: 'X25519', public: peer }, eph.privateKey, 256));
    const k = await subtle.importKey('raw', await hkdf(shared, new Uint8Array(), 'TA-TEAM-WRAP-1', 32), 'AES-GCM', false, ['encrypt']);
    const iv = rand(12);
    const ct = new Uint8Array(await subtle.encrypt({ name: 'AES-GCM', iv }, k, teamKey));
    return b64u(Buffer.concat([new Uint8Array(await subtle.exportKey('raw', eph.publicKey)), iv, ct]));
  };
  const unwrap = async (wrapped, boxPriv) => {
    const all = unb64u(wrapped);
    const peer = await subtle.importKey('raw', all.slice(0, 32), { name: 'X25519' }, false, []);
    const shared = new Uint8Array(await subtle.deriveBits({ name: 'X25519', public: peer }, boxPriv, 256));
    const k = await subtle.importKey('raw', await hkdf(shared, new Uint8Array(), 'TA-TEAM-WRAP-1', 32), 'AES-GCM', false, ['decrypt']);
    return new Uint8Array(await subtle.decrypt({ name: 'AES-GCM', iv: all.slice(32, 44) }, k, all.slice(44)));
  };
  const A = await person();
  const B = await person();
  const C = await person();

  let r = await call(A, 'POST', `${T}/create`, { boxKey: A.box.pub });
  check('create without a license is refused (402)', r.status === 402, JSON.stringify(r));
  r = await call(A, 'POST', `${T}/create`, { boxKey: A.box.pub, license: await teamLicense(`1|cs_test_x|20261030`, realKey, 'TA1') });
  check('a Premium key is not a team license (402)', r.status === 402 && /malformed/.test(r.body?.error), JSON.stringify(r));
  r = await call(A, 'POST', `${T}/create`, { boxKey: A.box.pub, license: await teamLicense(`team1|sub_test|${Math.floor(Date.now() / 1000) - 60}`) });
  check('expired team license is refused (402)', r.status === 402 && /expired/.test(r.body?.error), JSON.stringify(r));
  const fake = await subtle.generateKey({ name: 'Ed25519' }, true, ['sign', 'verify']);
  r = await call(A, 'POST', `${T}/create`, { boxKey: A.box.pub, license: await teamLicense(`team1|sub_test|${yearOut}`, fake.privateKey) });
  check('team license signed by another key is refused (402)', r.status === 402 && /signature/.test(r.body?.error), JSON.stringify(r));
  r = await call(A, 'POST', `${T}/create`, { boxKey: A.box.pub, license: await teamLicense(`team1|sub_test|${yearOut}`) });
  check('admin creates the team with a valid license (201)', r.status === 201 && r.body.admin === A.pub && r.body.epoch === 1, JSON.stringify(r));
  r = await call(B, 'POST', `${T}/create`, { boxKey: B.box.pub, license: await teamLicense(`team1|sub_test|${yearOut}`) });
  check('second create is refused (409)', r.status === 409, JSON.stringify(r));

  r = await call(B, 'POST', `${T}/join`, { invite: 'made-up', boxKey: B.box.pub });
  check('made-up invite is refused (403)', r.status === 403, JSON.stringify(r));
  r = await call(A, 'POST', `${T}/invites`);
  const inviteB = r.body?.invite;
  check('admin makes an invite', r.status === 201 && typeof inviteB === 'string', JSON.stringify(r));
  r = await call(B, 'POST', `${T}/join`, { invite: inviteB, boxKey: B.box.pub });
  check('B joins with the invite (201)', r.status === 201 && r.body.members.length === 2, JSON.stringify(r));
  r = await call(C, 'POST', `${T}/join`, { invite: inviteB, boxKey: C.box.pub });
  check('invite is single-use (403)', r.status === 403, JSON.stringify(r));
  r = await call(B, 'POST', `${T}/invites`);
  check('a member cannot make invites (403)', r.status === 403, JSON.stringify(r));
  r = await call(C, 'GET', T);
  check('outsider cannot read the team (403)', r.status === 403, JSON.stringify(r));

  const key1 = rand(32);
  r = await call(A, 'POST', `${T}/keys`, { epoch: 1, keys: { [A.pub]: await wrap(key1, A.box.pub), [B.pub]: await wrap(key1, B.box.pub) } });
  check('admin uploads wrapped keys for epoch 1', r.status === 200 && r.body.members.every((m) => m.hasKey), JSON.stringify(r));
  r = await call(B, 'GET', `${T}/key`);
  const bKey = r.status === 200 ? await unwrap(r.body.wrapped, B.box.kp.privateKey) : null;
  check('B fetches and unwraps the team key', bKey && Buffer.compare(bKey, key1) === 0, JSON.stringify(r));

  const entryId = b64u(rand(16));
  const aad = (epoch) => `TA-TEAM-1|${T.split('/').pop()}|${entryId}|${epoch}`;
  const t0 = Date.now();
  r = await call(A, 'POST', `${T}/entries`, { entries: [{ id: entryId, updatedAt: t0, epoch: 1, ciphertext: await seal(key1, { issuer: 'AWS', secret: 'JBSWY3DPEHPK3PXP' }, aad(1)) }] });
  check('admin pushes an entry', r.status === 200 && r.body.results[0].status === 'ok', JSON.stringify(r));
  r = await call(B, 'GET', `${T}/entries?since=0`);
  check('B reads and decrypts it', r.status === 200 && (await open(bKey, r.body.entries[0].ciphertext, aad(1))).issuer === 'AWS', JSON.stringify(r));
  r = await call(B, 'POST', `${T}/entries`, { entries: [{ id: entryId, updatedAt: t0 - 1, epoch: 1, ciphertext: await seal(key1, { issuer: 'old' }, aad(1)) }] });
  check('older write loses (stale + current)', r.body?.results?.[0]?.status === 'stale' && r.body.results[0].current.updatedAt === t0, JSON.stringify(r));
  r = await call(B, 'POST', `${T}/entries`, { entries: [{ id: entryId, updatedAt: t0 + 1, epoch: 1, ciphertext: await seal(key1, { issuer: 'AWS', label: 'ops' }, aad(1)) }] });
  check('newer write wins', r.body?.results?.[0]?.status === 'ok', JSON.stringify(r));

  // Fill the team to 10, then the 11th is refused.
  const extra = [C];
  for (let i = 0; i < 7; i++) extra.push(await person());
  let joined = 0;
  for (const p of extra) {
    const inv = (await call(A, 'POST', `${T}/invites`)).body.invite;
    if ((await call(p, 'POST', `${T}/join`, { invite: inv, boxKey: p.box.pub })).status === 201) joined++;
  }
  check('8 more people join (10 in all)', joined === 8);
  const eleventh = await person();
  r = await call(eleventh, 'POST', `${T}/join`, { invite: (await call(A, 'POST', `${T}/invites`)).body.invite, boxKey: eleventh.box.pub });
  check('11th member is refused (507)', r.status === 507, JSON.stringify(r));

  r = await call(A, 'DELETE', `${T}/members/${B.pub}`);
  check('admin removes B: team needs key rotation', r.status === 200 && r.body.needsRotation === true && !r.body.members.some((m) => m.key === B.pub), JSON.stringify(r));
  r = await call(B, 'GET', `${T}/entries?since=0`);
  check('B loses access at once (403)', r.status === 403, JSON.stringify(r));
  r = await call(B, 'GET', `${T}/key`);
  check('B cannot fetch the key any more (403)', r.status === 403, JSON.stringify(r));
  r = await call(C, 'DELETE', `${T}/members/${A.pub}`);
  check('a member cannot remove others (403)', r.status === 403, JSON.stringify(r));

  const key2 = rand(32);
  const members = [A, ...extra];
  r = await call(A, 'POST', `${T}/keys`, { epoch: 2, keys: { [A.pub]: await wrap(key2, A.box.pub) } });
  check('rotation missing members is refused (400)', r.status === 400 && r.body.missing?.length === 8, JSON.stringify(r).slice(0, 200));
  const all = {};
  for (const p of members) all[p.pub] = await wrap(key2, p.box.pub);
  r = await call(A, 'POST', `${T}/keys`, { epoch: 2, keys: all });
  check('admin rotates to epoch 2', r.status === 200 && r.body.epoch === 2 && r.body.needsRotation === false, JSON.stringify(r).slice(0, 200));
  r = await call(A, 'POST', `${T}/keys`, { epoch: 4, keys: all });
  check('skipping an epoch is refused (409)', r.status === 409, JSON.stringify(r).slice(0, 200));
  r = await call(C, 'POST', `${T}/entries`, { entries: [{ id: b64u(rand(16)), updatedAt: Date.now(), epoch: 1, ciphertext: 'AAAA' }] });
  check('writing with the old key is refused (409)', r.status === 409 && r.body.epoch === 2, JSON.stringify(r));
  r = await call(C, 'GET', `${T}/key`);
  const cKey = r.status === 200 ? await unwrap(r.body.wrapped, C.box.kp.privateKey) : null;
  check('C unwraps the epoch 2 key', r.body?.epoch === 2 && cKey && Buffer.compare(cKey, key2) === 0, JSON.stringify(r));
  r = await call(C, 'GET', `${T}/entries?since=0`);
  const oldEntry = r.body?.entries?.[0];
  check('old entries keep epoch 1 until re-encrypted', oldEntry?.epoch === 1, JSON.stringify(r));
  r = await call(C, 'POST', `${T}/entries`, { entries: [{ id: entryId, updatedAt: oldEntry.updatedAt, epoch: 2, ciphertext: await seal(key2, await open(key1, oldEntry.ciphertext, aad(1)), aad(2)) }] });
  check('re-encrypting under epoch 2 with the same time is accepted', r.body?.results?.[0]?.status === 'ok', JSON.stringify(r));
  r = await call(A, 'GET', `${T}/entries?since=0`);
  check('A decrypts the re-encrypted entry with the new key', r.body.entries[0].epoch === 2 && (await open(key2, r.body.entries[0].ciphertext, aad(2))).label === 'ops', JSON.stringify(r));

  r = await call(A, 'DELETE', `${T}/members/${A.pub}`);
  check('the admin cannot leave (409)', r.status === 409, JSON.stringify(r));
  r = await call(C, 'DELETE', `${T}/members/${C.pub}`);
  check('a member can leave (team needs rotation again)', r.status === 200 && r.body.needsRotation === true, JSON.stringify(r).slice(0, 200));
  r = await call(A, 'POST', `${T}/license`, { license: await teamLicense(`team1|sub_test|${yearOut + 86400}`) });
  check('admin refreshes the license', r.status === 200 && r.body.licenseEnd === (yearOut + 86400) * 1000, JSON.stringify(r).slice(0, 200));
  r = await call(extra[1], 'DELETE', T);
  check('only the admin deletes the team (403)', r.status === 403, JSON.stringify(r));
  r = await call(A, 'DELETE', T);
  check('admin deletes the team', r.status === 200);
  r = await call(A, 'GET', T);
  check('deleted team is gone (404)', r.status === 404, JSON.stringify(r));
}

console.log(`relay test against ${BASE}`);
const info = await fetch(BASE).then((r) => r.json());
check('service answers', info.service === 'tanooki-auth-relay');
await healthTests();
await syncTests();
await linkTests();
await emergencyTests();
await teamTests();
console.log(`\n${passed} passed, ${failed} failed`);
process.exit(failed ? 1 : 0);
