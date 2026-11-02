// One Team Durable Object per team vault (PROTOCOL.md section 4). Member devices (10 on a team license, more on a
// business license) share a team key that an admin wraps separately for each member; entries and the activity
// log are ciphertext under that key. The relay sees only public keys, roles, wrapped-key blobs and ciphertext.
// Roles: the owner (who made the team and holds the license) is an admin; admins invite, remove and change roles;
// members read and write entries; viewers only read.
import { DurableObject } from 'cloudflare:workers';
import { B64U, Window, b64u, err, json, parseJson, randomId, readBody, sha256, signedParts, verifySigned } from './util.js';
import { TEAM_SEATS, checkTeamLicense } from './license.js';

const MAX_ENTRIES = 2000;
const MAX_CIPHERTEXT = 65_536; // characters of base64url per entry
const MAX_WRAPPED = 1024; // characters of base64url per wrapped team key
const MAX_BATCH = 100;
const INVITE_LIFE = 7 * 86400_000;
const LICENSE_GRACE = 14 * 86400_000; // writes keep working this long after the subscription period ends
const ENTRY_ID = /^[A-Za-z0-9_-]{1,64}$/;
const BOX_KEY = /^[A-Za-z0-9_-]{43}$/; // member's X25519 public key, used by the admin to wrap the team key

const ROLES = ['admin', 'member', 'viewer'];
const MAX_EVENTS = 2000; // activity log entries kept per team
const EVENT_LIFE = 90 * 86400_000; // and for at most this long
const MAX_EVENT_CT = 4096;

const LICENSE_TAKEN = 'this team license is already used by another team; delete that team first, or buy another team subscription';

// One TeamLicense Durable Object per team subscription: the one team it pays for (PROTOCOL.md 4.2).
export class TeamLicense extends DurableObject {
  // True when the license is free or already this team's; binds it to `team`.
  async claim(team) {
    const bound = await this.ctx.storage.get('team');
    if (bound && bound !== team) return false;
    if (!bound) await this.ctx.storage.put('team', team);
    return true;
  }
  async team() { return (await this.ctx.storage.get('team')) ?? null; }
  async release(team) {
    if ((await this.ctx.storage.get('team')) === team) await this.ctx.storage.delete('team');
  }
}

const rowToEntry = (r) => ({ id: r.id, updatedAt: r.updated_at, deleted: !!r.deleted, epoch: r.epoch, ciphertext: r.ct, seq: r.seq });

export class Team extends DurableObject {
  constructor(ctx, env) {
    super(ctx, env);
    this.sql = ctx.storage.sql;
    this.schema();
    this.migrate();
    this.window = new Window(600, 60_000);
  }

  // deleteAll() drops the tables, so every entry point re-runs this.
  schema() {
    this.sql.exec(`
      CREATE TABLE IF NOT EXISTS meta(k TEXT PRIMARY KEY, v TEXT NOT NULL);
      CREATE TABLE IF NOT EXISTS members(key TEXT PRIMARY KEY, role TEXT NOT NULL, box TEXT NOT NULL, added INTEGER NOT NULL);
      CREATE TABLE IF NOT EXISTS wrapped(member TEXT PRIMARY KEY, epoch INTEGER NOT NULL, blob TEXT NOT NULL);
      CREATE TABLE IF NOT EXISTS entries(id TEXT PRIMARY KEY, updated_at INTEGER NOT NULL, deleted INTEGER NOT NULL,
        epoch INTEGER NOT NULL, ct TEXT NOT NULL, seq INTEGER NOT NULL);
      CREATE INDEX IF NOT EXISTS entries_seq ON entries(seq);
      CREATE TABLE IF NOT EXISTS invites(hash TEXT PRIMARY KEY, exp INTEGER NOT NULL, role TEXT NOT NULL DEFAULT 'member');
      CREATE TABLE IF NOT EXISTS activity(seq INTEGER PRIMARY KEY AUTOINCREMENT, at INTEGER NOT NULL, by TEXT NOT NULL,
        epoch INTEGER NOT NULL, ct TEXT NOT NULL);
      CREATE TABLE IF NOT EXISTS nonces(nonce TEXT PRIMARY KEY, exp INTEGER NOT NULL);`);
  }

  // Teams made before roles had invites without a role column.
  migrate() {
    try { this.sql.exec("ALTER TABLE invites ADD COLUMN role TEXT NOT NULL DEFAULT 'member'"); } catch {}
  }

  one(q, ...args) { return this.sql.exec(q, ...args).toArray()[0]; }
  get(k) { return this.one('SELECT v FROM meta WHERE k=?', k)?.v; }
  set(k, v) { this.sql.exec('INSERT OR REPLACE INTO meta VALUES(?, ?)', k, String(v)); }
  epoch() { return Number(this.get('epoch') || 0); }
  cursor() { return Number(this.get('seq') || 0); }
  member(key) { return this.one('SELECT * FROM members WHERE key=?', key); }
  memberCount() { return this.one('SELECT COUNT(*) AS n FROM members').n; }
  licenseFor(subscription) { return this.env.TEAM_LICENSE.get(this.env.TEAM_LICENSE.idFromName(subscription)); }
  licensed() { return Date.now() < Number(this.get('licenseEnd') || 0) + LICENSE_GRACE; }
  seats() { return Number(this.get('seats') || TEAM_SEATS); }

  // Keeps the newest MAX_EVENTS activity entries from the last EVENT_LIFE.
  pruneActivity() {
    this.sql.exec('DELETE FROM activity WHERE at < ?', Date.now() - EVENT_LIFE);
    this.sql.exec('DELETE FROM activity WHERE seq <= (SELECT MAX(seq) FROM activity) - ?', MAX_EVENTS);
  }

  // Removes a member at once and flags the team key for rotation. The owner can't be removed.
  removeMember(target) {
    if (target === this.get('admin')) return err(409, 'the team owner cannot leave or be removed; delete the team instead');
    if (!this.member(target)) return err(404, 'no such member in this team');
    this.sql.exec('DELETE FROM members WHERE key=?', target);
    this.sql.exec('DELETE FROM wrapped WHERE member=?', target);
    this.set('needsRotation', 1);
    return null;
  }

  // Business admin page (relay index.js /v1/business): the caller proved it holds this team's license.
  async businessView(subscription) {
    this.schema();
    if (!this.get('admin') || this.get('subscription') !== subscription) return null;
    const { admin, seats, licenseEnd, members } = this.status();
    return { owner: admin, seats, used: members.length, licenseEnd, members: members.map(({ key, role, added }) => ({ key, role, added })) };
  }
  async businessRemove(subscription, key) {
    this.schema();
    if (!this.get('admin') || this.get('subscription') !== subscription) return { status: 404, error: 'no team uses this license' };
    const refused = this.removeMember(key);
    return refused ? { status: refused.status, error: (await refused.json()).error } : { status: 200, view: await this.businessView(subscription) };
  }

  status() {
    const epoch = this.epoch();
    return {
      admin: this.get('admin'),
      owner: this.get('admin'),
      seats: this.seats(),
      epoch,
      needsRotation: this.get('needsRotation') === '1',
      licenseEnd: Number(this.get('licenseEnd')),
      cursor: this.cursor(),
      members: this.sql.exec('SELECT m.key, m.role, m.box AS boxKey, m.added, w.epoch AS keyEpoch FROM members m LEFT JOIN wrapped w ON w.member = m.key ORDER BY m.added')
        .toArray().map(({ keyEpoch, ...m }) => ({ ...m, hasKey: keyEpoch === epoch })),
    };
  }

  async fetch(req) {
    this.schema();
    const url = new URL(req.url);
    const rest = url.pathname.split('/').slice(4);
    const route = rest.join('/');
    if (!this.window.hit()) return err(429, 'too many requests for this team (600 per minute)');
    const { bytes, error } = await readBody(req);
    if (error) return error;
    const body = parseJson(bytes);
    if (body === null) return err(400, 'body is not a JSON object');
    const dev = await verifySigned(this.sql, signedParts(req, url, bytes));
    if (dev instanceof Response) return dev;
    const exists = !!this.get('admin');
    const teamId = url.pathname.split('/')[3];

    if (req.method === 'POST' && route === 'create') {
      if (exists) return err(409, 'team already exists');
      if (!BOX_KEY.test(body.boxKey || '')) return err(400, 'boxKey must be an X25519 public key (43 base64url characters)');
      const lic = await checkTeamLicense(body.license, this.env.LICENSE_PUBLIC);
      if (lic.error) return err(402, lic.error);
      if (!(await this.licenseFor(lic.subscription).claim(teamId))) return err(409, LICENSE_TAKEN);
      if (this.get('admin')) { // a parallel create finished while we waited for the claim
        if (this.get('subscription') !== lic.subscription) await this.licenseFor(lic.subscription).release(teamId);
        return err(409, 'team already exists');
      }
      const now = Date.now();
      this.set('admin', dev);
      this.set('epoch', 1);
      this.set('needsRotation', 0);
      this.set('licenseEnd', lic.periodEnd);
      this.set('subscription', lic.subscription);
      this.set('seats', lic.seats);
      this.sql.exec("INSERT INTO members VALUES(?, 'admin', ?, ?)", dev, body.boxKey, now);
      return json(this.status(), 201);
    }
    if (!exists) return err(404, 'team not found');

    if (req.method === 'POST' && route === 'join') {
      if (this.member(dev)) return err(409, 'device is already in this team');
      if (typeof body.invite !== 'string' || !body.invite) return err(400, 'invite is missing');
      if (!BOX_KEY.test(body.boxKey || '')) return err(400, 'boxKey must be an X25519 public key (43 base64url characters)');
      if (!this.licensed()) return err(402, 'the team subscription has lapsed; ask the admin to renew it');
      const hash = b64u(await sha256(body.invite));
      this.sql.exec('DELETE FROM invites WHERE exp < ?', Date.now());
      const inv = this.one('SELECT role FROM invites WHERE hash=?', hash);
      if (!inv) return err(403, 'invite is not valid, expired, or already used');
      if (this.memberCount() >= this.seats()) return err(507, `team is full (${this.seats()} members)`);
      this.sql.exec('DELETE FROM invites WHERE hash=?', hash);
      this.sql.exec('INSERT INTO members VALUES(?, ?, ?, ?)', dev, ROLES.includes(inv.role) ? inv.role : 'member', body.boxKey, Date.now());
      return json(this.status(), 201);
    }

    const me = this.member(dev);
    if (!me) return err(403, 'device is not in this team');
    const admin = me.role === 'admin';
    const owner = dev === this.get('admin');
    const adminOnly = () => err(403, 'only a team admin can do this');
    const ownerOnly = () => err(403, 'only the team owner (who made the team) can do this');

    if (req.method === 'GET' && route === '') return json(this.status());

    if (req.method === 'DELETE' && route === '') {
      if (!owner) return ownerOnly();
      await this.licenseFor(this.get('subscription')).release(teamId); // the license can now make a new team
      await this.ctx.storage.deleteAll();
      return json({ ok: true });
    }

    if (req.method === 'POST' && route === 'license') {
      if (!owner) return ownerOnly();
      const lic = await checkTeamLicense(body.license, this.env.LICENSE_PUBLIC);
      if (lic.error) return err(402, lic.error);
      // Claimed every time, so teams made before licenses were bound get bound on their next refresh.
      if (!(await this.licenseFor(lic.subscription).claim(teamId))) return err(409, LICENSE_TAKEN);
      const old = this.get('subscription');
      if (old !== lic.subscription) await this.licenseFor(old).release(teamId);
      if (lic.periodEnd > Number(this.get('licenseEnd'))) this.set('licenseEnd', lic.periodEnd);
      this.set('subscription', lic.subscription);
      this.set('seats', lic.seats); // members past the seat count stay; nobody new can join until there's room
      return json(this.status());
    }

    if (req.method === 'POST' && route === 'invites') {
      if (!admin) return adminOnly();
      if (!this.licensed()) return err(402, 'the team subscription has lapsed; renew it to invite people');
      const now = Date.now();
      this.sql.exec('DELETE FROM invites WHERE exp < ?', now);
      if (this.one('SELECT COUNT(*) AS n FROM invites').n >= 20) return err(429, 'too many unused invites; wait for some to expire');
      const role = body.role ?? 'member';
      if (!ROLES.includes(role)) return err(400, 'role must be admin, member or viewer');
      const invite = randomId();
      this.sql.exec('INSERT INTO invites VALUES(?, ?, ?)', b64u(await sha256(invite)), now + INVITE_LIFE, role);
      return json({ invite, expiresAt: now + INVITE_LIFE, role }, 201);
    }

    // Removing someone (or leaving) drops their access now and flags the team key for rotation.
    if (req.method === 'DELETE' && rest[0] === 'members' && rest.length === 2) {
      const target = rest[1];
      if (target !== dev && !admin) return adminOnly();
      return this.removeMember(target) || json(this.status());
    }

    if (req.method === 'POST' && rest[0] === 'members' && rest[2] === 'role' && rest.length === 3) {
      if (!admin) return adminOnly();
      if (!ROLES.includes(body.role)) return err(400, 'role must be admin, member or viewer');
      if (rest[1] === this.get('admin')) return err(409, 'the team owner is always an admin');
      if (!this.member(rest[1])) return err(404, 'no such member in this team');
      this.sql.exec('UPDATE members SET role=? WHERE key=?', body.role, rest[1]);
      return json(this.status());
    }

    // Activity log: any member appends (ciphertext under the team key); admins read it. The relay adds who
    // (the signing device) and when (its own clock), so neither can be faked by the writer.
    if (req.method === 'POST' && route === 'activity') {
      const list = body.events;
      if (!Array.isArray(list) || list.length < 1 || list.length > MAX_BATCH) return err(400, `events must be an array of 1 to ${MAX_BATCH}`);
      const cur = this.epoch();
      for (const e of list) {
        if (!e || typeof e.ciphertext !== 'string' || !e.ciphertext || !B64U.test(e.ciphertext)) return err(400, 'event ciphertext must be a base64url string');
        if (e.ciphertext.length > MAX_EVENT_CT) return err(413, `event ciphertext too large (max ${MAX_EVENT_CT} characters)`);
        if (e.epoch !== cur) return err(409, 'the team key has changed; fetch the new key and encrypt with it', { epoch: cur });
      }
      const now = Date.now();
      for (const e of list) this.sql.exec('INSERT INTO activity(at, by, epoch, ct) VALUES(?, ?, ?, ?)', now, dev, cur, e.ciphertext);
      this.pruneActivity();
      return json({ ok: true, count: list.length }, 201);
    }
    if (req.method === 'GET' && route === 'activity') {
      if (!admin) return adminOnly();
      const since = Number(url.searchParams.get('since') ?? 0);
      if (!Number.isInteger(since) || since < 0) return err(400, 'since must be an integer >= 0');
      this.pruneActivity();
      const rows = this.sql.exec('SELECT * FROM activity WHERE seq > ? ORDER BY seq LIMIT 501', since).toArray();
      const page = rows.slice(0, 500).map((r) => ({ seq: r.seq, at: r.at, by: r.by, epoch: r.epoch, ciphertext: r.ct }));
      return json({ events: page, cursor: page.length ? page[page.length - 1].seq : since, more: rows.length > 500 });
    }

    // Wrapped team keys. Same epoch: add or replace keys for listed members. Next epoch: a rotation, which must
    // cover every member and replaces all wrapped keys at once.
    if (req.method === 'POST' && route === 'keys') {
      if (!admin) return adminOnly();
      const cur = this.epoch();
      const keys = body.keys;
      if (!keys || typeof keys !== 'object' || Array.isArray(keys) || !Object.keys(keys).length) return err(400, 'keys must be an object of member key -> wrapped team key');
      for (const [k, v] of Object.entries(keys)) {
        if (!this.member(k)) return err(400, `${k} is not a member of this team`);
        if (typeof v !== 'string' || !v || !B64U.test(v) || v.length > MAX_WRAPPED) return err(400, `wrapped key for ${k} must be base64url, at most ${MAX_WRAPPED} characters`);
      }
      if (body.epoch === cur + 1) {
        const missing = this.sql.exec('SELECT key FROM members').toArray().map((m) => m.key).filter((k) => !(k in keys));
        if (missing.length) return err(400, 'a key rotation must include a wrapped key for every member', { missing });
        this.sql.exec('DELETE FROM wrapped');
        this.set('epoch', cur + 1);
        this.set('needsRotation', 0);
      } else if (body.epoch !== cur) return err(409, `epoch must be ${cur} (add keys) or ${cur + 1} (rotate)`, { epoch: cur });
      for (const [k, v] of Object.entries(keys)) this.sql.exec('INSERT OR REPLACE INTO wrapped VALUES(?, ?, ?)', k, body.epoch, v);
      return json(this.status());
    }

    if (req.method === 'GET' && route === 'key') {
      const w = this.one('SELECT * FROM wrapped WHERE member=? AND epoch=?', dev, this.epoch());
      return w ? json({ epoch: w.epoch, wrapped: w.blob }) : err(404, 'the admin has not shared the team key with this device yet');
    }

    // Entries: last writer wins by updatedAt, like sync. Writes must use the current key epoch.
    if (req.method === 'POST' && route === 'entries') {
      if (me.role === 'viewer') return err(403, 'view-only members cannot change team accounts');
      if (!this.licensed()) return err(402, 'the team subscription has lapsed; entries are read-only until it is renewed');
      const list = body.entries;
      if (!Array.isArray(list) || list.length < 1 || list.length > MAX_BATCH) return err(400, `entries must be an array of 1 to ${MAX_BATCH}`);
      const cur = this.epoch();
      for (const e of list) {
        if (!e || !ENTRY_ID.test(e.id || '')) return err(400, 'entry id must be 1-64 base64url characters');
        if (!Number.isInteger(e.updatedAt) || e.updatedAt < 0) return err(400, `entry ${e.id}: updatedAt must be an integer (ms)`);
        if (typeof e.ciphertext !== 'string' || !B64U.test(e.ciphertext) || (!e.deleted && !e.ciphertext)) return err(400, `entry ${e.id}: ciphertext must be a base64url string`);
        if (e.ciphertext.length > MAX_CIPHERTEXT) return err(413, `entry ${e.id}: ciphertext too large (max ${MAX_CIPHERTEXT} characters)`);
        if (e.epoch !== cur) return err(409, 'the team key has changed; fetch the new key and encrypt with it', { epoch: cur });
      }
      if (new Set(list.map((e) => e.id)).size !== list.length) return err(400, 'the same entry id appears twice in one push');
      const fresh = list.filter((e) => !this.one('SELECT 1 AS x FROM entries WHERE id=?', e.id)).length;
      if (this.one('SELECT COUNT(*) AS n FROM entries').n + fresh > MAX_ENTRIES) return err(507, `entry limit reached (${MAX_ENTRIES} per team, deleted ones included)`);
      let seq = this.cursor();
      const results = list.map((e) => {
        const old = this.one('SELECT * FROM entries WHERE id=?', e.id);
        // A same-time rewrite is accepted only when it moves an old-epoch entry onto the current key.
        if (old && (old.updated_at > e.updatedAt || (old.updated_at === e.updatedAt && old.epoch >= cur))) return { id: e.id, status: 'stale', current: rowToEntry(old) };
        seq += 1;
        this.sql.exec('INSERT OR REPLACE INTO entries VALUES(?, ?, ?, ?, ?, ?)', e.id, e.updatedAt, e.deleted ? 1 : 0, cur, e.ciphertext, seq);
        return { id: e.id, status: 'ok', seq };
      });
      this.set('seq', seq);
      return json({ results, cursor: seq });
    }

    if (req.method === 'GET' && route === 'entries') {
      const since = Number(url.searchParams.get('since') ?? 0);
      if (!Number.isInteger(since) || since < 0) return err(400, 'since must be an integer >= 0');
      const rows = this.sql.exec('SELECT * FROM entries WHERE seq > ? ORDER BY seq LIMIT 501', since).toArray();
      const page = rows.slice(0, 500).map(rowToEntry);
      return json({ entries: page, cursor: page.length ? page[page.length - 1].seq : since, more: rows.length > 500 });
    }

    return err(404, 'not found');
  }
}
