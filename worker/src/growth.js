// Growth features, kept out of index.js so other work on that file merges cleanly:
//   newsletter signup   POST /subscribe, GET /subscribe/confirm, GET|POST /unsubscribe, GET /subscribers/export (admin)
//   student discount    POST /student, GET /student/claim
//   affiliates          POST /affiliates (admin), GET /affiliates/report (admin), GET /affiliate/<code>?key=
// Email goes out through Resend (secret RESEND_API_KEY, sender in the EMAIL_FROM var). Without the secret every
// endpoint that would send email answers 503 "Email sending isn't set up yet" and stores nothing.
import { isSchoolDomain } from './schools.js';

// Same $5 Payment Link as PAYMENT_LINK in index.js; worker/test.mjs checks the two stay equal.
export const PAYMENT_LINK = 'https://buy.stripe.com/fZubJ3dsP5kv5xZ2kr1VK03';
export const STUDENT_PROMO = 'STUDENT50';
export const AFFILIATE_SHARE = 0.3;
const DAY = 86400;

const te = (s) => new TextEncoder().encode(s);
const hex = (b) => [...new Uint8Array(b)].map((x) => x.toString(16).padStart(2, '0')).join('');
const sha = async (s) => hex(await crypto.subtle.digest('SHA-256', te(s)));
const randomToken = () => hex(crypto.getRandomValues(new Uint8Array(24)));
const esc = (s) => String(s).replace(/[&<>"']/g, (c) => `&#${c.charCodeAt(0)};`);
const money = (cents) => `$${(cents / 100).toFixed(2)}`;

const CORS = { 'access-control-allow-origin': '*', 'access-control-allow-methods': 'GET, POST, OPTIONS', 'access-control-allow-headers': 'authorization, content-type' };
const json = (obj, status = 200) => new Response(JSON.stringify(obj), { status, headers: { 'content-type': 'application/json', 'cache-control': 'no-store', ...CORS } });
const fail = (status, error) => json({ error }, status);
const NO_EMAIL = "Email sending isn't set up yet, so this can't send you anything right now. Please try again in a day or two.";

function page(title, body, status = 200) {
  return new Response(`<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>${esc(title)}</title><meta name="robots" content="noindex">
<style>body{margin:0;background:#0B0B0D;color:#F2F2F5;font:16px/1.5 system-ui,sans-serif;padding:40px 16px}main{max-width:620px;margin:0 auto}
h1{font-size:26px;margin:0 0 6px}p{color:#B5B5BE}a{color:#7DB0FF}table{width:100%;border-collapse:collapse;margin:20px 0}
th,td{text-align:left;padding:8px;border-bottom:1px solid #2A2A30}td.n,th.n{text-align:right;font-variant-numeric:tabular-nums}</style>
</head><body><main>${body}</main></body></html>`, { status, headers: { 'content-type': 'text/html; charset=utf-8', 'cache-control': 'no-store', 'referrer-policy': 'no-referrer' } });
}

// Constant time: hash both sides to equal-length digests, then compare every byte.
async function sameSecret(a, b) {
  const [x, y] = await Promise.all([sha(String(a)), sha(String(b))]);
  let diff = 0;
  for (let i = 0; i < x.length; i++) diff |= x.charCodeAt(i) ^ y.charCodeAt(i);
  return diff === 0;
}
const isAdmin = (request, secret) => sameSecret((request.headers.get('authorization') || '').replace(/^Bearer /, ''), secret);

// A salted hash, so rate-limit keys never hold an address or an email.
const hashed = (env, what, value) => sha(`${what}|${env.LICENSE_SEED}|${value}`).then((h) => h.slice(0, 32));

// True when `key` has already been used `max` times in this window; otherwise counts one more use.
async function overLimit(kv, key, max, ttl) {
  const used = Number((await kv.get(key)) || 0);
  if (used >= max) return true;
  await kv.put(key, String(used + 1), { expirationTtl: ttl });
  return false;
}

async function listAll(kv, prefix) {
  const names = [];
  let cursor;
  do {
    const p = await kv.list({ prefix, cursor });
    names.push(...p.keys.map((k) => k.name));
    cursor = p.list_complete ? undefined : p.cursor;
  } while (cursor);
  return names;
}

async function readEmail(request) {
  const text = await request.text();
  if (text.length > 2048) return null;
  let b;
  try { b = JSON.parse(text); } catch { return null; }
  const email = typeof b?.email === 'string' ? b.email.trim().toLowerCase() : '';
  return email.length <= 254 && /^[^\s@<>()",;:]{1,64}@([a-z0-9]([a-z0-9-]{0,61}[a-z0-9])?\.)+[a-z]{2,63}$/.test(email) ? email : null;
}

// Sends one email through Resend. Throws with a plain message when it can't; callers check env.RESEND_API_KEY first.
export async function sendEmail(env, { to, subject, text, html, headers }) {
  const r = await fetch('https://api.resend.com/emails', {
    method: 'POST',
    headers: { authorization: `Bearer ${env.RESEND_API_KEY}`, 'content-type': 'application/json' },
    body: JSON.stringify({ from: env.EMAIL_FROM, to: [to], subject, text, html, ...(headers ? { headers } : {}) }),
  });
  if (!r.ok) throw new Error(`Resend answered ${r.status}: ${(await r.text()).slice(0, 300)}`);
  return (await r.json()).id;
}

// ---------- newsletter (#40) ----------
// sub:<email> -> {status: "pending"|"confirmed", token, at}; subtok:<token> -> email. Pending entries expire after 7 days.
async function subscribe(request, env, origin) {
  const email = await readEmail(request);
  if (!email) return fail(400, "That doesn't look like an email address.");
  if (!env.RESEND_API_KEY) return fail(503, NO_EMAIL);
  if (await overLimit(env.SUBSCRIBERS, `rate:ip:${await hashed(env, 'ip', request.headers.get('cf-connecting-ip') || 'unknown')}:${Math.floor(Date.now() / 3600_000)}`, 5, 7200)) {
    return fail(429, 'Too many signups from your connection. Try again in an hour.');
  }
  if (await overLimit(env.SUBSCRIBERS, `rate:mail:${await hashed(env, 'mail', email)}`, 3, DAY)) {
    return fail(429, 'We already sent that address a few confirmation emails today. Check the inbox (and spam folder) for the latest one.');
  }
  const done = { ok: true, message: 'Check your inbox for a link to confirm your signup.' };
  const existing = JSON.parse((await env.SUBSCRIBERS.get(`sub:${email}`)) || 'null');
  if (existing?.status === 'confirmed') return json(done); // the same answer either way, so nobody can test who's signed up
  const token = existing?.token || randomToken();
  await env.SUBSCRIBERS.put(`sub:${email}`, JSON.stringify({ status: 'pending', token, at: new Date().toISOString() }), { expirationTtl: 7 * DAY });
  await env.SUBSCRIBERS.put(`subtok:${token}`, email, { expirationTtl: 7 * DAY });
  const confirm = `${origin}/subscribe/confirm?token=${token}`;
  const unsub = `${origin}/unsubscribe?token=${token}`;
  try {
    await sendEmail(env, {
      to: email,
      subject: 'Confirm your Tanooki Auth newsletter signup',
      text: `Tap this link to confirm you want occasional Tanooki Auth news by email:\n${confirm}\n\nDidn't sign up? Ignore this email and nothing happens. To never hear from us: ${unsub}\n`,
      html: `<p>Tap the link below to confirm you want occasional Tanooki Auth news by email.</p><p><a href="${confirm}">Confirm my signup</a></p><p>Didn't sign up? Ignore this email and nothing happens. <a href="${unsub}">Unsubscribe</a></p>`,
      headers: { 'List-Unsubscribe': `<${unsub}>`, 'List-Unsubscribe-Post': 'List-Unsubscribe=One-Click' },
    });
  } catch (e) {
    console.error('signup email failed', e.message);
    return fail(502, "We couldn't send the confirmation email just now. Please try again in a few minutes.");
  }
  return json(done);
}

async function confirmSubscription(url, env) {
  const token = url.searchParams.get('token') || '';
  const email = /^[0-9a-f]{48}$/.test(token) ? await env.SUBSCRIBERS.get(`subtok:${token}`) : null;
  const entry = email && JSON.parse((await env.SUBSCRIBERS.get(`sub:${email}`)) || 'null');
  if (!entry || entry.token !== token) return page('Link expired', '<h1>That link has expired</h1><p>Confirmation links last 7 days. Sign up again at <a href="https://auth.tanookistudios.com/newsletter/">auth.tanookistudios.com/newsletter</a>.</p>', 404);
  await env.SUBSCRIBERS.put(`sub:${email}`, JSON.stringify({ ...entry, status: 'confirmed', confirmedAt: new Date().toISOString() }));
  await env.SUBSCRIBERS.put(`subtok:${token}`, email);
  return page("You're signed up", `<h1>You're signed up</h1><p>Thanks! You'll get occasional Tanooki Auth news. Every email has a link to unsubscribe in one click.</p><p><a href="/unsubscribe?token=${token}">Changed your mind? Unsubscribe</a></p>`);
}

async function unsubscribe(url, env) {
  const token = url.searchParams.get('token') || '';
  const email = /^[0-9a-f]{48}$/.test(token) ? await env.SUBSCRIBERS.get(`subtok:${token}`) : null;
  if (email) await Promise.all([env.SUBSCRIBERS.delete(`sub:${email}`), env.SUBSCRIBERS.delete(`subtok:${token}`)]);
  // Same page whether or not the token was known: unsubscribing twice is fine.
  return page('Unsubscribed', "<h1>You're unsubscribed</h1><p>Your email address has been deleted from the Tanooki Auth list. You won't get any more emails from it.</p>");
}

async function exportSubscribers(request, env) {
  if (!env.SUBSCRIBERS_ADMIN) return fail(503, 'subscriber export is not set up on this server');
  if (!(await isAdmin(request, env.SUBSCRIBERS_ADMIN))) return fail(401, 'wrong or missing admin token');
  const names = await listAll(env.SUBSCRIBERS, 'sub:');
  const entries = await Promise.all(names.map(async (n) => [n.slice(4), JSON.parse((await env.SUBSCRIBERS.get(n)) || 'null')]));
  const confirmed = entries.filter(([, e]) => e?.status === 'confirmed').map(([email, e]) => ({ email, confirmedAt: e.confirmedAt }));
  return json({ count: confirmed.length, subscribers: confirmed });
}

// ---------- student discount (#42) ----------
// stu:<token> -> "1" for 7 days. The student's email address is not stored, only a salted hash for the rate limit.
async function studentRequest(request, env, origin) {
  const email = await readEmail(request);
  if (!email) return fail(400, "That doesn't look like an email address.");
  if (!isSchoolDomain(email.split('@')[1])) {
    return fail(403, "That isn't a school email address we recognize. Use the address your school or university gave you (for example one ending in .edu or .ac.uk). If your school isn't recognized, get in touch through tanookistudios.com/support.");
  }
  if (!env.RESEND_API_KEY) return fail(503, NO_EMAIL);
  if (await overLimit(env.GROWTH, `rate:ip:${await hashed(env, 'ip', request.headers.get('cf-connecting-ip') || 'unknown')}:${Math.floor(Date.now() / 3600_000)}`, 5, 7200)) {
    return fail(429, 'Too many requests from your connection. Try again in an hour.');
  }
  if (await overLimit(env.GROWTH, `rate:student:${await hashed(env, 'mail', email)}`, 2, DAY)) {
    return fail(429, 'We already sent that address a student link today. Check the inbox (and spam folder).');
  }
  const token = randomToken();
  await env.GROWTH.put(`stu:${token}`, '1', { expirationTtl: 7 * DAY });
  const link = `${origin}/student/claim?token=${token}`;
  try {
    await sendEmail(env, {
      to: email,
      subject: 'Your Tanooki Auth student discount',
      text: `Here's your link for 50% off Tanooki Auth Premium:\n${link}\n\nIt works once and lasts 7 days.\n`,
      html: `<p>Here's your link for 50% off Tanooki Auth Premium:</p><p><a href="${link}">Get Premium at 50% off</a></p><p>It works once and lasts 7 days.</p>`,
    });
  } catch (e) {
    console.error('student email failed', e.message);
    await env.GROWTH.delete(`stu:${token}`);
    return fail(502, "We couldn't send the email just now. Please try again in a few minutes.");
  }
  return json({ ok: true, message: 'Check your school inbox for your discount link. It works once and lasts 7 days.' });
}

async function studentClaim(url, env) {
  const token = url.searchParams.get('token') || '';
  const known = /^[0-9a-f]{48}$/.test(token) && (await env.GROWTH.get(`stu:${token}`));
  if (!known) return page('Link used or expired', '<h1>This link has already been used or has expired</h1><p>Each student link works once, for 7 days. Ask for a new one at <a href="https://auth.tanookistudios.com/students/">auth.tanookistudios.com/students</a>.</p>', 410);
  if (env.STUDENT_COUPON_READY !== 'yes') {
    // The link is not used up, so it still works once the discount is switched on.
    return page('Not switched on yet', '<h1>The student discount isn\'t switched on yet</h1><p>Sorry, the 50% off code isn\'t ready at the checkout yet. Your link has not been used up: open it again in a day or two (it lasts 7 days from when it was sent).</p>', 503);
  }
  // shortcut: get-then-delete is not atomic, so two clicks in the same instant could both reach checkout; harmless,
  // because the promo code itself is what gives the discount.
  await env.GROWTH.delete(`stu:${token}`);
  return Response.redirect(`${PAYMENT_LINK}?prefilled_promo_code=${STUDENT_PROMO}&client_reference_id=student`, 302);
}

// ---------- affiliates (#43) ----------
// aff:<code> -> {name, code, key, created}; affsale:<code>:<checkout ID> -> {amount (cents, after discount, before tax), currency, created}.
// One key per checkout, so sales landing at the same instant all count and a reload re-puts the same key.
const AFF_CODE = /^[a-z0-9][a-z0-9-]{2,31}$/;
export const affiliateLink = (code) => `${PAYMENT_LINK}?client_reference_id=aff_${code}`;
const monthOf = (seconds) => new Date(seconds * 1000).toISOString().slice(0, 7);

// Called from /thanks after Stripe says the checkout is paid. Unknown codes are ignored.
export async function countAffiliateSale(env, code, session, s) {
  if (!AFF_CODE.test(code) || !(await env.GROWTH.get(`aff:${code}`))) return;
  const amount = (s.amount_subtotal ?? s.amount_total ?? 0) - (s.total_details?.amount_discount ?? 0);
  await env.GROWTH.put(`affsale:${code}:${session}`, JSON.stringify({ amount, currency: s.currency || 'usd', created: s.created }));
}

async function salesFor(env, code) {
  const names = await listAll(env.GROWTH, `affsale:${code}:`);
  return Promise.all(names.map(async (n) => ({ session: n.slice(`affsale:${code}:`.length), ...JSON.parse(await env.GROWTH.get(n)) })));
}

const summarize = (sales) => {
  const revenue = sales.reduce((t, x) => t + x.amount, 0);
  return { sales: sales.length, revenue, owed: Math.round(revenue * AFFILIATE_SHARE) };
};

async function createAffiliate(request, env, origin) {
  if (!env.AFFILIATES_ADMIN) return fail(503, 'affiliates are not set up on this server');
  if (!(await isAdmin(request, env.AFFILIATES_ADMIN))) return fail(401, 'wrong or missing admin token');
  const b = await request.json().catch(() => null);
  const name = typeof b?.name === 'string' ? b.name.trim() : '';
  const code = typeof b?.code === 'string' ? b.code.trim().toLowerCase() : '';
  if (!name || name.length > 80) return fail(400, 'name is required (80 characters max)');
  if (!AFF_CODE.test(code)) return fail(400, 'code must be 3 to 32 lowercase letters, numbers or dashes');
  if (await env.GROWTH.get(`aff:${code}`)) return fail(409, 'that code is already taken');
  const key = randomToken();
  await env.GROWTH.put(`aff:${code}`, JSON.stringify({ name, code, key, created: new Date().toISOString() }));
  return json({ name, code, link: affiliateLink(code), statsPage: `${origin}/affiliate/${code}?key=${key}` }, 201);
}

async function affiliateStats(url, env, code) {
  const aff = AFF_CODE.test(code) ? JSON.parse((await env.GROWTH.get(`aff:${code}`)) || 'null') : null;
  if (!aff || !(await sameSecret(url.searchParams.get('key') || '', aff.key))) {
    return page('Not found', '<h1>Stats page not found</h1><p>Check you copied the whole link, including the part after <b>?key=</b>.</p>', 404);
  }
  const sales = await salesFor(env, code);
  const months = [...new Set(sales.map((x) => monthOf(x.created)))].sort().reverse();
  const row = (label, s) => `<tr><td>${label}</td><td class="n">${s.sales}</td><td class="n">${money(s.revenue)}</td><td class="n">${money(s.owed)}</td></tr>`;
  const total = summarize(sales);
  return page(`${aff.name}: affiliate stats`, `<h1>Hi ${esc(aff.name)}</h1>
<p>Your link: <a href="${esc(affiliateLink(code))}">${esc(affiliateLink(code))}</a></p>
<p>You earn ${AFFILIATE_SHARE * 100}% of each sale through your link (the price paid after any discount, before tax). Maddie pays it out by hand each month.</p>
<table><tr><th>Month</th><th class="n">Sales</th><th class="n">Revenue</th><th class="n">Your ${AFFILIATE_SHARE * 100}%</th></tr>
${months.map((m) => row(m, summarize(sales.filter((x) => monthOf(x.created) === m)))).join('\n') || '<tr><td colspan="4">No sales yet.</td></tr>'}
${row('<b>All time</b>', total)}</table>
<p>Keep this page's link private: anyone with it can see these numbers.</p>`);
}

async function affiliateReport(request, url, env) {
  if (!env.AFFILIATES_ADMIN) return fail(503, 'affiliates are not set up on this server');
  if (!(await isAdmin(request, env.AFFILIATES_ADMIN))) return fail(401, 'wrong or missing admin token');
  const month = url.searchParams.get('month') || monthOf(Date.now() / 1000);
  if (!/^\d{4}-(0[1-9]|1[0-2])$/.test(month)) return fail(400, 'month must look like 2026-11');
  const codes = (await listAll(env.GROWTH, 'aff:')).map((n) => n.slice(4));
  const affiliates = await Promise.all(codes.map(async (code) => {
    const aff = JSON.parse(await env.GROWTH.get(`aff:${code}`));
    const sales = (await salesFor(env, code)).filter((x) => monthOf(x.created) === month);
    return { code, name: aff.name, ...summarize(sales), sessions: sales.map((x) => ({ session: x.session, amount: x.amount, currency: x.currency })) };
  }));
  return json({ month, share: AFFILIATE_SHARE, affiliates });
}

// Returns a Response for the routes above, or null so index.js carries on.
export async function growthRoute(request, env, url) {
  const route = `${request.method} ${url.pathname}`;
  if (route === 'POST /subscribe') return subscribe(request, env, url.origin);
  if (route === 'GET /subscribe/confirm') return confirmSubscription(url, env);
  if (route === 'GET /unsubscribe' || route === 'POST /unsubscribe') return unsubscribe(url, env);
  if (route === 'GET /subscribers/export') return exportSubscribers(request, env);
  if (route === 'POST /student') return studentRequest(request, env, url.origin);
  if (route === 'GET /student/claim') return studentClaim(url, env);
  if (route === 'POST /affiliates') return createAffiliate(request, env, url.origin);
  if (route === 'GET /affiliates/report') return affiliateReport(request, url, env);
  if (request.method === 'GET' && url.pathname.startsWith('/affiliate/')) return affiliateStats(url, env, url.pathname.slice('/affiliate/'.length));
  return null;
}
