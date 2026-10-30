// Loads the extension into Playwright's Firefox and runs code in its background page, over Firefox's
// remote debugging protocol (Playwright can't load extensions into Firefox, or open moz-extension:// pages).
const net = require('net');

class Rdp {
  static async connect(port) {
    for (let i = 0; ; i++) {
      try { const r = new Rdp(); await r.open(port); return r; } catch (e) {
        if (i > 50) throw e;
        await new Promise((r) => setTimeout(r, 200));
      }
    }
  }

  open(port) {
    this.buf = Buffer.alloc(0);
    this.waiters = [];
    this.events = [];
    return new Promise((resolve, reject) => {
      this.sock = net.connect(port, '127.0.0.1');
      this.sock.on('error', reject);
      this.sock.on('data', (d) => {
        this.buf = Buffer.concat([this.buf, d]);
        for (;;) { // packets are "<byte length>:<json>"
          const i = this.buf.indexOf(':');
          if (i < 0) return;
          const n = +this.buf.subarray(0, i).toString();
          if (this.buf.length < i + 1 + n) return;
          const msg = JSON.parse(this.buf.subarray(i + 1, i + 1 + n).toString());
          this.buf = this.buf.subarray(i + 1 + n);
          if (msg.from === 'root' && msg.applicationType) { resolve(); continue; }
          const w = this.waiters.findIndex((x) => x.from === msg.from && x.match(msg));
          if (w >= 0) this.waiters.splice(w, 1)[0].resolve(msg);
          else this.events.push(msg);
        }
      });
    });
  }

  /** Next packet from [from] that [match]es, including one that already arrived. */
  wait(from, match) {
    const i = this.events.findIndex((m) => m.from === from && match(m));
    if (i >= 0) return Promise.resolve(this.events.splice(i, 1)[0]);
    return new Promise((resolve) => this.waiters.push({ from, match, resolve }));
  }

  request(to, type, extra = {}, match = (m) => !m.type || m.type === type) {
    return new Promise((resolve, reject) => {
      this.waiters.push({ from: to, match, resolve: (m) => (m.error ? reject(new Error(`${type}: ${m.error} ${m.message || ''}`)) : resolve(m)) });
      const s = Buffer.from(JSON.stringify({ to, type, ...extra }));
      this.sock.write(Buffer.concat([Buffer.from(`${s.length}:`), s]));
    });
  }
}

/** Installs [extDir] as a temporary add-on; returns bg(fn, arg), which runs fn(arg) in the background page. */
async function installAddon(debugPort, extDir, addonId) {
  const rdp = await Rdp.connect(debugPort);
  const root = await rdp.request('root', 'getRoot');
  await rdp.request(root.addonsActor, 'installTemporaryAddon', { addonPath: extDir, openDevTools: false });
  const { addons } = await rdp.request('root', 'listAddons');
  const addon = addons.find((a) => a.id === addonId);
  if (!addon) throw new Error(`add-on ${addonId} did not install`);
  const watcher = await rdp.request(addon.actor, 'getWatcher', { isServerTargetSwitchingEnabled: true });
  await rdp.request(watcher.actor, 'watchTargets', { targetType: 'frame' }, () => true);
  let target;
  for (let i = 0; i < 50 && !target; i++) {
    target = rdp.events.find((e) => e.type === 'target-available-form' && /_generated_background_page/.test(e.target.url))?.target;
    if (!target) await new Promise((r) => setTimeout(r, 100));
  }
  if (!target) throw new Error('background page not found');
  const consoleActor = target.consoleActor;
  return async (fn, arg) => {
    const text = `(async () => JSON.stringify(await (${fn})(${JSON.stringify(arg)})))()`;
    const { resultID } = await rdp.request(consoleActor, 'evaluateJSAsync', { text, mapped: { await: true } }, (m) => !!m.resultID);
    const r = await rdp.wait(consoleActor, (m) => m.type === 'evaluationResult' && m.resultID === resultID);
    if (r.hasException) throw new Error(`background: ${r.exceptionMessage}`);
    if (typeof r.result !== 'string') return undefined; // undefined, or a reply too long to come back as text
    return JSON.parse(r.result);
  };
}

module.exports = { installAddon };
