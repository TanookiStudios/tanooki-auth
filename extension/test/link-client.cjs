// Scripted extension for the live phone-link test (app/tool/relay_live_test.dart): the real link.js,
// run in Node instead of the browser. Prints one line per step for the Dart test to read:
//   QR <text>  ->  PAIRED <phone name>  ->  CODE <digits> <domain>  ->  DENIED  ->  DONE
// Usage: node extension/test/link-client.cjs <relay base URL> <host>
const { makeLink } = require('../link.js');

const [relay, host] = process.argv.slice(2);
let state = null;
const link = makeLink({ storage: { get: async () => state, set: async (s) => { state = s; }, clear: async () => { state = null; } } });
const sleep = (ms) => new Promise((r) => setTimeout(r, ms));

(async () => {
  const { qr } = await link.startPairing(relay);
  console.log(`QR ${qr}`);
  for (let i = 0; ; i++) {
    const p = await link.checkPairing();
    if (p.state === 'paired') { console.log(`PAIRED ${p.phoneName}`); break; }
    if (i > 60) throw new Error(`never paired: ${p.state}`);
    await sleep(1000);
  }
  const r = await link.requestCode(host, { timeoutMs: 60000, onSent: (push) => console.log(`PUSH ${push}`) });
  console.log(`CODE ${r.code} ${r.domain}`);
  try {
    await link.requestCode(host, { timeoutMs: 60000 });
    console.log('NOT DENIED');
  } catch (e) {
    console.log(e.code === 'denied' ? 'DENIED' : `ERROR ${e.code} ${e.message}`);
  }
  console.log(`STORED ${Object.keys(state).sort().join(',')}`);
  await link.unpair();
  console.log('DONE');
  process.exit(0); // don't wait for idle keep-alive connections
})().catch((e) => { console.log(`ERROR ${e.code || ''} ${e.message}`); process.exit(1); });
