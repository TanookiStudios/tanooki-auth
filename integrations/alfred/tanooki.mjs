// Alfred workflow entry point. Usage (Alfred passes the query as argv):
//   node tanooki.mjs filter [query]   script filter for the "2fa" keyword (prints Alfred JSON)
//   node tanooki.mjs copy <arg>       Enter on a result: copies the code, prints the notification text
//   node tanooki.mjs pair [code]      "2fa-pair": no code starts pairing, a code finishes it
import { execFile } from 'node:child_process';
import { createClient, groupCode } from './bridge.mjs';

const bridge = createClient('alfred', 'Alfred');
const [cmd, ...rest] = process.argv.slice(2);
const arg = rest.join(' ').trim();

const notice = (title, subtitle) => ({ items: [{ title, subtitle, valid: false, icon: { path: 'icon.png' } }] });

async function filter(query) {
  let accounts;
  try {
    accounts = await bridge.listCodes();
  } catch (e) {
    if (e.code === 'noApp') return notice('Open Tanooki Auth', e.message);
    if (e.code === 'notPaired') return notice('Pair Alfred with Tanooki Auth', 'Type 2fa-pair and press Enter, then 2fa-pair followed by the 6-digit code the app shows.');
    if (e.code === 'locked') return notice('Unlock Tanooki Auth', e.message);
    return notice('Tanooki Auth', e.message);
  }
  const words = query.toLowerCase().split(/\s+/).filter(Boolean);
  const items = accounts
    .filter((a) => {
      const hay = [a.issuer, a.label, ...a.domains].join(' ').toLowerCase();
      return words.every((w) => hay.includes(w));
    })
    .map((a) => {
      const left = a.expiresAt ? Math.max(0, Math.ceil((a.expiresAt - Date.now()) / 1000)) : null;
      const name = a.issuer || a.label;
      return {
        uid: a.id,
        title: a.code ? `${groupCode(a.code)}  ${name}` : name,
        subtitle: a.code
          ? `${a.issuer ? a.label + ' · ' : ''}${left}s left · Enter to copy`
          : `${a.issuer ? a.label + ' · ' : ''}Counter-based code · Enter to make and copy a new one`,
        arg: a.code ?? `hotp:${a.id}`,
        match: [a.issuer, a.label, ...a.domains].join(' '),
        icon: { path: 'icon.png' },
      };
    });
  if (!items.length) return notice(accounts.length ? 'No matching accounts' : 'No accounts in Tanooki Auth yet', 'Add accounts in the Tanooki Auth app.');
  return { rerun: 1, items }; // rerun keeps codes and countdowns live while Alfred is open
}

async function copy(value) {
  let code = value;
  if (value.startsWith('hotp:')) code = (await bridge.code(value.slice(5))).code;
  if (!/^[0-9A-Z]{5,10}$/.test(code)) throw new Error('Nothing to copy.');
  await new Promise((resolve, reject) => execFile('pbcopy', (e) => (e ? reject(e) : resolve())).stdin.end(code));
  return `Copied ${groupCode(code)}`;
}

async function pair(code) {
  if (!code) {
    await bridge.pairStart();
    return 'Tanooki Auth is showing a 6-digit code. Type 2fa-pair followed by that code.';
  }
  await bridge.pairFinish(code);
  return 'Alfred is paired with Tanooki Auth. Type 2fa to see your codes.';
}

try {
  if (cmd === 'filter') console.log(JSON.stringify(await filter(arg)));
  else if (cmd === 'copy') console.log(await copy(arg));
  else if (cmd === 'pair') console.log(await pair(arg));
  else throw new Error(`Unknown command "${cmd}".`);
} catch (e) {
  // copy and pair feed a notification, so the message is the output; a nonzero exit would hide it.
  console.log(cmd === 'filter' ? JSON.stringify(notice('Tanooki Auth', e.message)) : e.message);
}
