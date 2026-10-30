// Browser test of "Use my phone" with the real extension in Chromium and the app's real phone-link code
// (app/tool/phone_harness_test.dart) as the phone, through the LIVE relay. The desktop app must NOT be
// reachable, so run it through isolated.sh (moves the extension's app ports to empty ones):
//   SCRIPT=phone-e2e.cjs extension/test/isolated.sh
// Checks: the popup's QR pairs the phone; a login page fills itself with the phone's code; the popup's
// "Get code" fills too; a lookalike site gets nothing; storage never holds a secret or a code; unpair clears it.
const { chromium } = require('playwright');
const { spawn } = require('child_process');
const crypto = require('crypto');
const fs = require('fs');
const http = require('http');
const os = require('os');
const path = require('path');

const root = path.resolve(__dirname, '../..');
const extDir = process.env.EXT_DIR || path.join(root, 'extension');
const jsQR = require(path.join(extDir, 'jsqr.js'));
const work = fs.mkdtempSync(path.join(os.tmpdir(), 'ta-phone-'));
const SECRET = 'KRUGKIDROVUWG2ZAMJZG653OEBTG66BAN52XE';
let failures = 0;
const check = (ok, what) => { console.log(`${ok ? 'PASS' : 'FAIL'} ${what}`); if (!ok) failures++; };

function totp(b32, t = Date.now() / 1000) {
  const alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';
  let bits = '';
  for (const c of b32) bits += alphabet.indexOf(c).toString(2).padStart(5, '0');
  const key = Buffer.from(bits.match(/.{8}/g).map((b) => parseInt(b, 2)));
  const msg = Buffer.alloc(8);
  msg.writeBigUInt64BE(BigInt(Math.floor(t / 30)));
  const mac = crypto.createHmac('sha1', key).update(msg).digest();
  const o = mac[mac.length - 1] & 15;
  return String((mac.readUInt32BE(o) & 0x7fffffff) % 1e6).padStart(6, '0');
}
const currentCodes = () => [-30, 0, 30].map((d) => totp(SECRET, Date.now() / 1000 + d));

async function main() {
  let log = '';
  const waitFor = (re, ms = 180000) => new Promise((resolve, reject) => {
    const t0 = Date.now();
    const tick = () => {
      const m = log.match(re);
      if (m) return resolve(m);
      if (Date.now() - t0 > ms) return reject(new Error(`timed out waiting for ${re}\n${log}`));
      setTimeout(tick, 100);
    };
    tick();
  });
  const phone = spawn('flutter', ['test', 'tool/phone_harness_test.dart', `--dart-define=HARNESS_DIR=${work}`], { cwd: path.join(root, 'app') });
  phone.stdout.on('data', (d) => { log += d; });
  phone.stderr.on('data', (d) => { log += d; });

  const server = http.createServer((req, res) => {
    res.setHeader('content-type', 'text/html');
    res.end(req.url.startsWith('/plain')
      // A box the page script doesn't recognize, with the cursor in it: only the popup's button fills it.
      ? '<!doctype html><title>t</title><h1>Sign in</h1><input id="otp" name="box" autofocus>'
      : '<!doctype html><title>t</title><h1>Enter your verification code</h1><form><input id="otp" name="otp" autocomplete="one-time-code" inputmode="numeric"></form>');
  });
  await new Promise((r) => server.listen(0, '127.0.0.1', r));
  const site = (h, p = '/login.html') => `http://${h}:${server.address().port}${p}`;

  const ctx = await chromium.launchPersistentContext(path.join(work, 'profile'), {
    channel: 'chromium',
    headless: true,
    args: [`--disable-extensions-except=${extDir}`, `--load-extension=${extDir}`, '--host-resolver-rules=MAP *.test 127.0.0.1'],
  });
  try {
    let [sw] = ctx.serviceWorkers();
    if (!sw) sw = await ctx.waitForEvent('serviceworker');
    const extId = new URL(sw.url()).host;
    const bg = (fn, arg) => sw.evaluate(fn, arg);

    // Desktop app not running -> offer the phone -> QR.
    const popup = await ctx.newPage();
    popup.on('pageerror', (e) => { console.log('POPUP ERROR:', e.message); failures++; });
    await popup.goto(`chrome-extension://${extId}/popup.html`);
    await popup.getByText('Use my phone instead').click();
    const canvas = popup.locator('canvas.qr');
    await canvas.waitFor({ timeout: 15000 });
    const img = await canvas.evaluate((c) => {
      const d = c.getContext('2d').getImageData(0, 0, c.width, c.height);
      return { w: c.width, h: c.height, data: Array.from(d.data) };
    });
    // The QR is drawn edge to edge; give jsQR the white quiet zone a printed code has.
    const pad = 40, W = img.w + 2 * pad, H = img.h + 2 * pad;
    const px = new Uint8ClampedArray(W * H * 4).fill(255);
    for (let y = 0; y < img.h; y++) px.set(img.data.slice(y * img.w * 4, (y + 1) * img.w * 4), ((y + pad) * W + pad) * 4);
    const qr = jsQR(px, W, H)?.data || '';
    check(qr.startsWith('tanookiauth://link?v=1&relay='), `popup shows a pairing QR (${qr.slice(0, 40)}…)`);
    fs.writeFileSync(path.join(work, 'qr.txt'), qr);
    await waitFor(/PAIRED/, 120000);
    await popup.getByText('Test phone').waitFor({ timeout: 20000 });
    check(true, 'popup says paired with "Test phone" after the phone\'s hello decrypted');

    // A login page fills itself with the phone's code (phone approves: an account is saved for github.test).
    const login = await ctx.newPage();
    await login.goto(site('github.test'));
    await login.waitForFunction(() => document.getElementById('otp').value.length === 6, null, { timeout: 60000 }).catch(() => {});
    const filled = await login.inputValue('#otp');
    check(/APPROVE github\.test/.test(log) && currentCodes().includes(filled), `login page filled from the phone (${filled})`);

    // Popup's "Get code" button (the handler it calls), on a page whose box only the user's cursor marks.
    const plain = await ctx.newPage();
    await plain.goto(site('github.test', '/plain.html'));
    await plain.waitForTimeout(1500);
    const r = await bg(async (url) => {
      const t = (await chrome.tabs.query({})).find((x) => x.url === url);
      return self.handlersForTest.phoneFillTab({ tabId: t.id, tabUrl: url }).catch((e) => ({ error: e.code, message: e.message }));
    }, site('github.test', '/plain.html'));
    const typed = await plain.inputValue('#otp');
    check(r.filled === true && r.domain === 'github.test' && currentCodes().includes(typed), `"Get code" filled the box with the cursor in it (${JSON.stringify(r)})`);

    // Lookalike: the phone has nothing saved for it and denies; nothing is filled.
    const fake = await ctx.newPage();
    await fake.goto(site('gihtub.test'));
    await waitFor(/DENY gihtub\.test/, 60000).catch(() => {});
    await fake.waitForTimeout(3000);
    check(/DENY gihtub\.test/.test(log) && (await fake.inputValue('#otp')) === '', 'lookalike gihtub.test: phone denied, nothing filled');
    const denied = await bg(async (url) => {
      const t = (await chrome.tabs.query({})).find((x) => x.url === url);
      return self.handlersForTest.phoneFillTab({ tabId: t.id, tabUrl: url }).then(() => ({ ok: true }), (e) => ({ error: e.code }));
    }, site('gihtub.test'));
    check(denied.error === 'denied', `"Get code" on the lookalike reports the Deny (${JSON.stringify(denied)})`);

    const stored = JSON.stringify(await bg(() => chrome.storage.local.get(null)));
    check(!stored.includes(SECRET) && !currentCodes().some((c) => stored.includes(`"${c}"`)), 'extension storage holds no secret and no code');

    await popup.reload();
    await popup.getByText('Unpair phone').click();
    await popup.getByText('Use my phone instead').waitFor({ timeout: 15000 });
    check(Object.keys(await bg(() => chrome.storage.local.get(null))).length === 0, 'Unpair phone clears the pairing from storage');
    await waitFor(/UNPAIRED/, 20000).then(() => check(true, 'phone heard the unpair'), () => check(false, 'phone heard the unpair'));
  } finally {
    await ctx.close();
    server.close();
    fs.writeFileSync(path.join(work, 'done'), '');
    setTimeout(() => phone.kill(), 5000);
  }
  console.log(failures ? `${failures} FAILED` : 'ALL PASSED');
  process.exit(failures ? 1 : 0);
}

main().catch((e) => { console.error(e); process.exit(1); });
