const main = document.getElementById('main');
const send = (msg) => chrome.runtime.sendMessage(msg);
const el = (tag, attrs = {}, ...kids) => {
  const e = Object.assign(document.createElement(tag), attrs);
  e.append(...kids);
  return e;
};
const group = (c) => (c.length === 6 ? `${c.slice(0, 3)} ${c.slice(3)}` : c.length === 8 ? `${c.slice(0, 4)} ${c.slice(4)}` : c);

let tab = null;
let statusEl = null;

function showStatus(text, isError) {
  if (!statusEl) return;
  statusEl.className = isError ? 'err' : 'msg';
  statusEl.textContent = text;
}

async function start() {
  [tab] = await chrome.tabs.query({ active: true, currentWindow: true });
  const s = await send({ type: 'status' });
  if (s.state === 'ready') return showAccounts();
  if (s.state === 'notPaired') return showPairing();
  if (s.state === 'noApp' && s.phone?.paired) return showPhone(s.phone, s.message);
  main.replaceChildren(
    el('p', { className: s.state === 'locked' ? 'msg' : 'err', textContent: s.message }),
    el('button', { className: 'primary', textContent: 'Try again', onclick: start }),
    ...(s.state === 'noApp' ? [usePhoneButton()] : []),
  );
}

// --- "Use my phone" (Premium in the app): codes come from Tanooki Auth on a paired phone. ---

const usePhoneButton = () => el('div', { style: 'margin-top:12px' },
  el('button', { className: 'link', textContent: 'No desktop app here? Use my phone instead', onclick: showPhonePairing }));

function drawQr(text) {
  const q = qrcode(0, 'M'); // smallest version that fits
  q.addData(text);
  q.make();
  const n = q.getModuleCount();
  const scale = Math.max(2, Math.floor(220 / n));
  const canvas = el('canvas', { className: 'qr', width: n * scale, height: n * scale });
  const ctx = canvas.getContext('2d');
  ctx.fillStyle = '#fff';
  ctx.fillRect(0, 0, n * scale, n * scale);
  ctx.fillStyle = '#000';
  for (let r = 0; r < n; r++) for (let c = 0; c < n; c++) if (q.isDark(r, c)) ctx.fillRect(c * scale, r * scale, scale, scale);
  canvas.setAttribute('role', 'img');
  canvas.setAttribute('aria-label', 'Pairing QR code. Scan it with Tanooki Auth on your phone.');
  return canvas;
}

async function showPhonePairing() {
  main.replaceChildren(el('p', { className: 'msg', textContent: 'Making a pairing code…' }));
  const r = await send({ type: 'phoneStart' });
  if (r.error) {
    main.replaceChildren(el('p', { className: 'err', textContent: r.message }), el('button', { className: 'primary', textContent: 'Try again', onclick: showPhonePairing }));
    return;
  }
  const status = el('p', { className: 'msg', textContent: 'Waiting for your phone…' });
  main.replaceChildren(
    el('p', { className: 'msg', textContent: 'On your phone, open Tanooki Auth, go to Settings, then "Use with a browser", and tap "Pair a browser". Point the camera at this code.' }),
    drawQr(r.qr),
    status,
    el('button', { textContent: 'Cancel', onclick: async () => { await send({ type: 'phoneUnpair' }); start(); } }),
  );
  for (;;) {
    await new Promise((res) => setTimeout(res, 2000));
    if (!document.body.contains(status)) return; // the user left this screen
    const c = await send({ type: 'phoneCheck' });
    if (c.state === 'paired') return showPhone({ phoneName: c.phoneName }, null, 'Paired. Your phone will ask you to approve each code.');
    if (c.state === 'expired' || c.error === 'unpaired') {
      status.className = 'err';
      status.textContent = 'This code has expired.';
      main.append(el('button', { className: 'primary', textContent: 'Make a new code', onclick: showPhonePairing }));
      return;
    }
    if (c.error) { status.className = 'err'; status.textContent = c.message; }
  }
}

function showPhone(phone, appMessage, hello) {
  const host = (() => { try { const u = new URL(tab?.url || ''); return /^https?:$/.test(u.protocol) ? u.hostname.replace(/^www\./, '') : ''; } catch { return ''; } })();
  const status = el('p', { className: 'msg', textContent: hello || '' });
  const parts = [
    el('div', { className: 'caps', textContent: 'Using your phone' }),
    el('div', { className: 'card' },
      el('div', { className: 'title', textContent: phone.phoneName || 'Your phone' }),
      el('div', { className: 'sub', textContent: appMessage ? 'The desktop app isn\'t running, so codes come from your phone.' : 'Codes come from your phone.' })),
  ];
  if (host) {
    const get = el('button', { className: 'primary', textContent: `Get code for ${host}` });
    const codeEl = el('div', { className: 'code' });
    get.onclick = async () => {
      get.disabled = true;
      codeEl.textContent = '';
      status.className = 'msg';
      status.textContent = 'Check your phone and tap Approve…';
      const r = await send({ type: 'phoneFillTab', tabId: tab.id, tabUrl: tab.url });
      get.disabled = false;
      if (r.error) { status.className = 'err'; status.textContent = r.message; return; }
      codeEl.textContent = group(r.code);
      const copy = el('button', { textContent: 'Copy', onclick: async () => { await navigator.clipboard.writeText(r.code); copy.textContent = 'Copied'; } });
      codeEl.after(copy);
      status.textContent = r.filled ? `Filled the ${r.issuer || host} code ✓` : 'Couldn\'t find the code box on this page. Use Copy and paste it.';
    };
    parts.push(el('div', { className: 'row', style: 'margin-top:4px' }, get, codeEl));
  } else {
    parts.push(el('p', { className: 'msg', textContent: 'Open a website\'s sign-in page, then click the extension again.' }));
  }
  parts.push(status, el('div', { className: 'row', style: 'gap:6px;margin-top:12px' },
    el('button', { textContent: 'Try the desktop app again', onclick: start }),
    el('button', {
      textContent: 'Unpair phone',
      onclick: async () => { await send({ type: 'phoneUnpair' }); start(); },
    })));
  main.replaceChildren(...parts);
}

function showPairing() {
  const go = el('button', { className: 'primary', textContent: 'Pair with Tanooki Auth' });
  const note = el('p', { className: 'msg', textContent: 'Connect this browser to the Tanooki Auth app on this computer. You only do this once.' });
  main.replaceChildren(note, go, usePhoneButton());
  go.onclick = async () => {
    go.disabled = true;
    const r = await send({ type: 'pairStart' });
    if (r.error) {
      main.replaceChildren(el('p', { className: 'err', textContent: r.message }), go);
      go.disabled = false;
      return;
    }
    const input = el('input', { className: 'code-input', inputMode: 'numeric', maxLength: 7, placeholder: '000 000', autocomplete: 'off' });
    const err = el('p', { className: 'err' });
    const ok = el('button', { className: 'primary', textContent: 'Pair' });
    const submit = async () => {
      ok.disabled = true;
      const f = await send({ type: 'pairFinish', code: input.value });
      if (!f.error) return showAccounts();
      err.textContent = f.message;
      ok.disabled = false;
      if (f.error === 'pairing') { input.disabled = true; main.append(el('button', { textContent: 'Start again', onclick: showPairing })); }
    };
    ok.onclick = submit;
    input.onkeydown = (e) => { if (e.key === 'Enter') submit(); };
    main.replaceChildren(
      el('p', { className: 'msg', textContent: 'Tanooki Auth is now showing a 6-digit code. Type it here:' }),
      input, err, el('div', { className: 'row' }, el('div', { className: 'grow' }), ok),
    );
    input.focus();
  };
}

// --- Account list with live codes ---

const cards = new Map(); // accountId -> { account, codeEl, leftEl, code, expires }

async function refreshCodes() {
  const ids = [...cards.values()].filter((c) => c.account.type !== 'hotp').map((c) => c.account.id);
  if (!ids.length) return;
  const r = await send({ type: 'codes', accountIds: ids });
  if (r.error) {
    for (const c of cards.values()) if (c.account.type !== 'hotp') c.codeEl.textContent = '—';
    showStatus(r.message, true);
    return;
  }
  for (const [id, { code, secondsLeft }] of Object.entries(r.codes)) {
    const c = cards.get(id);
    if (!c) continue;
    c.code = code;
    c.codeEl.textContent = group(code);
    c.expires = Date.now() + secondsLeft * 1000;
  }
}

setInterval(() => {
  let due = false;
  for (const c of cards.values()) {
    if (c.expires == null) continue;
    const left = Math.ceil((c.expires - Date.now()) / 1000);
    if (left <= 0) { c.expires = null; due = true; } else c.leftEl.textContent = `${left}s`;
  }
  if (due) refreshCodes();
}, 500);

function accountCard(a, { matching, host }) {
  const codeEl = el('div', { className: 'code', textContent: '··· ···' });
  const leftEl = el('div', { className: 'left' });
  const c = { account: a, codeEl, leftEl, code: '', expires: null };
  cards.set(a.id, c);
  if (a.type === 'hotp') {
    // Each counter-based code is single-use, so don't spend one just because the popup opened.
    codeEl.replaceChildren(el('button', {
      textContent: 'Show code',
      onclick: async () => {
        const r = await send({ type: 'code', accountId: a.id });
        c.code = r.code || '';
        codeEl.textContent = r.error ? r.message : group(r.code);
      },
    }));
  }
  const copy = el('button', { textContent: 'Copy' });
  copy.onclick = async () => {
    if (!c.code) {
      const r = await send({ type: 'code', accountId: a.id });
      if (r.error) { showStatus(r.message, true); return; }
      c.code = r.code;
      codeEl.textContent = group(r.code);
    }
    await navigator.clipboard.writeText(c.code);
    copy.textContent = 'Copied';
  };
  const buttons = [copy];
  if (host) {
    const fill = el('button', { className: matching ? 'primary' : '', textContent: matching ? 'Fill' : 'Use here' });
    fill.title = matching ? 'Fill the code on this page' : `Fill on this page, and remember ${host} for this account`;
    fill.onclick = async () => {
      const r = await send({ type: 'fillTab', accountId: a.id, tabId: tab.id, tabUrl: tab.url, remember: !matching });
      if (r.error) showStatus(r.message, true);
      else window.close();
    };
    buttons.push(fill);
  }
  const card = el('div', { className: 'card' },
    el('div', { className: 'row' },
      el('div', { className: 'grow' },
        el('div', { className: 'title', textContent: a.issuer || a.label }),
        el('div', { className: 'sub', textContent: a.issuer ? a.label : '' })),
      a.domains.length ? el('span', {
        className: 'pill',
        // Show the website that matched this page, not just the first one saved.
        textContent: a.domains.find((d) => host && (host === d || host.endsWith('.' + d))) || a.domains[0],
      }) : ''),
    el('div', { className: 'row', style: 'margin-top:6px' }, codeEl, leftEl, el('div', { className: 'grow' }), ...buttons));
  card.dataset.search = [a.issuer, a.label, ...a.domains].join(' ').toLowerCase();
  return card;
}

function actions(host) {
  const status = statusEl;
  const scan = el('button', { className: 'primary', textContent: 'Scan page for QR code' });
  scan.title = 'Adds the two-factor setup QR code showing on this page';
  scan.onclick = async () => {
    scan.disabled = true;
    status.className = 'msg';
    status.textContent = 'Looking for a QR code… then check the Tanooki Auth app to confirm.';
    const r = await send({ type: 'scanTab', windowId: tab.windowId, tabUrl: tab.url });
    scan.disabled = false;
    if (r.error) { status.className = 'err'; status.textContent = r.message; return; }
    status.textContent = r.accepted ? 'Added to Tanooki Auth ✓' : r.reason === 'duplicate' ? 'That account is already in Tanooki Auth.' : 'Not added.';
    if (r.accepted) showAccounts();
  };
  const open = (screen, label) => el('button', {
    textContent: label,
    onclick: async () => {
      const r = await send({ type: 'openApp', screen });
      if (r.error) { status.className = 'err'; status.textContent = r.message; } else window.close();
    },
  });
  return [
    el('div', { className: 'row', style: 'gap:6px;flex-wrap:wrap;margin-top:12px' },
      scan, open('add', 'Add account…'), open('settings', 'Backup & settings…')),
    status,
  ];
}

async function showAccounts() {
  const r = await send({ type: 'listForTab', tabUrl: tab?.url || '' });
  if (r.error) return start();
  cards.clear();
  statusEl = el('p', { className: 'msg' });
  const { host, accounts, matching } = r;
  const here = accounts.filter((a) => matching.includes(a.id));
  const rest = accounts.filter((a) => !matching.includes(a.id));
  const parts = [];

  if (r.warning) parts.push(el('p', { className: 'err', textContent: r.warning }));
  if (host) {
    parts.push(el('div', { className: 'caps', textContent: `For ${host}` }));
    parts.push(...(here.length
      ? here.map((a) => accountCard(a, { matching: true, host }))
      : [el('p', { className: 'msg', textContent: 'No account saved for this website. Pick one below and click "Use here"; it will be filled automatically next time.' })]));
  }

  const list = el('div', { className: 'list' }, ...rest.map((a) => accountCard(a, { matching: false, host })));
  parts.push(el('div', { className: 'caps', textContent: `${host ? 'Other accounts' : 'All accounts'} (${rest.length})` }));
  if (rest.length > 4) {
    const search = el('input', { placeholder: 'Search accounts…', style: 'margin-bottom:8px' });
    search.oninput = () => {
      const q = search.value.trim().toLowerCase();
      for (const card of list.children) card.style.display = card.dataset.search.includes(q) ? '' : 'none';
    };
    parts.push(search);
  }
  if (!accounts.length) parts.push(el('p', { className: 'msg', textContent: 'No accounts yet. Open a website\'s two-factor setup page and click "Scan page for QR code".' }));
  parts.push(list, ...actions(host));
  main.replaceChildren(...parts);
  refreshCodes();
}

start();
