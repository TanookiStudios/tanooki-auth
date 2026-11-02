// Uploads PNG screenshots to one App Store version localization's screenshot set, replacing what's there,
// then waits until Apple reports each one COMPLETE. Uses the key from ~/.tanooki-auth-signing/asc.env.
// usage: node scripts/asc-upload-screenshots.mjs <localizationId> <displayType> file1.png file2.png ...
//   displayType e.g. APP_IPHONE_67, APP_IPAD_PRO_3GEN_129, APP_DESKTOP. Files upload in the order given.
import crypto from 'node:crypto';
import fs from 'node:fs';
import path from 'node:path';
const { ASC_KEY_PATH: keyPath, ASC_KEY_ID: kid, ASC_ISSUER_ID: iss } = process.env;
if (!keyPath || !kid || !iss) { console.error('Set ASC_KEY_PATH, ASC_KEY_ID and ASC_ISSUER_ID (source ~/.tanooki-auth-signing/asc.env)'); process.exit(2); }
const [loc, displayType, ...files] = process.argv.slice(2);
if (!loc || !displayType || !files.length) { console.error('usage: <localizationId> <displayType> files...'); process.exit(2); }

function token() {
  const b64 = (o) => Buffer.from(JSON.stringify(o)).toString('base64url');
  const now = Math.floor(Date.now() / 1000);
  const head = b64({ alg: 'ES256', kid, typ: 'JWT' });
  const claims = b64({ iss, iat: now, exp: now + 600, aud: 'appstoreconnect-v1' });
  const sig = crypto.sign('sha256', Buffer.from(`${head}.${claims}`), { key: fs.readFileSync(keyPath), dsaEncoding: 'ieee-p1363' }).toString('base64url');
  return `${head}.${claims}.${sig}`;
}
async function api(method, p, body) {
  const r = await fetch(`https://api.appstoreconnect.apple.com${p}`, {
    method, body: body && JSON.stringify(body), headers: { Authorization: `Bearer ${token()}`, 'content-type': 'application/json' },
  });
  const text = await r.text();
  if (!r.ok) throw new Error(`${method} ${p} -> ${r.status}\n${text}`);
  return text ? JSON.parse(text) : null;
}

const sets = await api('GET', `/v1/appStoreVersionLocalizations/${loc}/appScreenshotSets?limit=50`);
let set = sets.data.find((s) => s.attributes.screenshotDisplayType === displayType);
if (!set) {
  set = (await api('POST', '/v1/appScreenshotSets', { data: { type: 'appScreenshotSets', attributes: { screenshotDisplayType: displayType },
    relationships: { appStoreVersionLocalization: { data: { type: 'appStoreVersionLocalizations', id: loc } } } } })).data;
}
for (const old of (await api('GET', `/v1/appScreenshotSets/${set.id}/appScreenshots?limit=50`)).data) {
  await api('DELETE', `/v1/appScreenshots/${old.id}`);
}

const ids = [];
for (const file of files) {
  const bytes = fs.readFileSync(file);
  const shot = (await api('POST', '/v1/appScreenshots', { data: { type: 'appScreenshots',
    attributes: { fileName: path.basename(file), fileSize: bytes.length },
    relationships: { appScreenshotSet: { data: { type: 'appScreenshotSets', id: set.id } } } } })).data;
  for (const op of shot.attributes.uploadOperations) {
    const headers = Object.fromEntries(op.requestHeaders.map((h) => [h.name, h.value]));
    const r = await fetch(op.url, { method: op.method, headers, body: bytes.subarray(op.offset, op.offset + op.length) });
    if (!r.ok) throw new Error(`upload part of ${file} -> ${r.status} ${await r.text()}`);
  }
  await api('PATCH', `/v1/appScreenshots/${shot.id}`, { data: { type: 'appScreenshots', id: shot.id,
    attributes: { uploaded: true, sourceFileChecksum: crypto.createHash('md5').update(bytes).digest('hex') } } });
  ids.push([shot.id, file]);
}

// Apple processes uploads after the fact; only COMPLETE means the screenshot is really there.
let bad = 0;
for (const [id, file] of ids) {
  let state;
  for (let i = 0; i < 60; i++) {
    state = (await api('GET', `/v1/appScreenshots/${id}`)).data.attributes.assetDeliveryState;
    if (state.state === 'COMPLETE' || state.state === 'FAILED') break;
    await new Promise((r) => setTimeout(r, 5000));
  }
  console.log(`${state.state}\t${path.basename(file)}${state.errors?.length ? '\t' + JSON.stringify(state.errors) : ''}`);
  if (state.state !== 'COMPLETE') bad++;
}
console.log(`${displayType}: ${ids.length - bad} of ${ids.length} COMPLETE`);
process.exit(bad ? 1 : 0);
