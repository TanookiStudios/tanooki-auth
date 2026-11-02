// The page shell (head, nav, call-to-action band, footer) shared by the built pages:
// guides/build.mjs, blog/build.mjs and compare/build.mjs. The hand-written pages in public/
// (home, status, press) carry a copy of the same nav and footer; change both together.
export const esc = (s) => String(s).replace(/[&<>"']/g, (c) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' })[c]);
const MONTHS = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
// Split the date by hand: new Date('YYYY-MM-DD') is UTC midnight and prints as the day before in the US.
export const longDate = (iso) => { const [y, m, d] = iso.split('-').map(Number); return `${MONTHS[m - 1]} ${d}, ${y}`; };
export const SITE = 'https://auth.tanookistudios.com';

const navItems = [
  ['/#promise', 'Privacy'],
  ['/#how', 'How it works'],
  ['/#themes', 'Premium'],
  ['/guides/', 'Guides'],
  ['/compare/', 'Compare'],
  ['/blog/', 'Blog'],
  ['https://tanookistudios.com/SupportMe', 'Donate'],
];

// current: the nav href to mark with aria-current (only on that section's index page).
export const page = ({ title, description, body, path, current, head = '' }) => `<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>${esc(title)}</title>
<meta name="description" content="${esc(description)}">
<link rel="canonical" href="${SITE}${path}">
<meta name="color-scheme" content="dark">
<link rel="icon" href="/favicon.png">
<link rel="apple-touch-icon" href="/icon.png">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Geist:wght@400;600;650&display=swap" rel="stylesheet">
<link rel="stylesheet" href="/site.css">
<link rel="stylesheet" href="/pages.css">
${head}</head>
<body>
<a class="skip" href="#main">Skip to content</a>

<header class="nav">
  <div class="container">
    <nav class="pill" aria-label="Main">
      <a class="brand" href="/" aria-label="Tanooki Auth home"><img src="/icon.png" alt="" width="28" height="28">Tanooki Auth</a>
      <ul>
${navItems.map(([href, label]) => `        <li><a href="${href}"${href === current ? ' aria-current="page"' : ''}>${label}</a></li>`).join('\n')}
      </ul>
      <a class="btn" href="/#download">Download</a>
    </nav>
  </div>
</header>

<main id="main">
${body}
  <section class="support" aria-labelledby="cta-h">
    <div class="container">
      <div>
        <h2 id="cta-h">Get Tanooki Auth</h2>
        <p>A free authenticator for Mac, Windows and Android. No account, no cloud.</p>
      </div>
      <a class="btn" href="/">Get Tanooki Auth</a>
    </div>
  </section>
</main>

<footer class="foot">
  <div class="container">
    <p class="mast">Tanooki Auth</p>
    <nav aria-label="Footer">
      <ul>
        <li><a href="/guides/">2FA guides</a></li>
        <li><a href="/blog/">Blog</a></li>
        <li><a href="/compare/">Compare</a></li>
        <li><a href="/status/">Status</a></li>
        <li><a href="/press/">Press kit</a></li>
        <li><a href="https://tanooki-auth-premium.kirbymail.workers.dev/privacy">Privacy policy</a></li>
        <li><a href="https://github.com/TanookiStudios/tanooki-auth">Source code</a></li>
        <li><a href="https://tanookistudios.com">Tanooki Studios</a></li>
        <li><a href="https://tanookistudios.com/SupportMe">Donate</a></li>
      </ul>
    </nav>
    <small>© 2026 Maddie</small>
  </div>
</footer>
</body>
</html>
`;
