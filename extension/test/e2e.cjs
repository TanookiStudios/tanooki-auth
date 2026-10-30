// Automated browser test: real extension in Chromium (headless) + real bridge code (tool/bridge_harness_test.dart).
// Run from the repo root with the Tanooki Auth app closed (it would answer instead of the harness):
//   NODE_PATH="$(npm root -g)" node extension/test/e2e.cjs
// ENGINE=firefox runs it in Playwright's Firefox instead (npx playwright install firefox). Firefox can't open
// the popup under Playwright, so there the popup's steps call the same background handlers the popup calls.
// Fake sites on *.test resolve to this Mac: github.test is the "real" site, github-login.test the lookalike.
const { chromium, firefox } = require('playwright');
const { installAddon } = require('./firefox.cjs');
const { spawn } = require('child_process');
const crypto = require('crypto');
const fs = require('fs');
const http = require('http');
const os = require('os');
const path = require('path');
const { domainToASCII } = require('url');

const root = path.resolve(__dirname, '../..');
// Overrides for running beside a real Tanooki Auth that holds port 41984: point these at copies of
// extension/ and app/ whose port lists were shifted (see extension/test/isolated.sh).
const extDir = process.env.EXT_DIR || path.join(root, 'extension');
const appDir = process.env.APP_DIR || path.join(root, 'app');
const bridgePort = process.env.BRIDGE_PORT || '41984';
const isFirefox = process.env.ENGINE === 'firefox';
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
const codesFor = (secret) => [totp(secret, Date.now() / 1000 - 1), totp(secret), totp(secret, Date.now() / 1000 + 1)];
const currentCodes = () => codesFor(SECRET);
// Two accounts saved for one site (multi.test), told apart by the email the page shows.
const ALICE = 'GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ';
const BOB = 'MFRGGZDFMZTWQ2LKNNWG23TPOBYXE43U';
const multiUri = (who, secret) => `otpauth://totp/Multi:${who}%40example.com?secret=${secret}&issuer=Multi`;
// Right-click QR images, drawn here with the extension's own QR library.
const qrcode = require(path.join(root, 'extension', 'qrcode.js'));
const qrImage = (text, svg) => { const q = qrcode(0, 'M'); q.addData(text); q.make(); return svg ? q.createSvgTag(6, 4) : Buffer.from(q.createDataURL(6, 4).split(',')[1], 'base64'); };
const RC_SECRET = 'ONSWG4TFORZWK3DFMNZGK5DTMVRXEZLU';
const qrImages = {
  '/rc-cross.gif': qrImage(`otpauth://totp/Rightclick:cross?secret=${RC_SECRET}&issuer=Rightclick`),
  '/rc.svg': qrImage('otpauth://totp/SvgSite:svg?secret=OBQXG43XN5ZGIZLTMVRXEZLUONSWG4TF&issuer=SvgSite', true),
  '/rc-migration.gif': qrImage('otpauth-migration://offline?data=CjEKCkhlbGxvId6tvu8SEnRlc3RAZXhhbXBsZS5jb20aBVRlc3QgASgBMAJCEzE2NTgyNjEyMTQ5NzIwNjI4MjMQAhgBIAA%3D'),
  '/rc-web.gif': qrImage('https://example.com/not-a-setup-code'),
};

const pages = {
  '/setup.html': '<h1>Set up two-factor authentication</h1><p>Scan this QR code with your authenticator app.</p><img id="qr" src="/setup-qr.png" width="240">',
  '/login.html': '<h1>Enter your verification code</h1><form><input id="otp" name="otp" autocomplete="one-time-code" inputmode="numeric"></form>',
  '/login6.html': '<h1>Two-factor code</h1><div id="boxes">' + Array.from({ length: 6 }, (_, i) => `<input id="d${i}" maxlength="1">`).join('') + '</div>',
  '/frame.html': '<h1>Totally legit</h1><iframe id="f" src="http://github.test:PORT/login.html" width="400" height="200"></iframe>',
  '/setup2.html': '<h1>Two-factor setup</h1><div style="width:240px;height:240px;background:url(/setup2-qr.png) 0 0/240px 240px"></div>',
  '/signin.html': '<h1>Sign in</h1><form><input name="login"><input type="password" name="password"></form>',
  '/multi.html': '<h1>Enter your verification code</h1><p>We sent a code for bob@example.com.</p><input id="otp" autocomplete="one-time-code">',
  '/multi-field.html': '<h1>Two-factor code</h1><input type="email" name="email" value="alice@example.com" readonly><input id="otp" name="otp">',
  '/multi-ask.html': '<h1>Enter your verification code</h1><input id="otp" autocomplete="one-time-code">',
  '/rightclick.html': '<h1>Some page</h1><img id="cross" src="http://cdn.test:PORT/rc-cross.gif" width="200"><img id="svg" src="/rc.svg" width="200"><img id="mig" src="/rc-migration.gif" width="200"><img id="web" src="/rc-web.gif" width="200"><img id="plain" src="/setup-qr.png" width="200">',
  '/ws.html': '<script>window.result="pending";const w=new WebSocket("ws://127.0.0.1:BRIDGE");w.onopen=()=>window.result="open";w.onerror=()=>window.result="refused";</script>',
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
    const p = new URL(req.url, 'http://x').pathname; // Firefox reaches us as a proxy, with full URLs
    if (qrImages[p]) { res.setHeader('content-type', p.endsWith('.svg') ? 'image/svg+xml' : 'image/gif'); return res.end(qrImages[p]); }
    if (p.endsWith('-qr.png')) { res.setHeader('content-type', 'image/png'); return res.end(fs.readFileSync(path.join(work, p.slice(1)))); }
    res.setHeader('content-type', 'text/html');
    res.end(pages[p] ? `<!doctype html><title>t</title>${pages[p].replace('PORT', server.address().port).replace('BRIDGE', bridgePort)}` : 'not found');
  });
  await new Promise((r) => server.listen(0, '127.0.0.1', r));
  const port = server.address().port;
  const site = (h, p) => `http://${h}:${port}${p}`;

  // 3. The browser with the extension, no window on screen.
  // BROWSER=/path/to/Brave runs the same checks in another Chromium-based browser.
  let ctx, bg, extId;
  if (isFirefox) {
    const debugPort = 6000 + Math.floor(Math.random() * 1000);
    ctx = await firefox.launchPersistentContext(path.join(work, 'profile'), {
      headless: true,
      args: ['-start-debugger-server', String(debugPort)],
      proxy: { server: `http://127.0.0.1:${port}`, bypass: '127.0.0.1' }, // reaches the *.test sites; the app is direct
      firefoxUserPrefs: {
        'devtools.debugger.remote-enabled': true, 'devtools.debugger.prompt-connection': false, 'devtools.chrome.enabled': true,
        'network.proxy.allow_hijacking_localhost': false,
      },
    });
    bg = await installAddon(debugPort, extDir, JSON.parse(fs.readFileSync(path.join(extDir, 'manifest.json'))).browser_specific_settings.gecko.id);
  } else {
    ctx = await chromium.launchPersistentContext(path.join(work, 'profile'), {
      ...(process.env.BROWSER ? { executablePath: process.env.BROWSER } : { channel: 'chromium' }),
      headless: true,
      args: [
        `--disable-extensions-except=${extDir}`,
        `--load-extension=${extDir}`,
        '--host-resolver-rules=MAP *.test 127.0.0.1',
      ],
    });
  }
  const consoleText = [];
  ctx.on('console', (m) => consoleText.push(m.text()));
  console.log(`browser: ${isFirefox ? 'Firefox' : 'Chromium'} ${ctx.browser()?.version() ?? ''}`.trim());
  try {
    if (!isFirefox) {
      let [sw] = ctx.serviceWorkers();
      if (!sw) sw = await ctx.waitForEvent('serviceworker');
      extId = new URL(sw.url()).host;
      bg = (fn, arg) => sw.evaluate(fn, arg);
    }

    // App not running: the popup must say so quickly (it used to hang for many seconds).
    if (isFirefox) {
      for (let i = 0; i < 2; i++) {
        const t0 = Date.now();
        const s = await bg(() => self.handlersForTest.status());
        const ms = Date.now() - t0;
        check(s.state === 'noApp' && /isn't running/.test(s.message) && ms < 2500, `"isn't running" reported quickly with the app closed, try ${i + 1} (${ms} ms)`);
      }
    } else {
      const early = await ctx.newPage();
      for (let i = 0; i < 2; i++) {
        const t0 = Date.now();
        await early.goto(`chrome-extension://${extId}/popup.html`);
        await early.getByText('isn\'t running').waitFor({ timeout: 15000 });
        const ms = Date.now() - t0;
        check(ms < 2500, `"isn't running" shown quickly with the app closed, try ${i + 1} (${ms} ms)`);
      }
      await early.close();
    }

    // Now start the app, as a person would after seeing that message.
    harness = spawn('flutter', ['test', 'tool/bridge_harness_test.dart', `--dart-define=HARNESS_DIR=${work}`], { cwd: appDir });
    harness.stdout.on('data', (d) => { log += d; });
    harness.stderr.on('data', (d) => { log += d; });
    await waitFor(/READY (\d+)/);



    // Pair through the popup (straight after those failed attempts, which used to slow everything down).
    let popup = null;
    if (isFirefox) {
      await bg(() => self.handlersForTest.pairStart());
      const [, pairCode] = await waitFor(/PAIRCODE (\d{6})/, 10000);
      const r = await bg((code) => self.handlersForTest.pairFinish({ code }), pairCode);
      check(r?.ok === true && (await bg(() => self.handlersForTest.status())).state === 'ready', 'paired with the code the app showed');
    } else {
      popup = await ctx.newPage();
      popup.on('pageerror', (e) => { console.log('POPUP ERROR:', e.message); failures++; });
      await popup.goto(`chrome-extension://${extId}/popup.html`);
      await popup.getByText('Pair with Tanooki Auth').click();
      const [, pairCode] = await waitFor(/PAIRCODE (\d{6})/, 10000);
      await popup.locator('input').fill(pairCode);
      await popup.getByRole('button', { name: 'Pair', exact: true }).click();
      await popup.getByText('All accounts').waitFor({ timeout: 10000 });
      check(true, 'paired with the code the app showed');
    }

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

    // Toolbar countdown for the tab with the filled code, ticking without the popup open.
    const badgeOf = (url) => bg(async (u) => {
      const t = (await chrome.tabs.query({})).find((x) => x.url === u);
      return t ? chrome.action.getBadgeText({ tabId: t.id }) : 'no tab';
    }, url);
    const loginUrl = site('github.test', '/login.html');
    const b1 = await badgeOf(loginUrl);
    await login.waitForTimeout(2200);
    const b2 = await badgeOf(loginUrl);
    const secs = Math.ceil(30 - (Date.now() / 1000) % 30);
    const off = Math.abs(+b2 - secs) % 30;
    check(/^\d+$/.test(b1) && +b1 >= 1 && +b1 <= 30 && /^\d+$/.test(b2) && b1 !== b2 && Math.min(off, 30 - off) <= 2,
      `badge counts down the seconds left (${b1} then ${b2}, expected about ${secs})`);

    // One-box-per-digit login.
    const six = await ctx.newPage();
    await six.goto(site('github.test', '/login6.html'));
    await six.waitForFunction(() => document.getElementById('d5').value !== '', null, { timeout: 10000 }).catch(() => {});
    const digits = await six.evaluate(() => [...document.querySelectorAll('#boxes input')].map((i) => i.value).join(''));
    check(currentCodes().includes(digits), `six single-digit boxes filled (${digits})`);

    check(await login.locator('[data-tanooki-auth-warning]').count() === 0, 'no lookalike warning on the real github.test');

    // Lookalike sites: warning banner, nothing fills. (Matcher details: test/lookalike.test.cjs.)
    const lookalikes = [
      ['github-login.test', '/login.html', 'saved name inside another name'],
      ['gihtub.test', '/login.html', 'swapped letters'],
      ['github.test.evil.test', '/login.html', 'saved domain at the front of another domain'],
      [domainToASCII('gіthub.test'), '/login.html', 'Cyrillic і (punycode)'],
      ['githubb.test', '/signin.html', 'password page, no code box yet'],
    ];
    for (const [h, p, why] of lookalikes) {
      const fake = await ctx.newPage();
      await fake.goto(site(h, p));
      const banner = await fake.locator('[data-tanooki-auth-warning]').waitFor({ state: 'attached', timeout: 6000 }).then(() => true, () => false);
      const otp = p === '/login.html' ? await fake.inputValue('#otp') : '';
      check(banner && otp === '', `lookalike ${h} (${why}): warning shown, nothing filled`);
      await fake.close();
    }
    const warning = await bg((url) => self.handlersForTest.checkSite({}, { url }), site('gihtub.test', '/login.html'));
    check(warning.message === "This site looks like github.test but isn't. Tanooki Auth won't fill codes here.", `warning text: ${warning.message}`);
    const notLookalike = await ctx.newPage();
    await notLookalike.goto(site('gitlab.test', '/login.html'));
    await notLookalike.waitForTimeout(3000);
    check(await notLookalike.locator('[data-tanooki-auth-warning]').count() === 0 && await notLookalike.inputValue('#otp') === '',
      'unrelated gitlab.test: no warning, nothing filled');
    // The popup's "Use here" must not let a lookalike be saved for an account.
    const useHerePage = await ctx.newPage();
    await useHerePage.goto(site('gihtub.test', '/login.html'));
    const useHere = await bg(async (url) => {
      const t = (await chrome.tabs.query({})).find((x) => x.url === url);
      const { accounts } = await self.handlersForTest.listForTab({ tabUrl: url });
      return self.handlersForTest.fillTab({ accountId: accounts[0].id, tabId: t.id, tabUrl: url, remember: true })
        .then(() => ({ ok: true }), (e) => ({ error: e.code }));
    }, site('gihtub.test', '/login.html'));
    check(useHere.error === 'lookalike', `"Use here" refused on a lookalike (${JSON.stringify(useHere)})`);
    await useHerePage.close();

    // The real site framed inside another site: nothing fills.
    const framed = await ctx.newPage();
    await framed.goto(site('evil.test', '/frame.html'));
    await framed.waitForTimeout(3000);
    const inner = framed.frames().find((f) => f.url().includes('github.test'));
    check(!!inner && await inner.inputValue('#otp') === '', 'nothing filled when github.test is framed by evil.test');

    // Popup lists accounts with the right live code, and can open the app's settings.
    if (isFirefox) {
      const list = await bg((tabUrl) => self.handlersForTest.listForTab({ tabUrl }), site('github.test', '/login.html'));
      const id = list.matching[0];
      const { codes } = await bg((accountIds) => self.handlersForTest.codes({ accountIds }), [id]);
      check(list.matching.length === 1 && currentCodes().includes(codes[id].code), `popup data: account for github.test with the live code (${codes[id]?.code})`);
      await bg(() => self.handlersForTest.openApp({ screen: 'settings' }));
      await waitFor(/OPEN settings/, 5000);
      check(true, '"Backup & settings…" opens the app on Settings');
    } else {
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
    }

    // "Scan page" finds a QR the in-page scanner can't see (CSS background) and adds it for that site.
    const setup2 = await ctx.newPage();
    await setup2.goto(site('other.test', '/setup2.html'));
    await setup2.bringToFront();
    await setup2.waitForTimeout(1500);
    check(await setup2.getByText('+ Add to Tanooki Auth').count() === 0, 'in-page scanner cannot see the CSS-background QR');
    const scan = await bg(async (url) => {
      const t = (await chrome.tabs.query({})).find((x) => x.url === url);
      return new Promise((resolve) => self.handlersForTest.scanTab({ windowId: t.windowId, tabUrl: t.url }).then(resolve, (e) => resolve({ error: e.message })));
    }, site('other.test', '/setup2.html'));
    check(scan.accepted === true, `"Scan page" added the QR from the screen (${JSON.stringify(scan)})`);
    await waitFor(/CONFIRM OtherSite other\.test/, 5000);

    // Two accounts for one site: the email on the page picks which code to fill.
    for (const [who, secret] of [['alice', ALICE], ['bob', BOB]]) {
      await bg((uri) => call({ type: 'add', uri, domain: 'multi.test' }), multiUri(who, secret));
    }
    const fillOf = async (p) => {
      const page = await ctx.newPage();
      await page.goto(site('multi.test', p));
      await page.waitForFunction(() => document.getElementById('otp').value.length === 6, null, { timeout: 6000 }).catch(() => {});
      return { page, value: await page.inputValue('#otp') };
    };
    const shownEmail = await fillOf('/multi.html');
    check(codesFor(BOB).includes(shownEmail.value), `two accounts on multi.test: bob's code filled from the email in the text (${shownEmail.value})`);
    const field = await fillOf('/multi-field.html');
    check(codesFor(ALICE).includes(field.value), `two accounts on multi.test: alice's code filled from the email field (${field.value})`);
    const ask = await fillOf('/multi-ask.html');
    const askBadge = await badgeOf(site('multi.test', '/multi-ask.html'));
    check(ask.value === '' && askBadge === '2', `no email on the page: nothing filled, badge says 2 to choose from (${JSON.stringify([ask.value, askBadge])})`);
    // Same tab moves on to a page with no matching account: the countdown badge goes away.
    await field.page.goto(site('gitlab.test', '/login.html'));
    await field.page.waitForTimeout(1500);
    check(await badgeOf(site('gitlab.test', '/login.html')) === '', 'badge cleared after the tab moved to a site with no account');
    for (const x of [shownEmail, field, ask]) await x.page.close();

    // Right-click "Add to Tanooki Auth" on images (the menu's click handler, called directly).
    const rc = await ctx.newPage();
    await rc.goto(site('qr.test', '/rightclick.html'));
    await rc.waitForFunction(() => [...document.images].every((i) => i.complete), null, { timeout: 5000 });
    const rightClick = (id) => bg(async ([u, srcUrl]) => {
      const tab = (await chrome.tabs.query({})).find((x) => x.url === u);
      return self.handlersForTest.addImage({ srcUrl, frameId: 0 }, { tab }).then((r) => r, (e) => ({ error: e.code, message: e.message }));
    }, [site('qr.test', '/rightclick.html'), id.startsWith('http') ? id : site('qr.test', id)]);
    const cross = await rightClick(site('cdn.test', '/rc-cross.gif'));
    check(cross.accepted === true, `right-click on an image from another site: added (${JSON.stringify(cross)})`);
    await waitFor(/CONFIRM Rightclick qr\.test/, 5000);
    const svg = await rightClick('/rc.svg');
    check(svg.accepted === true, `right-click on an SVG image: added (${JSON.stringify(svg)})`);
    await waitFor(/CONFIRM SvgSite qr\.test/, 5000);
    const again = await rightClick('/setup-qr.png');
    check(again.accepted === false && again.reason === 'duplicate', `right-click on a QR already saved: "already in" (${JSON.stringify(again)})`);
    const mig = await rightClick('/rc-migration.gif');
    check(mig.error === 'oldApp' && /can't add Google Authenticator transfer codes from the browser yet/.test(mig.message),
      `Google Authenticator transfer QR with an app that can't take it yet: clear message (${mig.message})`);
    const web = await rightClick('/rc-web.gif');
    check(web.error === 'notSetup', `right-click on a QR that's just a web link: refused (${web.message})`);
    const none = await rightClick(site('qr.test', '/rightclick.html'));
    check(none.error === 'noQr', `right-click on something with no QR code: says so (${none.message})`);
    check(!consoleText.some((t) => t.includes(RC_SECRET) || t.includes('otpauth')), 'right-click: nothing about the setup code in any console');
    await rc.close();

    // Secrets never reach the extension's storage.
    const stored = await bg(() => chrome.storage.local.get(null));
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
