// Runs the packaged Alfred workflow script and the Raycast data layer (shared/bridge.mjs)
// against the fake bridge. Uses its own ports and keychain item, never the real app or token.
// Run: node --test integrations/test/integrations.test.mjs
import { test, before, after } from 'node:test';
import assert from 'node:assert/strict';
import { execFile, execFileSync } from 'node:child_process';
import { promisify } from 'node:util';
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import net from 'node:net';
import { startFakeBridge } from './fake-bridge.mjs';

const here = path.dirname(new URL(import.meta.url).pathname);
const freePort = () => new Promise((r) => { const s = net.createServer().listen(0, '127.0.0.1', () => { const p = s.address().port; s.close(() => r(p)); }); });

const tmp = fs.mkdtempSync(path.join(os.tmpdir(), 'tanooki-integrations-'));
const service = `Tanooki Auth bridge TEST ${process.pid}`;
let env, raycast, appPort, workflowDir;

before(async () => {
  appPort = await freePort();
  const emptyPort = await freePort();
  // Nothing listens on emptyPort; the fake app comes and goes on appPort.
  process.env.TANOOKI_BRIDGE_PORTS = `${emptyPort},${appPort}`;
  process.env.TANOOKI_KEYCHAIN_SERVICE = service;
  // A pbcopy stand-in so the test never touches the real clipboard.
  fs.writeFileSync(path.join(tmp, 'pbcopy'), `#!/bin/sh\ncat > "${tmp}/clipboard"\n`, { mode: 0o755 });
  env = { ...process.env, PATH: `${tmp}:${process.env.PATH}` };
  // Test the real package: build it and run the script from the unzipped copy.
  const pkg = path.join(tmp, 'Tanooki Auth.alfredworkflow');
  execFileSync(path.join(here, '../alfred/build.sh'), [pkg]);
  workflowDir = path.join(tmp, 'workflow');
  execFileSync('unzip', ['-q', pkg, '-d', workflowDir]);
  const { createClient } = await import('../shared/bridge.mjs');
  raycast = createClient('raycast', 'Raycast');
});

after(() => {
  for (const a of ['alfred', 'raycast']) {
    try { execFileSync('security', ['delete-generic-password', '-s', service, '-a', a], { stdio: 'ignore' }); } catch {}
  }
  fs.rmSync(tmp, { recursive: true, force: true });
});

// Async on purpose: a sync child would block this process, which is also running the fake app.
const alfred = async (...args) => (await promisify(execFile)('node', [path.join(workflowDir, 'tanooki.mjs'), ...args], { env, cwd: workflowDir })).stdout.trim();
const filter = async (q = '') => JSON.parse(await alfred('filter', q));
const keychainToken = (account) => {
  try { return execFileSync('security', ['find-generic-password', '-s', service, '-a', account, '-w']).toString().trim(); } catch { return null; }
};
const rejects = (p, code, text) => assert.rejects(p, (e) => { assert.equal(e.code, code); if (text) assert.match(e.message, text); return true; });

test('app not running', async () => {
  const r = await filter();
  assert.equal(r.items[0].title, 'Open Tanooki Auth');
  assert.match(r.items[0].subtitle, /isn't running/);
  await rejects(raycast.listCodes(), 'noApp', /Open Tanooki Auth/);
});

test('app that only accepts the browser extension (today\'s bridge)', async () => {
  const app = await startFakeBridge({ port: appPort, allowOrigin: /^chrome-extension:\/\/[a-p]{32}$/ });
  try {
    assert.match((await filter()).items[0].subtitle, /doesn't accept Alfred yet\. Update Tanooki Auth/);
    await rejects(raycast.listCodes(), 'oldApp', /doesn't accept Raycast yet/);
  } finally { await app.close(); }
});

test('pair, list, copy, lock, revoke', async (t) => {
  const app = await startFakeBridge({ port: appPort });
  t.after(() => app.close());
  const { state } = app;

  await t.test('Alfred: not paired yet', async () => {
    assert.equal((await filter()).items[0].title, 'Pair Alfred with Tanooki Auth');
  });

  await t.test('Alfred: 2fa-pair with a wrong code, then the right one', async () => {
    assert.match(await alfred('pair'), /showing a 6-digit code/);
    assert.equal(state.pairOrigin, 'tanooki-integration://alfred');
    const wrong = state.pairCode === '000000' ? '111111' : '000000';
    assert.match(await alfred('pair', wrong), /doesn't match/);
    assert.match(await alfred('pair', `${state.pairCode.slice(0, 3)} ${state.pairCode.slice(3)}`), /Alfred is paired/);
    const token = keychainToken('alfred');
    assert.match(token, /^[0-9a-f]{64}$/);
    assert.equal(token, state.pairings.get('tanooki-integration://alfred'));
  });

  await t.test('Alfred: 2fa lists accounts with live codes and filters', async () => {
    const r = await filter();
    assert.equal(r.rerun, 1);
    assert.equal(r.items.length, 3);
    const gh = r.items.find((i) => i.uid === 'gh');
    const code = state.codeFor('gh');
    assert.equal(gh.arg, code);
    assert.equal(gh.title, `${code.slice(0, 3)} ${code.slice(3)}  GitHub`);
    assert.match(gh.subtitle, /1[67]s left/);
    assert.equal(r.items.find((i) => i.uid === 'bank').arg, 'hotp:bank');
    assert.deepEqual((await filter('git')).items.map((i) => i.uid), ['gh']);
    assert.equal((await filter('nothing-matches')).items[0].title, 'No matching accounts');
  });

  await t.test('Alfred: Enter copies (TOTP as listed, HOTP fetched fresh)', async () => {
    assert.match(await alfred('copy', state.codeFor('aws')), /^Copied \d{3} \d{3}$/);
    assert.equal(fs.readFileSync(path.join(tmp, 'clipboard'), 'utf8'), state.codeFor('aws'));
    await alfred('copy', 'hotp:bank');
    assert.equal(fs.readFileSync(path.join(tmp, 'clipboard'), 'utf8'), state.codeFor('bank', 0));
    assert.equal(state.hotpCounter, 1);
  });

  await t.test('Raycast: separate pairing, then list and code', async () => {
    await rejects(raycast.listCodes(), 'notPaired', /Raycast isn't paired/);
    await raycast.pairStart();
    assert.equal(state.pairOrigin, 'tanooki-integration://raycast');
    await rejects(raycast.pairFinish('999999' === state.pairCode ? '888888' : '999999'), 'wrongCode');
    await raycast.pairFinish(state.pairCode);
    assert.equal(keychainToken('raycast'), state.pairings.get('tanooki-integration://raycast'));
    const list = await raycast.listCodes();
    assert.deepEqual(list.map((a) => a.id), ['gh', 'aws', 'bank']);
    assert.equal(list[0].code, state.codeFor('gh'));
    assert.ok(list[0].expiresAt > Date.now() + 15000);
    assert.equal(list[2].code, null); // HOTP: not spent just by listing
    assert.equal((await raycast.code('aws')).code, state.codeFor('aws'));
  });

  await t.test('locked app', async () => {
    state.locked = true;
    assert.equal((await filter()).items[0].title, 'Unlock Tanooki Auth');
    await rejects(raycast.listCodes(), 'locked', /locked/);
    state.locked = false;
  });

  await t.test('pairing removed in the app clears the stored token', async () => {
    state.pairings.delete('tanooki-integration://raycast');
    await rejects(raycast.listCodes(), 'notPaired');
    assert.equal(keychainToken('raycast'), null);
    assert.equal(keychainToken('alfred') !== null, true); // the other integration is untouched
  });
});
