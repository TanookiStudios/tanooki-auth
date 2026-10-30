// Calls the App Store Connect API with the key from ~/.tanooki-auth-signing/asc.env.
// usage: node scripts/asc-api.mjs METHOD PATH [jsonBody]   (prints the status line, then the body)
import crypto from 'node:crypto';
import fs from 'node:fs';
const { ASC_KEY_PATH: keyPath, ASC_KEY_ID: kid, ASC_ISSUER_ID: iss } = process.env;
if (!keyPath || !kid || !iss) { console.error('Set ASC_KEY_PATH, ASC_KEY_ID and ASC_ISSUER_ID (source ~/.tanooki-auth-signing/asc.env)'); process.exit(2); }
const b64 = (o) => Buffer.from(JSON.stringify(o)).toString('base64url');
const now = Math.floor(Date.now() / 1000);
const head = b64({ alg: 'ES256', kid, typ: 'JWT' });
const claims = b64({ iss, iat: now, exp: now + 600, aud: 'appstoreconnect-v1' });
const sig = crypto.sign('sha256', Buffer.from(`${head}.${claims}`), { key: fs.readFileSync(keyPath), dsaEncoding: 'ieee-p1363' }).toString('base64url');
const [method, path, body] = process.argv.slice(2);
const r = await fetch(`https://api.appstoreconnect.apple.com${path}`, {
  method, body, headers: { Authorization: `Bearer ${head}.${claims}.${sig}`, 'content-type': 'application/json' },
});
console.log(r.status);
console.log(await r.text());
process.exit(r.ok ? 0 : 1);
