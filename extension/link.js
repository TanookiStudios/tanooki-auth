// "Use my phone": the extension side of the phone link (relay/PROTOCOL.md section 2). When the desktop app
// isn't reachable, the extension asks the paired phone for a code through the relay; the phone shows
// Approve / Deny. Everything is end-to-end encrypted (X25519 + HKDF + AES-256-GCM); the relay only sees
// ciphertext, and the pairing secret only travels in the QR code. Loaded by the background script, and by
// test/link-client.cjs in Node.
(() => {
  const DEFAULT_RELAY = 'https://tanooki-auth-relay.kirbymail.workers.dev';
  const te = new TextEncoder();
  const td = new TextDecoder();

  const b64u = (bytes) => {
    let s = '';
    for (const b of new Uint8Array(bytes)) s += String.fromCharCode(b);
    return btoa(s).replace(/\+/g, '-').replace(/\//g, '_').replace(/=+$/, '');
  };
  const unb64u = (s) => Uint8Array.from(atob(s.replace(/-/g, '+').replace(/_/g, '/')), (c) => c.charCodeAt(0));

  class LinkError extends Error {
    constructor(code, message) { super(message); this.code = code; }
  }

  function makeLink({ storage, fetchFn = (...a) => fetch(...a), crypto = globalThis.crypto, pollMs = 1500 }) {
    const { subtle } = crypto;
    const rand = (n) => crypto.getRandomValues(new Uint8Array(n));
    const sleep = (ms) => new Promise((r) => setTimeout(r, ms));
    const seen = new Map(); // inner message id -> time, for replay protection

    async function api(st, method, path, body, token = st.extToken) {
      let r;
      try {
        r = await fetchFn(st.relay + path, {
          method,
          headers: { 'content-type': 'application/json', ...(token ? { authorization: `Bearer ${token}` } : {}) },
          body: body ? JSON.stringify(body) : undefined,
        });
      } catch {
        throw new LinkError('offline', 'Can\'t reach the Tanooki Auth server. Check your internet connection.');
      }
      const json = await r.json().catch(() => ({}));
      if (r.status === 404 || r.status === 401) throw new LinkError('unpaired', 'Your phone is no longer paired. Pair it again.');
      if (r.status >= 400) throw new LinkError('relay', json.error || `The Tanooki Auth server said no (HTTP ${r.status}).`);
      return json;
    }

    async function keys(st) {
      if (st._keys) return st._keys;
      const priv = await subtle.importKey('pkcs8', unb64u(st.extPriv), { name: 'X25519' }, false, ['deriveBits']);
      const peer = await subtle.importKey('raw', unb64u(st.phoneKey), { name: 'X25519' }, false, []);
      const shared = await subtle.deriveBits({ name: 'X25519', public: peer }, priv, 256);
      const hk = await subtle.importKey('raw', shared, 'HKDF', false, ['deriveBits']);
      const okm = new Uint8Array(await subtle.deriveBits({
        name: 'HKDF', hash: 'SHA-256', salt: unb64u(st.pairSecret),
        info: te.encode(`TA-LINK-1|${st.roomId}|${st.extPub}|${st.phoneKey}`),
      }, hk, 512));
      const imp = (b) => subtle.importKey('raw', b, 'AES-GCM', false, ['encrypt', 'decrypt']);
      st._keys = { e2p: await imp(okm.slice(0, 32)), p2e: await imp(okm.slice(32)) };
      return st._keys;
    }

    async function seal(st, msg) {
      const iv = rand(12);
      const plain = te.encode(JSON.stringify({ ...msg, id: b64u(rand(16)), ts: Date.now() }));
      const ct = await subtle.encrypt({ name: 'AES-GCM', iv, additionalData: te.encode(`TA-LINK-1|${st.roomId}|e2p`) }, (await keys(st)).e2p, plain);
      return { ciphertext: b64u([...iv, ...new Uint8Array(ct)]), id: JSON.parse(td.decode(plain)).id };
    }

    // A message from the phone, decrypted, or null if it doesn't decrypt, is stale, or was seen before.
    async function openMsg(st, m) {
      if (m.from !== 'phone') return null;
      let msg;
      try {
        const all = unb64u(m.ciphertext);
        const clear = await subtle.decrypt({ name: 'AES-GCM', iv: all.slice(0, 12), additionalData: te.encode(`TA-LINK-1|${st.roomId}|p2e`) }, (await keys(st)).p2e, all.slice(12));
        msg = JSON.parse(td.decode(clear));
      } catch { return null; }
      const now = Date.now();
      for (const [id, t] of seen) if (now - t > 300000) seen.delete(id);
      const age = now - (msg.ts || 0);
      if (age > 120000 || age < -30000 || !msg.id || seen.has(msg.id)) return null;
      seen.set(msg.id, now);
      return msg;
    }

    // New messages from the phone since the last poll.
    async function poll(st) {
      const r = await api(st, 'GET', `/v1/link/rooms/${st.roomId}/messages?after=${st.cursor || 0}`);
      st.cursor = r.cursor;
      const out = [];
      for (const m of r.messages) {
        const msg = await openMsg(st, m);
        if (msg) out.push({ msg, relayId: m.id });
      }
      return out;
    }

    const save = (st) => { const { _keys, ...plain } = st; return storage.set(plain); };

    return {
      /** Makes a room and returns the QR text for the phone to scan (PROTOCOL.md 2.1). */
      async startPairing(relay = DEFAULT_RELAY) {
        const roomId = b64u(rand(32));
        const kp = await subtle.generateKey({ name: 'X25519' }, true, ['deriveBits']);
        const st = {
          relay, roomId, paired: false, cursor: 0,
          extPub: b64u(await subtle.exportKey('raw', kp.publicKey)),
          extPriv: b64u(await subtle.exportKey('pkcs8', kp.privateKey)),
          pairSecret: b64u(rand(32)),
        };
        const r = await api(st, 'POST', `/v1/link/rooms/${roomId}/create`, {}, null);
        st.extToken = r.extToken;
        st.pairBy = r.pairBy;
        await save(st);
        return { qr: `tanookiauth://link?v=1&relay=${encodeURIComponent(relay)}&room=${roomId}&key=${st.extPub}&secret=${st.pairSecret}`, pairBy: r.pairBy };
      },

      /** While pairing: 'waiting', 'expired', or 'paired' once the phone's hello decrypts. */
      async checkPairing() {
        const st = await storage.get();
        if (!st) return { state: 'none' };
        if (st.paired) return { state: 'paired', phoneName: st.phoneName };
        if (Date.now() > st.pairBy && !st.phoneKey) return { state: 'expired' };
        if (!st.phoneKey) {
          const room = await api(st, 'GET', `/v1/link/rooms/${st.roomId}`);
          if (!room.phoneKey) return { state: 'waiting' };
          st.phoneKey = room.phoneKey;
        }
        for (const { msg } of await poll(st)) {
          if (msg.t === 'hello') { st.paired = true; st.phoneName = String(msg.device || 'your phone').slice(0, 60); }
        }
        await save(st);
        return st.paired ? { state: 'paired', phoneName: st.phoneName } : { state: 'waiting' };
      },

      async status() {
        const st = await storage.get();
        return st?.paired ? { paired: true, phoneName: st.phoneName } : { paired: false };
      },

      /**
       * Asks the phone for a code for [host] and waits for Approve or Deny. Resolves with
       * { code, domain, issuer, expiresIn }. [onSent] gets the relay's push result ('sent', 'not-configured', ...).
       */
      async requestCode(host, { timeoutMs = 110000, onSent } = {}) {
        const st = await storage.get();
        if (!st?.paired) throw new LinkError('notLinked', 'No phone is paired with this browser.');
        await poll(st).catch(() => {}); // skip anything old, so only answers to this request count
        const { ciphertext, id } = await seal(st, { t: 'fill-request', host });
        const sent = await api(st, 'POST', `/v1/link/rooms/${st.roomId}/messages`, { ciphertext, ttl: 120, notify: true });
        onSent?.(sent.push);
        const until = Date.now() + timeoutMs;
        try {
          while (Date.now() < until) {
            await sleep(pollMs);
            for (const { msg, relayId } of await poll(st)) {
              if (msg.re !== id) continue; // ignore answers to requests we didn't make
              api(st, 'DELETE', `/v1/link/rooms/${st.roomId}/messages/${relayId}`).catch(() => {});
              if (msg.t === 'deny') throw new LinkError('denied', 'You tapped Deny on your phone.');
              if (msg.t === 'code' && /^[0-9A-Z]{5,10}$/.test(msg.code)) {
                return { code: msg.code, domain: String(msg.domain || ''), issuer: String(msg.issuer || ''), expiresIn: msg.expiresIn };
              }
            }
          }
          throw new LinkError('timeout', 'Your phone didn\'t answer in time. Open Tanooki Auth on your phone and try again.');
        } finally {
          await save(st);
        }
      },

      async unpair() {
        const st = await storage.get();
        await storage.clear();
        if (st?.extToken) await api(st, 'DELETE', `/v1/link/rooms/${st.roomId}`).catch(() => {});
      },
    };
  }

  const api = { makeLink, LinkError, DEFAULT_RELAY };
  if (typeof module !== 'undefined') module.exports = api;
  else globalThis.tanookiLink = api;
})();
