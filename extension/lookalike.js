// Spots sites dressed up as one the user saved: gihtub.com, gіthub.com (Cyrillic і), xn--… names,
// github.com.evil.io, github-login.com. Pure functions, loaded by the background script and by
// test/lookalike.test.cjs in Node. Runs only in the background, so saved domains never reach a page.
(() => {
  // RFC 3492 punycode decode of one label (without the "xn--" prefix).
  function punyDecode(input) {
    const base = 36, tMin = 1, tMax = 26;
    const adapt = (delta, points, first) => {
      delta = first ? Math.floor(delta / 700) : delta >> 1;
      delta += Math.floor(delta / points);
      let k = 0;
      for (; delta > 455; k += base) delta = Math.floor(delta / 35);
      return k + Math.floor((36 * delta) / (delta + 38));
    };
    const b = Math.max(0, input.lastIndexOf('-'));
    const out = [...input.slice(0, b)].map((c) => c.codePointAt(0));
    let n = 128, i = 0, bias = 72;
    for (let at = b > 0 ? b + 1 : 0; at < input.length;) {
      const old = i;
      for (let w = 1, k = base; ; k += base) {
        const c = input.charCodeAt(at++);
        const digit = c >= 48 && c <= 57 ? c - 22 : c >= 97 && c <= 122 ? c - 97 : c >= 65 && c <= 90 ? c - 65 : base;
        if (digit >= base || at > input.length) throw new Error('bad punycode');
        i += digit * w;
        const t = k <= bias ? tMin : k >= bias + tMax ? tMax : k - bias;
        if (digit < t) break;
        w *= base - t;
      }
      bias = adapt(i - old, out.length + 1, old === 0);
      n += Math.floor(i / (out.length + 1));
      i %= out.length + 1;
      out.splice(i++, 0, n);
    }
    return String.fromCodePoint(...out);
  }

  const decodeHost = (host) => host.toLowerCase().split('.').map((l) => {
    if (!l.startsWith('xn--')) return l;
    try { return punyDecode(l.slice(4)); } catch { return l; }
  }).join('.');

  // Characters that render like Latin letters. Accents are stripped separately (é -> e).
  const CONFUSABLE = {
    // Cyrillic
    'а': 'a', 'в': 'b', 'е': 'e', 'ё': 'e', 'һ': 'h', 'і': 'i', 'ї': 'i', 'ј': 'j', 'к': 'k', 'ӏ': 'l',
    'м': 'm', 'н': 'h', 'о': 'o', 'р': 'p', 'с': 'c', 'ѕ': 's', 'т': 't', 'у': 'y', 'х': 'x', 'ԁ': 'd',
    'ԛ': 'q', 'ԝ': 'w', 'ɡ': 'g', 'ь': 'b',
    // Greek
    'α': 'a', 'β': 'b', 'ε': 'e', 'η': 'n', 'ι': 'i', 'κ': 'k', 'ν': 'v', 'ο': 'o', 'ρ': 'p', 'τ': 't',
    'υ': 'u', 'χ': 'x', 'ω': 'w',
    // Latin look-alikes and digits
    'ı': 'i', 'ȷ': 'j', 'ł': 'l', 'ø': 'o', 'đ': 'd', 'ħ': 'h', '0': 'o', '1': 'l', '|': 'l',
  };
  const skeleton = (s) => [...s.normalize('NFKD').replace(/[̀-ͯ]/g, '')]
    .map((c) => CONFUSABLE[c] || c).join('')
    .replace(/rn/g, 'm').replace(/vv/g, 'w');

  // shortcut: a short list of two-part endings (co.uk, com.au…) instead of the public-suffix list; upgrade if a real one is missed.
  const SECOND_LEVEL = /^(co|com|net|org|gov|edu|ac|ltd|plc|ne|or|go)$/;
  const nameLabel = (host) => {
    const p = host.split('.');
    return p.length > 2 && p[p.length - 1].length === 2 && SECOND_LEVEL.test(p[p.length - 2]) ? p[p.length - 3] : p[Math.max(0, p.length - 2)];
  };

  // Edit distance where swapping two neighbors counts as one edit (gihtub is 1 away from github).
  function distance(a, b) {
    const d = Array.from({ length: a.length + 1 }, (_, i) => [i, ...Array(b.length).fill(0)]);
    for (let j = 1; j <= b.length; j++) d[0][j] = j;
    for (let i = 1; i <= a.length; i++) {
      for (let j = 1; j <= b.length; j++) {
        const cost = a[i - 1] === b[j - 1] ? 0 : 1;
        d[i][j] = Math.min(d[i - 1][j] + 1, d[i][j - 1] + 1, d[i - 1][j - 1] + cost);
        if (i > 1 && j > 1 && a[i - 1] === b[j - 2] && a[i - 2] === b[j - 1]) d[i][j] = Math.min(d[i][j], d[i - 2][j - 2] + 1);
      }
    }
    return d[a.length][b.length];
  }

  const clean = (h) => h.toLowerCase().replace(/\.$/, '').replace(/^www\./, '');
  const onSite = (host, d) => host === d || host.endsWith('.' + d);

  /** The saved domain that [host] imitates, or null when it is a saved site or not close to one. */
  function lookalikeOf(host, savedDomains) {
    const raw = clean(host || '');
    const saved = savedDomains.map(clean).filter(Boolean);
    if (!raw || /^[\d.]+$|:/.test(raw) || saved.some((d) => onSite(raw, d))) return null;
    const h = decodeHost(raw);
    const label = skeleton(nameLabel(h));
    const parts = h.split(/[.-]/).map(skeleton);
    for (const d of saved) {
      const want = skeleton(nameLabel(decodeHost(d)));
      if (want.length < 3) continue;
      if (label === want) return d; // same name with confusable letters, or the same name under another ending
      // Short names are one letter from lots of real sites, so allow fewer edits for them.
      const max = want.length >= 8 ? 2 : want.length >= 5 ? 1 : 0;
      if (max && distance(label, want) <= max) return d;
      if (want.length >= 4 && parts.includes(want)) return d; // github.com.evil.io, github-login.com
    }
    return null;
  }

  const api = { lookalikeOf, punyDecode, skeleton, distance };
  if (typeof module !== 'undefined') module.exports = api;
  else globalThis.tanookiLookalike = api;
})();
