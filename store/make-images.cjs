// Makes the browser store images in store/images/ from the site's screenshots:
// four 1280x800 screenshots and a 440x280 promo tile, as PNGs with no transparency (Chrome rejects alpha).
// Run: NODE_PATH="$(npm root -g)" node store/make-images.cjs   (uses the globally installed Playwright)
const { chromium } = require('playwright');
const fs = require('fs');
const path = require('path');

const root = path.join(__dirname, '..');
const out = path.join(__dirname, 'images');
const img = (f) => 'data:image/' + (f.endsWith('.png') ? 'png' : 'jpeg') + ';base64,' + fs.readFileSync(path.join(root, 'site/public', f)).toString('base64');
const tokens = fs.readFileSync(path.join(root, 'site/public/tokens.css'), 'utf8');

const shell = (w, h, body) => `<!doctype html><html><head><meta charset="utf-8">
<link href="https://fonts.googleapis.com/css2?family=Geist:wght@400;600;650&display=swap" rel="stylesheet">
<style>${tokens}
* { box-sizing: border-box; margin: 0; }
html, body { width: ${w}px; height: ${h}px; overflow: hidden; }
body { background: var(--color-paper); color: var(--color-ink); font-family: var(--font-body); display: grid; grid-template-columns: 1fr auto; align-items: center; gap: 56px; padding: 0 72px; }
h1 { font-size: 56px; line-height: 1.02; letter-spacing: var(--tracking-display); font-weight: 650; max-width: 11ch; }
p { margin-top: 24px; font-size: 24px; line-height: 1.4; color: var(--color-ink-2); max-width: 22ch; }
.brand { display: flex; align-items: center; gap: 12px; font-weight: 650; font-size: 22px; margin-bottom: 40px; }
.brand img { width: 40px; height: 40px; border-radius: 10px; }
.shots { display: flex; gap: 24px; align-items: center; }
.phone { height: 680px; border-radius: 28px; outline: 1px solid var(--color-rule-2); }
.small { height: 520px; }
.ext { width: 360px; border-radius: 16px; outline: 1px solid var(--color-rule-2); }
</style></head><body>${body}</body></html>`;

const brand = `<div class="brand"><img src="${img('icon.png')}" alt="">Tanooki Auth</div>`;
const slide = (title, text, shots) => shell(1280, 800, `<div>${brand}<h1>${title}</h1><p>${text}</p></div><div class="shots">${shots}</div>`);

const images = [
  ['screenshot-1-fill.png', 1280, 800, slide('Codes filled in for you', 'Only on the exact website each account belongs to, so lookalike sites get nothing.', `<img class="ext" src="${img('screens/extension.png')}" alt="">`)],
  ['screenshot-2-accounts.png', 1280, 800, slide('Your codes stay on your device', 'No account and no cloud. The extension talks only to the Tanooki Auth app on your computer.', `<img class="phone" src="${img('screens/phone-accounts.jpg')}" alt="">`)],
  ['screenshot-3-add.png', 1280, 800, slide('Add an account from its QR code', 'Right-click a setup QR code and pick “Add to Tanooki Auth”, or scan it with the app.', `<img class="phone" src="${img('screens/phone-add.jpg')}" alt="">`)],
  ['screenshot-4-themes.png', 1280, 800, slide('Free, with optional Premium', 'Premium is a one-time purchase: more themes, encrypted sync and approve from your phone.', ['theme-light', 'theme-pink', 'theme-blue'].map((t) => `<img class="phone small" src="${img(`screens/${t}.jpg`)}" alt="">`).join(''))],
  ['promo-tile-440x280.png', 440, 280, shell(440, 280, `<div style="grid-column:1/-1;text-align:center;display:grid;justify-items:center;gap:14px">
    <img src="${img('icon.png')}" alt="" style="width:96px;height:96px;border-radius:22px">
    <div style="font-size:34px;font-weight:650;letter-spacing:-0.02em">Tanooki Auth</div>
    <div style="font-size:17px;color:var(--color-ink-2)">Two-factor codes, filled on the right site</div></div>`).replace('padding: 0 72px', 'padding: 0 24px')],
];

(async () => {
  fs.mkdirSync(out, { recursive: true });
  const browser = await chromium.launch();
  for (const [name, w, h, html] of images) {
    const page = await browser.newPage({ viewport: { width: w, height: h } });
    await page.setContent(html, { waitUntil: 'networkidle' });
    await page.evaluate(() => document.fonts.ready);
    await page.screenshot({ path: path.join(out, name) });
    await page.close();
    console.log('made', name, `${w}x${h}`);
  }
  await browser.close();
})().catch((e) => { console.error(e); process.exit(1); });
