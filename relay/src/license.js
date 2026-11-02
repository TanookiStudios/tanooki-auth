// Checks team license tokens made by the Premium worker (worker/src/index.js makeTeamLicense). No Workers-only
// imports, so worker/test.mjs can check both sides agree.
import { B64U, unb64u, verifyEd25519 } from './util.js';

export const TEAM_SEATS = 10; // a team license is for up to 10 members
export const MAX_SEATS = 500; // a business license names its own seat count, up to this

// Team license token from the Premium worker: TT1.<base64url "team1|<subscriptionId>|<periodEnd seconds>">.<Ed25519 sig>
// Business plan: the same, with payload "biz1|<subscriptionId>|<periodEnd seconds>|<seats>".
// Returns { subscription, periodEnd (ms), seats, business } or { error }.
export async function checkTeamLicense(token, publicKey) {
  const [tag, p, s, extra] = String(token || '').split('.');
  if (tag !== 'TT1' || !p || !s || extra !== undefined || !B64U.test(p)) return { error: 'team license is malformed' };
  let payload;
  try { payload = new TextDecoder().decode(unb64u(p)); } catch { return { error: 'team license is malformed' }; }
  if (!(await verifyEd25519(publicKey, s, payload))) return { error: 'team license signature is not valid' };
  const [kind, subscription, end, seatText, extraField] = payload.split('|');
  const periodEnd = Number(end) * 1000;
  const business = kind === 'biz1';
  const seats = business ? Number(seatText) : TEAM_SEATS;
  if (!(kind === 'team1' && seatText === undefined) && !(business && extraField === undefined)) return { error: 'team license is malformed' };
  if (!subscription || !Number.isInteger(periodEnd) || !Number.isInteger(seats) || seats < 1 || seats > MAX_SEATS) return { error: 'team license is malformed' };
  if (periodEnd <= Date.now()) return { error: 'team license has expired; refresh it in the app' };
  return { subscription, periodEnd, seats, business };
}
