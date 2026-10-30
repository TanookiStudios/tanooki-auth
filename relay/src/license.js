// Checks team license tokens made by the Premium worker (worker/src/index.js makeTeamLicense). No Workers-only
// imports, so worker/test.mjs can check both sides agree.
import { B64U, unb64u, verifyEd25519 } from './util.js';

// Team license token from the Premium worker: TT1.<base64url "team1|<subscriptionId>|<periodEnd seconds>">.<Ed25519 sig>
export async function checkTeamLicense(token, publicKey) {
  const [tag, p, s, extra] = String(token || '').split('.');
  if (tag !== 'TT1' || !p || !s || extra !== undefined || !B64U.test(p)) return { error: 'team license is malformed' };
  let payload;
  try { payload = new TextDecoder().decode(unb64u(p)); } catch { return { error: 'team license is malformed' }; }
  if (!(await verifyEd25519(publicKey, s, payload))) return { error: 'team license signature is not valid' };
  const [kind, subscription, end] = payload.split('|');
  const periodEnd = Number(end) * 1000;
  if (kind !== 'team1' || !subscription || !Number.isInteger(periodEnd)) return { error: 'team license is malformed' };
  if (periodEnd <= Date.now()) return { error: 'team license has expired; refresh it in the app' };
  return { subscription, periodEnd };
}
