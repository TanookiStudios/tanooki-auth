// Picks which saved account a sign-in page is for, from the email or username the page shows.
// Pure function, loaded by the background script and by test/login.test.cjs in Node.
(() => {
  const norm = (s) => String(s || '').trim().toLowerCase();
  const local = (s) => (s.includes('@') ? s.slice(0, s.indexOf('@')) : s);

  /**
   * The one account in [accounts] whose label matches one of [hints] (emails or usernames seen on the
   * page), or null when none or more than one match. Exact matches win over matching only the part
   * before the @, so alice@work.com picks the work account over alice@home.com.
   */
  function pickByLogin(accounts, hints) {
    const hs = [...new Set((hints || []).map(norm).filter(Boolean))];
    if (!hs.length) return null;
    const pick = (same) => {
      const found = new Set();
      for (const a of accounts) {
        const label = norm(a.label);
        if (label && hs.some((h) => same(label, h))) found.add(a);
      }
      return found.size === 1 ? [...found][0] : found.size > 1 ? false : null;
    };
    const exact = pick((l, h) => l === h);
    if (exact !== null) return exact || null;
    // "alice" typed on the page vs a saved "alice@example.com", or the other way round.
    const loose = pick((l, h) => (l.includes('@') !== h.includes('@')) && local(l) === local(h) && local(l) !== '');
    return loose || null;
  }

  const api = { pickByLogin };
  if (typeof module !== 'undefined') module.exports = api;
  else globalThis.tanookiLogin = api;
})();
