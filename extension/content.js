// Finds one-time-code boxes and 2FA setup QR codes. Fills only on the exact site an account is
// saved for (checked again in sw.js), and only when exactly one account matches.
(() => {
  if (window.__tanookiAuth) return;
  window.__tanookiAuth = true;

  const OTP_WORDS = /\b(otp|totp|2fa|mfa|one.?time|verif\w*|auth(enticat)?(or|ion)?.?code|security.?code)\b|^code$/i;
  const SETUP_WORDS = /authenticator|two-factor|two factor|2fa|verification code/i;
  const host = location.hostname.toLowerCase().replace(/^www\./, '');
  const ancestorHosts = [...(location.ancestorOrigins || [])].map((o) => {
    try { return new URL(o).hostname.toLowerCase(); } catch { return ''; }
  });
  // Decisions only, never codes or secrets; readable in the page's console when diagnosing a site.
  const log = (...a) => console.debug('[Tanooki Auth]', ...a);
  const handledFields = new WeakSet();
  const scannedImages = new WeakSet();
  let filledOnce = false; // also set once a lookalike warning is up: this page never gets a code
  let lastAsk = 0;
  let siteChecked = false;

  // On screen at all, even if read-only (2FA pages often show the email in a locked box).
  const shown = (el) => {
    const r = el.getBoundingClientRect();
    return el.type !== 'hidden' && r.width > 0 && r.height > 0 && getComputedStyle(el).visibility !== 'hidden';
  };
  const visible = (el) => {
    if (el.disabled || el.readOnly || el.type === 'hidden') return false;
    const r = el.getBoundingClientRect();
    return r.width > 0 && r.height > 0 && getComputedStyle(el).visibility !== 'hidden';
  };

  // --- Which login is this? Emails and usernames the page shows, so sw.js can pick between accounts. ---

  const EMAIL = /[\w.+-]+@[\w-]+(?:\.[\w-]+)+/g;
  const LOGIN_KEY = 'tanookiAuthLogin';
  const isLoginField = (el) => el instanceof HTMLInputElement && el.type !== 'password' &&
    (el.type === 'email' || /\b(username|email)\b/.test(el.getAttribute('autocomplete') || '') || /user|email|login/i.test(`${el.name} ${el.id}`));

  function loginHints() {
    const hints = [...document.querySelectorAll('input')].filter((el) => isLoginField(el) && el.value.trim() && shown(el)).map((el) => el.value.trim());
    hints.push(...(document.body?.innerText.match(EMAIL) || []).slice(0, 5));
    // Typed on the previous page of this sign-in (kept in the site's own session storage, for this tab only).
    if (!hints.length) try { hints.push(sessionStorage.getItem(LOGIN_KEY) || ''); } catch { /* storage blocked */ }
    return hints.filter(Boolean);
  }
  document.addEventListener('change', (e) => {
    if (isLoginField(e.target) && e.target.value.trim()) try { sessionStorage.setItem(LOGIN_KEY, e.target.value.trim()); } catch { /* storage blocked */ }
  }, true);

  // --- Toolbar countdown: seconds left on the filled code, while this page stays put. ---

  let countdown = null;
  function stopCountdown() {
    if (!countdown) return;
    clearInterval(countdown);
    countdown = null;
    chrome.runtime.sendMessage({ type: 'badge', text: '' }).catch(() => {});
  }
  function startCountdown(secondsLeft, accountId) {
    stopCountdown();
    if (!(secondsLeft > 0)) return; // counter-based codes don't expire on a clock
    const href = location.href;
    let until = Date.now() + secondsLeft * 1000;
    let busy = false;
    const tick = async () => {
      if (busy) return;
      if (location.href !== href) return stopCountdown(); // the page moved on (sites that never reload)
      let left = Math.ceil((until - Date.now()) / 1000);
      if (left <= 0) {
        if (!accountId) return stopCountdown(); // a phone code: nothing to ask for the next one
        busy = true;
        const r = await chrome.runtime.sendMessage({ type: 'secondsLeft', accountId }).catch(() => null);
        busy = false;
        if (!(r?.secondsLeft > 0)) return stopCountdown();
        until = Date.now() + r.secondsLeft * 1000;
        left = r.secondsLeft;
      }
      chrome.runtime.sendMessage({ type: 'badge', text: String(left) }).catch(stopCountdown);
    };
    countdown = setInterval(tick, 1000);
    tick();
  }
  addEventListener('pagehide', stopCountdown);

  /** Returns arrays of inputs: [single box] or [box1..box6] for the one-box-per-digit pattern. */
  function findOtpTargets() {
    const inputs = [...document.querySelectorAll('input')].filter(
      (el) => /^(text|tel|number|password|)$/.test(el.type) && visible(el) && !handledFields.has(el),
    );
    const targets = [];
    const singles = inputs.filter((el) => el.maxLength === 1);
    const byParent = new Map();
    for (const el of singles) {
      const p = el.parentElement?.parentElement || el.parentElement;
      byParent.set(p, [...(byParent.get(p) || []), el]);
    }
    for (const group of byParent.values()) if (group.length === 6 || group.length === 8) targets.push(group);
    for (const el of inputs) {
      if (el.maxLength === 1) continue;
      const words = [el.name, el.id, el.getAttribute('aria-label'), el.placeholder].filter(Boolean).join(' ');
      if (el.autocomplete === 'one-time-code' || OTP_WORDS.test(words)) targets.push([el]);
    }
    return targets;
  }

  const setValue = (el, value) => {
    // Use the native setter so React/Vue-style pages notice the change.
    Object.getOwnPropertyDescriptor(HTMLInputElement.prototype, 'value').set.call(el, value);
    el.dispatchEvent(new Event('input', { bubbles: true }));
    el.dispatchEvent(new Event('change', { bubbles: true }));
  };

  function fill(target, code, issuer, secondsLeft, accountId) {
    const before = target.map((el) => el.value);
    log('filling', target.length, 'box(es)');
    if (target.length === 1) setValue(target[0], code);
    else target.forEach((el, i) => setValue(el, code[i] || ''));
    target.forEach((el) => handledFields.add(el));
    startCountdown(secondsLeft, accountId);
    toast(`Filled ${issuer ? issuer + ' ' : ''}code from Tanooki Auth`, () => target.forEach((el, i) => setValue(el, before[i])));
  }

  // Top-of-page warning for a site imitating a saved one. Stays until dismissed.
  function warnBanner(text) {
    const box = document.createElement('div');
    const root = box.attachShadow({ mode: 'closed' });
    root.innerHTML = `<style>
      div{position:fixed;left:0;right:0;top:0;z-index:2147483647;display:flex;gap:12px;align-items:center;justify-content:center;
        background:#B3261E;color:#fff;padding:12px 16px;font:600 15px/1.35 system-ui,sans-serif;box-shadow:0 4px 18px rgba(0,0,0,.35)}
      button{background:#fff;color:#B3261E;border:0;border-radius:6px;font:600 13px system-ui,sans-serif;padding:6px 10px;cursor:pointer}
    </style><div role="alert"><span></span><button>Dismiss</button></div>`;
    root.querySelector('span').textContent = `⚠ ${text}`;
    root.querySelector('button').addEventListener('click', () => box.remove());
    box.dataset.tanookiAuthWarning = '1';
    document.documentElement.appendChild(box);
  }

  function toast(text, undo) {
    const host = document.createElement('div');
    const root = host.attachShadow({ mode: 'closed' });
    root.innerHTML = `<style>
      div{position:fixed;right:16px;bottom:16px;z-index:2147483647;display:flex;gap:12px;align-items:center;
        background:#131316;color:#F2F2F5;border:1px solid #2A2A30;border-radius:8px;padding:10px 14px;
        font:13px/1.3 system-ui,sans-serif;box-shadow:0 6px 24px rgba(0,0,0,.4)}
      button{background:none;border:0;color:#2F80FF;font:600 13px system-ui,sans-serif;cursor:pointer;padding:0}
    </style><div role="status"><span></span><button>Undo</button></div>`; // static markup: Firefox's add-on review flags built HTML
    root.querySelector('span').textContent = text;
    if (undo) root.querySelector('button').addEventListener('click', () => { undo(); host.remove(); });
    else root.querySelector('button').remove();
    document.documentElement.appendChild(host);
    setTimeout(() => host.remove(), 6000);
  }

  async function tryFill() {
    if (filledOnce) return;
    const targets = findOtpTargets();
    // A password box alone can't be filled, but it's where a fake site first asks for something.
    const password = !targets.length && [...document.querySelectorAll('input[type=password]')].some(visible);
    if (!targets.length && (!password || siteChecked)) return;
    if (targets.length) log('code box found', targets[0].map((el) => el.name || el.id || el.autocomplete));
    // Busy pages change constantly; ask the app at most every 2 seconds.
    if (Date.now() - lastAsk < 2000) return;
    lastAsk = Date.now();
    if (!targets.length) siteChecked = true; // one lookalike check per page for password-only pages
    let reply;
    try {
      reply = await chrome.runtime.sendMessage(targets.length ? { type: 'fillPage', ancestorHosts, logins: loginHints() } : { type: 'checkSite' });
    } catch (e) { log('extension unreachable (reload the page)', e?.message); return; }
    if (reply?.lookalike) {
      log('lookalike of', reply.lookalike, '- not filling');
      filledOnce = true;
      warnBanner(reply.message);
      return;
    }
    if (password) return;
    if (!reply || reply.error || !reply.code) { log('not filling:', reply?.error || `${reply?.count ?? 0} matching accounts`, reply?.message || ''); return; }
    const target = findOtpTargets()[0];
    if (!target) { log('code box disappeared before filling'); return; }
    filledOnce = true;
    fill(target, reply.code, reply.account.issuer, reply.secondsLeft, reply.account.id);
  }

  chrome.runtime.onMessage.addListener((msg, _sender, sendResponse) => {
    // Right-click "Add to Tanooki Auth" on an image the background couldn't read (SVG, blob: images).
    if (msg.type === 'decodeImage') {
      const img = [...document.images].find((i) => i.currentSrc === msg.srcUrl || i.src === msg.srcUrl);
      if (!img) return;
      decodeElement(img).then((text) => sendResponse({ text }));
      return true;
    }
    if (msg.type === 'notice') {
      if (window === top) toast(msg.text);
      return;
    }
    // The popup asks to fill a code the user picked; double-check this frame is on that site.
    if (msg.type !== 'fill') return;
    const on = (h) => h === msg.domain || h.endsWith('.' + msg.domain);
    if (!on(host) || !ancestorHosts.every((h) => on(h.replace(/^www\./, '')))) return;
    // Prefer the box the user clicked into, then any code box we recognize.
    const focused = document.activeElement instanceof HTMLInputElement && visible(document.activeElement) ? [document.activeElement] : null;
    const target = findOtpTargets()[0] || focused;
    if (!target) { log('popup fill: no code box in this frame'); return; } // another frame may have it
    fill(target, msg.code, msg.issuer, msg.secondsLeft, msg.accountId);
    sendResponse({ filled: true });
  });

  // --- Setup QR capture ---

  function decode(source, w, h) {
    const scale = Math.min(1, 800 / Math.max(w, h));
    const c = document.createElement('canvas');
    c.width = Math.max(1, Math.round(w * scale));
    c.height = Math.max(1, Math.round(h * scale));
    const ctx = c.getContext('2d', { willReadFrequently: true });
    ctx.fillStyle = '#fff'; // transparent QR backgrounds would read as black
    ctx.fillRect(0, 0, c.width, c.height);
    ctx.drawImage(source, 0, 0, c.width, c.height);
    const data = ctx.getImageData(0, 0, c.width, c.height); // throws for cross-origin images
    return jsQR(data.data, c.width, c.height)?.data || '';
  }

  const loadImage = (src) => new Promise((resolve, reject) => {
    const img = new Image();
    img.onload = () => resolve(img);
    img.onerror = reject;
    img.src = src;
  });

  async function decodeElement(el) {
    try {
      if (el instanceof HTMLImageElement) {
        if (!el.complete || !el.naturalWidth) await new Promise((r) => el.addEventListener('load', r, { once: true }));
        return decode(el, el.naturalWidth, el.naturalHeight);
      }
      if (el instanceof HTMLCanvasElement) return decode(el, el.width, el.height);
      if (el instanceof SVGSVGElement) {
        const r = el.getBoundingClientRect();
        const url = URL.createObjectURL(new Blob([new XMLSerializer().serializeToString(el)], { type: 'image/svg+xml' }));
        try {
          return decode(await loadImage(url), Math.max(r.width, 200), Math.max(r.height, 200));
        } finally {
          URL.revokeObjectURL(url);
        }
      }
    } catch { /* cross-origin or unreadable: skip */ }
    return '';
  }

  function addButton(after, uri) {
    if (after.nextElementSibling?.dataset?.tanookiAuth) return;
    const b = document.createElement('button');
    b.type = 'button';
    b.dataset.tanookiAuth = '1';
    b.textContent = '+ Add to Tanooki Auth';
    b.style.cssText =
      'display:inline-block;margin:8px;padding:6px 12px;border:0;border-radius:999px;background:#2F80FF;color:#fff;' +
      'font:600 13px system-ui,sans-serif;cursor:pointer;vertical-align:middle';
    b.addEventListener('click', async (e) => {
      e.preventDefault();
      e.stopPropagation();
      b.disabled = true;
      b.textContent = 'Check the Tanooki Auth app…';
      const r = await chrome.runtime.sendMessage({ type: 'add', uri });
      b.textContent = r.error ? r.message
        : r.accepted ? 'Added to Tanooki Auth ✓'
        : r.reason === 'duplicate' ? 'Already in Tanooki Auth'
        : 'Not added';
      b.disabled = !!r.accepted || r.reason === 'duplicate';
    });
    after.insertAdjacentElement('afterend', b);
  }

  async function scanForSetupCodes() {
    for (const a of document.querySelectorAll('a[href^="otpauth://"]')) addButton(a, a.href);
    if (!SETUP_WORDS.test(document.body?.innerText || '')) return;
    const candidates = [...document.querySelectorAll('img, canvas, svg')]
      .filter((el) => !scannedImages.has(el) && !(el.ownerSVGElement))
      .filter((el) => {
        const r = el.getBoundingClientRect();
        return r.width >= 60 && r.height >= 60;
      })
      .slice(0, 20);
    for (const el of candidates) {
      scannedImages.add(el);
      const text = await decodeElement(el);
      if (text.startsWith('otpauth://')) addButton(el, text);
    }
  }

  let timer = null;
  const scan = () => {
    clearTimeout(timer);
    timer = setTimeout(() => { tryFill(); scanForSetupCodes(); }, 400);
  };
  scan();
  // Also watch hide/show changes: some sites unhide an existing code box rather than adding one.
  new MutationObserver(scan).observe(document.documentElement, {
    childList: true, subtree: true, attributes: true, attributeFilter: ['hidden', 'class', 'style'],
  });
})();
