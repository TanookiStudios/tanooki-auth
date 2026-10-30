// A tiny stand-in for the desktop app's bridge (app/lib/bridge/server.dart), no dependencies.
// Same port behavior, Origin check, pairing, token check, and accounts/code/codes replies.
import http from 'node:http';
import crypto from 'node:crypto';

const TOTP = [
  { id: 'gh', type: 'totp', issuer: 'GitHub', label: 'maddie@example.com', domains: ['github.com'] },
  { id: 'aws', type: 'totp', issuer: 'AWS', label: 'root', domains: ['aws.amazon.com'] },
];
const HOTP = { id: 'bank', type: 'hotp', issuer: 'Bank', label: 'checking', domains: [] };

/**
 * Starts a fake bridge on [port].
 * allowOrigin: which Origins get through (default: the proposed tanooki-integration:// rule).
 * Today's real app only allows chrome-extension://, which the tests use to check the "update the app" message.
 */
export function startFakeBridge({ port, allowOrigin = /^tanooki-integration:\/\/(raycast|alfred)$/ } = {}) {
  const state = {
    locked: false,
    pairCode: null, pairOrigin: null, pairMisses: 0,
    pairings: new Map(), // origin -> token
    hotpCounter: 0,
    codeFor: (id, n = 0) => String(100000 + (crypto.createHash('sha256').update(id + n).digest().readUInt32BE(0) % 900000)),
  };

  function handle(msg, origin) {
    const type = msg.type;
    if (state.locked) throw ['locked', 'Tanooki Auth is locked. Unlock it, then try again.'];
    if (type === 'ping') return { ok: true };
    if (type === 'pair') {
      if (msg.code == null) {
        state.pairCode = String(crypto.randomInt(0, 1e6)).padStart(6, '0');
        state.pairOrigin = origin;
        state.pairMisses = 0;
        return { pending: true };
      }
      if (state.pairCode == null || state.pairOrigin !== origin) throw ['pairing', 'Pairing timed out or was closed. Start pairing again.'];
      if (String(msg.code) !== state.pairCode) {
        if (++state.pairMisses >= 3) { state.pairCode = null; throw ['pairing', 'Three wrong codes. Start pairing again.']; }
        throw ['wrongCode', "That code doesn't match. Check the code shown in Tanooki Auth."];
      }
      state.pairCode = null;
      const token = crypto.randomBytes(32).toString('hex');
      state.pairings.set(origin, token);
      return { token };
    }
    if (typeof msg.token !== 'string' || state.pairings.get(origin) !== msg.token) {
      throw ['notPaired', "This browser isn't paired with Tanooki Auth."];
    }
    const accounts = [...TOTP, HOTP];
    switch (type) {
      case 'accounts':
        return { accounts };
      case 'codes':
        return { codes: Object.fromEntries(TOTP.filter((a) => msg.accountIds.includes(a.id)).map((a) => [a.id, { code: state.codeFor(a.id), secondsLeft: 17 }])) };
      case 'code': {
        const a = accounts.find((x) => x.id === msg.accountId);
        if (!a) throw ['notFound', "That account isn't in Tanooki Auth any more."];
        if (a.type === 'hotp') return { code: state.codeFor(a.id, state.hotpCounter++), secondsLeft: null };
        return { code: state.codeFor(a.id), secondsLeft: 17 };
      }
      default:
        throw ['badRequest', `Unknown request "${type}".`];
    }
  }

  const server = http.createServer((req, res) => {
    res.statusCode = allowOrigin.test(req.headers.origin ?? '') ? 400 : 403; // the app: 403 bad Origin, else 400 not a WebSocket
    res.end();
  });

  const upgraded = new Set();
  server.on('upgrade', (req, sock) => {
    upgraded.add(sock);
    sock.on('close', () => upgraded.delete(sock));
    const origin = req.headers.origin ?? '';
    if (!allowOrigin.test(origin)) { sock.end('HTTP/1.1 403 Forbidden\r\n\r\n'); return; }
    const accept = crypto.createHash('sha1').update(req.headers['sec-websocket-key'] + '258EAFA5-E914-47DA-95CA-C5AB0DC85B11').digest('base64');
    sock.write(`HTTP/1.1 101 Switching Protocols\r\nUpgrade: websocket\r\nConnection: Upgrade\r\nSec-WebSocket-Accept: ${accept}\r\n\r\n`);
    let buf = Buffer.alloc(0);
    sock.on('error', () => {});
    sock.on('data', (chunk) => {
      buf = Buffer.concat([buf, chunk]);
      // shortcut: unfragmented frames under 64 KiB only, which is all a client of this protocol sends.
      while (buf.length >= 2) {
        const opcode = buf[0] & 0x0f;
        let len = buf[1] & 0x7f, off = 2;
        if (len === 126) { if (buf.length < 4) return; len = buf.readUInt16BE(2); off = 4; }
        if (buf.length < off + 4 + len) return;
        const mask = buf.subarray(off, off + 4);
        const data = Buffer.from(buf.subarray(off + 4, off + 4 + len)).map((b, i) => b ^ mask[i % 4]);
        buf = buf.subarray(off + 4 + len);
        if (opcode === 8) { sock.end(Buffer.from([0x88, 0])); return; }
        if (opcode !== 1) continue;
        let reply, id = null;
        try {
          const msg = JSON.parse(data.toString());
          id = msg.id;
          reply = handle(msg, origin);
        } catch (e) {
          reply = Array.isArray(e) ? { error: e[0], message: e[1] } : { error: 'badRequest', message: "Tanooki Auth didn't understand that request." };
        }
        const out = Buffer.from(JSON.stringify({ id, ...reply }));
        const head = out.length < 126 ? Buffer.from([0x81, out.length]) : Buffer.from([0x81, 126, out.length >> 8, out.length & 0xff]);
        sock.write(Buffer.concat([head, out]));
      }
    });
  });

  return new Promise((resolve) => server.listen(port, '127.0.0.1', () => resolve({ server, state, close: () => new Promise((r) => { for (const s of upgraded) s.destroy(); server.closeAllConnections(); server.close(r); }) })));
}

// `node fake-bridge.mjs [port]` runs it by hand and prints pairing codes.
if (import.meta.url === `file://${process.argv[1]}`) {
  const { state } = await startFakeBridge({ port: Number(process.argv[2] || 41984) });
  console.log('Fake Tanooki Auth bridge running. Pairing codes appear here.');
  let last = null;
  setInterval(() => { if (state.pairCode && state.pairCode !== last) console.log('Pairing code:', (last = state.pairCode)); }, 200);
}
