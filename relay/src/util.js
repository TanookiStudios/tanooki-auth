// Shared helpers. Everything on the wire is base64url without padding.
export const MAX_BODY = 1 << 20; // 1 MiB per request
export const ID = /^[A-Za-z0-9_-]{43}$/; // 32 random bytes, base64url

export const CORS = {
  'access-control-allow-origin': '*',
  'access-control-allow-methods': 'GET, POST, DELETE, OPTIONS',
  'access-control-allow-headers': 'authorization, content-type, x-ta-device, x-ta-timestamp, x-ta-nonce, x-ta-signature',
  'access-control-max-age': '86400',
};

export const json = (obj, status = 200) =>
  new Response(JSON.stringify(obj), { status, headers: { 'content-type': 'application/json', 'cache-control': 'no-store', ...CORS } });
export const err = (status, error, extra = {}) => json({ error, ...extra }, status);

export const b64u = (buf) => {
  const b = new Uint8Array(buf);
  let s = '';
  for (let i = 0; i < b.length; i += 0x8000) s += String.fromCharCode(...b.subarray(i, i + 0x8000));
  return btoa(s).replace(/\+/g, '-').replace(/\//g, '_').replace(/=+$/, '');
};
export const unb64u = (s) => Uint8Array.from(atob(s.replace(/-/g, '+').replace(/_/g, '/')), (c) => c.charCodeAt(0));
export const randomId = () => b64u(crypto.getRandomValues(new Uint8Array(32)));
export const sha256 = async (data) =>
  new Uint8Array(await crypto.subtle.digest('SHA-256', typeof data === 'string' ? new TextEncoder().encode(data) : data));

// Constant-time: hash both sides to equal length, then timingSafeEqual.
export async function secretEquals(a, bHash) {
  const aHash = await sha256(a);
  return bHash.byteLength === aHash.byteLength && crypto.subtle.timingSafeEqual(aHash, bHash);
}

export async function verifyEd25519(pubB64u, sigB64u, message) {
  try {
    const key = await crypto.subtle.importKey('raw', unb64u(pubB64u), { name: 'Ed25519' }, false, ['verify']);
    return await crypto.subtle.verify({ name: 'Ed25519' }, key, unb64u(sigB64u), new TextEncoder().encode(message));
  } catch {
    return false; // malformed key or signature is just a bad signature
  }
}

// Reads the body with the size cap. Returns { bytes } or { error: Response }.
export async function readBody(req) {
  const bytes = new Uint8Array(await req.arrayBuffer());
  if (bytes.byteLength > MAX_BODY) return { error: err(413, 'body too large (max 1 MiB)') };
  return { bytes };
}
export function parseJson(bytes) {
  if (!bytes.byteLength) return {};
  try {
    const v = JSON.parse(new TextDecoder().decode(bytes));
    return v && typeof v === 'object' && !Array.isArray(v) ? v : null;
  } catch {
    return null;
  }
}

// Fixed-window counter held in a Durable Object's memory (resets if the object is evicted, which only loosens it).
export class Window {
  constructor(limit, ms) { Object.assign(this, { limit, ms, start: 0, n: 0 }); }
  hit() {
    const now = Date.now();
    if (now - this.start >= this.ms) { this.start = now; this.n = 0; }
    return ++this.n <= this.limit;
  }
}
