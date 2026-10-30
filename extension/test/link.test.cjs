// "Add account" over the phone link (link.js requestAdd) against an in-memory relay and a scripted phone.
// Run from the repo root: node --test extension/test/link.test.cjs
const test = require('node:test');
const assert = require('node:assert');
const { webcrypto: crypto } = require('node:crypto');
const { makeLink } = require('../link.js');

const { subtle } = crypto;
const te = new TextEncoder();
const b64u = (b) => Buffer.from(b).toString('base64url');
const unb64u = (s) => new Uint8Array(Buffer.from(s, 'base64url'));
const URI = 'otpauth://totp/Site:me?secret=ONSWG4TFORZWK3DFMNZGK5DTMVRXEZLU&issuer=Site';

// A paired link (as after PROTOCOL.md 2.1), plus the phone's half of the keys.
async function pairedLink(phoneAnswers) {
  const ext = await subtle.generateKey({ name: 'X25519' }, true, ['deriveBits']);
  const ph = await subtle.generateKey({ name: 'X25519' }, true, ['deriveBits']);
  let st = {
    relay: 'https://relay.invalid', roomId: b64u(crypto.getRandomValues(new Uint8Array(32))), paired: true, cursor: 0,
    extPub: b64u(await subtle.exportKey('raw', ext.publicKey)), extPriv: b64u(await subtle.exportKey('pkcs8', ext.privateKey)),
    phoneKey: b64u(await subtle.exportKey('raw', ph.publicKey)), pairSecret: b64u(crypto.getRandomValues(new Uint8Array(32))), extToken: 't',
  };
  const shared = await subtle.deriveBits({ name: 'X25519', public: ext.publicKey }, ph.privateKey, 256);
  const hk = await subtle.importKey('raw', shared, 'HKDF', false, ['deriveBits']);
  const okm = new Uint8Array(await subtle.deriveBits({ name: 'HKDF', hash: 'SHA-256', salt: unb64u(st.pairSecret), info: te.encode(`TA-LINK-1|${st.roomId}|${st.extPub}|${st.phoneKey}`) }, hk, 512));
  const e2p = await subtle.importKey('raw', okm.slice(0, 32), 'AES-GCM', false, ['decrypt']);
  const p2e = await subtle.importKey('raw', okm.slice(32), 'AES-GCM', false, ['encrypt']);
  const aad = (dir) => ({ additionalData: te.encode(`TA-LINK-1|${st.roomId}|${dir}`) });

  const relay = { toPhone: [], toExt: [], seq: 0 };
  const fetchFn = async (url, { method, body }) => {
    const json = (o) => ({ status: 200, json: async () => o });
    if (method === 'POST') {
      const { ciphertext } = JSON.parse(body);
      relay.toPhone.push(ciphertext);
      const all = unb64u(ciphertext);
      const msg = JSON.parse(Buffer.from(await subtle.decrypt({ name: 'AES-GCM', iv: all.slice(0, 12), ...aad('e2p') }, e2p, all.slice(12))));
      for (const answer of phoneAnswers(msg)) {
        const iv = crypto.getRandomValues(new Uint8Array(12));
        const plain = te.encode(JSON.stringify({ ...answer, re: msg.id, id: b64u(crypto.getRandomValues(new Uint8Array(16))), ts: Date.now() }));
        const ct = new Uint8Array(await subtle.encrypt({ name: 'AES-GCM', iv, ...aad('p2e') }, p2e, plain));
        relay.toExt.push({ id: ++relay.seq, from: 'phone', ciphertext: b64u([...iv, ...ct]) });
      }
      return json({ push: 'sent' });
    }
    if (method === 'GET') return json({ messages: relay.toExt.splice(0), cursor: relay.seq });
    return json({});
  };
  const link = makeLink({ storage: { get: async () => st, set: async (s) => { st = s; }, clear: async () => { st = null; } }, fetchFn, crypto, pollMs: 5 });
  return { link, relay };
}

test('the phone confirms: add-request carries the URI end to end, add-result comes back', async () => {
  let asked;
  const { link, relay } = await pairedLink((msg) => { asked = msg; return msg.t === 'add-request' ? [{ t: 'add-result', accepted: true }] : []; });
  const r = await link.requestAdd(URI, { timeoutMs: 2000 });
  assert.deepStrictEqual(r, { accepted: true, reason: '' });
  assert.strictEqual(asked.t, 'add-request');
  assert.strictEqual(asked.uri, URI);
  assert.ok(!relay.toPhone.join().includes('ONSWG4TF'), 'the relay only ever sees ciphertext');
});

test('the phone taps Deny', async () => {
  const { link } = await pairedLink(() => [{ t: 'deny' }]);
  await assert.rejects(link.requestAdd(URI, { timeoutMs: 2000 }), (e) => e.code === 'denied');
});

test('an older phone app ignores the request: clear message telling Maddie to update', async () => {
  const { link } = await pairedLink(() => []);
  await assert.rejects(link.requestAdd(URI, { timeoutMs: 100 }), (e) => e.code === 'timeout' && /update the app on your phone/.test(e.message));
});

test('code requests still work through the shared path', async () => {
  const { link } = await pairedLink((msg) => (msg.t === 'fill-request' ? [{ t: 'code', code: '123456', domain: msg.host, issuer: 'X', expiresIn: 12 }] : []));
  assert.deepStrictEqual(await link.requestCode('site.test', { timeoutMs: 2000 }), { code: '123456', domain: 'site.test', issuer: 'X', expiresIn: 12 });
});
