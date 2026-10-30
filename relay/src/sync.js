// One SyncGroup Durable Object per sync group. Stores opaque ciphertext records; devices sign every request.
import { DurableObject } from 'cloudflare:workers';
import { B64U, ID, SKEW, Window, err, json, parseJson, readBody, signedParts, verifyEd25519, verifySigned } from './util.js';

const MAX_RECORDS = 2000; // per group, tombstones included
const MAX_DEVICES = 20;
const MAX_CIPHERTEXT = 65_536; // characters of base64url per record
const MAX_BATCH = 100;
const MAX_INVITE_LIFE = 24 * 3600_000;
const REC_ID = /^[A-Za-z0-9_-]{1,64}$/;
const NONCE = /^[A-Za-z0-9_-]{16,64}$/;

const rowToRecord = (r) => ({ id: r.id, version: r.version, deleted: !!r.deleted, updatedAt: r.updated_at, ciphertext: r.ct, seq: r.seq });

export class SyncGroup extends DurableObject {
  constructor(ctx, env) {
    super(ctx, env);
    this.sql = ctx.storage.sql;
    this.schema();
    this.window = new Window(600, 60_000);
  }

  // deleteAll() drops the tables, so every entry point re-runs this.
  schema() {
    this.sql.exec(`
      CREATE TABLE IF NOT EXISTS devices(key TEXT PRIMARY KEY, added INTEGER NOT NULL);
      CREATE TABLE IF NOT EXISTS records(id TEXT PRIMARY KEY, version INTEGER NOT NULL, deleted INTEGER NOT NULL,
        updated_at INTEGER NOT NULL, ct TEXT NOT NULL, seq INTEGER NOT NULL);
      CREATE INDEX IF NOT EXISTS records_seq ON records(seq);
      CREATE TABLE IF NOT EXISTS nonces(nonce TEXT PRIMARY KEY, exp INTEGER NOT NULL);
      CREATE TABLE IF NOT EXISTS invites(nonce TEXT PRIMARY KEY, exp INTEGER NOT NULL);
      CREATE TABLE IF NOT EXISTS meta(k TEXT PRIMARY KEY, v INTEGER NOT NULL);`);
  }

  one(q, ...args) { return this.sql.exec(q, ...args).toArray()[0]; }
  cursor() { return this.one("SELECT v FROM meta WHERE k='seq'")?.v ?? 0; }
  exists() { return !!this.one('SELECT 1 AS x FROM devices LIMIT 1'); }
  isDevice(key) { return !!this.one('SELECT 1 AS x FROM devices WHERE key=?', key); }

  // Verifies the Ed25519 request signature and burns the nonce. Returns the device key, or a Response on failure.
  authenticate({ registered = true, ...parts }) {
    return verifySigned(this.sql, parts, (device) =>
      registered && !this.isDevice(device) ? err(this.exists() ? 403 : 404, this.exists() ? 'device is not in this sync group' : 'sync group not found') : null);
  }

  async fetch(req) {
    this.schema();
    const url = new URL(req.url);
    const [, , , gid, ...rest] = url.pathname.split('/');
    const route = rest.join('/');
    if (!this.window.hit()) return err(429, 'too many requests for this sync group (600 per minute)');

    if (route === 'ws') {
      if (req.headers.get('upgrade') !== 'websocket') return err(426, 'expected a WebSocket upgrade');
      const q = url.searchParams;
      const dev = await this.authenticate({ method: 'GET', path: url.pathname, device: q.get('device'), ts: q.get('ts'), nonce: q.get('nonce'), sig: q.get('sig'), body: new Uint8Array() });
      if (dev instanceof Response) return dev;
      if (this.ctx.getWebSockets().length >= 50) return err(429, 'too many live connections for this sync group');
      const [client, server] = Object.values(new WebSocketPair());
      this.ctx.acceptWebSocket(server, [dev]);
      server.send(JSON.stringify({ type: 'hello', cursor: this.cursor() }));
      return new Response(null, { status: 101, webSocket: client });
    }

    const { bytes, error } = await readBody(req);
    if (error) return error;
    const auth = (registered = true) => this.authenticate({ ...signedParts(req, url, bytes), registered });
    const body = parseJson(bytes);
    if (body === null) return err(400, 'body is not a JSON object');

    if (req.method === 'POST' && route === 'create') {
      const dev = await auth(false);
      if (dev instanceof Response) return dev;
      if (this.exists()) return err(409, 'sync group already exists');
      this.sql.exec('INSERT INTO devices VALUES(?, ?)', dev, Date.now());
      return json({ ok: true, cursor: 0 }, 201);
    }

    if (req.method === 'POST' && route === 'join') {
      const dev = await auth(false);
      if (dev instanceof Response) return dev;
      if (!this.exists()) return err(404, 'sync group not found');
      const inv = body.invite || {};
      const exp = Number(inv.expiresAt);
      if (!ID.test(inv.inviter || '') || !NONCE.test(inv.nonce || '') || !Number.isInteger(exp) || typeof inv.sig !== 'string') return err(400, 'invite is malformed');
      if (!this.isDevice(inv.inviter)) return err(403, 'invite was signed by a device that is not in this group');
      if (!(await verifyEd25519(inv.inviter, inv.sig, `TA-INVITE-1\n${gid}\n${inv.nonce}\n${exp}`))) return err(403, 'invite signature is not valid');
      const now = Date.now();
      if (exp <= now) return err(403, 'invite has expired');
      if (exp > now + MAX_INVITE_LIFE + SKEW) return err(403, 'invite lifetime is longer than 24 hours');
      this.sql.exec('DELETE FROM invites WHERE exp < ?', now);
      if (this.one('SELECT 1 AS x FROM invites WHERE nonce=?', inv.nonce)) return err(403, 'invite was already used');
      if (this.isDevice(dev)) return err(409, 'device is already in this group');
      if (this.one('SELECT COUNT(*) AS n FROM devices').n >= MAX_DEVICES) return err(507, `device limit reached (${MAX_DEVICES} per group)`);
      this.sql.exec('INSERT INTO invites VALUES(?, ?)', inv.nonce, exp);
      this.sql.exec('INSERT INTO devices VALUES(?, ?)', dev, now);
      return json({ ok: true, cursor: this.cursor() }, 201);
    }

    const dev = await auth();
    if (dev instanceof Response) return dev;

    if (req.method === 'GET' && route === 'devices') {
      return json({ devices: this.sql.exec('SELECT key, added FROM devices ORDER BY added').toArray() });
    }
    if (req.method === 'DELETE' && rest[0] === 'devices' && rest.length === 2) {
      if (!this.isDevice(rest[1])) return err(404, 'no such device in this group');
      this.sql.exec('DELETE FROM devices WHERE key=?', rest[1]);
      for (const ws of this.ctx.getWebSockets(rest[1])) ws.close(4001, 'device removed');
      if (!this.exists()) await this.ctx.storage.deleteAll(); // last device gone: the group is gone
      return json({ ok: true });
    }
    if (req.method === 'DELETE' && route === '') {
      for (const ws of this.ctx.getWebSockets()) ws.close(4002, 'sync group deleted');
      await this.ctx.storage.deleteAll();
      return json({ ok: true });
    }

    if (req.method === 'POST' && route === 'push') {
      const recs = body.records;
      if (!Array.isArray(recs) || recs.length < 1 || recs.length > MAX_BATCH) return err(400, `records must be an array of 1 to ${MAX_BATCH}`);
      for (const r of recs) {
        if (!r || !REC_ID.test(r.id || '')) return err(400, 'record id must be 1-64 base64url characters');
        if (!Number.isInteger(r.baseVersion) || r.baseVersion < 0) return err(400, `record ${r.id}: baseVersion must be an integer >= 0`);
        if (typeof r.ciphertext !== 'string' || !B64U.test(r.ciphertext)) return err(400, `record ${r.id}: ciphertext must be a base64url string`);
        if (r.ciphertext.length > MAX_CIPHERTEXT) return err(413, `record ${r.id}: ciphertext too large (max ${MAX_CIPHERTEXT} characters)`);
        if (!r.deleted && !r.ciphertext) return err(400, `record ${r.id}: ciphertext is required unless deleted`);
      }
      if (new Set(recs.map((r) => r.id)).size !== recs.length) return err(400, 'the same record id appears twice in one push');
      const newIds = recs.filter((r) => !this.one('SELECT 1 AS x FROM records WHERE id=?', r.id)).length;
      const count = this.one('SELECT COUNT(*) AS n FROM records').n;
      if (count + newIds > MAX_RECORDS) return err(507, `record limit reached (${MAX_RECORDS} per group, tombstones included)`, { count });

      let seq = this.cursor();
      const now = Date.now();
      const results = recs.map((r) => {
        const cur = this.one('SELECT * FROM records WHERE id=?', r.id);
        if ((cur?.version ?? 0) !== r.baseVersion) return { id: r.id, status: 'conflict', current: cur ? rowToRecord(cur) : null };
        seq += 1;
        const version = r.baseVersion + 1;
        this.sql.exec('INSERT OR REPLACE INTO records VALUES(?, ?, ?, ?, ?, ?)', r.id, version, r.deleted ? 1 : 0, now, r.ciphertext, seq);
        return { id: r.id, status: 'ok', version, seq };
      });
      this.sql.exec("INSERT OR REPLACE INTO meta VALUES('seq', ?)", seq);
      const msg = JSON.stringify({ type: 'changed', cursor: seq });
      if (results.some((r) => r.status === 'ok')) for (const ws of this.ctx.getWebSockets()) try { ws.send(msg); } catch {}
      return json({ results, cursor: seq });
    }

    if (req.method === 'GET' && rest[0] === 'records' && rest.length === 2) {
      const r = this.one('SELECT * FROM records WHERE id=?', rest[1]);
      return r ? json(rowToRecord(r)) : err(404, 'no such record');
    }

    if (req.method === 'GET' && route === 'changes') {
      const since = Number(url.searchParams.get('since') ?? 0);
      const limit = Math.min(Math.max(Number(url.searchParams.get('limit') ?? 500) || 500, 1), 500);
      if (!Number.isInteger(since) || since < 0) return err(400, 'since must be an integer >= 0');
      const rows = this.sql.exec('SELECT * FROM records WHERE seq > ? ORDER BY seq LIMIT ?', since, limit + 1).toArray();
      const page = rows.slice(0, limit).map(rowToRecord);
      return json({ records: page, cursor: page.length ? page[page.length - 1].seq : Math.max(since, 0), more: rows.length > limit });
    }

    return err(404, 'not found');
  }

  webSocketMessage(ws, msg) {
    if (msg === 'ping') ws.send('pong'); // keep-alive; nothing else is accepted from clients
  }
  webSocketClose(ws, code) { try { ws.close(code, 'closing'); } catch {} }
}
