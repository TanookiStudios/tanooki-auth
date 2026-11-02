// Builds the 2FA guide pages from data.json into public/guides/. Run: node site/guides/build.mjs
// Everything about a service comes from data.json; the script only adds the page around it.
import { readFileSync, writeFileSync, mkdirSync, rmSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';
import { esc, longDate, page } from '../layout.mjs';

const here = dirname(fileURLToPath(import.meta.url));
const out = join(here, '..', 'public', 'guides');
const guides = JSON.parse(readFileSync(join(here, 'data.json'), 'utf8'));

// Refuse to build from bad data rather than publish a broken page.
const seen = new Set();
for (const g of guides) {
  const where = `data.json entry ${JSON.stringify(g.slug ?? g.name)}`;
  if (!/^[a-z0-9-]+$/.test(g.slug ?? '')) throw new Error(`${where}: slug must be lowercase letters, digits and dashes`);
  if (seen.has(g.slug)) throw new Error(`${where}: duplicate slug`);
  seen.add(g.slug);
  for (const k of ['name', 'domain']) if (typeof g[k] !== 'string' || !g[k].trim()) throw new Error(`${where}: missing ${k}`);
  for (const k of ['officialUrl', 'settingsUrl']) if (g[k] != null && !/^https:\/\/\S+$/.test(g[k])) throw new Error(`${where}: ${k} must be an https URL`);
  if (!g.officialUrl) throw new Error(`${where}: missing officialUrl`);
  if (!Array.isArray(g.steps) || !g.steps.length || g.steps.some((s) => typeof s !== 'string' || !s.trim())) throw new Error(`${where}: steps must be a non-empty list of text`);
  if (!/^\d{4}-\d{2}-\d{2}$/.test(g.checked ?? '')) throw new Error(`${where}: checked must be YYYY-MM-DD`);
}

const possessive = (name) => (name.endsWith('s') ? `${name}’` : `${name}’s`);
const letterOf = (name) => (/[a-z]/i.test(name[0]) ? name[0].toUpperCase() : '#');
const byName = (a, b) => a.name.localeCompare(b.name, 'en', { sensitivity: 'base' });

const guidePage = (g) => page({
  path: `/guides/${g.slug}/`,
  // Search engines cut titles past about 70 characters, so long names get the short form.
  title: [`How to turn on two-factor authentication for ${g.name} | Tanooki Auth`, `Turn on two-factor for ${g.name} | Tanooki Auth`].find((t) => t.length <= 70) ?? `Turn on two-factor for ${g.name}`,
  description: `Step by step: turn on two-factor authentication for your ${g.name} account (${g.domain}) with an authenticator app.`,
  body: `  <section class="page">
    <div class="container">
      <p class="crumb"><a href="/guides/">All 2FA guides</a></p>
      <h1>Turn on two-factor for ${esc(g.name)}</h1>
      <p class="lead">Use an authenticator app like Tanooki Auth for your ${esc(g.name)} account at ${esc(g.domain)}.</p>
      <ol class="steps">
${g.steps.map((s) => `        <li>${esc(s)}</li>`).join('\n')}
      </ol>
${g.notes ? `      <p class="note"><strong>Good to know:</strong> ${esc(g.notes)}</p>\n` : ''}      <div class="links">
${g.settingsUrl ? `        <a class="btn" href="${esc(g.settingsUrl)}">Open ${esc(possessive(g.name))} settings</a>\n` : ''}        <a class="text" href="${esc(g.officialUrl)}">Source: ${esc(possessive(g.name))} help page</a>
      </div>
      <p class="muted block">Checked ${longDate(g.checked)}. Websites change their menus often; if a step looks different, the help page above has the latest.</p>
    </div>
  </section>
`,
});

const groups = new Map();
for (const g of [...guides].sort(byName)) {
  const l = letterOf(g.name);
  if (!groups.has(l)) groups.set(l, []);
  groups.get(l).push(g);
}
// '#' (names starting with a digit) sorts first, then A-Z.
const letters = [...groups.keys()].sort((a, b) => (a === '#' ? -1 : b === '#' ? 1 : a.localeCompare(b)));

const indexPage = page({
  path: '/guides/',
  current: '/guides/',
  title: 'Two-factor authentication guides for popular sites | Tanooki Auth',
  description: `Step-by-step guides to turn on two-factor authentication with an authenticator app for ${guides.length} sites, including ${[...guides].sort(byName).slice(0, 3).map((g) => g.name).join(', ')} and more.`,
  body: `  <section class="page">
    <div class="container">
      <h1>Two-factor guides</h1>
      <p class="lead">How to turn on two-factor authentication with an authenticator app, site by site. ${guides.length} guides so far.</p>
      <div class="search" role="search" hidden>
        <label for="q">Find a site</label>
        <input id="q" type="search" autocomplete="off" placeholder="GitHub, Google, PayPal…">
      </div>
      <p id="none" class="block" role="status" aria-live="polite"></p>
      <div class="letters">
${letters.map((l) => `        <section class="letter" aria-label="${l === '#' ? 'Numbers' : l}">
          <h2 aria-hidden="true">${l}</h2>
          <ul>
${groups.get(l).map((g) => `            <li data-q="${esc(`${g.name} ${g.domain}`.toLowerCase())}"><a href="/guides/${g.slug}/">${esc(g.name)}</a><small>${esc(g.domain)}</small></li>`).join('\n')}
          </ul>
        </section>`).join('\n')}
      </div>
    </div>
  </section>
  <script>
    // Without script every guide shows; with it, the box filters by name or web address and hides empty letters.
    const form = document.querySelector('.search'), q = document.getElementById('q'), none = document.getElementById('none');
    form.hidden = false;
    q.addEventListener('input', () => {
      const t = q.value.trim().toLowerCase();
      let shown = 0;
      document.querySelectorAll('.letter').forEach((sec) => {
        let n = 0;
        sec.querySelectorAll('li').forEach((li) => { const hit = li.dataset.q.includes(t); li.hidden = !hit; n += hit; });
        sec.hidden = !n; shown += n;
      });
      none.textContent = shown ? '' : 'No guide for “' + q.value.trim() + '” yet.';
    });
  </script>
`,
});

rmSync(out, { recursive: true, force: true });
mkdirSync(out, { recursive: true });
writeFileSync(join(out, 'index.html'), indexPage);
for (const g of guides) {
  mkdirSync(join(out, g.slug));
  writeFileSync(join(out, g.slug, 'index.html'), guidePage(g));
}
console.log(`Built ${guides.length} guides + index into ${out}`);
