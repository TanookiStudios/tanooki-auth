// Renders the Premium alternate app icons: the blue-shield design from assets/icon/make_icons.cjs,
// recolored with each theme's background and accent read straight from lib/ui/theme.dart.
// Run from the repo root:  NODE_PATH="$(npm root -g)" node app/tool/make_app_icons.cjs
// The icon ids must match appIcons in lib/ui/app_icon.dart (test/app_icon_test.dart checks every file).
const { chromium } = require('playwright');
const { execFileSync } = require('child_process');
const fs = require('fs');
const path = require('path');

// Seasonal icons: the same shield in season colors with a small touch drawn around it (inside the shield's
// group, so it scales with the shield on every platform, Android's adaptive foreground included).
const flake = (x, y, r) => `<g transform="translate(${x} ${y})" stroke="#FFFFFF" stroke-width="${r / 5}" stroke-linecap="round">${
  [0, 60, 120].map((a) => `<line x1="0" y1="${-r}" x2="0" y2="${r}" transform="rotate(${a})"/>`).join('')}</g>`;
const blossom = (x, y, r) => `<g transform="translate(${x} ${y})">${
  [0, 72, 144, 216, 288].map((a) => `<circle cx="0" cy="${-r * 0.62}" r="${r * 0.5}" fill="#F7A8C8" transform="rotate(${a})"/>`).join('')
}<circle r="${r * 0.32}" fill="#FFD95A"/></g>`;
const bat = (x, y, s) => `<path fill="#B58BD6" transform="translate(${x} ${y}) scale(${s})" d="M-50 0 Q-38 -22 -14 -12 Q-8 -26 0 -14 Q8 -26 14 -12 Q38 -22 50 0 Q34 -4 26 10 Q18 0 10 12 Q4 2 0 10 Q-4 2 -10 12 Q-18 0 -26 10 Q-34 -4 -50 0 Z"/>`;
const seasonal = {
  // Fall: pumpkin-orange shield under a crescent moon, two bats.
  spooky: { bg: '#1A1022', fg: '#F07A1A', touch: (bg) =>
    `<circle cx="830" cy="170" r="92" fill="#FFD27A"/><circle cx="790" cy="140" r="84" fill="${bg}"/>${bat(230, 170, 2.4)}${bat(880, 470, 1.7)}` },
  // Winter: warm red shield with snow on top and snowflakes around it.
  cozy: { bg: '#0E2238', fg: '#D9364F', touch: () =>
    `<path fill="#FFFFFF" d="M212 232 L512 120 L812 232 Q840 243 840 273 L840 300 Q790 330 740 300 Q690 340 630 302 Q570 342 512 304 Q454 342 394 302 Q334 340 284 300 Q234 330 184 300 L184 273 Q184 243 212 232 Z"/>${
      flake(200, 140, 46)}${flake(860, 420, 38)}${flake(150, 640, 30)}${flake(880, 780, 44)}` },
  // Spring: leaf-green shield with blossoms around it.
  spring: { bg: '#EEF8EA', fg: '#3E9E5F', touch: () => `${blossom(210, 160, 70)}${blossom(860, 380, 54)}${blossom(170, 760, 48)}${blossom(870, 840, 62)}` },
};
const ids = ['pink', 'blue', 'lavender', 'mint', 'midnight', 'sunset', ...Object.keys(seasonal)];
const app = path.join(__dirname, '..');
const themeSrc = fs.readFileSync(path.join(app, 'lib/ui/theme.dart'), 'utf8');

function colors(id) {
  if (seasonal[id]) return { ...seasonal[id], touch: seasonal[id].touch(seasonal[id].bg) };
  const block = themeSrc.match(new RegExp(`'${id}': AppPalette\\(([\\s\\S]*?)\\n  \\),`));
  if (!block) throw new Error(`theme '${id}' not found in theme.dart`);
  const pick = (k) => '#' + block[1].match(new RegExp(`${k}: Color\\(0xFF([0-9A-Fa-f]{6})\\)`))[1].toUpperCase();
  return { bg: pick('background'), fg: pick('accent') };
}

// Same shield path as make_icons.cjs, in a 1024 box, scaled about the center.
const shield = (s, fg, touch = '') => `<g transform="translate(512 512) scale(${s}) translate(-512 -512)">
  <path fill="${fg}" d="M512 120 L812 232 Q840 243 840 273 L840 500 Q840 780 512 920 Q184 780 184 500 L184 273 Q184 243 212 232 Z"/>
  <path fill="rgba(255,255,255,.18)" d="M512 120 L812 232 Q840 243 840 273 L840 500 Q840 780 512 920 Z"/>
  ${touch}
</g>`;
const svg = (body) => `<svg xmlns="http://www.w3.org/2000/svg" width="1024" height="1024" viewBox="0 0 1024 1024">${body}</svg>`;
const square = ({ bg, fg, touch }) => svg(`<rect width="1024" height="1024" fill="${bg}"/>${shield(0.78, fg, touch)}`);
const rounded = ({ bg, fg, touch }) =>
  svg(`<rect x="100" y="100" width="824" height="824" rx="185" fill="${bg}" stroke="rgba(128,128,128,.35)" stroke-width="6"/>${shield(0.62, fg, touch)}`);

const res = path.join(app, 'android/app/src/main/res');
const jobs = [];
const palettes = { default: { bg: '#0B0B0D', fg: '#2F80FF' } };
for (const id of ids) palettes[id] = colors(id);
for (const [id, c] of Object.entries(palettes)) {
  // Picker preview, and the Mac Dock icon while the app runs.
  jobs.push([path.join(app, `assets/app_icons/${id}.png`), 512, rounded(c), true]);
  if (id === 'default') continue; // the real launcher icons already exist for the default
  // iOS alternate icon: one 1024 square, Xcode makes the other sizes. No transparency allowed.
  jobs.push([path.join(app, `ios/Runner/Assets.xcassets/AppIcon-${id}.appiconset/icon.png`), 1024, square(c), false]);
  // Android adaptive foreground (108dp at 4x), shield sized like the default's inset foreground.
  jobs.push([path.join(res, `drawable-nodpi/ic_launcher_${id}_foreground.png`), 432, svg(shield(0.38, c.fg, c.touch)), true]);
  // Android 7 (no adaptive icons): a plain square.
  jobs.push([path.join(res, `mipmap-xxxhdpi/ic_launcher_${id}.png`), 192, square(c), false]);
}

(async () => {
  const browser = await chromium.launch();
  const page = await browser.newPage();
  for (const [file, size, markup, transparent] of jobs) {
    fs.mkdirSync(path.dirname(file), { recursive: true });
    await page.setViewportSize({ width: size, height: size });
    await page.setContent(`<html><body style="margin:0;background:transparent">${markup.replace('width="1024" height="1024"', `width="${size}" height="${size}"`)}</body></html>`);
    await page.screenshot({ path: file, omitBackground: transparent });
    if (!transparent) {
      // Strip the alpha channel (App Store rule for icons): round-trip through JPEG with macOS sips.
      const tmp = file + '.jpg';
      execFileSync('sips', ['-s', 'format', 'jpeg', '-s', 'formatOptions', 'best', file, '--out', tmp], { stdio: 'ignore' });
      execFileSync('sips', ['-s', 'format', 'png', tmp, '--out', file], { stdio: 'ignore' });
      fs.unlinkSync(tmp);
    }
    console.log('wrote', path.relative(app, file));
  }
  await browser.close();

  for (const id of ids) {
    const dir = path.join(app, `ios/Runner/Assets.xcassets/AppIcon-${id}.appiconset`);
    fs.writeFileSync(path.join(dir, 'Contents.json'), JSON.stringify({
      images: [{ filename: 'icon.png', idiom: 'universal', platform: 'ios', size: '1024x1024' }],
      info: { author: 'xcode', version: 1 },
    }, null, 2) + '\n');
    fs.writeFileSync(path.join(res, `mipmap-anydpi-v26/ic_launcher_${id}.xml`), `<?xml version="1.0" encoding="utf-8"?>
<!-- Generated by app/tool/make_app_icons.cjs -->
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
  <background android:drawable="@color/ic_launcher_${id}_background"/>
  <foreground android:drawable="@drawable/ic_launcher_${id}_foreground"/>
</adaptive-icon>
`);
  }
  fs.writeFileSync(path.join(res, 'values/app_icon_colors.xml'), `<?xml version="1.0" encoding="utf-8"?>
<!-- Generated by app/tool/make_app_icons.cjs from lib/ui/theme.dart -->
<resources>
${ids.map((id) => `    <color name="ic_launcher_${id}_background">${palettes[id].bg}</color>`).join('\n')}
</resources>
`);
  console.log('wrote Contents.json, adaptive icon XML and colors');
})();
