// node worker/test.mjs — runs the Worker with a fake Stripe and fake KV, then checks keys with Node's own Ed25519.
import assert from 'node:assert/strict';
import crypto from 'node:crypto';
import { readFileSync } from 'node:fs';
import worker, { appleLicense, inviteCode, makeLicense } from './src/index.js';
import { APPLE_ROOT_G3, verifyChain, verifyTransaction } from './src/apple.js';
import { checkTeamLicense } from '../relay/src/license.js';

const { publicKey, privateKey } = crypto.generateKeyPairSync('ed25519');
const seed = privateKey.export({ format: 'jwk' }).d;
const pub = publicKey.export({ format: 'jwk' }).x;
const std = (u) => Buffer.from(u, 'base64url').toString('base64');
const fakeKV = () => {
  const m = new Map();
  return { m, get: async (k) => m.get(k) ?? null, put: async (k, v) => { m.set(k, v); },
    list: async ({ prefix }) => ({ keys: [...m.keys()].filter((k) => k.startsWith(prefix)).sort().map((name) => ({ name })), list_complete: true }) };
};
const env = { STRIPE_KEY: 'rk_test', LICENSE_SEED: std(seed), LICENSE_PUBLIC: std(pub), INVITES: fakeKV(), FEEDBACK: fakeKV(), FEEDBACK_ADMIN: 'admin-secret-for-tests' };

const sessions = { cs_test_paid1234567890: { payment_status: 'paid', created: 1793145600, amount_subtotal: 500, amount_total: 540 },
  cs_test_family12345678: { payment_status: 'paid', created: 1793145600, amount_subtotal: 1000, amount_total: 1080 },
  cs_test_fivetax1234567: { payment_status: 'paid', created: 1793145600, amount_subtotal: 500, amount_total: 1040 }, cs_test_unpaid12345678: { payment_status: 'unpaid', created: 1 } };
const subs = {};
let subsForbidden = false; // a restricted key without subscription read rights
globalThis.fetch = async (url, opts) => {
  assert.equal(opts.headers.authorization, 'Bearer rk_test');
  const id = url.split('/').pop();
  const table = url.includes('/subscriptions/') ? subs : sessions;
  if (table === subs && subsForbidden) return new Response('{"error":{"type":"invalid_request_error"}}', { status: 403 });
  return table[id] ? new Response(JSON.stringify(table[id])) : new Response('{}', { status: 404 });
};
const get = (q) => worker.fetch(new Request(`https://x.dev/thanks${q}`), env);

const ok = await get('?session_id=cs_test_paid1234567890');
assert.equal(ok.status, 200);
const key = (await ok.text()).match(/TA1\.[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+/)[0];
const [, p, s] = key.split('.');
assert.equal(Buffer.from(p, 'base64url').toString(), '1|cs_test_paid1234567890|20261028');
assert.ok(crypto.verify(null, Buffer.from(p, 'base64url'), publicKey, Buffer.from(s, 'base64url')), 'signature verifies');
assert.equal(key, await makeLicense('cs_test_paid1234567890', 1793145600, env.LICENSE_SEED, env.LICENSE_PUBLIC), 'same key every visit');

assert.doesNotMatch(await (await get('?session_id=cs_test_paid1234567890')).text(), /family|up to 4/i, '$5 page unchanged');

// $10 family plan: payload gains |5, same signing key, $5 + tax is still a $5 key.
const famPage = await (await get('?session_id=cs_test_family12345678')).text();
const famKey = famPage.match(/TA1\.[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+/)[0];
const [, fp, fs] = famKey.split('.');
assert.equal(Buffer.from(fp, 'base64url').toString(), '1|cs_test_family12345678|20261028|5');
assert.ok(crypto.verify(null, Buffer.from(fp, 'base64url'), publicKey, Buffer.from(fs, 'base64url')), 'family signature verifies');
assert.match(famPage, /up to 4 other people/);
const taxed = (await (await get('?session_id=cs_test_fivetax1234567')).text()).match(/TA1\.([A-Za-z0-9_-]+)\./)[1];
assert.equal(Buffer.from(taxed, 'base64url').toString(), '1|cs_test_fivetax1234567|20261028', 'tax does not make a family key');

assert.equal((await get('?session_id=cs_test_unpaid12345678')).status, 402);
assert.equal((await get('?session_id=cs_test_nosuchsession1')).status, 404);
assert.equal((await get('?session_id=<script>')).status, 400);
assert.equal((await get('')).status, 400);
const privacy = await (await worker.fetch(new Request('https://x.dev/privacy'), env)).text();
assert.match(privacy, /collects nothing/);
assert.match(privacy, /Have I Been Pwned/);
assert.match(privacy, /end-to-end encrypted/);

const call = (path, init) => worker.fetch(new Request(`https://x.dev${path}`, init), env);
const payloadOf = (k) => Buffer.from(k.split('.')[1], 'base64url').toString();
const verifies = (k) => crypto.verify(null, Buffer.from(k.split('.')[1], 'base64url'), publicKey, Buffer.from(k.split('.')[2], 'base64url'));
const KEY_RE = /TA1\.[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+/;

// ---------- health (#49) ----------
const h = await call('/health');
const hb = await h.json();
assert.equal(h.status, 200);
assert.ok(hb.ok === true && hb.service === 'tanooki-auth-premium' && !Number.isNaN(Date.parse(hb.time)), 'health JSON');
assert.equal(h.headers.get('access-control-allow-origin'), '*', 'health CORS');

// ---------- gift (#40) ----------
sessions.cs_test_gift1234567890 = { payment_status: 'paid', created: 1793145600, amount_subtotal: 500, client_reference_id: 'gift' };
const giftPage = await (await get('?session_id=cs_test_gift1234567890')).text();
assert.match(giftPage, /A gift for you: Tanooki Auth Premium/);
assert.match(giftPage, /@media print\{.*main>\*:not\(\.gift\)\{display:none\}/, 'print CSS shows only the card');
assert.match(giftPage, /window\.print\(\)/);
assert.match(giftPage, /Already bought it\? Enter your license key/, 'recipient instructions');
assert.equal(payloadOf(giftPage.match(KEY_RE)[0]), '1|cs_test_gift1234567890|20261028');
assert.ok(verifies(giftPage.match(KEY_RE)[0]), 'gift key verifies');
assert.doesNotMatch(await (await get('?session_id=cs_test_paid1234567890')).text(), /gift for you|@media print/, 'normal page has no gift card');

// ---------- invites (#41) ----------
const myCode = (await (await call(`/invite?key=${key}`)).json());
assert.match(myCode.code, /^[A-HJ-NP-Z2-9]{8}$/);
assert.equal(myCode.code, await inviteCode('cs_test_paid1234567890', env.LICENSE_SEED), 'code comes from the order ID');
assert.equal(myCode.link, `https://buy.stripe.com/fZubJ3dsP5kv5xZ2kr1VK03?prefilled_promo_code=FRIEND20&client_reference_id=ref_${myCode.code}`);
assert.notEqual(myCode.code, await inviteCode('cs_test_family12345678', env.LICENSE_SEED), 'different order, different code');
assert.equal((await call('/invite?key=TA1.bogus.key')).status, 400);
const forgedKey = `TA1.${Buffer.from('1|cs_test_someoneelse1|20261028').toString('base64url')}.${key.split('.')[2]}`;
assert.equal((await call(`/invite?key=${forgedKey}`)).status, 400, 'key with a borrowed signature is refused');
const invitesNow = async (k = key) => (await call(`/invites?key=${k}`)).json();
assert.deepEqual(await invitesNow(), { code: myCode.code, count: 0, needed: 3 });
for (let i = 1; i <= 3; i++) sessions[`cs_test_referred${i}xxxxx`] = { payment_status: 'paid', created: 1793145600, amount_subtotal: 400, client_reference_id: `ref_${myCode.code}` };
sessions.cs_test_referredunpaid = { payment_status: 'unpaid', created: 1, client_reference_id: `ref_${myCode.code}` };
await get('?session_id=cs_test_referred1xxxxx');
await get('?session_id=cs_test_referred1xxxxx'); // reloading the thanks page does not count twice
await get('?session_id=cs_test_referredunpaid');
await get('?session_id=cs_test_referred2xxxxx');
let inv = await invitesNow();
assert.equal(inv.count, 2, 'deduped by session, unpaid ignored');
assert.equal(inv.familyKey, undefined, 'no family key before 3');
await get('?session_id=cs_test_referred3xxxxx');
inv = await invitesNow();
assert.equal(inv.count, 3);
assert.equal(payloadOf(inv.familyKey), '1|cs_test_paid1234567890|20261028|5', 'family key for the same order');
assert.ok(verifies(inv.familyKey), 'family key verifies');
assert.equal((await invitesNow(inv.familyKey)).familyKey, undefined, 'a family key is not upgraded again');
assert.deepEqual([...env.INVITES.m.keys()], [`ref:${myCode.code}`], 'KV holds only the code');
assert.deepEqual(Object.keys(JSON.parse(env.INVITES.m.get(`ref:${myCode.code}`))).sort(), ['count', 'sessions']);

// ---------- team license (#42 billing) ----------
const periodEnd = Math.floor(Date.now() / 1000) + 365 * 86400;
sessions.cs_test_team1234567890 = { payment_status: 'paid', mode: 'subscription', subscription: 'sub_test123456', created: 1793145600 };
subs.sub_test123456 = { id: 'sub_test123456', status: 'active', items: { data: [{ current_period_end: periodEnd }] } };
const teamPage = await (await call('/team-license?session_id=cs_test_team1234567890')).text();
const teamToken = teamPage.match(/TT1\.[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+/)[0];
assert.equal(payloadOf(teamToken), `team1|sub_test123456|${periodEnd}`);
assert.ok(verifies(teamToken), 'team token verifies');
assert.deepEqual(await checkTeamLicense(teamToken, env.LICENSE_PUBLIC), { subscription: 'sub_test123456', periodEnd: periodEnd * 1000 }, 'relay accepts the worker\'s token');
assert.equal((await checkTeamLicense(key, env.LICENSE_PUBLIC)).error, 'team license is malformed', 'relay refuses a Premium key as a team license');
assert.equal((await call('/team-license?session_id=cs_test_paid1234567890')).status, 400, 'one-time purchase is not a team subscription');
const refresh = (token) => call('/team-license/refresh', { method: 'POST', body: JSON.stringify({ token }) });
subs.sub_test123456.items.data[0].current_period_end = periodEnd + 1000;
let rr = await refresh(teamToken);
let rb = await rr.json();
assert.equal(rr.status, 200);
assert.equal(payloadOf(rb.token), `team1|sub_test123456|${periodEnd + 1000}`, 'refresh picks up the new period');
subs.sub_test123456.status = 'canceled';
rr = await refresh(teamToken);
assert.equal(rr.status, 402);
assert.equal((await rr.json()).status, 'canceled');
assert.equal((await refresh(teamToken.slice(0, -2) + 'AA')).status, 400, 'tampered team token');
assert.equal((await refresh(key)).status, 400, 'Premium key is not a team token');
subs.sub_test123456.status = 'active';
subsForbidden = true;
rr = await refresh(teamToken);
assert.equal(rr.status, 503);
assert.match((await rr.json()).error, /subscription read access/);
const forbiddenPage = await call('/team-license?session_id=cs_test_team1234567890');
assert.equal(forbiddenPage.status, 503);
assert.match(await forbiddenPage.text(), /subscription read access/);
subsForbidden = false;

// ---------- App Store (#39) ----------
const apple = JSON.parse(readFileSync(new URL('./test-fixtures/apple-library.json', import.meta.url)));
const real = apple.realChain;
// Real Apple certificates (from Apple's own library tests) chain to the root we embed, at the date Apple's test uses.
assert.equal(real.root, APPLE_ROOT_G3, 'Apple library root is byte-identical to the downloaded root');
await verifyChain([real.leaf, real.intermediate, real.root], real.effectiveDate);
const refused = async (p, re) => { try { await p; } catch (e) { assert.match(e.message, re); return; } assert.fail(`expected refusal ${re}`); };
await refused(verifyChain([real.leaf, real.intermediate, real.root], Date.UTC(2028, 0, 1)), /not valid when this was signed/);
await refused(verifyChain([real.intermediate, real.intermediate, real.root], real.effectiveDate), /not an App Store receipt signing certificate/);
await refused(verifyChain([real.leaf, real.leaf, real.root], real.effectiveDate), /not an Apple WWDR certificate/);
const badSig = Buffer.from(real.intermediate, 'base64');
badSig[badSig.length - 10] ^= 1;
await refused(verifyChain([real.leaf, badSig.toString('base64'), real.root], real.effectiveDate), /not signed by the root/);

// Apple's mock transaction (signed by Apple's test chain): signature checks out with its own test root, but it is
// for another app, and the live path refuses its root.
const mockRoot = JSON.parse(Buffer.from(apple.mockTransaction.split('.')[0], 'base64url')).x5c[2];
assert.equal((await verifyTransaction(apple.mockTransaction, [mockRoot])).bundleId, 'com.example');
assert.equal((await appleLicense(apple.mockTransaction, env, [mockRoot])).status, 403);
const iap = (signedTransaction) => call('/iap/apple', { method: 'POST', body: JSON.stringify({ signedTransaction }) });
let ir = await iap(apple.mockTransaction);
assert.equal(ir.status, 403);
assert.match((await ir.json()).error, /Apple Root CA - G3/, 'live endpoint trusts only Apple\'s root');

// Our own test-only chain (made with openssl, Apple's OIDs, throwaway root) for transactions about this app.
const tc = JSON.parse(readFileSync(new URL('./test-fixtures/test-chain.json', import.meta.url)));
const jws = (payload) => {
  const head = Buffer.from(JSON.stringify({ alg: 'ES256', x5c: [tc.leaf, tc.intermediate, tc.root] })).toString('base64url');
  const body = Buffer.from(JSON.stringify(payload)).toString('base64url');
  const sig = crypto.sign('sha256', Buffer.from(`${head}.${body}`), { key: tc.leafKey, dsaEncoding: 'ieee-p1363' }).toString('base64url');
  return `${head}.${body}.${sig}`;
};
const tx = { bundleId: 'com.tanookistudios.auth', productId: 'com.tanookistudios.auth.premium', originalTransactionId: '2000000123456789',
  transactionId: '2000000123456789', purchaseDate: 1793145600000, originalPurchaseDate: 1793145600000, signedDate: Date.now(), environment: 'Production', type: 'Non-Consumable' };
const viaTestCA = (payload) => appleLicense(typeof payload === 'string' ? payload : jws(payload), env, [tc.root]);
let a = await viaTestCA(tx);
let ab = await a.json();
assert.equal(a.status, 200, JSON.stringify(ab));
assert.equal(payloadOf(ab.key), '1|ios-2000000123456789|20261028');
assert.ok(verifies(ab.key) && ab.seats === 1);
ab = await (await viaTestCA({ ...tx, productId: 'com.tanookistudios.auth.family' })).json();
assert.equal(payloadOf(ab.key), '1|ios-2000000123456789|20261028|5', 'family product gives 5 seats');
const good = jws(tx);
const [gh, , gs] = good.split('.');
const tampered = `${gh}.${Buffer.from(JSON.stringify({ ...tx, productId: 'com.tanookistudios.auth.family' })).toString('base64url')}.${gs}`;
a = await viaTestCA(tampered);
assert.equal(a.status, 403);
assert.match((await a.json()).error, /signature is not valid/, 'tampered payload');
const flipped = Buffer.from(gs, 'base64url');
flipped[5] ^= 1;
a = await viaTestCA(`${gh}.${good.split('.')[1]}.${flipped.toString('base64url')}`);
assert.match((await a.json()).error, /signature is not valid/, 'tampered signature');
const reason = async (p) => (await (await viaTestCA(p)).json()).error;
assert.match(await reason({ ...tx, bundleId: 'com.example.other' }), /different app/);
assert.match(await reason({ ...tx, productId: 'com.tanookistudios.auth.coins' }), /not Tanooki Auth Premium/);
assert.match(await reason({ ...tx, revocationDate: Date.now() }), /refunded or revoked/);
assert.match(await reason({ ...tx, environment: 'Sandbox' }), /sandbox/i);
ir = await iap(good);
assert.equal(ir.status, 403, 'live endpoint refuses the test CA');
assert.match((await ir.json()).error, /Apple Root CA - G3/);
assert.equal((await iap('not.a.jws')).status, 400);
assert.equal((await call('/iap/apple', { method: 'POST', body: '{}' })).status, 400);

// ---------- feedback (#46) ----------
const post = (body, ip = '203.0.113.7') => call('/feedback', { method: 'POST', headers: { 'cf-connecting-ip': ip }, body: typeof body === 'string' ? body : JSON.stringify(body) });
const fb = { message: 'Love it. Dark mode on the widget please.', platform: 'ios', appVersion: '0.3.0' };
let f = await post(fb);
assert.equal(f.status, 201);
assert.equal(f.headers.get('access-control-allow-origin'), '*');
const pre = await call('/feedback', { method: 'OPTIONS' });
assert.equal(pre.status, 204);
assert.equal(pre.headers.get('access-control-allow-origin'), '*');
for (let i = 0; i < 4; i++) assert.equal((await post({ ...fb, contact: 'me@example.com' })).status, 201);
assert.equal((await post(fb)).status, 429, '6th in an hour from one address');
assert.equal((await post(fb, '198.51.100.9')).status, 201, 'another address is fine');
assert.equal((await post({ ...fb, message: 'x'.repeat(4100) }, '198.51.100.10')).status, 413);
assert.equal((await post({ platform: 'ios', appVersion: '1' }, '198.51.100.11')).status, 400);
assert.equal((await post('not json', '198.51.100.12')).status, 400);
const stored = [...env.FEEDBACK.m.entries()].join('\n');
assert.doesNotMatch(stored, /203\.0\.113\.7|198\.51\.100\.9/, 'raw IPs are never stored');
const list = (auth) => call('/feedback/list', { headers: auth ? { authorization: auth } : {} });
assert.equal((await list()).status, 401);
assert.equal((await list('Bearer admin-secret-for-test')).status, 401, 'near-miss token');
const lr = await list('Bearer admin-secret-for-tests');
const entries = (await lr.json()).entries;
assert.equal(lr.status, 200);
assert.equal(entries.length, 6);
assert.deepEqual(Object.keys(entries.find((e) => !e.contact)).sort(), ['appVersion', 'at', 'message', 'platform'], 'only these fields are stored');
assert.equal(entries.filter((e) => e.contact === 'me@example.com').length, 4);
assert.equal((await worker.fetch(new Request('https://x.dev/feedback/list'), { ...env, FEEDBACK_ADMIN: undefined })).status, 503);

console.log('worker tests passed; sample key', key.slice(0, 24) + '…');
