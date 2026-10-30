// Router: per-IP limit and body cap, then hand the request to the Durable Object that owns the ID.
import { SyncGroup } from './sync.js';
import { LinkRoom } from './link.js';
import { EmergencyGrant } from './emergency.js';
import { Team } from './team.js';
import { CORS, ID, MAX_BODY, err, json } from './util.js';

export { SyncGroup, LinkRoom, EmergencyGrant, Team };

export default {
  async fetch(req, env) {
    if (req.method === 'OPTIONS') return new Response(null, { status: 204, headers: CORS });
    const url = new URL(req.url);
    if (url.pathname === '/health') return json({ ok: true, service: 'tanooki-auth-relay', time: new Date().toISOString() });
    const ip = req.headers.get('cf-connecting-ip') || 'unknown';
    const { success } = await env.IP_LIMIT.limit({ key: ip });
    if (!success) return err(429, 'too many requests from this address (300 per minute)');
    if (Number(req.headers.get('content-length') || 0) > MAX_BODY) return err(413, 'body too large (max 1 MiB)');

    const p = url.pathname.split('/').filter(Boolean);
    if (url.pathname === '/' || url.pathname === '/v1') return json({ service: 'tanooki-auth-relay', protocol: 1 });
    if (p[0] === 'v1' && p[1] === 'sync' && ID.test(p[2] || '')) return env.SYNC.get(env.SYNC.idFromName(p[2])).fetch(req);
    if (p[0] === 'v1' && p[1] === 'link' && p[2] === 'rooms' && ID.test(p[3] || '')) return env.LINK.get(env.LINK.idFromName(p[3])).fetch(req);
    if (p[0] === 'v1' && p[1] === 'emergency' && ID.test(p[2] || '')) return env.EMERGENCY.get(env.EMERGENCY.idFromName(p[2])).fetch(req);
    if (p[0] === 'v1' && p[1] === 'team' && ID.test(p[2] || '')) return env.TEAM.get(env.TEAM.idFromName(p[2])).fetch(req);
    return err(404, 'not found');
  },
};
