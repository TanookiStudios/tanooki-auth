// After a $5 (or $10 family) Stripe Checkout, Stripe sends the buyer to /thanks?session_id=cs_...
// We ask Stripe whether that session is paid, then show a license key for it. Ed25519 signatures are
// deterministic and the payload only uses the session, so revisiting the link shows the same key.

const b64url = (bytes) => btoa(String.fromCharCode(...new Uint8Array(bytes))).replace(/\+/g, '-').replace(/\//g, '_').replace(/=+$/, '');
const fromB64 = (s) => Uint8Array.from(atob(s), (c) => c.charCodeAt(0));

export async function makeLicense(orderId, created, seedB64, publicB64, seats = 1) {
  const d = new Date(created * 1000);
  const ymd = `${d.getUTCFullYear()}${String(d.getUTCMonth() + 1).padStart(2, '0')}${String(d.getUTCDate()).padStart(2, '0')}`;
  // Family keys add `|seats`; $5 keys keep the original three fields so they stay byte-identical.
  const payload = new TextEncoder().encode(`1|${orderId}|${ymd}${seats > 1 ? `|${seats}` : ''}`);
  const key = await crypto.subtle.importKey(
    'jwk',
    { kty: 'OKP', crv: 'Ed25519', d: b64url(fromB64(seedB64)), x: b64url(fromB64(publicB64)) },
    { name: 'Ed25519' },
    false,
    ['sign'],
  );
  const sig = await crypto.subtle.sign({ name: 'Ed25519' }, key, payload);
  return `TA1.${b64url(payload)}.${b64url(sig)}`;
}

const PRIVACY = `<h1>Privacy policy</h1><p>Tanooki Auth, by Tanooki Studios. Last updated October 29, 2026.</p>
<p><b>The app collects nothing.</b> Your accounts and setup keys are encrypted and stored only on your own device. There is no account to create, no analytics, no ads, and no tracking. The app makes no internet connections except opening a web page when you tap a link, and the features below, which stay off unless you turn them on.</p>
<p><b>The browser extension</b> reads the web pages you visit only to find code boxes and two-factor setup QR codes. It talks only to the Tanooki Auth app on your own computer (127.0.0.1), receives one current code at a time, and stores only a pairing token in your browser. Nothing is sent anywhere else.</p>
<p><b>Backups</b> are files you create, encrypted with a passphrase only you know.</p>
<p><b>Breach alerts</b> (off unless you turn them on) download the public list of known website breaches from Have I Been Pwned and check it on your device. Nothing about you or your accounts is sent.</p>
<p><b>Sync and approving codes from your phone</b> (off unless you turn them on) are end-to-end encrypted on your devices before anything leaves them. Whether it goes through your own iCloud or the Tanooki relay, they only ever see scrambled data they cannot read. To ask your phone for approval, the relay keeps your phone's notification address (from Apple or Google) until you unlink it.</p>
<p><b>Premium purchases</b> are handled by Stripe (or Apple / Google in their stores), who receive your payment details under their own privacy policies. This page receives your checkout ID only to show your license key and keeps no record of it.</p>
<p>Questions: tanookistudios.com/support</p>`;

const esc = (s) => String(s).replace(/[&<>"']/g, (c) => `&#${c.charCodeAt(0)};`);

function page(title, body, status = 200) {
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
ol{color:var(--muted);padding-left:20px}li{margin:6px 0}
</style></head><body><main>${body}</main></body></html>`,
    { status, headers: { 'content-type': 'text/html; charset=utf-8', 'cache-control': 'no-store', 'referrer-policy': 'no-referrer' } },
  );
}

export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    if (url.pathname === '/privacy') return page('Tanooki Auth privacy policy', PRIVACY);
    if (url.pathname !== '/thanks') return page('Tanooki Auth', '<h1>Tanooki Auth Premium</h1><p>Nothing to see here.</p>', 404);

    const session = url.searchParams.get('session_id') || '';
    if (!/^cs_(test|live)_[A-Za-z0-9]{10,200}$/.test(session)) {
      return page('Link not recognized', '<h1>That link isn\'t complete</h1><p>Open the link from your Stripe receipt or the page you landed on after paying. If you\'re stuck, get in touch through tanookistudios.com/support.</p>', 400);
    }
    const r = await fetch(`https://api.stripe.com/v1/checkout/sessions/${session}`, {
      headers: { authorization: `Bearer ${env.STRIPE_KEY}` },
    });
    if (r.status === 404) return page('Purchase not found', '<h1>Purchase not found</h1><p>Stripe doesn\'t know that checkout. If you paid, get in touch through tanookistudios.com/support with your receipt and Maddie will sort it out.</p>', 404);
    if (!r.ok) return page('Try again', '<h1>Couldn\'t check your payment</h1><p>Stripe didn\'t answer just now. Reload this page in a minute.</p>', 502);
    const s = await r.json();
    if (s.payment_status !== 'paid') {
      return page('Payment pending', '<h1>Payment not finished yet</h1><p>Stripe hasn\'t confirmed this payment. Reload this page in a minute; your key appears as soon as it does.</p>', 402);
    }

    // shortcut: the $10 family plan is told apart by price (before tax), not by price ID; switch to the
    // Payment Link ID if a coupon or a second price ever makes amounts overlap.
    const family = (s.amount_subtotal ?? s.amount_total ?? 0) >= 1000;
    const key = await makeLicense(session, s.created, env.LICENSE_SEED, env.LICENSE_PUBLIC, family ? 5 : 1);
    return page('Your Premium key', `
<h1>Thank you!</h1><p>You've got Tanooki Auth Premium${family ? ' for your family' : ''}, forever. Here's your license key:</p>
<div class="card"><code id="k">${esc(key)}</code><button onclick="navigator.clipboard.writeText(document.getElementById('k').textContent);this.textContent='Copied'">Copy key</button></div>
<ol><li>Open Tanooki Auth and go to <b>Settings → Get Premium</b>.</li>
<li>Tap <b>Already bought it? Enter your license key</b>, paste, and tap <b>Unlock</b>.</li>
<li>Use the same key on all your devices. Bookmark this page to find it again.</li>${family ? '\n<li>Family plan: send this key to up to 4 other people (5 in all) and they unlock Premium the same way. Only share it with people you trust.</li>' : ''}</ol>
<p>Your support is what lets me keep making free privacy apps. — Maddie</p>`);
  },
};
