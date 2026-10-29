// node worker/test.mjs — runs the Worker with a fake Stripe, then checks the key with Node's own Ed25519.
import assert from 'node:assert/strict';
import crypto from 'node:crypto';
import worker, { makeLicense } from './src/index.js';

const { publicKey, privateKey } = crypto.generateKeyPairSync('ed25519');
const seed = privateKey.export({ format: 'jwk' }).d;
const pub = publicKey.export({ format: 'jwk' }).x;
const std = (u) => Buffer.from(u, 'base64url').toString('base64');
const env = { STRIPE_KEY: 'rk_test', LICENSE_SEED: std(seed), LICENSE_PUBLIC: std(pub) };

const sessions = { cs_test_paid1234567890: { payment_status: 'paid', created: 1793145600 }, cs_test_unpaid12345678: { payment_status: 'unpaid', created: 1 } };
globalThis.fetch = async (url, opts) => {
  assert.equal(opts.headers.authorization, 'Bearer rk_test');
  const id = url.split('/').pop();
  return sessions[id] ? new Response(JSON.stringify(sessions[id])) : new Response('{}', { status: 404 });
};
const get = (q) => worker.fetch(new Request(`https://x.dev/thanks${q}`), env);

const ok = await get('?session_id=cs_test_paid1234567890');
assert.equal(ok.status, 200);
const key = (await ok.text()).match(/TA1\.[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+/)[0];
const [, p, s] = key.split('.');
assert.equal(Buffer.from(p, 'base64url').toString(), '1|cs_test_paid1234567890|20261028');
assert.ok(crypto.verify(null, Buffer.from(p, 'base64url'), publicKey, Buffer.from(s, 'base64url')), 'signature verifies');
assert.equal(key, await makeLicense('cs_test_paid1234567890', 1793145600, env.LICENSE_SEED, env.LICENSE_PUBLIC), 'same key every visit');

assert.equal((await get('?session_id=cs_test_unpaid12345678')).status, 402);
assert.equal((await get('?session_id=cs_test_nosuchsession1')).status, 404);
assert.equal((await get('?session_id=<script>')).status, 400);
assert.equal((await get('')).status, 400);
assert.match(await (await worker.fetch(new Request('https://x.dev/privacy'), env)).text(), /collects nothing/);
console.log('worker tests passed; sample key', key.slice(0, 24) + '…');
