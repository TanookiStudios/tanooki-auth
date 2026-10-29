importScripts('jsqr.js');

// Talks to the Tanooki Auth desktop app over 127.0.0.1 only. Holds the pairing token;
// never sees a secret, only the current code for one account at a time.

const PORTS = [41984, 41985, 41986, 41987, 41988, 41989, 41990, 41991, 41992, 41993];
let lastPort = null;

const MESSAGES = {
  noApp: 'Tanooki Auth isn\'t running. Open the Tanooki Auth app on this computer.',
  notPaired: 'This browser isn\'t paired with Tanooki Auth yet.',
  locked: 'Tanooki Auth is locked. Unlock it, then try again.',
  timeout: 'Tanooki Auth didn\'t answer in time.',
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
  return accounts.filter((a) => a.domains.some((d) => hostMatches(host, d) && ancestorHosts.every((h) => hostMatches(h, d))));
}

async function setBadge(tabId, text) {
  if (tabId == null) return;
  await chrome.action.setBadgeBackgroundColor({ tabId, color: '#2F80FF' });
  await chrome.action.setBadgeText({ tabId, text });
}

const handlers = {
  async status() {
    try {
      await call({ type: 'ping' });
    } catch (e) {
      return { state: e.code === 'locked' ? 'locked' : 'noApp', message: e.message };
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
    return { host, accounts, matching: accounts.filter((a) => a.domains.some((d) => hostMatches(host, d))).map((a) => a.id) };
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
    if (!host) throw new AppError('badPage', 'Open the website\'s two-factor setup page first.');
    const shot = await chrome.tabs.captureVisibleTab(windowId, { format: 'png' });
    const bitmap = await createImageBitmap(await (await fetch(shot)).blob());
    const canvas = new OffscreenCanvas(bitmap.width, bitmap.height);
    const ctx = canvas.getContext('2d', { willReadFrequently: true });
    ctx.drawImage(bitmap, 0, 0);
    const found = jsQR(ctx.getImageData(0, 0, bitmap.width, bitmap.height).data, bitmap.width, bitmap.height);
    const text = found?.data || '';
    if (text.startsWith('otpauth-migration://')) {
      throw new AppError('migration', 'That\'s a Google Authenticator transfer code. Use "Add account…" in the Tanooki Auth app to import it.');
    }
    if (!text.startsWith('otpauth://')) {
      throw new AppError('noQr', 'No setup QR code visible. Scroll so the whole QR code is on screen, then try again.');
    }
    return call({ type: 'add', uri: text, domain: host }, { waitSeconds: 300 });
  },

  // Content script found a code box: fill only when exactly one account is saved for this site.
  async fillPage({ ancestorHosts }, sender) {
    const host = hostOf(sender.url);
    const matches = await accountsFor(host, (ancestorHosts || []).map((h) => h.replace(/^www\./, '')));
    await setBadge(sender.tab?.id, matches.length > 1 ? String(matches.length) : '');
    if (matches.length !== 1) return { count: matches.length };
    const { code } = await call({ type: 'code', accountId: matches[0].id });
    return { code, account: matches[0] };
  },

  // Popup: the user picked an account for this tab. Optionally remember the site first.
  async fillTab({ accountId, tabId, tabUrl, remember }) {
    const host = hostOf(tabUrl);
    if (!host) throw new AppError('badPage', 'Codes can only be filled on websites.');
    if (remember) await call({ type: 'setDomain', accountId, domain: host });
    const { accounts } = await call({ type: 'accounts' });
    const a = accounts.find((x) => x.id === accountId);
    const domain = a && a.domains.find((d) => hostMatches(host, d));
    if (!domain) throw new AppError('wrongSite', 'That account isn\'t saved for this website.');
    const { code } = await call({ type: 'code', accountId });
    let reply;
    try {
      reply = await chrome.tabs.sendMessage(tabId, { type: 'fill', code, domain, issuer: a.issuer });
    } catch {
      // No page script: the tab was open before the extension was installed or reloaded.
      throw new AppError('noPageScript', 'Reload this page, then try again.');
    }
    if (!reply?.filled) {
      throw new AppError('noField', 'Couldn\'t find the code box on this page. Click into the box and try again, or use Copy and paste.');
    }
    return { ok: true };
  },

  // Content script found a setup QR code and the user clicked "Add to Tanooki Auth".
  async add({ uri }, sender) {
    // The app shows a confirmation, so give the user time to answer it.
    return call({ type: 'add', uri, domain: hostOf(sender.url) }, { waitSeconds: 300 });
  },
};

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
