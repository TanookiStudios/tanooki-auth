// Checks every internal link and image in public/*.html points at a real file (and a real #id).
// Run: node site/check-links.mjs [folder]   Exits 1 and lists each broken link if any.
// /download/* is skipped: the Worker serves it from R2, so check those live with curl.
import { readFileSync, readdirSync, existsSync, statSync } from 'node:fs';
import { join, relative, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';

const root = process.argv[2] ?? join(dirname(fileURLToPath(import.meta.url)), 'public');
const pages = [];
const walk = (d) => readdirSync(d).forEach((f) => { const p = join(d, f); statSync(p).isDirectory() ? walk(p) : p.endsWith('.html') && pages.push(p); });
walk(root);

const ids = (file) => new Set([...readFileSync(file, 'utf8').matchAll(/\sid="([^"]+)"/g)].map((m) => m[1]));
const fileFor = (urlPath) => {
  const p = join(root, decodeURIComponent(urlPath));
  if (urlPath.endsWith('/')) return join(p, 'index.html');
  return existsSync(p) && statSync(p).isDirectory() ? join(p, 'index.html') : p;
};

const broken = [];
let checked = 0;
for (const page of pages) {
  const urlPath = '/' + relative(root, page).replace(/index\.html$/, '');
  const base = new URL(urlPath, 'https://site.invalid');
  for (const [, attr, raw] of readFileSync(page, 'utf8').matchAll(/\s(href|src)="([^"]*)"/g)) {
    if (/^(https?:|mailto:|data:)/.test(raw) && !raw.startsWith('https://site.invalid')) continue;
    const u = new URL(raw, base);
    if (u.pathname.startsWith('/download/')) continue;
    checked++;
    const target = fileFor(u.pathname);
    if (!existsSync(target)) { broken.push(`${relative(root, page)}: ${attr}="${raw}" (no file ${relative(root, target)})`); continue; }
    if (u.hash && target.endsWith('.html') && !ids(target).has(decodeURIComponent(u.hash.slice(1)))) broken.push(`${relative(root, page)}: ${attr}="${raw}" (no id ${u.hash})`);
  }
}
if (broken.length) { console.error(`${broken.length} broken link(s):\n` + broken.join('\n')); process.exit(1); }
console.log(`OK: ${checked} internal links across ${pages.length} pages, none broken.`);
