// node worker/test-growth.mjs (also run at the end of worker/test.mjs) — newsletter, student discount and affiliates,
// with a fake Stripe, a fake Resend and fake KV. Nothing leaves this machine.
import assert from 'node:assert/strict';
import crypto from 'node:crypto';
import worker, { makeLicense } from './src/index.js';
import { PAYMENT_LINK } from './src/growth.js';
import { isSchoolDomain } from './src/schools.js';

const { publicKey, privateKey } = crypto.generateKeyPairSync('ed25519');
const std = (u) => Buffer.from(u, 'base64url').toString('base64');
const fakeKV = () => {
  const m = new Map();
  return { m, get: async (k) => { const v = m.get(k) ?? null; await new Promise((r) => setTimeout(r, 1)); return v; },
    put: async (k, v, opts) => { m.set(k, v); if (opts?.expirationTtl) m.set(`ttl?${k}`, opts.expirationTtl); else m.delete(`ttl?${k}`); }, delete: async (k) => { m.delete(k); m.delete(`ttl?${k}`); },
    list: async ({ prefix }) => ({ keys: [...m.keys()].filter((k) => k.startsWith(prefix)).sort().map((name) => ({ name })), list_complete: true }) };
};
const env = { STRIPE_KEY: 'rk_test', LICENSE_SEED: std(privateKey.export({ format: 'jwk' }).d), LICENSE_PUBLIC: std(publicKey.export({ format: 'jwk' }).x),
  INVITES: fakeKV(), FEEDBACK: fakeKV(), SUBSCRIBERS: fakeKV(), GROWTH: fakeKV(),
  EMAIL_FROM: 'Tanooki Auth <hello@tanookistudios.com>', RESEND_API_KEY: 're_test', SUBSCRIBERS_ADMIN: 'subs-admin-test', AFFILIATES_ADMIN: 'aff-admin-test', STUDENT_COUPON_READY: 'yes' };

const sessions = {};
const outbox = [];
let resendDown = false;
globalThis.fetch = async (url, opts) => {
  if (url === 'https://api.resend.com/emails') {
    assert.equal(opts.headers.authorization, 'Bearer re_test');
    if (resendDown) return new Response('{"message":"internal"}', { status: 500 });
    outbox.push(JSON.parse(opts.body));
    return new Response(JSON.stringify({ id: `em_${outbox.length}` }));
  }
  assert.equal(opts.headers.authorization, 'Bearer rk_test');
  const s = sessions[url.split('/').pop()];
  return s ? new Response(JSON.stringify(s)) : new Response('{}', { status: 404 });
};
const call = (path, init = {}, e = env) => worker.fetch(new Request(`https://x.dev${path}`, init), e);
const postJSON = (path, body, ip = '203.0.113.7', e = env, headers = {}) =>
  call(path, { method: 'POST', headers: { 'cf-connecting-ip': ip, 'content-type': 'application/json', ...headers }, body: typeof body === 'string' ? body : JSON.stringify(body) }, e);
const tokenIn = (text, path) => text.match(new RegExp(`${path.replace('/', '\\/')}\\?token=([0-9a-f]{48})`))[1];
const allStored = (kv) => [...kv.m.entries()].join('\n');

// ---------- email not set up ----------
const noEmail = { ...env, RESEND_API_KEY: undefined, SUBSCRIBERS: fakeKV(), GROWTH: fakeKV() };
for (const [path, email] of [['/subscribe', 'pat@example.com'], ['/student', 'pat@mit.edu']]) {
  const r = await postJSON(path, { email }, '203.0.113.1', noEmail);
  assert.equal(r.status, 503, path);
  assert.match((await r.json()).error, /^Email sending isn't set up yet/, `${path} says email isn't set up`);
}
assert.equal(noEmail.SUBSCRIBERS.m.size + noEmail.GROWTH.m.size, 0, 'nothing stored when email is not set up');

// ---------- newsletter (#40) ----------
for (const bad of ['', 'nope', 'a@b', 'a b@example.com', '<x>@example.com', `${'a'.repeat(250)}@example.com`]) {
  assert.equal((await postJSON('/subscribe', { email: bad })).status, 400, `refuses ${JSON.stringify(bad)}`);
}
assert.equal((await postJSON('/subscribe', 'not json')).status, 400);
let r = await postJSON('/subscribe', { email: '  Pat@Example.com ' });
assert.equal(r.status, 200);
assert.equal(r.headers.get('access-control-allow-origin'), '*', 'the site can read the answer');
assert.equal(outbox.length, 1);
const confirmMail = outbox[0];
assert.deepEqual(confirmMail.to, ['pat@example.com']);
assert.equal(confirmMail.from, 'Tanooki Auth <hello@tanookistudios.com>');
const subToken = tokenIn(confirmMail.text, '/subscribe/confirm');
assert.equal(confirmMail.headers['List-Unsubscribe'], `<https://x.dev/unsubscribe?token=${subToken}>`, 'List-Unsubscribe header');
assert.equal(confirmMail.headers['List-Unsubscribe-Post'], 'List-Unsubscribe=One-Click');
assert.match(confirmMail.html, new RegExp(`/unsubscribe\\?token=${subToken}`), 'unsubscribe link in the email body');
assert.equal(JSON.parse(env.SUBSCRIBERS.m.get('sub:pat@example.com')).status, 'pending');
assert.equal(env.SUBSCRIBERS.m.get('ttl?sub:pat@example.com'), 7 * 86400, 'pending signups expire');
const exportList = async (auth) => call('/subscribers/export', { headers: auth ? { authorization: auth } : {} });
assert.equal((await exportList()).status, 401);
assert.equal((await exportList('Bearer subs-admin-tes')).status, 401, 'near-miss token');
assert.deepEqual((await (await exportList('Bearer subs-admin-test')).json()).subscribers, [], 'pending is not exported');
assert.equal((await call('/subscribe/confirm?token=' + 'f'.repeat(48))).status, 404, 'unknown token');
assert.equal((await call('/subscribe/confirm?token=<script>')).status, 404);
r = await call(`/subscribe/confirm?token=${subToken}`);
assert.equal(r.status, 200);
assert.match(await r.text(), /You're signed up/);
assert.equal(env.SUBSCRIBERS.m.get('ttl?sub:pat@example.com'), undefined, 'confirmed signups do not expire');
const ex = await (await exportList('Bearer subs-admin-test')).json();
assert.equal(ex.count, 1);
assert.equal(ex.subscribers[0].email, 'pat@example.com');
// Signing up again once confirmed sends nothing and answers the same as a new signup.
r = await postJSON('/subscribe', { email: 'pat@example.com' }, '198.51.100.2');
assert.equal(r.status, 200);
assert.equal(outbox.length, 1, 'no second email to a confirmed address');
// Rate limits: 5 an hour per connection; 3 a day per address.
for (let i = 0; i < 4; i++) assert.equal((await postJSON('/subscribe', { email: `p${i}@example.com` }, '203.0.113.50')).status, 200);
assert.equal((await postJSON('/subscribe', { email: 'p9@example.com' }, '203.0.113.50')).status, 200);
assert.equal((await postJSON('/subscribe', { email: 'p10@example.com' }, '203.0.113.50')).status, 429, '6th signup in an hour from one connection');
for (let i = 0; i < 3; i++) assert.equal((await postJSON('/subscribe', { email: 'victim@example.com' }, `198.51.100.${10 + i}`)).status, 200);
assert.equal((await postJSON('/subscribe', { email: 'victim@example.com' }, '198.51.100.20')).status, 429, '4th email to one address in a day');
assert.doesNotMatch(allStored(env.SUBSCRIBERS), /203\.0\.113|198\.51\.100/, 'raw IPs are never stored');
// Resend failing is reported, not hidden.
resendDown = true;
r = await postJSON('/subscribe', { email: 'down@example.com' }, '192.0.2.1');
assert.equal(r.status, 502);
assert.match((await r.json()).error, /couldn't send the confirmation email/);
resendDown = false;
// One-click unsubscribe deletes the address, by GET (link) or POST (mail app button).
r = await call(`/unsubscribe?token=${subToken}`, { method: 'POST' });
assert.equal(r.status, 200);
assert.equal(env.SUBSCRIBERS.m.has('sub:pat@example.com'), false, 'unsubscribe deletes the address');
assert.equal((await (await exportList('Bearer subs-admin-test')).json()).count, 0);
assert.equal((await call(`/unsubscribe?token=${subToken}`)).status, 200, 'unsubscribing twice is fine');
assert.equal((await call('/subscribers/export', {}, { ...env, SUBSCRIBERS_ADMIN: undefined })).status, 503);

// ---------- student discount (#42) ----------
for (const d of ['mit.edu', 'cs.stanford.edu', 'ox.ac.uk', 'unimelb.edu.au', 'u-tokyo.ac.jp', 'ethz.ch', 'student.ethz.ch']) assert.ok(isSchoolDomain(d), d);
for (const d of ['gmail.com', 'edu', 'mit.edu.evil.com', 'notethz.ch', 'ac.uk', 'example.education']) assert.ok(!isSchoolDomain(d), d);
r = await postJSON('/student', { email: 'pat@gmail.com' });
assert.equal(r.status, 403);
assert.match((await r.json()).error, /school email/);
assert.equal((await postJSON('/student', { email: 'nope' })).status, 400);
const sent = outbox.length;
r = await postJSON('/student', { email: 'Pat@MIT.edu' }, '203.0.113.60');
assert.equal(r.status, 200);
const studentMail = outbox[sent];
assert.deepEqual(studentMail.to, ['pat@mit.edu']);
const stuToken = tokenIn(studentMail.text, '/student/claim');
assert.equal(env.GROWTH.m.get(`ttl?stu:${stuToken}`), 7 * 86400, 'student links expire after 7 days');
assert.doesNotMatch(allStored(env.GROWTH), /mit\.edu|203\.0\.113/, 'the student email and IP are not stored');
// Switched off until the STUDENT50 coupon exists: explains, and does not use up the link.
r = await call(`/student/claim?token=${stuToken}`, {}, { ...env, STUDENT_COUPON_READY: 'no' });
assert.equal(r.status, 503);
assert.match(await r.text(), /isn't switched on yet/);
r = await call(`/student/claim?token=${stuToken}`);
assert.equal(r.status, 302);
assert.equal(r.headers.get('location'), `${PAYMENT_LINK}?prefilled_promo_code=STUDENT50&client_reference_id=student`);
r = await call(`/student/claim?token=${stuToken}`);
assert.equal(r.status, 410, 'single use');
assert.match(await r.text(), /already been used or has expired/);
assert.equal((await call('/student/claim?token=abc')).status, 410);
assert.equal((await postJSON('/student', { email: 'pat@mit.edu' }, '203.0.113.61')).status, 200);
assert.equal((await postJSON('/student', { email: 'pat@mit.edu' }, '203.0.113.62')).status, 429, '3rd link to one address in a day');
for (let i = 0; i < 4; i++) await postJSON('/student', { email: `s${i}@ox.ac.uk` }, '203.0.113.70');
assert.equal((await postJSON('/student', { email: 's9@ox.ac.uk' }, '203.0.113.70')).status, 200);
assert.equal((await postJSON('/student', { email: 's10@ox.ac.uk' }, '203.0.113.70')).status, 429, '6th request in an hour from one connection');
resendDown = true;
const before = [...env.GROWTH.m.keys()].filter((k) => k.startsWith('stu:')).length;
assert.equal((await postJSON('/student', { email: 'x@ox.ac.uk' }, '192.0.2.9')).status, 502);
assert.equal([...env.GROWTH.m.keys()].filter((k) => k.startsWith('stu:')).length, before, 'a link that was never emailed is removed');
resendDown = false;
// A student checkout still gets a normal key.
sessions.cs_test_student12345678 = { payment_status: 'paid', created: 1793145600, amount_subtotal: 500, amount_total: 270, total_details: { amount_discount: 250 }, client_reference_id: 'student' };
r = await call('/thanks?session_id=cs_test_student12345678');
assert.equal(r.status, 200);
assert.match(await r.text(), /Here's your license key/);

// ---------- affiliates (#43) ----------
const admin = { authorization: 'Bearer aff-admin-test' };
const add = (body, headers = admin) => postJSON('/affiliates', body, '203.0.113.1', env, headers);
assert.equal((await add({ name: 'Sam', code: 'samtech' }, {})).status, 401);
assert.equal((await add({ name: 'Sam', code: 'samtech' }, { authorization: 'Bearer aff-admin-tes' })).status, 401, 'near-miss token');
assert.equal((await add({ name: 'Sam', code: 'no' })).status, 400);
assert.equal((await add({ name: 'Sam', code: 'has space' })).status, 400);
assert.equal((await add({ code: 'samtech' })).status, 400);
r = await add({ name: 'Sam Tech', code: 'SamTech' });
assert.equal(r.status, 201);
const sam = await r.json();
assert.equal(sam.link, `${PAYMENT_LINK}?client_reference_id=aff_samtech`);
assert.equal((await add({ name: 'Other', code: 'samtech' })).status, 409, 'codes are unique');
await add({ name: 'Quiet Creator', code: 'quiet' });
// The affiliate link uses the same Payment Link as invites.
const lic = await makeLicense('cs_test_owner123456789', 1793145600, env.LICENSE_SEED, env.LICENSE_PUBLIC);
assert.equal((await (await call(`/invite?key=${lic}`)).json()).link.split('?')[0], PAYMENT_LINK, 'growth.js PAYMENT_LINK matches index.js');

const nov = Date.UTC(2026, 10, 5) / 1000;
const oct = Date.UTC(2026, 9, 20) / 1000;
sessions.cs_test_aff1xxxxxxxxxxx = { payment_status: 'paid', created: nov, amount_subtotal: 500, amount_total: 540, currency: 'usd', client_reference_id: 'aff_samtech' };
sessions.cs_test_aff2xxxxxxxxxxx = { payment_status: 'paid', created: nov, amount_subtotal: 1000, amount_total: 1080, currency: 'usd', client_reference_id: 'aff_samtech' };
sessions.cs_test_aff3xxxxxxxxxxx = { payment_status: 'paid', created: oct, amount_subtotal: 500, amount_total: 540, currency: 'usd', client_reference_id: 'aff_samtech' };
sessions.cs_test_affunpaidxxxxxx = { payment_status: 'unpaid', created: nov, amount_subtotal: 500, client_reference_id: 'aff_samtech' };
sessions.cs_test_affunknownxxxxx = { payment_status: 'paid', created: nov, amount_subtotal: 500, client_reference_id: 'aff_nobody' };
const thanks = (id) => call(`/thanks?session_id=${id}`);
// Two sales landing at the same instant both count; a reload does not count twice.
await Promise.all([thanks('cs_test_aff1xxxxxxxxxxx'), thanks('cs_test_aff2xxxxxxxxxxx')]);
await thanks('cs_test_aff1xxxxxxxxxxx');
await thanks('cs_test_aff3xxxxxxxxxxx');
assert.equal((await thanks('cs_test_affunpaidxxxxxx')).status, 402);
const famPage = await (await thanks('cs_test_aff2xxxxxxxxxxx')).text();
assert.match(famPage, /up to 4 other people/, 'affiliate family sale still gets a family key');
assert.equal((await thanks('cs_test_affunknownxxxxx')).status, 200, 'unknown affiliate code still gets a key');
assert.deepEqual([...env.GROWTH.m.keys()].filter((k) => k.startsWith('affsale:')).sort(),
  ['affsale:samtech:cs_test_aff1xxxxxxxxxxx', 'affsale:samtech:cs_test_aff2xxxxxxxxxxx', 'affsale:samtech:cs_test_aff3xxxxxxxxxxx'], 'one key per paid sale, known codes only');

const report = async (q, headers = admin) => call(`/affiliates/report${q}`, { headers });
assert.equal((await report('?month=2026-11', {})).status, 401);
assert.equal((await report('?month=2026-13')).status, 400);
const rep = await (await report('?month=2026-11')).json();
const samRow = rep.affiliates.find((a) => a.code === 'samtech');
assert.deepEqual({ sales: samRow.sales, revenue: samRow.revenue, owed: samRow.owed, name: samRow.name }, { sales: 2, revenue: 1500, owed: 450, name: 'Sam Tech' }, 'November: 2 sales, $15, owed $4.50 (before tax)');
assert.deepEqual(samRow.sessions.map((x) => x.session).sort(), ['cs_test_aff1xxxxxxxxxxx', 'cs_test_aff2xxxxxxxxxxx']);
assert.deepEqual(rep.affiliates.find((a) => a.code === 'quiet'), { code: 'quiet', name: 'Quiet Creator', sales: 0, revenue: 0, owed: 0, sessions: [] }, 'creators with no sales are listed with zero');
assert.equal((await (await report('?month=2026-10')).json()).affiliates.find((a) => a.code === 'samtech').owed, 150, 'October counted separately');
// Discounts come off before the 30%.
sessions.cs_test_affdiscountxxxx = { payment_status: 'paid', created: nov, amount_subtotal: 500, amount_total: 270, total_details: { amount_discount: 250 }, client_reference_id: 'aff_quiet' };
await thanks('cs_test_affdiscountxxxx');
assert.equal((await (await report('?month=2026-11')).json()).affiliates.find((a) => a.code === 'quiet').revenue, 250, 'revenue is after discount');

// Private stats page.
const statsPath = new URL(sam.statsPage).pathname + new URL(sam.statsPage).search;
r = await call(statsPath);
assert.equal(r.status, 200);
const stats = await r.text();
assert.match(stats, /Hi Sam Tech/);
assert.match(stats, /<td>2026-11<\/td><td class="n">2<\/td><td class="n">\$15\.00<\/td><td class="n">\$4\.50<\/td>/, 'November row');
assert.match(stats, /All time<\/b><\/td><td class="n">3<\/td><td class="n">\$20\.00<\/td><td class="n">\$6\.00<\/td>/, 'all-time row');
assert.equal(r.headers.get('referrer-policy'), 'no-referrer', 'the private key never leaks in a Referer header');
assert.equal((await call('/affiliate/samtech?key=wrong')).status, 404, 'wrong key');
assert.equal((await call('/affiliate/samtech')).status, 404, 'no key');
assert.equal((await call(`/affiliate/quiet${new URL(sam.statsPage).search}`)).status, 404, "one creator's key does not open another's page");

// The existing client_reference_id uses are untouched: gift and invites still work alongside affiliates.
sessions.cs_test_giftaffxxxxxxxx = { payment_status: 'paid', created: nov, amount_subtotal: 500, client_reference_id: 'gift' };
assert.match(await (await thanks('cs_test_giftaffxxxxxxxx')).text(), /A gift for you/);

console.log('growth tests passed');
