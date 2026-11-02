// Business admin page support (PROTOCOL.md 4.5): the holder of a team's license can see its members and seats,
// and remove members, without a device key. Used by the worker's /business page from the browser.
import { ID, err, json } from './util.js';
import { checkTeamLicense } from './license.js';

export async function business(req, env, rest) {
  const token = (req.headers.get('authorization') || '').replace(/^Bearer\s+/i, '').trim();
  const lic = await checkTeamLicense(token, env.LICENSE_PUBLIC);
  if (lic.error) return err(401, lic.error);
  const teamId = await env.TEAM_LICENSE.get(env.TEAM_LICENSE.idFromName(lic.subscription)).team();
  if (!teamId) return err(404, 'no team uses this license yet; create the team in the app first');
  const team = env.TEAM.get(env.TEAM.idFromName(teamId));

  if (req.method === 'GET' && rest.length === 0) {
    const view = await team.businessView(lic.subscription);
    return view ? json({ ...view, business: lic.business }) : err(404, 'no team uses this license');
  }
  if (req.method === 'DELETE' && rest[0] === 'members' && ID.test(rest[1] || '') && rest.length === 2) {
    const r = await team.businessRemove(lic.subscription, rest[1]);
    return r.status === 200 ? json({ ...r.view, business: lic.business }) : err(r.status, r.error);
  }
  return err(404, 'not found');
}
