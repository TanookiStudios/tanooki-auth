// Wake-up pushes for a fill request. The payload carries no secret, no site and no room ID: just a fixed sentence.
import { b64u } from './util.js';

const TITLE = 'Tanooki Auth';
const BODY = 'Approve sign-in code request';

export function pushConfigured(env, platform) {
  if (platform === 'apns') return !!(env.APNS_KEY && env.APNS_KEY_ID && env.APNS_TEAM_ID);
  if (platform === 'fcm') return !!env.FCM_SERVICE_ACCOUNT;
  return false;
}

const pemToDer = (pem) => Uint8Array.from(atob(pem.replace(/-----[^-]+-----/g, '').replace(/\s+/g, '')), (c) => c.charCodeAt(0));
const enc = (obj) => b64u(new TextEncoder().encode(JSON.stringify(obj)));

async function jwt(header, claims, pem, alg) {
  const key = await crypto.subtle.importKey('pkcs8', pemToDer(pem), alg, false, ['sign']);
  const input = `${enc(header)}.${enc(claims)}`;
  const sig = await crypto.subtle.sign(alg.name === 'ECDSA' ? { name: 'ECDSA', hash: 'SHA-256' } : alg, key, new TextEncoder().encode(input));
  return `${input}.${b64u(sig)}`;
}

// Tokens are reused while the isolate lives: Apple asks for a new JWT at most every 20-60 minutes.
let apnsCache = { token: '', at: 0 };
let fcmCache = { token: '', exp: 0 };

async function apnsJwt(env) {
  const now = Math.floor(Date.now() / 1000);
  if (apnsCache.token && now - apnsCache.at < 50 * 60) return apnsCache.token;
  const token = await jwt({ alg: 'ES256', kid: env.APNS_KEY_ID }, { iss: env.APNS_TEAM_ID, iat: now }, env.APNS_KEY, { name: 'ECDSA', namedCurve: 'P-256' });
  apnsCache = { token, at: now };
  return token;
}

async function fcmAccess(sa) {
  const now = Math.floor(Date.now() / 1000);
  if (fcmCache.token && now < fcmCache.exp - 300) return fcmCache.token;
  const aud = sa.token_uri || 'https://oauth2.googleapis.com/token';
  const assertion = await jwt(
    { alg: 'RS256', typ: 'JWT' },
    { iss: sa.client_email, scope: 'https://www.googleapis.com/auth/firebase.messaging', aud, iat: now, exp: now + 3600 },
    sa.private_key,
    { name: 'RSASSA-PKCS1-v1_5', hash: 'SHA-256' },
  );
  const r = await fetch(aud, {
    method: 'POST',
    headers: { 'content-type': 'application/x-www-form-urlencoded' },
    body: `grant_type=${encodeURIComponent('urn:ietf:params:oauth:grant-type:jwt-bearer')}&assertion=${assertion}`,
  });
  if (!r.ok) throw new Error(`fcm-auth-${r.status}`);
  const { access_token, expires_in } = await r.json();
  fcmCache = { token: access_token, exp: now + (expires_in || 3600) };
  return access_token;
}

// Returns 'sent', 'token-dead' (the phone uninstalled or the token rotated), or 'failed:<reason>'.
export async function sendPush(env, platform, token, environment) {
  try {
    if (platform === 'apns') {
      const host = environment === 'sandbox' ? 'api.sandbox.push.apple.com' : 'api.push.apple.com';
      const r = await fetch(`https://${host}/3/device/${token}`, {
        method: 'POST',
        headers: {
          authorization: `bearer ${await apnsJwt(env)}`,
          'apns-topic': env.APNS_TOPIC || 'com.tanookistudios.auth',
          'apns-push-type': 'alert',
          'apns-priority': '10',
          'apns-expiration': String(Math.floor(Date.now() / 1000) + 120),
        },
        body: JSON.stringify({ aps: { alert: { title: TITLE, body: BODY }, sound: 'default', category: 'TA_FILL_REQUEST' } }),
      });
      if (r.ok) return 'sent';
      if (r.status === 410 || r.status === 400) {
        const reason = (await r.json().catch(() => ({}))).reason || '';
        if (r.status === 410 || reason === 'BadDeviceToken') return 'token-dead';
        return `failed:apns-${r.status}-${reason}`;
      }
      if (r.status === 403) apnsCache = { token: '', at: 0 };
      return `failed:apns-${r.status}`;
    }
    const sa = JSON.parse(env.FCM_SERVICE_ACCOUNT);
    const r = await fetch(`https://fcm.googleapis.com/v1/projects/${sa.project_id}/messages:send`, {
      method: 'POST',
      headers: { authorization: `Bearer ${await fcmAccess(sa)}`, 'content-type': 'application/json' },
      body: JSON.stringify({
        message: { token, notification: { title: TITLE, body: BODY }, android: { priority: 'high', ttl: '120s' }, data: { type: 'fill-request' } },
      }),
    });
    if (r.ok) return 'sent';
    if (r.status === 404) return 'token-dead';
    if (r.status === 401) fcmCache = { token: '', exp: 0 };
    return `failed:fcm-${r.status}`;
  } catch (e) {
    return `failed:${String(e.message || e).slice(0, 80)}`;
  }
}
