// Chrome runs this as a service worker; Firefox and Safari load the same files as background scripts (see manifest).
if (typeof importScripts === 'function') importScripts('jsqr.js', 'lookalike.js', 'link.js', 'login.js');

// Talks to the Tanooki Auth desktop app over 127.0.0.1 only. Holds the pairing token;
// never sees a secret, only the current code for one account at a time.

const t = (key, ...subs) => chrome.i18n.getMessage(key, subs.map(String)); // words from _locales/<language>/messages.json

const PORTS = [41984, 41985, 41986, 41987, 41988, 41989, 41990, 41991, 41992, 41993];
let lastPort = null;

const MESSAGES = {
  noApp: t('errNoApp'),
  notPaired: t('errNotPaired'),
  locked: t('errLocked'),
  timeout: t('errTimeout'),
};

class AppError extends Error {
  constructor(code, message) { super(message || MESSAGES[code] || code); this.code = code; }
}

// Is the app listening on this port? A plain HTTP request fails instantly when nothing is there,
// unlike WebSocket attempts, which the browser deliberately slows down after each failure.
async function appListening(port) {
  try {
    await fetch(`http://127.0.0.1:${port}/`, { signal: AbortSignal.timeout(400), cache: 'no-store' });
    return true; // any HTTP answer (the app replies 400 to non-WebSocket requests)
  } catch {
    return false;
  }
}

// One WebSocket, kept open and shared by every request (matched up by id).
let sock = null; // { ws, pending: Map<id, {resolve, reject, timer}> }
let nextId = 1;

async function socket() {
  if (sock?.ws.readyState === WebSocket.OPEN) return sock;
  const order = lastPort ? [lastPort, ...PORTS.filter((p) => p !== lastPort)] : PORTS;
  let port = null;
  for (const p of order) if (await appListening(p)) { port = p; break; }
  if (!port) throw new AppError('noApp');
  const ws = new WebSocket(`ws://127.0.0.1:${port}`);
  await new Promise((resolve, reject) => {
    const timer = setTimeout(() => { ws.close(); reject(new AppError('timeout')); }, 5000);
    ws.onopen = () => { clearTimeout(timer); resolve(); };
    ws.onerror = () => { clearTimeout(timer); reject(new AppError('noApp')); };
  });
  lastPort = port;
  const s = { ws, pending: new Map() };
  ws.onmessage = (e) => {
    const reply = JSON.parse(e.data);
    const p = s.pending.get(reply.id);
    if (!p) return;
    s.pending.delete(reply.id);
    clearTimeout(p.timer);
    if (reply.error) p.reject(new AppError(reply.error, reply.message));
    else p.resolve(reply);
  };
  ws.onclose = () => {
    if (sock === s) sock = null;
    for (const p of s.pending.values()) { clearTimeout(p.timer); p.reject(new AppError('noApp')); }
    s.pending.clear();
  };
  sock = s;
  return s;
}

async function call(msg, { waitSeconds = 10 } = {}) {
  const s = await socket();
  const { token } = await chrome.storage.local.get('token');
  const id = nextId++;
  try {
    return await new Promise((resolve, reject) => {
      const timer = setTimeout(() => { s.pending.delete(id); reject(new AppError('timeout')); }, waitSeconds * 1000);
      s.pending.set(id, { resolve, reject, timer });
      s.ws.send(JSON.stringify({ id, token, ...msg }));
    });
  } catch (e) {
    if (e.code === 'notPaired') await chrome.storage.local.remove('token');
    throw e;
  }
}

const hostOf = (url) => {
  try {
    const u = new URL(url);
    return /^https?:$/.test(u.protocol) ? u.hostname.toLowerCase().replace(/^www\./, '') : '';
  } catch { return ''; }
};

// shortcut: no public-suffix list, so a saved "co.uk" would over-match; upgrade to a PSL match if anyone hits it.
const hostMatches = (host, domain) => !!host && (host === domain || host.endsWith('.' + domain));

/** Accounts saved for [host], and only if every frame above it is on the same site too. */
async function accountsFor(host, ancestorHosts = []) {
  const { accounts } = await call({ type: 'accounts' });
  const matches = accounts.filter((a) => a.domains.some((d) => hostMatches(host, d) && ancestorHosts.every((h) => hostMatches(h, d))));
  return { matches, lookalike: matches.length ? null : lookalikeFor(host, accounts) };
}

// The saved domain this host pretends to be (gihtub.com, github.com.evil.io…), or null.
const lookalikeFor = (host, accounts) => tanookiLookalike.lookalikeOf(host, accounts.flatMap((a) => a.domains));
const lookalikeError = (d) => new AppError('lookalike', t('errLookalike', d));

async function setBadge(tabId, text, color = '#2F80FF') {
  if (tabId == null) return;
  await chrome.action.setBadgeBackgroundColor({ tabId, color });
  await chrome.action.setBadgeText({ tabId, text });
}

// A new page in the tab starts with a clean badge (its content script sets it again if it matches).
chrome.tabs.onUpdated.addListener((tabId, info) => {
  if (info.status === 'loading') chrome.action.setBadgeText({ tabId, text: '' }).catch(() => {});
});

function decodeBitmap(bitmap) {
  const canvas = new OffscreenCanvas(bitmap.width, bitmap.height);
  const ctx = canvas.getContext('2d', { willReadFrequently: true });
  ctx.fillStyle = '#fff'; // transparent QR backgrounds would read as black
  ctx.fillRect(0, 0, bitmap.width, bitmap.height);
  ctx.drawImage(bitmap, 0, 0);
  return jsQR(ctx.getImageData(0, 0, bitmap.width, bitmap.height).data, bitmap.width, bitmap.height)?.data || '';
}

// The text of the QR code in an image: fetched here (works across sites thanks to the extension's
// host permission), else read by the page's own script (SVG and blob: images).
async function qrFromImage(srcUrl, tabId, frameId) {
  try {
    const r = await fetch(srcUrl, { credentials: 'include' });
    const text = decodeBitmap(await createImageBitmap(await r.blob()));
    if (text) return text;
  } catch { /* unreadable here: let the page try */ }
  const r = await chrome.tabs.sendMessage(tabId, { type: 'decodeImage', srcUrl }, { frameId }).catch(() => null);
  return r?.text || '';
}

// Right-click menu on images. Menus outlive the worker, so they're made once per install or update.
chrome.runtime.onInstalled.addListener(() => {
  chrome.contextMenus.create({ id: 'addQr', title: t('menuAddQr'), contexts: ['image'] }, () => void chrome.runtime.lastError);
});
chrome.contextMenus.onClicked.addListener((info, tab) => {
  if (info.menuItemId !== 'addQr' || !tab) return;
  handlers.addImage({ srcUrl: info.srcUrl, frameId: info.frameId || 0 }, { tab }).catch(() => {});
});

// --- "Use my phone": when the desktop app isn't running, ask the paired phone instead (link.js). ---

const phone = tanookiLink.makeLink({
  storage: {
    get: async () => (await chrome.storage.local.get('link')).link || null,
    set: (link) => chrome.storage.local.set({ link }),
    clear: () => chrome.storage.local.remove('link'),
  },
});
const phoneAsks = new Map(); // host -> pending request, so busy pages don't send the same request twice
const phoneQuiet = new Map(); // host -> time; after a Deny or no answer, pages don't ask again for 2 minutes

/** A code from the phone for [host]. Fills nothing itself; checks the phone's account is saved for this site. */
async function phoneCode(host, framesAbove = [], { auto = false } = {}) {
  if (!host) throw new AppError('badPage', t('errBadPage'));
  // Don't make the phone buzz for a page framed inside some other site.
  if (!framesAbove.every((h) => hostMatches(h, host) || hostMatches(host, h))) throw new AppError('framed', t('errFramed'));
  if (auto && phoneQuiet.get(host) > Date.now()) throw new AppError('quiet', t('errQuiet'));
  if (!phoneAsks.has(host)) {
    phoneAsks.set(host, phone.requestCode(host).finally(() => phoneAsks.delete(host)));
  }
  let r;
  try {
    r = await phoneAsks.get(host);
  } catch (e) {
    phoneQuiet.set(host, Date.now() + 120000);
    throw new AppError(e.code || 'phone', e.message);
  }
  // The phone only offers accounts saved for this site, but check again here: never fill a code on any
  // site but the one its account is saved for, or anywhere framed by another site, or on a lookalike.
  const domain = r.domain.toLowerCase();
  if (!hostMatches(host, domain) || !framesAbove.every((h) => hostMatches(h, domain))) {
    throw new AppError('wrongSite', domain ? t('errWrongSitePhone', domain) : t('errWrongSitePhoneUnknown'));
  }
  const lookalike = tanookiLookalike.lookalikeOf(host, [domain]);
  if (lookalike) throw lookalikeError(lookalike);
  return { ...r, domain };
}

const handlers = {
  async status() {
    try {
      await call({ type: 'ping' });
    } catch (e) {
      return { state: e.code === 'locked' ? 'locked' : 'noApp', message: e.message, phone: await phone.status() };
    }
    const { token } = await chrome.storage.local.get('token');
    if (!token) return { state: 'notPaired' };
    try {
      await call({ type: 'accounts' });
      return { state: 'ready' };
    } catch (e) {
      return { state: e.code === 'notPaired' ? 'notPaired' : 'error', message: e.message };
    }
  },

  async pairStart() {
    return call({ type: 'pair' });
  },

  async pairFinish({ code }) {
    const { token } = await call({ type: 'pair', code: String(code).replace(/\D/g, '') });
    await chrome.storage.local.set({ token });
    return { ok: true };
  },

  async listForTab({ tabUrl }) {
    const host = hostOf(tabUrl);
    const { accounts } = await call({ type: 'accounts' });
    const lookalike = host ? lookalikeFor(host, accounts) : null;
    return {
      host, accounts, warning: lookalike && lookalikeError(lookalike).message,
      matching: accounts.filter((a) => a.domains.some((d) => hostMatches(host, d))).map((a) => a.id),
    };
  },

  async code({ accountId }) {
    return call({ type: 'code', accountId });
  },

  async codes({ accountIds }) {
    return call({ type: 'codes', accountIds });
  },

  async openApp({ screen }) {
    return call({ type: 'open', screen });
  },

  // Popup "Scan page": read the visible part of the tab and look for a setup QR code.
  // Catches codes the in-page button can't read (cross-origin images, odd markup).
  async scanTab({ windowId, tabUrl }) {
    const host = hostOf(tabUrl);
    if (!host) throw new AppError('badPage', t('errSetupPageFirst'));
    const shot = await chrome.tabs.captureVisibleTab(windowId, { format: 'png' });
    const text = decodeBitmap(await createImageBitmap(await (await fetch(shot)).blob()));
    if (text.startsWith('otpauth-migration://')) {
      throw new AppError('migration', t('errMigration'));
    }
    if (!text.startsWith('otpauth://')) {
      throw new AppError('noQr', t('errNoQrVisible'));
    }
    return call({ type: 'add', uri: text, domain: host }, { waitSeconds: 300 });
  },

  // Content script found a code box: fill only when exactly one account is saved for this site.
  async fillPage({ ancestorHosts, logins }, sender) {
    const host = hostOf(sender.url);
    // Some browsers (older Firefox) have no location.ancestorOrigins, so also check the tab's own address.
    const above = [...(ancestorHosts || []), hostOf(sender.tab?.url || sender.url)].map((h) => h.replace(/^www\./, ''));
    let found;
    try {
      found = await accountsFor(host, above);
    } catch (e) {
      // Desktop app not running: ask the paired phone, if there is one.
      if (e.code !== 'noApp' || !(await phone.status()).paired) throw e;
      const r = await phoneCode(host, above, { auto: true });
      return { code: r.code, secondsLeft: r.expiresIn, account: { issuer: r.issuer } };
    }
    const { matches, lookalike } = found;
    // Several accounts for this site: the one whose name matches the email or username on the page.
    const pick = matches.length === 1 ? matches[0] : tanookiLogin.pickByLogin(matches, logins);
    await setBadge(sender.tab?.id, lookalike ? '!' : matches.length > 1 && !pick ? String(matches.length) : '');
    if (lookalike) return { count: 0, lookalike, message: lookalikeError(lookalike).message };
    if (!pick) return { count: matches.length }; // unsure: the popup lists them to choose from
    const { code, secondsLeft } = await call({ type: 'code', accountId: pick.id });
    return { code, secondsLeft, account: pick };
  },

  // Content script found a password box but no code box yet: only warn about lookalikes.
  async checkSite(_msg, sender) {
    const host = hostOf(sender.url);
    const { accounts } = await call({ type: 'accounts' });
    const lookalike = lookalikeFor(host, accounts);
    if (lookalike) await setBadge(sender.tab?.id, '!');
    return lookalike ? { lookalike, message: lookalikeError(lookalike).message } : {};
  },

  // Popup: the user picked an account for this tab. Optionally remember the site first.
  async fillTab({ accountId, tabId, tabUrl, remember }) {
    const host = hostOf(tabUrl);
    if (!host) throw new AppError('badPage', t('errBadPage'));
    // "Use here" on a lookalike is exactly what a phishing page hopes for, so refuse it.
    const lookalike = lookalikeFor(host, (await call({ type: 'accounts' })).accounts);
    if (lookalike) throw lookalikeError(lookalike);
    if (remember) await call({ type: 'setDomain', accountId, domain: host });
    const { accounts } = await call({ type: 'accounts' });
    const a = accounts.find((x) => x.id === accountId);
    const domain = a && a.domains.find((d) => hostMatches(host, d));
    if (!domain) throw new AppError('wrongSite', t('errNotSavedHere'));
    const { code, secondsLeft } = await call({ type: 'code', accountId });
    let reply;
    try {
      reply = await chrome.tabs.sendMessage(tabId, { type: 'fill', code, domain, issuer: a.issuer, secondsLeft, accountId });
    } catch {
      // No page script: the tab was open before the extension was installed or reloaded.
      throw new AppError('noPageScript', t('errReload'));
    }
    if (!reply?.filled) {
      throw new AppError('noField', t('errNoField'));
    }
    return { ok: true };
  },

  async phoneStart() {
    return phone.startPairing();
  },

  async phoneCheck() {
    return phone.checkPairing();
  },

  async phoneUnpair() {
    await phone.unpair();
    return { ok: true };
  },

  // Popup "Get code from my phone": ask, then fill the tab (the content script checks every frame's site).
  async phoneFillTab({ tabId, tabUrl }) {
    const host = hostOf(tabUrl);
    const r = await phoneCode(host);
    let reply = null;
    try {
      reply = await chrome.tabs.sendMessage(tabId, { type: 'fill', code: r.code, domain: r.domain, issuer: r.issuer, secondsLeft: r.expiresIn });
    } catch {
      // No page script (page opened before the extension loaded): the popup still shows the code to copy.
    }
    return { code: r.code, issuer: r.issuer, domain: r.domain, filled: !!reply?.filled };
  },

  // Toolbar countdown from the page's 1-second timer (content.js). Numbers only, never a code.
  async badge({ text }, sender) {
    const n = Number(text);
    if (text !== '' && !(Number.isInteger(n) && n > 0 && n < 1000)) throw new AppError('badRequest', t('errBadgeSeconds'));
    await setBadge(sender.tab?.id, text, n && n <= 5 ? '#B3261E' : '#2F80FF');
    return { ok: true };
  },

  // The countdown ran out: how long the next code lasts (the code itself stays here).
  async secondsLeft({ accountId }) {
    const { codes } = await call({ type: 'codes', accountIds: [accountId] });
    return { secondsLeft: codes[accountId]?.secondsLeft ?? null };
  },

  // Right-click "Add to Tanooki Auth" on an image. The app (or phone) always asks the user to confirm;
  // the page gets a short notice, never the code's contents.
  async addImage({ srcUrl, frameId = 0 }, { tab }) {
    const notice = (text) => chrome.tabs.sendMessage(tab.id, { type: 'notice', text }, { frameId: 0 }).catch(() => {});
    let r;
    try {
      r = await addFromImage(srcUrl, tab, frameId, notice);
    } catch (e) {
      await notice(e.message);
      throw e;
    }
    await notice(r.accepted ? t('noticeAdded') : r.reason === 'duplicate' ? t('noticeDuplicate') : t('noticeNotAdded'));
    return r;
  },

  // Content script found a setup QR code and the user clicked "Add to Tanooki Auth".
  async add({ uri }, sender) {
    // The app shows a confirmation, so give the user time to answer it.
    return call({ type: 'add', uri, domain: hostOf(sender.url) }, { waitSeconds: 300 });
  },
};

async function addFromImage(srcUrl, tab, frameId, notice) {
  const text = await qrFromImage(srcUrl, tab.id, frameId);
  if (!text) throw new AppError('noQr', t('errNoQrInImage'));
  const migration = /^otpauth-migration:\/\//i.test(text);
  if (!migration && !/^otpauth:\/\//i.test(text)) throw new AppError('notSetup', t('errNotSetupQr'));
  // A Google Authenticator transfer holds many accounts from many sites, so it isn't tied to this page.
  const add = { type: 'add', uri: text, ...(migration ? {} : { domain: hostOf(tab.url) }) };
  await notice(t('noticeCheckApp'));
  try {
    return await call(add, { waitSeconds: 300 });
  } catch (e) {
    if (migration && e.code === 'badRequest') {
      throw new AppError('oldApp', t('errOldApp'));
    }
    if (e.code !== 'noApp' || !(await phone.status()).paired) throw e;
  }
  // No desktop app here: the paired phone adds it instead.
  await notice(t('noticeCheckPhone'));
  try {
    return await phone.requestAdd(text);
  } catch (e) {
    throw new AppError(e.code || 'phone', e.message);
  }
}

self.handlersForTest = handlers; // lets the automated test call handlers directly from the worker

chrome.runtime.onMessage.addListener((msg, sender, sendResponse) => {
  const handler = handlers[msg.type];
  if (!handler) return false;
  handler(msg, sender).then(
    (r) => sendResponse(r),
    (e) => sendResponse({ error: e.code || 'error', message: e.message }),
  );
  return true; // async reply
});
