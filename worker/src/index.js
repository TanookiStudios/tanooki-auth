// After a $5 (or $10 family) Stripe Checkout, Stripe sends the buyer to /thanks?session_id=cs_...
// We ask Stripe whether that session is paid, then show a license key for it. Ed25519 signatures are
// deterministic and the payload only uses the session, so revisiting the link shows the same key.
// Also here: App Store purchases (/iap/apple), invites, team licenses, feedback and /health.
import { PRODUCTS, BUNDLE_ID, Refused, verifyTransaction } from './apple.js';

const b64url = (bytes) => btoa(String.fromCharCode(...new Uint8Array(bytes))).replace(/\+/g, '-').replace(/\//g, '_').replace(/=+$/, '');
const fromB64 = (s) => Uint8Array.from(atob(s.replace(/-/g, '+').replace(/_/g, '/')), (c) => c.charCodeAt(0));
const te = (s) => new TextEncoder().encode(s);
const sha256 = async (s) => new Uint8Array(await crypto.subtle.digest('SHA-256', te(s)));
const hex = (b) => [...b].map((x) => x.toString(16).padStart(2, '0')).join('');

// The $5 Payment Link (checkoutUrl in app/lib/ui/premium.dart). Invite links add a promo code and referral tag.
const PAYMENT_LINK = 'https://buy.stripe.com/fZubJ3dsP5kv5xZ2kr1VK03';
const INVITE_CODE = /^[A-HJ-NP-Z2-9]{8}$/;
const CODE_ALPHABET = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
const REFERRALS_FOR_FAMILY = 3;

// Signs `text` with the license key: base64url(text) + '.' + base64url(signature).
async function signPayload(text, seedB64, publicB64) {
  const key = await crypto.subtle.importKey(
    'jwk',
    { kty: 'OKP', crv: 'Ed25519', d: b64url(fromB64(seedB64)), x: b64url(fromB64(publicB64)) },
    { name: 'Ed25519' },
    false,
    ['sign'],
  );
  return `${b64url(te(text))}.${b64url(await crypto.subtle.sign({ name: 'Ed25519' }, key, te(text)))}`;
}

// Returns the payload text when `p.s` is signed by our key, else null.
async function openSigned(p, s, publicB64) {
  try {
    const key = await crypto.subtle.importKey('raw', fromB64(publicB64), { name: 'Ed25519' }, false, ['verify']);
    const payload = fromB64(p);
    return (await crypto.subtle.verify({ name: 'Ed25519' }, key, fromB64(s), payload)) ? new TextDecoder().decode(payload) : null;
  } catch {
    return null;
  }
}

export async function makeLicense(orderId, created, seedB64, publicB64, seats = 1) {
  const d = new Date(created * 1000);
  const ymd = `${d.getUTCFullYear()}${String(d.getUTCMonth() + 1).padStart(2, '0')}${String(d.getUTCDate()).padStart(2, '0')}`;
  // Family keys add `|seats`; $5 keys keep the original three fields so they stay byte-identical.
  return `TA1.${await signPayload(`1|${orderId}|${ymd}${seats > 1 ? `|${seats}` : ''}`, seedB64, publicB64)}`;
}

// A genuine license key -> { orderId, created (seconds), seats }; anything else -> null.
export async function readLicense(key, publicB64) {
  const [tag, p, s, extra] = String(key || '').trim().split('.');
  if (tag !== 'TA1' || !p || !s || extra !== undefined) return null;
  const text = await openSigned(p, s, publicB64);
  const [v, orderId, ymd, seats] = text?.split('|') ?? [];
  if (v !== '1' || !orderId || !/^\d{8}$/.test(ymd)) return null;
  return { orderId, created: Date.UTC(+ymd.slice(0, 4), +ymd.slice(4, 6) - 1, +ymd.slice(6, 8)) / 1000, seats: Number(seats || 1) };
}

// Team license token for the relay: TT1.<base64url "team1|<subscriptionId>|<periodEnd seconds>">.<signature>
export const makeTeamLicense = async (subscription, periodEnd, env) => `TT1.${await signPayload(`team1|${subscription}|${periodEnd}`, env.LICENSE_SEED, env.LICENSE_PUBLIC)}`;

// Invite code: 8 characters from HMAC(key derived from LICENSE_SEED, orderId). Same order -> same code, and
// nobody can guess another buyer's code without the seed.
export async function inviteCode(orderId, seedB64) {
  const base = await crypto.subtle.importKey('raw', fromB64(seedB64), 'HKDF', false, ['deriveKey']);
  const key = await crypto.subtle.deriveKey(
    { name: 'HKDF', hash: 'SHA-256', salt: new Uint8Array(), info: te('TA-INVITE-CODE-1') },
    base,
    { name: 'HMAC', hash: 'SHA-256', length: 256 },
    false,
    ['sign'],
  );
  const mac = new Uint8Array(await crypto.subtle.sign('HMAC', key, te(orderId)));
  return [...mac.subarray(0, 8)].map((b) => CODE_ALPHABET[b & 31]).join('');
}

// Constant time: hash both sides to equal-length digests, then compare every byte.
async function sameSecret(a, b) {
  const [x, y] = await Promise.all([sha256(String(a)), sha256(String(b))]);
  let diff = 0;
  for (let i = 0; i < x.length; i++) diff |= x[i] ^ y[i];
  return diff === 0;
}

const CORS = {
  'access-control-allow-origin': '*',
  'access-control-allow-methods': 'GET, POST, OPTIONS',
  'access-control-allow-headers': 'authorization, content-type',
  'access-control-max-age': '86400',
};
const json = (obj, status = 200) => new Response(JSON.stringify(obj), { status, headers: { 'content-type': 'application/json', 'cache-control': 'no-store', ...CORS } });
const fail = (status, error, extra = {}) => json({ error, ...extra }, status);

const PRIVACY = `<h1>Privacy policy</h1><p>Tanooki Auth, by Tanooki Studios. Last updated October 29, 2026.</p>
<p><b>The app collects nothing.</b> Your accounts and setup keys are encrypted and stored only on your own device. There is no account to create, no analytics, no ads, and no tracking. The app makes no internet connections except opening a web page when you tap a link, and the features below, which stay off unless you turn them on.</p>
<p><b>The browser extension</b> reads the web pages you visit only to find code boxes and two-factor setup QR codes. It talks only to the Tanooki Auth app on your own computer (127.0.0.1), receives one current code at a time, and stores only a pairing token in your browser. Nothing is sent anywhere else.</p>
<p><b>Backups</b> are files you create, encrypted with a passphrase only you know.</p>
<p><b>Breach alerts</b> (off unless you turn them on) download the public list of known website breaches from Have I Been Pwned and check it on your device. Nothing about you or your accounts is sent.</p>
<p><b>Sync and approving codes from your phone</b> (off unless you turn them on) are end-to-end encrypted on your devices before anything leaves them. Whether it goes through your own iCloud or the Tanooki relay, they only ever see scrambled data they cannot read. To ask your phone for approval, the relay keeps your phone's notification address (from Apple or Google) until you unlink it.</p>
<p><b>Premium purchases</b> are handled by Stripe (or Apple / Google in their stores), who receive your payment details under their own privacy policies. This page receives your checkout ID only to show your license key and keeps no record of it, with one exception: if you bought through a friend's invite link, the checkout ID is kept next to that invite's count so it is only counted once. App Store purchases are checked from Apple's signed receipt, which is not stored.</p>
<p><b>Feedback</b> you send from the app is stored with the time, your platform and app version, and contact details only if you type them in. It never includes your accounts or codes. Your internet address is not stored; a scrambled form of it is kept for up to two hours to limit how much one address can send.</p>
<p>Questions: tanookistudios.com/support</p>`;

const esc = (s) => String(s).replace(/[&<>"']/g, (c) => `&#${c.charCodeAt(0)};`);

function page(title, body, status = 200, css = '') {
  return new Response(
    `<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>${esc(title)}</title><meta name="robots" content="noindex">
<style>
:root{--bg:#0B0B0D;--card:#16161A;--line:#2A2A30;--text:#F2F2F5;--muted:#8B8B95;--accent:#2F80FF}
*{box-sizing:border-box}body{margin:0;background:var(--bg);color:var(--text);font:16px/1.5 system-ui,sans-serif;padding:40px 16px}
main{max-width:560px;margin:0 auto}h1{font-size:26px;margin:0 0 6px}p{color:var(--muted)}
.card{background:var(--card);border:1px solid var(--line);border-radius:10px;padding:16px;margin:20px 0}
code{display:block;word-break:break-all;font:14px ui-monospace,monospace;color:var(--text)}
button{margin-top:12px;background:var(--accent);color:#fff;border:0;border-radius:6px;padding:10px 16px;font:600 15px system-ui;cursor:pointer}
ol{color:var(--muted);padding-left:20px}li{margin:6px 0}${css}
</style></head><body><main>${body}</main></body></html>`,
    { status, headers: { 'content-type': 'text/html; charset=utf-8', 'cache-control': 'no-store', 'referrer-policy': 'no-referrer' } },
  );
}

const GIFT_CSS = `
.gift{border:2px dashed var(--line);padding:24px}.gift h2{margin:0 0 8px;font-size:22px}.gift p,.gift ol{color:var(--text)}
@media print{body{background:#fff;color:#000;padding:0}main>*:not(.gift){display:none}
.gift{border:2px dashed #000;background:#fff;margin:0}.gift *{color:#000!important}button{display:none}}`;

async function stripe(env, path) {
  return fetch(`https://api.stripe.com/v1/${path}`, { headers: { authorization: `Bearer ${env.STRIPE_KEY}` } });
}

// Counts one paid checkout for an invite code. KV holds only the code, the count and the counted session IDs.
// shortcut: KV is not transactional, so two referred purchases in the same second can count once; fine at this
// volume, move the counter into a Durable Object if invites get busy.
async function countReferral(env, code, session) {
  const k = `ref:${code}`;
  const rec = JSON.parse((await env.INVITES.get(k)) || '{"count":0,"sessions":[]}');
  if (rec.sessions.includes(session)) return;
  rec.sessions.push(session);
  rec.count = rec.sessions.length;
  await env.INVITES.put(k, JSON.stringify(rec));
}

async function thanks(url, env) {
  const session = url.searchParams.get('session_id') || '';
  if (!/^cs_(test|live)_[A-Za-z0-9]{10,200}$/.test(session)) {
    return page('Link not recognized', '<h1>That link isn\'t complete</h1><p>Open the link from your Stripe receipt or the page you landed on after paying. If you\'re stuck, get in touch through tanookistudios.com/support.</p>', 400);
  }
  const r = await stripe(env, `checkout/sessions/${session}`);
  if (r.status === 404) return page('Purchase not found', '<h1>Purchase not found</h1><p>Stripe doesn\'t know that checkout. If you paid, get in touch through tanookistudios.com/support with your receipt and Maddie will sort it out.</p>', 404);
  if (!r.ok) return page('Try again', '<h1>Couldn\'t check your payment</h1><p>Stripe didn\'t answer just now. Reload this page in a minute.</p>', 502);
  const s = await r.json();
  if (s.payment_status !== 'paid') {
    return page('Payment pending', '<h1>Payment not finished yet</h1><p>Stripe hasn\'t confirmed this payment. Reload this page in a minute; your key appears as soon as it does.</p>', 402);
  }

  const ref = String(s.client_reference_id || '');
  if (ref.startsWith('ref_') && INVITE_CODE.test(ref.slice(4))) {
    try { await countReferral(env, ref.slice(4), session); } catch (e) { console.error('invite count failed', ref, e); } // the buyer still gets a key
  }

  // shortcut: the $10 family plan is told apart by price (before tax), not by price ID; switch to the
  // Payment Link ID if a coupon or a second price ever makes amounts overlap.
  const family = (s.amount_subtotal ?? s.amount_total ?? 0) >= 1000;
  const key = await makeLicense(session, s.created, env.LICENSE_SEED, env.LICENSE_PUBLIC, family ? 5 : 1);
  const copy = `<button onclick="navigator.clipboard.writeText(document.getElementById('k').textContent);this.textContent='Copied'">Copy key</button>`;

  if (ref === 'gift') {
    return page('Your Tanooki Auth gift', `
<h1>Your gift is ready</h1><p>Thank you! Print the card below, or copy the key into a text or email. The key is long, so
if you give a printed card, send the key by message too so they can paste it instead of typing it.</p>
<p><button onclick="window.print()">Print gift card</button> ${copy}</p>
<section class="card gift">
<h2>A gift for you: Tanooki Auth Premium</h2>
<p>Someone gave you Tanooki Auth Premium${family ? ' for up to 5 people' : ''}, forever. Tanooki Auth keeps your two-factor sign-in codes safe on your own devices.</p>
<p>Your license key:</p><code id="k">${esc(key)}</code>
<ol><li>Get the free Tanooki Auth app from <b>tanookistudios.com</b>.</li>
<li>Open it and go to <b>Settings → Get Premium</b>.</li>
<li>Tap <b>Already bought it? Enter your license key</b>, paste or type the key above, and tap <b>Unlock</b>.</li>
<li>Use the same key on all your devices.${family ? ' You can share it with up to 4 other people.' : ''}</li></ol>
<p>Stuck? Get in touch through tanookistudios.com/support.</p>
</section>`, 200, GIFT_CSS);
  }

  return page('Your Premium key', `
<h1>Thank you!</h1><p>You've got Tanooki Auth Premium${family ? ' for your family' : ''}, forever. Here's your license key:</p>
<div class="card"><code id="k">${esc(key)}</code>${copy}</div>
<ol><li>Open Tanooki Auth and go to <b>Settings → Get Premium</b>.</li>
<li>Tap <b>Already bought it? Enter your license key</b>, paste, and tap <b>Unlock</b>.</li>
<li>Use the same key on all your devices. Bookmark this page to find it again.</li>${family ? '\n<li>Family plan: send this key to up to 4 other people (5 in all) and they unlock Premium the same way. Only share it with people you trust.</li>' : ''}</ol>
<p>Your support is what lets me keep making free privacy apps. — Maddie</p>`);
}

// App Store purchase -> license key. `roots` is only ever passed by tests (a throwaway CA); live uses Apple's root.
export async function appleLicense(signedTransaction, env, roots) {
  let tx;
  try {
    tx = await verifyTransaction(signedTransaction, roots);
  } catch (e) {
    return e instanceof Refused ? fail(403, e.message) : fail(400, 'signedTransaction could not be read');
  }
  if (tx.bundleId !== BUNDLE_ID) return fail(403, 'this purchase is for a different app');
  const seats = PRODUCTS[tx.productId];
  if (!seats) return fail(403, 'this purchase is not Tanooki Auth Premium');
  if (tx.revocationDate) return fail(403, 'this purchase was refunded or revoked');
  if (tx.environment !== 'Production') return fail(403, 'sandbox and TestFlight purchases do not make license keys');
  if (!/^\d{1,30}$/.test(String(tx.originalTransactionId))) return fail(403, 'transaction has no originalTransactionId');
  const when = tx.originalPurchaseDate ?? tx.purchaseDate ?? tx.signedDate;
  const key = await makeLicense(`ios-${tx.originalTransactionId}`, Math.floor(when / 1000), env.LICENSE_SEED, env.LICENSE_PUBLIC, seats);
  return json({ key, seats });
}

// Subscription -> { periodEnd } when active, or a Response explaining why not.
async function activeSubscription(env, id) {
  if (!/^sub_[A-Za-z0-9]{6,200}$/.test(String(id))) return fail(400, 'that checkout has no subscription');
  const r = await stripe(env, `subscriptions/${id}`);
  if (r.status === 401 || r.status === 403) {
    return fail(503, 'the server is not allowed to read Stripe subscriptions yet; Maddie needs to give its Stripe key subscription read access');
  }
  if (r.status === 404) return fail(404, 'Stripe does not know that subscription');
  if (!r.ok) return fail(502, 'Stripe did not answer just now; try again in a minute');
  const sub = await r.json();
  if (sub.status !== 'active' && sub.status !== 'trialing') return fail(402, 'the team subscription is not active', { status: sub.status });
  // Newer Stripe API versions moved current_period_end onto the subscription item.
  const periodEnd = sub.current_period_end ?? sub.items?.data?.[0]?.current_period_end;
  if (!Number.isInteger(periodEnd)) return fail(502, 'Stripe did not say when the subscription period ends');
  return { periodEnd };
}

async function teamLicensePage(url, env) {
  const session = url.searchParams.get('session_id') || '';
  if (!/^cs_(test|live)_[A-Za-z0-9]{10,200}$/.test(session)) return page('Link not recognized', '<h1>That link isn\'t complete</h1><p>Open the link from the page you landed on after subscribing.</p>', 400);
  const r = await stripe(env, `checkout/sessions/${session}`);
  if (r.status === 404) return page('Subscription not found', '<h1>Subscription not found</h1><p>Stripe doesn\'t know that checkout. If you paid, get in touch through tanookistudios.com/support.</p>', 404);
  if (!r.ok) return page('Try again', '<h1>Couldn\'t check your subscription</h1><p>Stripe didn\'t answer just now. Reload this page in a minute.</p>', 502);
  const s = await r.json();
  if (s.mode !== 'subscription') return page('Not a team subscription', '<h1>This isn\'t a team subscription</h1><p>This checkout was a one-time purchase. Your Premium key is on the page Stripe sent you to after paying.</p>', 400);
  if (s.payment_status !== 'paid') return page('Payment pending', '<h1>Payment not finished yet</h1><p>Stripe hasn\'t confirmed this payment. Reload this page in a minute.</p>', 402);
  const sub = await activeSubscription(env, typeof s.subscription === 'string' ? s.subscription : s.subscription?.id);
  if (sub instanceof Response) {
    const { error } = await sub.json();
    return page('Team license not ready', `<h1>Couldn't make your team license</h1><p>${esc(error[0].toUpperCase() + error.slice(1))}. Reload this page later, or get in touch through tanookistudios.com/support.</p>`, sub.status);
  }
  const token = await makeTeamLicense(s.subscription, sub.periodEnd, env);
  return page('Your team license', `
<h1>Your team vault is paid for</h1><p>Here's your team license. Paste it into Tanooki Auth when you create your team vault (up to 10 people).</p>
<div class="card"><code id="k">${esc(token)}</code><button onclick="navigator.clipboard.writeText(document.getElementById('k').textContent);this.textContent='Copied'">Copy team license</button></div>
<p>The app renews this license by itself while your subscription is active. Bookmark this page to find it again.</p>`);
}

async function feedback(request, env) {
  if (!env.FEEDBACK_ADMIN) return fail(503, 'feedback is not set up on this server');
  const text = await request.text();
  if (te(text).length > 4096) return fail(413, 'feedback is too long (max 4 KB)');
  let b;
  try { b = JSON.parse(text); } catch { return fail(400, 'body must be JSON'); }
  const str = (v, max) => typeof v === 'string' && v.trim().length > 0 && v.length <= max;
  if (!b || !str(b.message, 4000)) return fail(400, 'message is required');
  if (!str(b.platform, 32) || !str(b.appVersion, 32)) return fail(400, 'platform and appVersion are required (32 characters max)');
  if (b.contact !== undefined && b.contact !== '' && !str(b.contact, 200)) return fail(400, 'contact must be text, 200 characters max');
  // Rate limit by a keyed hash of the address; the address itself is never stored.
  const ipKey = hex(await sha256(`${env.FEEDBACK_ADMIN}|${request.headers.get('cf-connecting-ip') || 'unknown'}`)).slice(0, 32);
  const rateKey = `rate:${ipKey}:${Math.floor(Date.now() / 3600_000)}`;
  const used = Number((await env.FEEDBACK.get(rateKey)) || 0);
  if (used >= 5) return fail(429, 'too much feedback from this address; try again in an hour');
  await env.FEEDBACK.put(rateKey, String(used + 1), { expirationTtl: 7200 });
  const at = new Date().toISOString();
  const entry = { at, message: b.message.trim(), platform: b.platform.trim(), appVersion: b.appVersion.trim(), ...(b.contact ? { contact: b.contact.trim() } : {}) };
  await env.FEEDBACK.put(`fb:${at}:${hex(crypto.getRandomValues(new Uint8Array(4)))}`, JSON.stringify(entry));
  return json({ ok: true }, 201);
}

async function feedbackList(request, env) {
  if (!env.FEEDBACK_ADMIN) return fail(503, 'feedback is not set up on this server');
  const given = (request.headers.get('authorization') || '').replace(/^Bearer /, '');
  if (!(await sameSecret(given, env.FEEDBACK_ADMIN))) return fail(401, 'wrong or missing admin token');
  // shortcut: reads the first 1,000 entries only; add a cursor parameter if feedback ever passes that.
  const { keys } = await env.FEEDBACK.list({ prefix: 'fb:', limit: 1000 });
  const entries = await Promise.all(keys.map(async (k) => JSON.parse(await env.FEEDBACK.get(k.name))));
  return json({ entries: entries.filter(Boolean) });
}

export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    const route = `${request.method} ${url.pathname}`;
    if (request.method === 'OPTIONS') return new Response(null, { status: 204, headers: CORS });
    if (url.pathname === '/health') return json({ ok: true, service: 'tanooki-auth-premium', time: new Date().toISOString() });
    if (url.pathname === '/privacy') return page('Tanooki Auth privacy policy', PRIVACY);
    if (url.pathname === '/thanks') return thanks(url, env);
    if (url.pathname === '/team-license') return teamLicensePage(url, env);

    if (route === 'POST /iap/apple') {
      const b = await request.json().catch(() => null);
      if (typeof b?.signedTransaction !== 'string' || b.signedTransaction.length > 20_000) return fail(400, 'body must be {"signedTransaction": "<StoreKit 2 JWS>"}');
      return appleLicense(b.signedTransaction, env);
    }

    if (route === 'GET /invite' || route === 'GET /invites') {
      const lic = await readLicense(url.searchParams.get('key'), env.LICENSE_PUBLIC);
      if (!lic) return fail(400, 'that license key is not valid');
      const code = await inviteCode(lic.orderId, env.LICENSE_SEED);
      if (route === 'GET /invite') return json({ code, link: `${PAYMENT_LINK}?prefilled_promo_code=FRIEND20&client_reference_id=ref_${code}` });
      const { count = 0 } = JSON.parse((await env.INVITES.get(`ref:${code}`)) || '{}');
      const out = { code, count, needed: REFERRALS_FOR_FAMILY };
      if (count >= REFERRALS_FOR_FAMILY && lic.seats < 5) out.familyKey = await makeLicense(lic.orderId, lic.created, env.LICENSE_SEED, env.LICENSE_PUBLIC, 5);
      return json(out);
    }

    if (route === 'POST /team-license/refresh') {
      const b = await request.json().catch(() => null);
      const [tag, p, sig, extra] = String(b?.token || '').split('.');
      const text = tag === 'TT1' && extra === undefined ? await openSigned(p, sig, env.LICENSE_PUBLIC) : null;
      const [kind, subscription] = text?.split('|') ?? [];
      if (kind !== 'team1' || !subscription) return fail(400, 'that team license is not valid');
      const sub = await activeSubscription(env, subscription);
      if (sub instanceof Response) return sub;
      return json({ token: await makeTeamLicense(subscription, sub.periodEnd, env), periodEnd: sub.periodEnd });
    }

    if (route === 'POST /feedback') return feedback(request, env);
    if (route === 'GET /feedback/list') return feedbackList(request, env);

    return page('Tanooki Auth', '<h1>Tanooki Auth Premium</h1><p>Nothing to see here.</p>', 404);
  },
};
