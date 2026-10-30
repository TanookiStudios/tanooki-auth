// Checks a StoreKit 2 signed transaction (a JWS) the way Apple's App Store Server Library does, without the network:
// the x5c chain must end in Apple Root CA - G3, the intermediate and leaf must carry Apple's marker OIDs, every
// certificate must be valid at the transaction's signedDate, and the ES256 signature must verify with the leaf key.

// Apple Root CA - G3, DER, from https://www.apple.com/certificateauthority/AppleRootCA-G3.cer (downloaded 2026-10-30).
// SHA-256 fingerprint 63:34:3A:BF:B8:9A:6A:03:EB:B5:7E:9B:3F:5F:A7:BE:7C:4F:5C:75:6F:30:17:B3:A8:C4:88:C3:65:3E:91:79
export const APPLE_ROOT_G3 =
  'MIICQzCCAcmgAwIBAgIILcX8iNLFS5UwCgYIKoZIzj0EAwMwZzEbMBkGA1UEAwwSQXBwbGUgUm9vdCBDQSAtIEczMSYwJAYDVQQLDB1BcHBsZSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTETMBEGA1UECgwKQXBwbGUgSW5jLjELMAkGA1UEBhMCVVMwHhcNMTQwNDMwMTgxOTA2WhcNMzkwNDMwMTgxOTA2WjBnMRswGQYDVQQDDBJBcHBsZSBSb290IENBIC0gRzMxJjAkBgNVBAsMHUFwcGxlIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MRMwEQYDVQQKDApBcHBsZSBJbmMuMQswCQYDVQQGEwJVUzB2MBAGByqGSM49AgEGBSuBBAAiA2IABJjpLz1AcqTtkyJygRMc3RCV8cWjTnHcFBbZDuWmBSp3ZHtfTjjTuxxEtX/1H7YyYl3J6YRbTzBPEVoA/VhYDKX1DyxNB0cTddqXl5dvMVztK517IDvYuVTZXpmkOlEKMaNCMEAwHQYDVR0OBBYEFLuw3qFYM4iapIqZ3r6966/ayySrMA8GA1UdEwEB/wQFMAMBAf8wDgYDVR0PAQH/BAQDAgEGMAoGCCqGSM49BAMDA2gAMGUCMQCD6cHEFl4aXTQY2e3v9GwOAEZLuN+yRhHFD/3meoyhpmvOwgPUnPWTxnS4at+qIxUCMG1mihDK1A3UT82NQz60imOlM27jbdoXt2QfyFMm+YhidDkLF1vLUagM6BgD56KyKA==';
const LEAF_OID = '1.2.840.113635.100.6.11.1';
const INTERMEDIATE_OID = '1.2.840.113635.100.6.2.1';
const CURVES = { '1.2.840.10045.3.1.7': ['P-256', 32], '1.3.132.0.34': ['P-384', 48] };
const HASHES = { '1.2.840.10045.4.3.2': 'SHA-256', '1.2.840.10045.4.3.3': 'SHA-384' };

export const BUNDLE_ID = 'com.tanookistudios.auth';
export const PRODUCTS = { 'com.tanookistudios.auth.premium': 1, 'com.tanookistudios.auth.family': 5 };

const fromB64 = (s) => Uint8Array.from(atob(s.replace(/-/g, '+').replace(/_/g, '/')), (c) => c.charCodeAt(0));
// A transaction we refuse, with a plain sentence for the app to show. Anything else thrown means unreadable input.
export class Refused extends Error {}
const fail = (why) => { throw new Refused(why); };

// Minimal DER reader: enough to walk a certificate. Returns { tag, start, body, end } for the element at `pos`.
function tlv(b, pos) {
  const tag = b[pos];
  let len = b[pos + 1];
  let body = pos + 2;
  if (len & 0x80) {
    const n = len & 0x7f;
    if (n < 1 || n > 3) fail('certificate is malformed');
    len = 0;
    for (let i = 0; i < n; i++) len = (len << 8) | b[body + i];
    body += n;
  }
  if (tag === undefined || body + len > b.length) fail('certificate is malformed');
  return { tag, start: pos, body, end: body + len };
}
function kids(b, node) {
  const out = [];
  for (let p = node.body; p < node.end; p = out[out.length - 1].end) out.push(tlv(b, p));
  return out;
}
function oid(b, node) {
  const v = b.subarray(node.body, node.end);
  const parts = [Math.floor(v[0] / 40), v[0] % 40];
  for (let i = 1, n = 0; i < v.length; i++) {
    n = n * 128 + (v[i] & 0x7f);
    if (!(v[i] & 0x80)) { parts.push(n); n = 0; }
  }
  return parts.join('.');
}
function time(b, node) {
  const s = new TextDecoder().decode(b.subarray(node.body, node.end));
  const full = node.tag === 0x17 ? (Number(s.slice(0, 2)) >= 50 ? '19' : '20') + s : s; // UTCTime has a 2-digit year
  return Date.UTC(+full.slice(0, 4), +full.slice(4, 6) - 1, +full.slice(6, 8), +full.slice(8, 10), +full.slice(10, 12), +full.slice(12, 14));
}

export function parseCert(der) {
  const cert = tlv(der, 0);
  const [tbs, alg, sig] = kids(der, cert);
  const f = kids(der, tbs);
  const i = f[0].tag === 0xa0 ? 1 : 0; // optional [0] version
  const validity = kids(der, f[i + 3]);
  const spki = f[i + 5];
  const extensions = new Set();
  const extBlock = f.slice(i + 6).find((x) => x.tag === 0xa3);
  if (extBlock) for (const ext of kids(der, kids(der, extBlock)[0])) extensions.add(oid(der, kids(der, ext)[0]));
  return {
    der,
    tbs: der.subarray(tbs.start, tbs.end),
    hash: HASHES[oid(der, kids(der, alg)[0])] || fail('certificate uses an unsupported signature algorithm'),
    signature: der.subarray(sig.body + 1, sig.end), // skip the BIT STRING's unused-bits byte
    notBefore: time(der, validity[0]),
    notAfter: time(der, validity[1]),
    spki: der.subarray(spki.start, spki.end),
    curve: CURVES[oid(der, kids(der, kids(der, spki)[0])[1])] || fail('certificate key is not P-256 or P-384'),
    extensions,
  };
}

// DER ECDSA-Sig-Value (SEQUENCE { r, s }) -> fixed-size r||s, which WebCrypto wants.
function rawSig(der, size) {
  const [r, s] = kids(der, tlv(der, 0));
  const out = new Uint8Array(size * 2);
  const put = (n, at) => { const v = der.subarray(n.body, n.end).slice(-size); out.set(v, at + size - v.length); };
  put(r, 0);
  put(s, size);
  return out;
}

const ecKey = (cert) => crypto.subtle.importKey('spki', cert.spki, { name: 'ECDSA', namedCurve: cert.curve[0] }, false, ['verify']);
const signedBy = async (child, parent) =>
  crypto.subtle.verify({ name: 'ECDSA', hash: child.hash }, await ecKey(parent), rawSig(child.signature, parent.curve[1]), child.tbs);

// x5c = [leaf, intermediate, root] as base64 DER. Throws unless the chain is Apple's (or a root passed in `roots`,
// which only tests do). Returns the parsed leaf.
export async function verifyChain(x5c, at, roots = [APPLE_ROOT_G3]) {
  if (!Array.isArray(x5c) || x5c.length !== 3) fail('x5c must hold exactly three certificates');
  const [leaf, inter, root] = x5c.map((c) => parseCert(fromB64(String(c))));
  if (!roots.some((r) => r === btoa(String.fromCharCode(...root.der)))) fail('certificate chain does not end in Apple Root CA - G3');
  if (!inter.extensions.has(INTERMEDIATE_OID)) fail('intermediate certificate is not an Apple WWDR certificate');
  if (!leaf.extensions.has(LEAF_OID)) fail('signing certificate is not an App Store receipt signing certificate');
  for (const c of [leaf, inter, root]) if (!(at >= c.notBefore && at <= c.notAfter)) fail('a certificate in the chain was not valid when this was signed');
  if (!(await signedBy(inter, root))) fail('intermediate certificate is not signed by the root');
  if (!(await signedBy(leaf, inter))) fail('signing certificate is not signed by the intermediate');
  return leaf;
}

// Returns the verified transaction payload. Throws an Error with a plain sentence on any failure.
export async function verifyTransaction(jws, roots) {
  const parts = String(jws || '').split('.');
  if (parts.length !== 3) throw new Error('not a JWS'); // unreadable input, not a refusal
  let header, payload;
  try {
    header = JSON.parse(new TextDecoder().decode(fromB64(parts[0])));
    payload = JSON.parse(new TextDecoder().decode(fromB64(parts[1])));
  } catch { throw new Error('not a JWS'); }
  if (header.alg !== 'ES256') fail('signedTransaction must use ES256');
  if (!Number.isInteger(payload.signedDate)) fail('transaction has no signedDate');
  const leaf = await verifyChain(header.x5c, payload.signedDate, roots);
  if (leaf.curve[0] !== 'P-256') fail('signing key must be P-256 for ES256');
  const sig = fromB64(parts[2]);
  if (sig.length !== 64) fail('transaction signature is not valid');
  const ok = await crypto.subtle.verify({ name: 'ECDSA', hash: 'SHA-256' }, await ecKey(leaf), sig, new TextEncoder().encode(`${parts[0]}.${parts[1]}`));
  if (!ok) fail('transaction signature is not valid');
  return payload;
}
