// Builds /compare/ and /compare/<app>/ from data.mjs into public/compare/. Run: node site/compare/build.mjs
import { writeFileSync, mkdirSync, rmSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';
import { esc, longDate, page } from '../layout.mjs';
import { apps, tanooki, rows, checked } from './data.mjs';

const out = join(dirname(fileURLToPath(import.meta.url)), '..', 'public', 'compare');

// Refuse to publish an uncited or half-filled claim.
if (!/^\d{4}-\d{2}-\d{2}$/.test(checked)) throw new Error('checked must be YYYY-MM-DD');
for (const a of [tanooki, ...apps]) {
  for (const [k] of rows) {
    const f = a[k];
    if (!f || typeof f.v !== 'string' || !f.v.trim()) throw new Error(`${a.name}: missing ${k}`);
    if (a !== tanooki && !/^https:\/\/\S+$/.test(f.src ?? '')) throw new Error(`${a.name}: ${k} needs an https source from the official site`);
    if (a === tanooki && !/^(https:\/\/|\/)\S*$/.test(f.src ?? '')) throw new Error(`Tanooki Auth: ${k} needs a source`);
    if (f.v === 'Not sure' && !f.note) throw new Error(`${a.name}: ${k} is "Not sure" and needs a note saying why`);
  }
  if (a !== tanooki && (!a.doesWell?.length || a.doesWell.some((d) => !/^https:\/\//.test(d.src)))) throw new Error(`${a.name}: doesWell needs cited items`);
}

const cell = (f) => `${esc(f.v)}${f.note ? ` <span class="muted">${esc(f.note)}</span>` : ''} <a class="src" href="${esc(f.src)}">Source</a>`;
const checkedLine = `<p class="muted block">Checked ${longDate(checked)} against each app’s official website, help pages, app store listing or source code, linked beside every fact. Apps change; if something here is out of date, <a class="text" href="https://tanookistudios.com/support">tell us</a> and we’ll fix it. “Not sure” means we couldn’t confirm it from an official source.</p>`;

const table = (cols, caption) => `      <section class="scroll" aria-label="${esc(caption)}" tabindex="0">
        <table class="compare">
          <caption>${esc(caption)}</caption>
          <thead><tr><th scope="col"><span class="visually-hidden">Feature</span></th>${cols.map((a) => `<th scope="col">${esc(a.name)}</th>`).join('')}</tr></thead>
          <tbody>
${rows.map(([k, label]) => `            <tr><th scope="row">${label}</th>${cols.map((a) => `<td>${cell(a[k])}</td>`).join('')}</tr>`).join('\n')}
          </tbody>
        </table>
      </section>`;

const appPage = (a) => page({
  path: `/compare/${a.slug}/`,
  title: `Tanooki Auth vs ${a.name}: a fair comparison`,
  description: `Tanooki Auth and ${a.name} side by side: platforms, open source, encrypted backup, export, desktop app, browser extension and price, each fact linked to its source.`,
  body: `  <section class="page">
    <div class="container">
      <p class="crumb"><a href="/compare/">All comparisons</a></p>
      <h1>Tanooki Auth vs ${esc(a.name)}</h1>
      <p class="lead">${esc(a.name)}, made by ${esc(a.maker)}, is a two-factor authenticator app. Here is how the two compare on facts you can check yourself.</p>
${table([tanooki, a], `Tanooki Auth compared with ${a.name}`)}
      <div class="block">
        <h2>What ${esc(a.name)} does well</h2>
        <ul class="features">
${a.doesWell.map((d) => `          <li>${esc(d.t)} <a class="src" href="${esc(d.src)}">Source</a></li>`).join('\n')}
        </ul>
      </div>
      <div class="block">
        <h2>Moving from ${esc(a.name)} to Tanooki Auth</h2>
        <p>${esc(a.moving)}</p>
        <p>For step-by-step help on a particular website, see the <a class="text" href="/guides/">two-factor guides</a>.</p>
      </div>
      ${checkedLine}
    </div>
  </section>
`,
});

const indexPage = page({
  path: '/compare/',
  current: '/compare/',
  title: 'Compare authenticator apps | Tanooki Auth',
  description: 'A fair, sourced comparison of Tanooki Auth with Authy, Google Authenticator, Microsoft Authenticator, 2FAS and Aegis: platforms, backup, export, extensions and price.',
  body: `  <section class="page">
    <div class="container">
      <h1>Compare authenticator apps</h1>
      <p class="lead">Every one of these apps makes the same standard six-digit codes, so any of them is far better than no two-factor at all. They differ in where they run, how they back up, and whether you can take your accounts with you.</p>
      <ul class="cards">
${apps.map((a) => `        <li><a href="/compare/${a.slug}/">Tanooki Auth vs ${esc(a.name)}</a></li>`).join('\n')}
      </ul>
${table([tanooki, ...apps], 'Six authenticator apps compared')}
      ${checkedLine}
    </div>
  </section>
`,
});

rmSync(out, { recursive: true, force: true });
mkdirSync(out, { recursive: true });
writeFileSync(join(out, 'index.html'), indexPage);
for (const a of apps) {
  mkdirSync(join(out, a.slug));
  writeFileSync(join(out, a.slug, 'index.html'), appPage(a));
}
console.log(`Built ${apps.length} comparisons + index into ${out}`);
