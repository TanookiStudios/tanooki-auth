// End-to-end test of the relay with real client crypto (Ed25519, X25519, HKDF, AES-256-GCM), as PROTOCOL.md describes.
//   node relay/test.mjs http://localhost:8787
//   node relay/test.mjs https://tanooki-auth-relay.kirbymail.workers.dev
// Set EXPECT_PUSH=1 once push secrets are installed: the push-token check then expects 200 instead of 503.
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
  if (process.env.EXPECT_PUSH) check('push token registers (200)', r.status === 200, JSON.stringify(r));
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

console.log(`relay test against ${BASE}`);
const info = await fetch(BASE).then((r) => r.json());
check('service answers', info.service === 'tanooki-auth-relay');
await syncTests();
await linkTests();
console.log(`\n${passed} passed, ${failed} failed`);
process.exit(failed ? 1 : 0);
