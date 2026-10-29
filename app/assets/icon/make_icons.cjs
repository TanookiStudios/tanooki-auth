// Renders the blue-shield icon masters with Chromium. Run from the repo root:
//   NODE_PATH="$(npm root -g)" node app/assets/icon/make_icons.cjs
const { chromium } = require('playwright');
const path = require('path');

const BLUE = '#2F80FF', BG = '#0B0B0D';
// Shield in a 1024 box, centered; `s` scales it about the center.
const shield = (s) => `<g transform="translate(512 512) scale(${s}) translate(-512 -512)">
  <path fill="${BLUE}" d="M512 120 L812 232 Q840 243 840 273 L840 500 Q840 780 512 920 Q184 780 184 500 L184 273 Q184 243 212 232 Z"/>
  <path fill="rgba(255,255,255,.18)" d="M512 120 L812 232 Q840 243 840 273 L840 500 Q840 780 512 920 Z"/>
</g>`;
const svg = (body) => `<svg xmlns="http://www.w3.org/2000/svg" width="1024" height="1024" viewBox="0 0 1024 1024">${body}</svg>`;

const out = path.join(__dirname);
const jobs = {
  // iOS / store: full square, no transparency (the system rounds the corners).
  'icon-square.png': [1024, svg(`<rect width="1024" height="1024" fill="${BG}"/>${shield(0.78)}`)],
  // macOS / Windows: rounded tile with Apple's standard margin, transparent outside.
  'icon-rounded.png': [1024, svg(`<rect x="100" y="100" width="824" height="824" rx="185" fill="${BG}" stroke="#2A2A30" stroke-width="6"/>${shield(0.62)}`)],
  // Android adaptive foreground: shield inside the 66% safe zone on transparent.
  'icon-foreground.png': [1024, svg(shield(0.56))],
  // Browser extension toolbar icons: shield alone.
  ...Object.fromEntries([16, 32, 48, 128].map((n) => [`../../../extension/icons/icon${n}.png`, [n, svg(shield(1.08))]])),
};

(async () => {
  const browser = await chromium.launch();
  const page = await browser.newPage();
  for (const [name, [size, markup]] of Object.entries(jobs)) {
    await page.setViewportSize({ width: size, height: size });
    await page.setContent(`<html><body style="margin:0;background:transparent">${markup.replace('width="1024" height="1024"', `width="${size}" height="${size}"`)}</body></html>`);
    await page.screenshot({ path: path.join(out, name), omitBackground: true });
    console.log('wrote', name);
  }
  await browser.close();
})();
