// Automated browser test: real extension in Chromium (headless) + real bridge code (tool/bridge_harness_test.dart).
// Run from the repo root with the Tanooki Auth app closed (it would answer instead of the harness):
//   NODE_PATH="$(npm root -g)" node extension/test/e2e.cjs
// Fake sites on *.test resolve to this Mac: github.test is the "real" site, github-login.test the lookalike.
const { chromium } = require('playwright');
const { spawn } = require('child_process');
const crypto = require('crypto');
const fs = require('fs');
const http = require('http');
const os = require('os');
const path = require('path');

const root = path.resolve(__dirname, '../..');
const work = fs.mkdtempSync(path.join(os.tmpdir(), 'ta-e2e-'));
const SECRET = 'KRUGKIDROVUWG2ZAMJZG653OEBTG66BAN52XE';
// Codes are only checked for TestSite (SECRET); OtherSite just has to be added.
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
const currentCodes = () => [totp(SECRET, Date.now() / 1000 - 1), totp(SECRET), totp(SECRET, Date.now() / 1000 + 1)];

const pages = {
  '/setup.html': '<h1>Set up two-factor authentication</h1><p>Scan this QR code with your authenticator app.</p><img id="qr" src="/setup-qr.png" width="240">',
  '/login.html': '<h1>Enter your verification code</h1><form><input id="otp" name="otp" autocomplete="one-time-code" inputmode="numeric"></form>',
  '/login6.html': '<h1>Two-factor code</h1><div id="boxes">' + Array.from({ length: 6 }, (_, i) => `<input id="d${i}" maxlength="1">`).join('') + '</div>',
  '/frame.html': '<h1>Totally legit</h1><iframe id="f" src="http://github.test:PORT/login.html" width="400" height="200"></iframe>',
  '/setup2.html': '<h1>Two-factor setup</h1><div style="width:240px;height:240px;background:url(/setup2-qr.png) 0 0/240px 240px"></div>',
  '/ws.html': '<script>window.result="pending";const w=new WebSocket("ws://127.0.0.1:41984");w.onopen=()=>window.result="open";w.onerror=()=>window.result="refused";</script>',
};

async function main() {
  let harness = null;
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
  // 2. Fake websites.
  const server = http.createServer((req, res) => {
    const p = req.url.split('?')[0];
    if (p.endsWith('-qr.png')) { res.setHeader('content-type', 'image/png'); return res.end(fs.readFileSync(path.join(work, p.slice(1)))); }
    res.setHeader('content-type', 'text/html');
    res.end(pages[p] ? `<!doctype html><title>t</title>${pages[p].replace('PORT', server.address().port)}` : 'not found');
  });
  await new Promise((r) => server.listen(0, '127.0.0.1', r));
  const port = server.address().port;
  const site = (h, p) => `http://${h}:${port}${p}`;

  // 3. Chromium with the extension, no window on screen.
  // BROWSER=/path/to/Brave runs the same checks in another Chromium-based browser.
  const ctx = await chromium.launchPersistentContext(path.join(work, 'profile'), {
    ...(process.env.BROWSER ? { executablePath: process.env.BROWSER } : { channel: 'chromium' }),
    headless: true,
    args: [
      `--disable-extensions-except=${path.join(root, 'extension')}`,
      `--load-extension=${path.join(root, 'extension')}`,
      '--host-resolver-rules=MAP *.test 127.0.0.1',
    ],
  });
  try {
    let [sw] = ctx.serviceWorkers();
    if (!sw) sw = await ctx.waitForEvent('serviceworker');
    const extId = new URL(sw.url()).host;

    // App not running: the popup must say so quickly (it used to hang for many seconds).
    const early = await ctx.newPage();
    for (let i = 0; i < 2; i++) {
      const t0 = Date.now();
      await early.goto(`chrome-extension://${extId}/popup.html`);
      await early.getByText('isn\'t running').waitFor({ timeout: 15000 });
      const ms = Date.now() - t0;
      check(ms < 2500, `"isn't running" shown quickly with the app closed, try ${i + 1} (${ms} ms)`);
    }
    await early.close();

    // Now start the app, as a person would after seeing that message.
    harness = spawn('flutter', ['test', 'tool/bridge_harness_test.dart', `--dart-define=HARNESS_DIR=${work}`], { cwd: path.join(root, 'app') });
    harness.stdout.on('data', (d) => { log += d; });
    harness.stderr.on('data', (d) => { log += d; });
    await waitFor(/READY (\d+)/);



    // Pair through the popup (straight after those failed attempts, which used to slow everything down).
    const popup = await ctx.newPage();
    popup.on('pageerror', (e) => { console.log('POPUP ERROR:', e.message); failures++; });
    await popup.goto(`chrome-extension://${extId}/popup.html`);
    await popup.getByText('Pair with Tanooki Auth').click();
    const [, pairCode] = await waitFor(/PAIRCODE (\d{6})/, 10000);
    await popup.locator('input').fill(pairCode);
    await popup.getByRole('button', { name: 'Pair', exact: true }).click();
    await popup.getByText('All accounts').waitFor({ timeout: 10000 });
    check(true, 'paired with the code the app showed');

    // A web page must not be able to talk to the app.
    const wsPage = await ctx.newPage();
    await wsPage.goto(site('github.test', '/ws.html'));
    await wsPage.waitForFunction(() => window.result !== 'pending', null, { timeout: 5000 });
    check(await wsPage.evaluate(() => window.result) === 'refused', 'web page WebSocket to the app is refused');

    // Setup QR on the page -> injected Add button -> app confirms -> stored with the site's domain.
    const setup = await ctx.newPage();
    await setup.goto(site('github.test', '/setup.html'));
    const add = setup.getByText('+ Add to Tanooki Auth');
    await add.waitFor({ timeout: 10000 });
    check(true, 'Add button appeared next to the setup QR code');
    await add.click();
    await setup.getByText('Added to Tanooki Auth ✓').waitFor({ timeout: 10000 });
    await waitFor(/CONFIRM TestSite github\.test/, 5000);
    check(true, 'account added after the app confirmed, saved for github.test');

    // Login page on the right site -> filled with the current code.
    const login = await ctx.newPage();
    await login.goto(site('github.test', '/login.html'));
    await login.waitForFunction(() => document.getElementById('otp').value.length === 6, null, { timeout: 10000 }).catch(() => {});
    const filled = await login.inputValue('#otp');
    check(currentCodes().includes(filled), `code filled on github.test (${filled})`);

    // One-box-per-digit login.
    const six = await ctx.newPage();
    await six.goto(site('github.test', '/login6.html'));
    await six.waitForFunction(() => document.getElementById('d5').value !== '', null, { timeout: 10000 }).catch(() => {});
    const digits = await six.evaluate(() => [...document.querySelectorAll('#boxes input')].map((i) => i.value).join(''));
    check(currentCodes().includes(digits), `six single-digit boxes filled (${digits})`);

    // Lookalike site: nothing fills.
    const fake = await ctx.newPage();
    await fake.goto(site('github-login.test', '/login.html'));
    await fake.waitForTimeout(3000);
    check(await fake.inputValue('#otp') === '', 'nothing filled on lookalike github-login.test');

    // The real site framed inside another site: nothing fills.
    const framed = await ctx.newPage();
    await framed.goto(site('evil.test', '/frame.html'));
    await framed.waitForTimeout(3000);
    const inner = framed.frames().find((f) => f.url().includes('github.test'));
    check(!!inner && await inner.inputValue('#otp') === '', 'nothing filled when github.test is framed by evil.test');

    // Popup lists accounts with the right live code, and can open the app's settings.
    await popup.bringToFront();
    await popup.reload();
    const tPopup = Date.now();
    await popup.getByText('TestSite').waitFor({ timeout: 10000 }).catch(async (e) => {
      console.log('POPUP TEXT:', await popup.locator('body').innerText());
      throw e;
    });
    await popup.waitForFunction(() => /^\d{3} \d{3}$/.test(document.querySelector('.code')?.textContent || ''), null, { timeout: 10000 });
    const popupMs = Date.now() - tPopup;
    check(popupMs < 2000, `popup ready with live codes quickly (${popupMs} ms)`);
    const shown = (await popup.locator('.code').first().textContent()).replace(' ', '');
    check(currentCodes().includes(shown), `popup shows the live code (${shown})`);
    if (process.env.POPUP_SHOT) {
      await popup.setViewportSize({ width: 360, height: 600 });
      await popup.screenshot({ path: process.env.POPUP_SHOT, fullPage: true });
    }
    await popup.getByText('Backup & settings…').click();
    await waitFor(/OPEN settings/, 5000);
    check(true, '"Backup & settings…" opens the app on Settings');

    // "Scan page" finds a QR the in-page scanner can't see (CSS background) and adds it for that site.
    const setup2 = await ctx.newPage();
    await setup2.goto(site('other.test', '/setup2.html'));
    await setup2.bringToFront();
    await setup2.waitForTimeout(1500);
    check(await setup2.getByText('+ Add to Tanooki Auth').count() === 0, 'in-page scanner cannot see the CSS-background QR');
    const scan = await sw.evaluate(async (url) => {
      const [t] = await chrome.tabs.query({ url });
      return new Promise((resolve) => self.handlersForTest.scanTab({ windowId: t.windowId, tabUrl: t.url }).then(resolve, (e) => resolve({ error: e.message })));
    }, site('other.test', '/setup2.html'));
    check(scan.accepted === true, `"Scan page" added the QR from the screen (${JSON.stringify(scan)})`);
    await waitFor(/CONFIRM OtherSite other\.test/, 5000);

    // Secrets never reach the extension's storage.
    const stored = await sw.evaluate(() => chrome.storage.local.get(null));
    check(!JSON.stringify(stored).includes(SECRET) && Object.keys(stored).join() === 'token', 'extension storage holds only the pairing token');
  } finally {
    await ctx.close();
    server.close();
    fs.writeFileSync(path.join(work, 'done'), '');
    await waitFor(/ACCOUNTS .*/, 30000).then(([l]) => console.log(l)).catch(() => {});
    harness?.kill();
  }
  console.log(failures ? `${failures} FAILED` : 'ALL PASSED');
  process.exit(failures ? 1 : 0);
}

main().catch((e) => { console.error(e); process.exit(1); });
