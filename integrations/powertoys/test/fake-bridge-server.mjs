// Runs the shared fake Tanooki Auth bridge (integrations/test/fake-bridge.mjs) for the PowerToys tests.
// Reads commands on stdin and answers on stdout, one line each:
//   start <port> [old]  -> STARTED      (old = today's app, which only accepts the browser extension)
//   stop                -> STOPPED
//   paircode            -> PAIRCODE <code>
//   token               -> TOKEN <token or none>     (the token the app holds for PowerToys)
//   lock / unlock / unpair -> OK
import readline from 'node:readline';
import { startFakeBridge } from '../../test/fake-bridge.mjs';

const ORIGIN = 'tanooki-integration://powertoys';
let app = null;
const say = (line) => process.stdout.write(`${line}\n`);

for await (const line of readline.createInterface({ input: process.stdin })) {
  const [cmd, arg, flag] = line.trim().split(/\s+/);
  if (cmd === 'start') {
    app = await startFakeBridge({ port: Number(arg), allowOrigin: flag === 'old' ? /^chrome-extension:\/\/[a-p]{32}$/ : /^tanooki-integration:\/\/(raycast|alfred|powertoys)$/ });
    say('STARTED');
  } else if (cmd === 'stop') {
    await app?.close();
    app = null;
    say('STOPPED');
  } else if (cmd === 'paircode') say(`PAIRCODE ${app.state.pairCode}`);
  else if (cmd === 'token') say(`TOKEN ${app.state.pairings.get(ORIGIN) ?? 'none'}`);
  else if (cmd === 'lock' || cmd === 'unlock') { app.state.locked = cmd === 'lock'; say('OK'); }
  else if (cmd === 'unpair') { app.state.pairings.delete(ORIGIN); say('OK'); }
  else if (cmd === 'code') say(`CODE ${app.state.codeFor(arg)}`);
  else say(`ERROR unknown ${cmd}`);
}
