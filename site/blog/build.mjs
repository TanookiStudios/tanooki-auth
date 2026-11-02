// Builds the blog from posts.mjs into public/blog/: an index, one page per post and an RSS feed (feed.xml).
// Run: node site/blog/build.mjs
import { readFileSync, writeFileSync, mkdirSync, rmSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';
import { esc, longDate, page, SITE } from '../layout.mjs';
import { posts } from './posts.mjs';

const here = dirname(fileURLToPath(import.meta.url));
const out = join(here, '..', 'public', 'blog');
const guides = new Map(JSON.parse(readFileSync(join(here, '..', 'guides', 'data.json'), 'utf8')).map((g) => [g.slug, g]));
const published = '2026-11-02'; // every post was written and its sources read on this date

// Refuse to build a post with missing pieces or uncited advice.
const seen = new Set();
for (const p of posts) {
  const where = `post ${JSON.stringify(p.slug)}`;
  if (!/^[a-z0-9-]+$/.test(p.slug ?? '') || seen.has(p.slug)) throw new Error(`${where}: bad or duplicate slug`);
  seen.add(p.slug);
  if (!p.title?.trim() || !p.body?.trim()) throw new Error(`${where}: missing title or body`);
  if (!(p.description?.length >= 50 && p.description.length <= 160)) throw new Error(`${where}: description must be 50-160 characters (is ${p.description?.length})`);
  if (!p.sources?.length || p.sources.some((s) => !s.title || !/^https:\/\/\S+$/.test(s.url))) throw new Error(`${where}: needs https sources`);
  for (const s of p.sources) if (!p.body.includes(`href="${s.url}"`)) throw new Error(`${where}: source ${s.url} is listed but never cited in the text`);
  for (const g of p.guides) if (!guides.has(g)) throw new Error(`${where}: no guide called ${g}`);
}

const feedLink = '<link rel="alternate" type="application/rss+xml" title="Tanooki Auth blog" href="/blog/feed.xml">\n';

const postPage = (p) => page({
  path: `/blog/${p.slug}/`,
  head: feedLink,
  title: `${p.title} | Tanooki Auth`,
  description: p.description,
  body: `  <section class="page">
    <div class="container">
      <p class="crumb"><a href="/blog/">All posts</a></p>
      <h1>${esc(p.title)}</h1>
      <p class="muted block"><time datetime="${published}">${longDate(published)}</time></p>
      <article class="article">${p.body}</article>
${p.guides.length ? `      <div class="block">
        <h2>Related guides</h2>
        <ul class="features">
${p.guides.map((g) => `          <li><a class="text" href="/guides/${g}/">Turn on two-factor for ${esc(guides.get(g).name)}</a></li>`).join('\n')}
        </ul>
      </div>
` : ''}      <div class="block">
        <h2>Sources</h2>
        <ol class="sources">
${p.sources.map((s) => `          <li><a class="text" href="${esc(s.url)}">${esc(s.title)}</a></li>`).join('\n')}
        </ol>
        <p class="muted block">Sources checked ${longDate(published)}. This post is general advice, not a substitute for each company’s own help pages.</p>
      </div>
    </div>
  </section>
`,
});

const indexPage = page({
  path: '/blog/',
  current: '/blog/',
  head: feedLink,
  title: 'Security tips blog | Tanooki Auth',
  description: 'Plain-English security tips: two-factor login, recovery codes, backups, phishing, passkeys, SIM swapping and more, each backed by CISA, FTC, NIST or vendor sources.',
  body: `  <section class="page">
    <div class="container">
      <h1>Security tips</h1>
      <p class="lead">Short, plain-English guides to keeping your accounts safe. Every tip links to the agency or company it comes from. <a class="text" href="/blog/feed.xml">RSS feed</a></p>
      <ul class="posts">
${posts.map((p) => `        <li><a href="/blog/${p.slug}/">${esc(p.title)}</a><p>${esc(p.description)}</p></li>`).join('\n')}
      </ul>
    </div>
  </section>
`,
});

// RSS 2.0 wants RFC 822 dates; build it from the parts so the day can't shift with the time zone.
const [y, m, d] = published.split('-').map(Number);
const DAYS = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
const MON = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
const rfc822 = `${DAYS[new Date(Date.UTC(y, m - 1, d)).getUTCDay()]}, ${String(d).padStart(2, '0')} ${MON[m - 1]} ${y} 12:00:00 GMT`;
const feed = `<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">
<channel>
<title>Tanooki Auth blog</title>
<link>${SITE}/blog/</link>
<atom:link href="${SITE}/blog/feed.xml" rel="self" type="application/rss+xml"/>
<description>Plain-English security tips from Tanooki Auth.</description>
<language>en-us</language>
<lastBuildDate>${rfc822}</lastBuildDate>
${posts.map((p) => `<item>
<title>${esc(p.title)}</title>
<link>${SITE}/blog/${p.slug}/</link>
<guid isPermaLink="true">${SITE}/blog/${p.slug}/</guid>
<pubDate>${rfc822}</pubDate>
<description>${esc(p.description)}</description>
</item>`).join('\n')}
</channel>
</rss>
`;

rmSync(out, { recursive: true, force: true });
mkdirSync(out, { recursive: true });
writeFileSync(join(out, 'index.html'), indexPage);
writeFileSync(join(out, 'feed.xml'), feed);
for (const p of posts) {
  mkdirSync(join(out, p.slug));
  writeFileSync(join(out, p.slug, 'index.html'), postPage(p));
}
console.log(`Built ${posts.length} posts + index + feed.xml into ${out}`);
