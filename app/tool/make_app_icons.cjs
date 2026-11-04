// Builds every app icon file from Maddie's 30 master PNGs (1024x1024, rounded tile on transparent corners).
// The masters aren't in the repo; unzip TanookiAuth_All_30_Icons.zip and pass the TanookiAuth folder:
//   NODE_PATH="$(npm root -g)" node app/tool/make_app_icons.cjs <folder>
// The icon ids must match appIcons in lib/ui/app_icon.dart (test/app_icon_test.dart checks every file).
const { chromium } = require('playwright');
const { execFileSync } = require('child_process');
const fs = require('fs');
const path = require('path');

const source = process.argv[2];
if (!source) throw new Error('usage: make_app_icons.cjs <folder with Standard, Colors, Holidays, Pride>');
const app = path.join(__dirname, '..');
const repo = path.join(app, '..');
const res = path.join(app, 'android/app/src/main/res');

// id -> master file. Pastel Pink and Pastel Blue come first; spooky, cozy and spring are also seasonal theme ids.
const icons = {
  default: 'Standard/OriginalBlue',
  pink: 'Colors/PastelPink', blue: 'Colors/PastelBlue', hotpink: 'Colors/Pink', red: 'Colors/Red', orange: 'Colors/Orange',
  gold: 'Colors/Gold', green: 'Colors/Green', cyan: 'Colors/Cyan', purple: 'Colors/Purple', monochrome: 'Colors/Monochrome',
  blackgold: 'Colors/BlackAndGold',
  spring: 'Holidays/Easter', summer: 'Holidays/Summer', spooky: 'Holidays/Halloween', thanksgiving: 'Holidays/Thanksgiving',
  cozy: 'Holidays/Winter', christmas: 'Holidays/Christmas', valentines: 'Holidays/ValentinesDay',
  stpatricks: 'Holidays/StPatricksDay', independence: 'Holidays/IndependenceDay',
  rainbow: 'Pride/RainbowPride', progress: 'Pride/ProgressPride', transgender: 'Pride/TransgenderPride', lesbian: 'Pride/LesbianPride',
  bisexual: 'Pride/BisexualPride', pansexual: 'Pride/PansexualPride', nonbinary: 'Pride/NonbinaryPride',
  asexual: 'Pride/AsexualPride', genderfluid: 'Pride/GenderfluidPride',
};
const master = (id) => path.join(source, path.dirname(icons[id]), `TanookiAuth_${path.basename(icons[id])}.png`);
const dims = (f) => +execFileSync('sips', ['-g', 'pixelWidth', f]).toString().match(/pixelWidth: (\d+)/)[1];
const walk = (d) => fs.readdirSync(d, { withFileTypes: true }).flatMap((e) => (e.isDirectory() ? walk(path.join(d, e.name)) : [path.join(d, e.name)]));
const pngs = (d) => walk(d).filter((f) => f.endsWith('.png'));

// The tile fills about 66..958 of 1024. Square versions crop to it; the rest is flattened onto the tile's own color.
const CROP = { x: 66, y: 68, side: 892 };
const flatten = (f) => { // App Store rule: no alpha channel. sips drops it on a round trip through JPEG.
  const tmp = `${f}.jpg`;
  execFileSync('sips', ['-s', 'format', 'jpeg', '-s', 'formatOptions', 'best', f, '--out', tmp], { stdio: 'ignore' });
  execFileSync('sips', ['-s', 'format', 'png', tmp, '--out', f], { stdio: 'ignore' });
  fs.unlinkSync(tmp);
};

(async () => {
  const browser = await chromium.launch();
  const page = await browser.newPage();
  await page.setContent('<canvas id=c></canvas>');
  await page.evaluate(() => {
    window.load = async (b64) => { const i = new Image(); i.src = `data:image/png;base64,${b64}`; await i.decode(); window.img = i; };
    window.draw = (size, crop, bg, scale) => {
      const c = document.getElementById('c'); c.width = c.height = size;
      const x = c.getContext('2d'); x.imageSmoothingQuality = 'high';
      if (bg) { x.fillStyle = bg; x.fillRect(0, 0, size, size); }
      if (crop) x.drawImage(window.img, crop.x, crop.y, crop.side, crop.side, 0, 0, size, size);
      else { const s = size * scale; x.drawImage(window.img, (size - s) / 2, (size - s) / 2, s, s); }
      return c.toDataURL('image/png').split(',')[1];
    };
    window.tileColor = () => { // Average of four spots inside the tile's corners.
      const c = document.createElement('canvas'); c.width = c.height = 1024;
      const x = c.getContext('2d', { willReadFrequently: true }); x.drawImage(window.img, 0, 0);
      let r = 0, g = 0, b = 0, n = 0;
      for (const [px, py] of [[170, 170], [854, 170], [170, 854], [854, 854]]) {
        const d = x.getImageData(px - 12, py - 12, 24, 24).data;
        for (let i = 0; i < d.length; i += 4) { r += d[i]; g += d[i + 1]; b += d[i + 2]; n++; }
      }
      return '#' + [r, g, b].map((v) => Math.round(v / n).toString(16).padStart(2, '0')).join('').toUpperCase();
    };
  });
  const write = async (file, size, opts) => {
    fs.mkdirSync(path.dirname(file), { recursive: true });
    const data = await page.evaluate(({ size, crop, bg, scale }) => window.draw(size, crop, bg, scale), { size, ...opts });
    fs.writeFileSync(file, Buffer.from(data, 'base64'));
    if (opts.bg) flatten(file);
  };
  const colors = {};

  for (const id of Object.keys(icons)) {
    await page.evaluate((b) => window.load(b), fs.readFileSync(master(id)).toString('base64'));
    const bg = colors[id] = await page.evaluate(() => window.tileColor());
    const square = { crop: CROP, bg };
    const rounded = { scale: 1 };
    await write(path.join(app, `assets/app_icons/${id}.png`), 512, rounded); // picker preview, Mac Dock icon
    if (id !== 'default') {
      await write(path.join(app, `ios/Runner/Assets.xcassets/AppIcon-${id}.appiconset/icon.png`), 1024, square);
      await write(path.join(res, `mipmap-xxxhdpi/ic_launcher_${id}.png`), 192, square); // Android 7
    }
    // Android adaptive foreground: the tile fills 80 of the 108dp, so the launcher's mask keeps all of the art.
    await write(path.join(res, `drawable-nodpi/ic_launcher_${id === 'default' ? '' : `${id}_`}foreground.png`), 432, { scale: 80 / 108 * (1024 / CROP.side) });
    if (id !== 'default') continue;
    // Everywhere the app's main icon lives: each file keeps the size it already has.
    const sized = async (files, opts) => { for (const f of files) await write(f, dims(f), opts); };
    await sized(pngs(path.join(app, 'ios/Runner/Assets.xcassets/AppIcon.appiconset')), square);
    await sized(pngs(path.join(app, 'ios/TanookiWatch/Assets.xcassets/AppIcon.appiconset')), square);
    await sized(pngs(path.join(app, 'android/wear/src/main/res')).filter((f) => path.basename(f).startsWith('ic_launcher')), square);
    await sized(pngs(res).filter((f) => path.basename(f) === 'ic_launcher.png'), square);
    await sized(pngs(path.join(app, 'macos/Runner/Assets.xcassets/AppIcon.appiconset')), rounded);
    await sized(pngs(path.join(repo, 'extension/icons')), rounded);
    await sized(walk(path.join(repo, 'extension-safari')).filter((f) => f.endsWith('.png') && /appiconset|LargeIcon/.test(f)), rounded);
    await sized(['icon.png', 'favicon.png'].map((f) => path.join(repo, 'site/public', f)), rounded);
    await write(path.join(app, 'assets/icon/icon-square.png'), 1024, square);
    await write(path.join(app, 'assets/icon/icon-rounded.png'), 1024, rounded);
    // Windows: an .ico is a small header in front of plain PNGs.
    const sizes = [16, 24, 32, 48, 64, 128, 256];
    const images = [];
    for (const s of sizes) images.push(Buffer.from(await page.evaluate((s) => window.draw(s, null, null, 1), s), 'base64'));
    const head = Buffer.alloc(6 + 16 * sizes.length);
    head.writeUInt16LE(1, 2); head.writeUInt16LE(sizes.length, 4);
    let at = head.length;
    sizes.forEach((s, i) => {
      const e = 6 + 16 * i;
      head[e] = s % 256; head[e + 1] = s % 256; head.writeUInt16LE(1, e + 4); head.writeUInt16LE(32, e + 6);
      head.writeUInt32LE(images[i].length, e + 8); head.writeUInt32LE(at, e + 12); at += images[i].length;
    });
    fs.writeFileSync(path.join(app, 'windows/runner/resources/app_icon.ico'), Buffer.concat([head, ...images]));
    console.log('wrote the main icon everywhere');
  }
  await browser.close();

  for (const id of Object.keys(icons)) {
    if (id === 'default') continue;
    fs.writeFileSync(path.join(app, `ios/Runner/Assets.xcassets/AppIcon-${id}.appiconset/Contents.json`), JSON.stringify({
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
  fs.writeFileSync(path.join(res, 'mipmap-anydpi-v26/ic_launcher.xml'), `<?xml version="1.0" encoding="utf-8"?>
<!-- Generated by app/tool/make_app_icons.cjs -->
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
  <background android:drawable="@color/ic_launcher_default_background"/>
  <foreground android:drawable="@drawable/ic_launcher_foreground"/>
</adaptive-icon>
`);
  fs.writeFileSync(path.join(res, 'values/app_icon_colors.xml'), `<?xml version="1.0" encoding="utf-8"?>
<!-- Generated by app/tool/make_app_icons.cjs from each icon's own color -->
<resources>
${Object.keys(icons).map((id) => `    <color name="ic_launcher_${id}_background">${colors[id]}</color>`).join('\n')}
</resources>
`);
  console.log('wrote Contents.json, adaptive icon XML and colors');
})();
