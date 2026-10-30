// One LinkRoom Durable Object per extension<->phone pairing. A mailbox of end-to-end encrypted messages.
import { DurableObject } from 'cloudflare:workers';
import { Window, b64u, err, json, parseJson, randomId, readBody, secretEquals, sha256, unb64u } from './util.js';
import { pushConfigured, sendPush } from './push.js';

const PAIR_WINDOW = 10 * 60_000; // phone must join within 10 minutes of creation
const MAX_TTL = 120; // seconds a message lives
const MAX_MESSAGE = 16_384; // characters of base64url ciphertext
const MAX_PENDING = 50; // unexpired messages per sender
const B64U = /^[A-Za-z0-9_-]+$/;
const OTHER = { ext: 'phone', phone: 'ext' };

export class LinkRoom extends DurableObject {
  constructor(ctx, env) {
    super(ctx, env);
    this.sql = ctx.storage.sql;
    this.schema();
    this.window = new Window(120, 60_000);
  }

  // deleteAll() drops the tables, so every entry point re-runs this.
  schema() {
    this.sql.exec(`
      CREATE TABLE IF NOT EXISTS room(k TEXT PRIMARY KEY, v TEXT NOT NULL);
      CREATE TABLE IF NOT EXISTS messages(id INTEGER PRIMARY KEY AUTOINCREMENT, sender TEXT NOT NULL, ct TEXT NOT NULL, exp INTEGER NOT NULL);`);
  }

  get(k) { return this.sql.exec('SELECT v FROM room WHERE k=?', k).toArray()[0]?.v; }
  set(k, v) { this.sql.exec('INSERT OR REPLACE INTO room VALUES(?, ?)', k, String(v)); }
  sockets(role) { return this.ctx.getWebSockets().filter((ws) => ws.deserializeAttachment()?.role === role); }
  broadcast(role, obj) { const m = JSON.stringify(obj); for (const ws of this.sockets(role)) try { ws.send(m); } catch {} }

  // Which side owns this bearer token: 'ext', 'phone', or null. Compares SHA-256 hashes in constant time.
  async roleFor(token) {
    if (!token) return null;
    for (const role of ['ext', 'phone']) {
      const stored = this.get(`${role}Hash`);
      if (stored && (await secretEquals(token, unb64u(stored)))) return role;
    }
    return null;
  }

  async fetch(req) {
    this.schema();
    const url = new URL(req.url);
    const [, , , , roomId, ...rest] = url.pathname.split('/');
    const route = rest.join('/');
    if (!this.window.hit()) return err(429, 'too many requests for this room (120 per minute)');
    const created = Number(this.get('created') || 0);

    if (route === 'ws') {
      if (req.headers.get('upgrade') !== 'websocket') return err(426, 'expected a WebSocket upgrade');
      if (!created) return err(404, 'room not found');
      if (this.ctx.getWebSockets().length >= 10) return err(429, 'too many live connections for this room');
      const [client, server] = Object.values(new WebSocketPair());
      this.ctx.acceptWebSocket(server);
      server.serializeAttachment({ role: null });
      return new Response(null, { status: 101, webSocket: client });
    }

    const { bytes, error } = await readBody(req);
    if (error) return error;
    const body = parseJson(bytes);
    if (body === null) return err(400, 'body is not a JSON object');

    if (req.method === 'POST' && route === 'create') {
      if (created) return err(409, 'room already exists');
      const now = Date.now();
      const extToken = randomId();
      this.set('created', now);
      this.set('extHash', b64u(await sha256(extToken)));
      await this.ctx.storage.setAlarm(now + PAIR_WINDOW);
      return json({ roomId, extToken, pairBy: now + PAIR_WINDOW }, 201);
    }
    if (!created) return err(404, 'room not found');

    if (req.method === 'POST' && route === 'join') {
      if (this.get('phoneHash')) return err(409, 'room is already paired');
      if (Date.now() > created + PAIR_WINDOW) return err(410, 'pairing window has closed; make a new QR code');
      if (typeof body.phoneKey !== 'string' || !B64U.test(body.phoneKey) || body.phoneKey.length > 128) return err(400, 'phoneKey must be a base64url string');
      const phoneToken = randomId();
      this.set('phoneHash', b64u(await sha256(phoneToken)));
      this.set('phoneKey', body.phoneKey);
      this.broadcast('ext', { type: 'joined', phoneKey: body.phoneKey });
      return json({ roomId, phoneToken }, 201);
    }

    const role = await this.roleFor((req.headers.get('authorization') || '').replace(/^Bearer /, ''));
    if (!role) return err(401, 'missing or wrong room token');
    const paired = !!this.get('phoneHash');

    if (req.method === 'GET' && route === '') {
      return json({ paired, phoneKey: this.get('phoneKey') ?? null, created, push: this.get('pushPlatform') ?? null });
    }

    if (req.method === 'DELETE' && route === '') {
      this.broadcast(OTHER[role], { type: 'unpaired' });
      for (const ws of this.ctx.getWebSockets()) ws.close(4002, 'room deleted');
      await this.ctx.storage.deleteAll();
      return json({ ok: true });
    }

    if (req.method === 'POST' && route === 'push') {
      if (role !== 'phone') return err(403, 'only the phone registers a push token');
      const { platform, token, environment = 'production' } = body;
      if (platform !== 'apns' && platform !== 'fcm') return err(400, 'platform must be "apns" or "fcm"');
      if (typeof token !== 'string' || !/^[A-Za-z0-9_:.-]{8,4096}$/.test(token)) return err(400, 'token is malformed');
      if (environment !== 'production' && environment !== 'sandbox') return err(400, 'environment must be "production" or "sandbox"');
      if (!pushConfigured(this.env, platform)) return err(503, 'push not configured', { platform });
      this.set('pushPlatform', platform);
      this.set('pushToken', token);
      this.set('pushEnv', environment);
      return json({ ok: true });
    }

    if (req.method === 'POST' && route === 'messages') {
      if (!paired) return err(409, 'phone has not joined this room yet');
      const ttl = body.ttl ?? MAX_TTL;
      if (!Number.isInteger(ttl) || ttl < 1 || ttl > MAX_TTL) return err(400, `ttl must be 1 to ${MAX_TTL} seconds`);
      if (typeof body.ciphertext !== 'string' || !B64U.test(body.ciphertext)) return err(400, 'ciphertext must be a base64url string');
      if (body.ciphertext.length > MAX_MESSAGE) return err(413, `ciphertext too large (max ${MAX_MESSAGE} characters)`);
      const now = Date.now();
      this.sql.exec('DELETE FROM messages WHERE exp <= ?', now);
      if (this.sql.exec('SELECT COUNT(*) AS n FROM messages WHERE sender=?', role).one().n >= MAX_PENDING) return err(429, 'too many undelivered messages; wait for them to expire');
      const exp = now + ttl * 1000;
      const id = this.sql.exec('INSERT INTO messages(sender, ct, exp) VALUES(?, ?, ?) RETURNING id', role, body.ciphertext, exp).one().id;
      const alarm = await this.ctx.storage.getAlarm();
      if (!alarm || alarm > exp) await this.ctx.storage.setAlarm(exp);
      this.broadcast(OTHER[role], { type: 'message', message: { id, from: role, ciphertext: body.ciphertext, expiresAt: exp } });

      let push = 'not-requested';
      if (body.notify === true && role === 'ext') {
        const platform = this.get('pushPlatform');
        if (!platform) push = 'no-token';
        else if (!pushConfigured(this.env, platform)) push = 'not-configured';
        else {
          push = await sendPush(this.env, platform, this.get('pushToken'), this.get('pushEnv'));
          if (push === 'token-dead') this.sql.exec("DELETE FROM room WHERE k IN ('pushPlatform','pushToken','pushEnv')");
        }
      }
      return json({ id, expiresAt: exp, push }, 201);
    }

    if (req.method === 'GET' && route === 'messages') {
      const after = Number(url.searchParams.get('after') ?? 0);
      if (!Number.isInteger(after) || after < 0) return err(400, 'after must be an integer >= 0');
      const rows = this.sql.exec('SELECT id, sender, ct, exp FROM messages WHERE sender=? AND id > ? AND exp > ? ORDER BY id LIMIT 100', OTHER[role], after, Date.now()).toArray();
      const messages = rows.map((r) => ({ id: r.id, from: r.sender, ciphertext: r.ct, expiresAt: r.exp }));
      return json({ messages, cursor: messages.length ? messages[messages.length - 1].id : after });
    }

    if (req.method === 'DELETE' && rest[0] === 'messages' && rest.length === 2) {
      // The recipient acknowledges a message so it does not sit on the server for the full ttl.
      this.sql.exec('DELETE FROM messages WHERE id=? AND sender=?', Number(rest[1]), OTHER[role]);
      return json({ ok: true });
    }

    return err(404, 'not found');
  }

  // WebSocket clients authenticate with their first message: {"type":"auth","token":"..."}.
  async webSocketMessage(ws, msg) {
    if (msg === 'ping') return ws.send('pong');
    this.schema();
    if (ws.deserializeAttachment()?.role) return; // nothing else is accepted from clients
    let token;
    try { ({ token } = JSON.parse(msg)); } catch {}
    const role = await this.roleFor(token);
    if (!role) return ws.close(4001, 'missing or wrong room token');
    ws.serializeAttachment({ role });
    ws.send(JSON.stringify({ type: 'ready', role, paired: !!this.get('phoneHash') }));
  }
  webSocketClose(ws, code) { try { ws.close(code, 'closing'); } catch {} }

  async alarm() {
    this.schema();
    const created = Number(this.get('created') || 0);
    if (created && !this.get('phoneHash')) {
      for (const ws of this.ctx.getWebSockets()) ws.close(4003, 'pairing window closed');
      return this.ctx.storage.deleteAll(); // never paired: forget the room
    }
    const now = Date.now();
    this.sql.exec('DELETE FROM messages WHERE exp <= ?', now);
    const next = this.sql.exec('SELECT MIN(exp) AS e FROM messages').one().e;
    if (next) await this.ctx.storage.setAlarm(next);
  }
}
