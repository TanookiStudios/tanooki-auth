// Tanooki Auth bridge client shared by the Raycast extension and the Alfred workflow.
// Talks to the desktop app over 127.0.0.1 only, the same way the browser extension does
// (see app/lib/bridge/server.dart). Never sees a secret, only current codes.
import http from 'node:http';
import { execFile } from 'node:child_process';

const DEFAULT_PORTS = [41984, 41985, 41986, 41987, 41988, 41989, 41990, 41991, 41992, 41993];
// TANOOKI_BRIDGE_PORTS / TANOOKI_KEYCHAIN_SERVICE exist so the tests never touch the real app or token.
const PORTS = process.env.TANOOKI_BRIDGE_PORTS ? process.env.TANOOKI_BRIDGE_PORTS.split(',').map(Number) : DEFAULT_PORTS;
const KEYCHAIN_SERVICE = process.env.TANOOKI_KEYCHAIN_SERVICE || 'Tanooki Auth bridge';

export class BridgeError extends Error {
  constructor(code, message) {
    super(message);
    this.code = code;
  }
}

const messages = (who) => ({
  noApp: "Tanooki Auth isn't running. Open Tanooki Auth on this Mac, then try again.",
  oldApp: `Tanooki Auth is running but doesn't accept ${who} yet. Update Tanooki Auth, then try again.`,
  notPaired: `${who} isn't paired with Tanooki Auth yet.`,
  timeout: "Tanooki Auth didn't answer in time.",
});

/** HTTP status the port answers with our Origin (400 = the app, 403 = the app refusing us), or null if nothing is there. */
function probe(port, origin) {
  return new Promise((resolve) => {
    const req = http.get({ host: '127.0.0.1', port, path: '/', headers: { Origin: origin }, timeout: 400 }, (res) => {
      res.resume();
      resolve(res.statusCode);
    });
    req.on('timeout', () => req.destroy());
    req.on('error', () => resolve(null));
  });
}

function run(cmd, args, input) {
  return new Promise((resolve, reject) => {
    const child = execFile(cmd, args, (err, stdout, stderr) => (err ? reject(Object.assign(err, { stderr })) : resolve(stdout)));
    if (input != null) child.stdin.end(input);
  });
}

/** A client for one integration, e.g. createClient('raycast', 'Raycast'). */
export function createClient(name, displayName = name) {
  const origin = `tanooki-integration://${name}`;
  const msg = messages(displayName);
  const err = (code) => new BridgeError(code, msg[code]);

  // The token lives in the login keychain, never in a file.
  const keychain = {
    async get() {
      try {
        return (await run('security', ['find-generic-password', '-s', KEYCHAIN_SERVICE, '-a', name, '-w'])).trim() || null;
      } catch {
        return null; // not found
      }
    },
    // Fed through `security -i` on stdin so the token never shows up in the process list.
    async set(token) {
      if (!/^[0-9a-f]+$/.test(token)) throw new BridgeError('badToken', 'Tanooki Auth sent an unexpected pairing token.');
      await run('security', ['-i'], `add-generic-password -U -s "${KEYCHAIN_SERVICE}" -a "${name}" -l "${KEYCHAIN_SERVICE}" -w "${token}"\n`);
    },
    async clear() {
      await run('security', ['delete-generic-password', '-s', KEYCHAIN_SERVICE, '-a', name]).catch(() => {});
    },
  };

  async function connect() {
    let refused = false;
    for (const port of PORTS) {
      const status = await probe(port, origin);
      if (status === 403) refused = true;
      if (status !== 400) continue; // 400 = the app's answer to a plain HTTP request it would accept
      const ws = new WebSocket(`ws://127.0.0.1:${port}`, { headers: { Origin: origin } });
      await new Promise((resolve, reject) => {
        const timer = setTimeout(() => { ws.close(); reject(err('timeout')); }, 5000);
        ws.onopen = () => { clearTimeout(timer); resolve(); };
        ws.onerror = () => { clearTimeout(timer); reject(err('noApp')); };
      });
      return ws;
    }
    throw err(refused ? 'oldApp' : 'noApp');
  }

  /** Opens one connection, runs fn(send), closes it. send() attaches the stored token. */
  async function session(fn) {
    const ws = await connect();
    const token = await keychain.get();
    const pending = new Map();
    let nextId = 1;
    ws.onmessage = (e) => {
      const reply = JSON.parse(e.data);
      const p = pending.get(reply.id);
      if (!p) return;
      pending.delete(reply.id);
      clearTimeout(p.timer);
      if (reply.error) p.reject(new BridgeError(reply.error, reply.message));
      else p.resolve(reply);
    };
    ws.onclose = () => {
      for (const p of pending.values()) { clearTimeout(p.timer); p.reject(err('noApp')); }
      pending.clear();
    };
    const send = (m) => new Promise((resolve, reject) => {
      const id = nextId++;
      const timer = setTimeout(() => { pending.delete(id); reject(err('timeout')); }, 10000);
      pending.set(id, { resolve, reject, timer });
      ws.send(JSON.stringify({ id, token: token ?? undefined, ...m }));
    });
    try {
      return await fn(send);
    } catch (e) {
      if (e.code === 'notPaired') {
        await keychain.clear();
        throw err('notPaired'); // the app's own wording says "This browser"
      }
      throw e;
    } finally {
      ws.close();
    }
  }

  return {
    origin,
    keychain,

    /** Every live account, with the current code for TOTP ones (HOTP codes are single-use: ask with code()). */
    listCodes: () => session(async (send) => {
      const { accounts } = await send({ type: 'accounts' });
      const ids = accounts.filter((a) => a.type !== 'hotp').map((a) => a.id);
      const { codes } = ids.length ? await send({ type: 'codes', accountIds: ids }) : { codes: {} };
      const fetchedAt = Date.now();
      return accounts.map((a) => ({
        ...a,
        code: codes[a.id]?.code ?? null,
        expiresAt: codes[a.id] ? fetchedAt + codes[a.id].secondsLeft * 1000 : null,
      }));
    }),

    /** A fresh code for one account (spends one HOTP code). */
    code: (accountId) => session((send) => send({ type: 'code', accountId })),

    /** Step 1: the app shows a 6-digit code. */
    pairStart: () => session((send) => send({ type: 'pair' })),

    /** Step 2: send the code the user typed; stores the token in the keychain. */
    pairFinish: (code) => session(async (send) => {
      const { token } = await send({ type: 'pair', code: String(code).replace(/\D/g, '') });
      await keychain.set(token);
      return { ok: true };
    }),
  };
}

/** "123456" -> "123 456", "12345678" -> "1234 5678". */
export const groupCode = (c) => (c.length === 6 ? `${c.slice(0, 3)} ${c.slice(3)}` : c.length === 8 ? `${c.slice(0, 4)} ${c.slice(4)}` : c);
