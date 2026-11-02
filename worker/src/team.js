// Team and business routes: the business plan's license page and admin page (#44), and team invites by email (#29).
import { esc, fail, json, page, teamLicensePage } from './index.js';

const RELAY_URL = 'https://tanooki-auth-relay.kirbymail.workers.dev';
const EMAIL_FROM = 'Tanooki Auth <noreply@tanookistudios.com>';
const ID = /^[A-Za-z0-9_-]{43}$/;
const NONCE = /^[A-Za-z0-9_-]{16,64}$/;
const SIG = /^[A-Za-z0-9_-]{86}$/;
// One address, nothing fancy: no spaces, one @, a dot in the domain.
const EMAIL = /^[^\s@<>()"',;]{1,64}@[^\s@<>()"',;]+\.[^\s@<>()"',;]{2,}$/;
export const TEAM_EMAILS_PER_DAY = 20;

const relayBase = (env) => (env.RELAY_URL || RELAY_URL).replace(/\/$/, '');

// Signed request to the relay, forwarded as the app signed it. A service binding when there is one, since a
// worker can't always fetch another worker on workers.dev directly.
const relayFetch = (env, path, headers) =>
  env.RELAY ? env.RELAY.fetch(new Request(`https://relay${path}`, { headers })) : fetch(`${relayBase(env)}${path}`, { headers });

export const teamInviteLink = (relay, teamId, invite) =>
  `tanookiauth://team?v=1&relay=${encodeURIComponent(relay)}&team=${teamId}&invite=${encodeURIComponent(invite)}`;

// POST /team-invite-email {email, teamId, invite, proof: {device, timestamp, nonce, signature}}
// `proof` is a request the admin's app signed for GET /v1/team/<teamId> (PROTOCOL.md 1.3). The worker hands it to
// the relay, which checks the signature and burns the nonce; the worker then checks that device is an admin.
// So only a team admin can send, only a Tanooki team invite goes out, and each proof works once.
async function inviteEmail(request, env) {
  const b = await request.json().catch(() => null);
  const email = String(b?.email ?? '').trim();
  const p = b?.proof ?? {};
  if (!EMAIL.test(email) || email.length > 254) return fail(400, 'that email address does not look right');
  if (!ID.test(b?.teamId ?? '') || !ID.test(b?.invite ?? '')) return fail(400, 'teamId and invite must come from the app');
  if (!ID.test(p.device ?? '') || !/^\d{1,16}$/.test(String(p.timestamp ?? '')) || !NONCE.test(p.nonce ?? '') || !SIG.test(p.signature ?? '')) {
    return fail(400, 'proof must be a signed request from the app');
  }
  if (!env.RESEND_API_KEY) return fail(503, "Email sending isn't set up yet", { code: 'email-not-set-up' });

  const r = await relayFetch(env, `/v1/team/${b.teamId}`, {
    'x-ta-device': p.device, 'x-ta-timestamp': String(p.timestamp), 'x-ta-nonce': p.nonce, 'x-ta-signature': p.signature,
  });
  const st = await r.json().catch(() => ({}));
  if (r.status !== 200) return fail(403, `the relay could not confirm you're in this team (${st.error || r.status})`);
  if (st.members?.find((m) => m.key === p.device)?.role !== 'admin') return fail(403, 'only a team admin can send invites');

  const rateKey = `teammail:${b.teamId}:${new Date().toISOString().slice(0, 10)}`;
  const sent = Number((await env.INVITES.get(rateKey)) || 0);
  if (sent >= TEAM_EMAILS_PER_DAY) return fail(429, `this team has sent ${TEAM_EMAILS_PER_DAY} invite emails today; try again tomorrow, or copy the link instead`);
  await env.INVITES.put(rateKey, String(sent + 1), { expirationTtl: 2 * 86400 });

  // The invite rides in the #fragment, so it never reaches this server's logs when the page opens.
  const join = `${new URL(request.url).origin}/join-team#${encodeURIComponent(teamInviteLink(relayBase(env), b.teamId, b.invite))}`;
  const text = `You've been invited to a team in Tanooki Auth, the two-factor code app.

Open this link on the phone or computer where you use Tanooki Auth:
${join}

The invite works once and runs out in 7 days. If you weren't expecting it, you can ignore this email.`;
  const html = `<p>You've been invited to a team in <b>Tanooki Auth</b>, the two-factor code app.</p>
<p><a href="${esc(join)}">Join the team</a> — open this on the phone or computer where you use Tanooki Auth.</p>
<p style="color:#666">The invite works once and runs out in 7 days. If you weren't expecting it, you can ignore this email.</p>`;
  const res = await fetch('https://api.resend.com/emails', {
    method: 'POST',
    headers: { authorization: `Bearer ${env.RESEND_API_KEY}`, 'content-type': 'application/json' },
    body: JSON.stringify({ from: env.EMAIL_FROM || EMAIL_FROM, to: [email], subject: "You're invited to a team in Tanooki Auth", text, html }),
  });
  if (!res.ok) {
    console.error('resend refused a team invite', res.status, await res.text().catch(() => ''));
    await env.INVITES.put(rateKey, String(sent), { expirationTtl: 2 * 86400 }); // a failed send doesn't use up the day
    return fail(502, `the email service didn't accept it (status ${res.status}); copy the link instead`);
  }
  return json({ ok: true }, 201);
}

const JOIN_PAGE = `<h1>Join a team in Tanooki Auth</h1>
<p>Someone invited you to their team. Open this page on the phone or computer where you use Tanooki Auth.</p>
<div class="card" id="ok" hidden><p><a id="open" href="#"><button>Open in Tanooki Auth</button></a></p>
<p>If that button does nothing, copy the invite and paste it in the app:</p><code id="k"></code>
<button onclick="navigator.clipboard.writeText(document.getElementById('k').textContent);this.textContent='Copied'">Copy invite</button>
<ol><li>Get Tanooki Auth from <b>tanookistudios.com</b> if you don't have it yet.</li>
<li>Open it and go to <b>Settings → Team vault</b>.</li><li>Tap <b>Paste an invite link</b>, paste, and tap <b>Join</b>.</li></ol></div>
<p id="bad" hidden>This invite link isn't complete. Ask the person who invited you to send it again.</p>
<script>
const link = decodeURIComponent(location.hash.slice(1));
if (link.startsWith('tanookiauth://team?')) {
  document.getElementById('k').textContent = link;
  document.getElementById('open').href = link;
  document.getElementById('ok').hidden = false;
} else document.getElementById('bad').hidden = false;
</script>`;

// The business admin page. Everything happens in the browser: it sends the license straight to the relay
// (PROTOCOL.md 4.5), so this worker never sees it.
const businessPage = (env) => `<h1>Tanooki Auth business admin</h1>
<p>Sign in with your team's business license (the long key that starts with TT1, from the page you saw after subscribing).</p>
<div class="card"><label for="lic">Business license</label><textarea id="lic" rows="3" autocomplete="off" spellcheck="false"></textarea>
<button id="go">Sign in</button><p id="msg" role="status"></p></div>
<section id="view" hidden><div class="card"><p id="seats"></p><p id="paid"></p>
${env.STRIPE_PORTAL_URL ? `<p><a href="${esc(env.STRIPE_PORTAL_URL)}" style="color:var(--accent)">Change seats or billing (Stripe)</a></p>` : ''}</div>
<h2>People</h2><p>Each person is one device. Removing someone locks them out at once; the next time the team owner's app opens, it changes the team key so they can't read anything new.</p>
<table><thead><tr><th>Device</th><th>Role</th><th>Joined</th><th></th></tr></thead><tbody id="rows"></tbody></table></section>
<script>
const RELAY = ${JSON.stringify(relayBase(env))};
const ROLE = { admin: 'Admin', member: 'Member', viewer: 'View-only' };
const $ = (id) => document.getElementById(id);
let license = '';
async function call(method, path) {
  const r = await fetch(RELAY + path, { method, headers: { authorization: 'Bearer ' + license } });
  const body = await r.json().catch(() => ({}));
  if (!r.ok) throw new Error(body.error || 'The relay said no (' + r.status + ').');
  return body;
}
function show(v) {
  $('seats').textContent = v.used + ' of ' + v.seats + ' seats used, ' + Math.max(v.seats - v.used, 0) + ' free.';
  $('paid').textContent = 'Paid until ' + new Date(v.licenseEnd).toLocaleDateString() + '.';
  const rows = $('rows'); rows.textContent = '';
  for (const m of v.members) {
    const tr = document.createElement('tr');
    const cells = [m.key.slice(0, 8) + (m.key === v.owner ? ' (owner)' : ''), ROLE[m.role] || m.role, new Date(m.added).toLocaleDateString()];
    for (const c of cells) { const td = document.createElement('td'); td.textContent = c; tr.append(td); }
    const td = document.createElement('td');
    if (m.key !== v.owner) {
      const b = document.createElement('button'); b.textContent = 'Remove';
      b.onclick = async () => {
        if (!confirm('Remove device ' + m.key.slice(0, 8) + ' from the team? They lose access right away.')) return;
        try { show(await call('DELETE', '/v1/business/members/' + m.key)); $('msg').textContent = 'Removed.'; } catch (e) { $('msg').textContent = e.message; }
      };
      td.append(b);
    }
    tr.append(td); rows.append(tr);
  }
  $('view').hidden = false;
}
$('go').onclick = async () => {
  license = $('lic').value.trim();
  $('msg').textContent = 'Checking…';
  try { show(await call('GET', '/v1/business')); $('msg').textContent = ''; } catch (e) { $('view').hidden = true; $('msg').textContent = e.message; }
};
</script>`;

const BUSINESS_CSS = `textarea{width:100%;background:var(--bg);color:var(--text);border:1px solid var(--line);border-radius:6px;padding:8px;font:13px ui-monospace,monospace}
label{display:block;margin-bottom:6px}table{width:100%;border-collapse:collapse}th,td{text-align:left;padding:8px 6px;border-bottom:1px solid var(--line)}
td button{margin:0;padding:6px 10px;font-size:13px}h2{font-size:19px;margin-top:28px}`;

/** The worker's team and business routes, or null when [url] is none of them. */
export async function teamRoutes(request, url, env) {
  const route = `${request.method} ${url.pathname}`;
  if (url.pathname === '/business-license') return teamLicensePage(url, env, true);
  if (route === 'GET /business') return page('Tanooki Auth business admin', businessPage(env), 200, BUSINESS_CSS);
  if (route === 'GET /join-team') return page('Join a team in Tanooki Auth', JOIN_PAGE);
  if (route === 'POST /team-invite-email') return inviteEmail(request, env);
  return null;
}
