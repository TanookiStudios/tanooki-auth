// One EmergencyGrant Durable Object per emergency-access grant (PROTOCOL.md section 3). The owner leaves a blob
// sealed to a trusted contact; the contact can ask for it, and gets it only after a waiting period the owner
// did not cancel. The relay never sees inside the blob: it only enforces the delay.
import { DurableObject } from 'cloudflare:workers';
import { B64U, ID, Window, err, json, parseJson, readBody, signedParts, verifySigned } from './util.js';
import { EMERGENCY_REQUEST, pushConfigured, pushTokenError, sendPush } from './push.js';

const DELAY = 7 * 86400_000; // contact waits 7 days after asking
const MAX_BLOB = 786_432; // characters of base64url (about 576 KiB of ciphertext)
const MAX_PUSH_TOKENS = 10; // owner devices that get the "someone asked" notification

export class EmergencyGrant extends DurableObject {
  constructor(ctx, env) {
    super(ctx, env);
    this.sql = ctx.storage.sql;
    this.schema();
    this.window = new Window(120, 60_000);
  }

  // deleteAll() drops the tables, so every entry point re-runs this.
  schema() {
    this.sql.exec(`
      CREATE TABLE IF NOT EXISTS meta(k TEXT PRIMARY KEY, v TEXT NOT NULL);
      CREATE TABLE IF NOT EXISTS push(token TEXT PRIMARY KEY, platform TEXT NOT NULL, env TEXT NOT NULL, added INTEGER NOT NULL);
      CREATE TABLE IF NOT EXISTS nonces(nonce TEXT PRIMARY KEY, exp INTEGER NOT NULL);`);
  }

  get(k) { return this.sql.exec('SELECT v FROM meta WHERE k=?', k).toArray()[0]?.v; }
  set(k, v) { this.sql.exec('INSERT OR REPLACE INTO meta VALUES(?, ?)', k, String(v)); }
  clearRequest() { this.sql.exec("DELETE FROM meta WHERE k IN ('requestedAt','releaseAt')"); }

  status() {
    const releaseAt = Number(this.get('releaseAt') || 0);
    return {
      owner: this.get('owner'),
      contactKey: this.get('contactKey'),
      state: !releaseAt ? 'idle' : Date.now() >= releaseAt ? 'released' : 'waiting',
      requestedAt: Number(this.get('requestedAt') || 0) || null,
      releaseAt: releaseAt || null,
      updatedAt: Number(this.get('updatedAt')),
      blobLength: this.get('blob').length,
    };
  }

  async fetch(req) {
    this.schema();
    const url = new URL(req.url);
    const route = url.pathname.split('/').slice(4).join('/');
    if (!this.window.hit()) return err(429, 'too many requests for this grant (120 per minute)');
    const { bytes, error } = await readBody(req);
    if (error) return error;
    const body = parseJson(bytes);
    if (body === null) return err(400, 'body is not a JSON object');
    const dev = await verifySigned(this.sql, signedParts(req, url, bytes));
    if (dev instanceof Response) return dev;
    const owner = this.get('owner');
    const role = !owner ? null : dev === owner ? 'owner' : dev === this.get('contactKey') ? 'contact' : null;

    // Upload or replace the sealed blob. The first upload makes the signer the owner.
    if (req.method === 'POST' && route === '') {
      if (owner && role !== 'owner') return err(403, 'only the owner can change this grant');
      if (!ID.test(body.contactKey || '')) return err(400, 'contactKey must be the contact\'s Ed25519 public key (43 base64url characters)');
      if (body.contactKey === dev) return err(400, 'the contact must be a different device from the owner');
      if (typeof body.blob !== 'string' || !body.blob || !B64U.test(body.blob)) return err(400, 'blob must be a base64url string');
      if (body.blob.length > MAX_BLOB) return err(413, `blob too large (max ${MAX_BLOB} characters)`);
      if (owner && body.contactKey !== this.get('contactKey')) this.clearRequest(); // a new contact starts from scratch
      this.set('owner', dev);
      this.set('contactKey', body.contactKey);
      this.set('blob', body.blob);
      this.set('updatedAt', Date.now());
      return json(this.status(), owner ? 200 : 201);
    }
    if (!owner) return err(404, 'grant not found');
    if (!role) return err(403, 'device is neither the owner nor the contact of this grant');

    if (req.method === 'GET' && route === '') return json(this.status());

    if (role === 'owner') {
      if (req.method === 'DELETE' && route === '') {
        await this.ctx.storage.deleteAll();
        return json({ ok: true });
      }
      if (req.method === 'POST' && route === 'deny') {
        if (!this.get('releaseAt')) return err(409, 'there is no request to deny');
        this.clearRequest();
        return json(this.status());
      }
      if (req.method === 'POST' && route === 'push') {
        const bad = pushTokenError(this.env, body);
        if (bad) return bad;
        this.sql.exec('INSERT OR REPLACE INTO push VALUES(?, ?, ?, ?)', body.token, body.platform, body.environment || 'production', Date.now());
        this.sql.exec('DELETE FROM push WHERE token NOT IN (SELECT token FROM push ORDER BY added DESC LIMIT ?)', MAX_PUSH_TOKENS);
        return json({ ok: true });
      }
      return err(404, 'not found');
    }

    // role === 'contact'
    if (req.method === 'POST' && route === 'request') {
      if (this.get('releaseAt')) return json(this.status()); // already asked: no second push
      // Tests on a local relay (TEST_MODE set) may shorten the wait; the deployed relay ignores delaySeconds.
      const delay = this.env.TEST_MODE && Number.isInteger(body.delaySeconds) && body.delaySeconds >= 0 ? body.delaySeconds * 1000 : DELAY;
      const now = Date.now();
      this.set('requestedAt', now);
      this.set('releaseAt', now + delay);
      return json({ ...this.status(), push: await this.notifyOwner() }, 201);
    }
    if (req.method === 'GET' && route === 'blob') {
      const s = this.status();
      if (s.state === 'idle') return err(409, 'ask for access first (POST request)');
      if (s.state === 'waiting') return err(403, 'the waiting period has not ended', { releaseAt: s.releaseAt });
      return json({ blob: this.get('blob'), updatedAt: s.updatedAt });
    }
    return err(404, 'not found');
  }

  // Tells every registered owner device. Returns { sent, tokens } and forgets tokens the push service calls dead.
  async notifyOwner() {
    const rows = this.sql.exec('SELECT * FROM push').toArray().filter((r) => pushConfigured(this.env, r.platform));
    let sent = 0;
    for (const r of rows) {
      const result = await sendPush(this.env, r.platform, r.token, r.env, EMERGENCY_REQUEST);
      if (result === 'sent') sent++;
      if (result === 'token-dead') this.sql.exec('DELETE FROM push WHERE token=?', r.token);
    }
    return { sent, tokens: rows.length };
  }
}
