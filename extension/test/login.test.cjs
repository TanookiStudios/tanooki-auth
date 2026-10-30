// Run from the repo root: node --test extension/test/login.test.cjs
const test = require('node:test');
const assert = require('node:assert');
const { pickByLogin } = require('../login.js');

const work = { id: 'w', label: 'alice@work.com' };
const home = { id: 'h', label: 'Alice@Home.com' };
const bob = { id: 'b', label: 'bob' };
const blank = { id: 'x', label: '' };
const all = [work, home, bob, blank];
const picks = (hints, want) => assert.strictEqual(pickByLogin(all, hints)?.id ?? null, want, JSON.stringify(hints));

test('exact email picks that account, ignoring case and spaces', () => {
  picks(['alice@work.com'], 'w');
  picks(['  ALICE@HOME.COM '], 'h');
});

test('the part before @ matches when one side is only a username', () => {
  picks(['bob@example.com'], 'b'); // page shows an email, label is a username
  picks(['Bob'], 'b');
  assert.strictEqual(pickByLogin([work], ['alice'])?.id, 'w'); // page shows a username, label is an email
});

test('unsure means null, so the chooser is used', () => {
  picks([], null);
  picks(['', '   '], null);
  picks(['carol@work.com'], null); // nobody
  picks(['alice'], null); // both Alice accounts
  picks(['alice@work.com', 'bob'], null); // two different accounts on one page
  picks(['alice@other.com'], null); // same name, different email: not the same person
});

test('exact matches beat before-the-@ matches', () => {
  assert.strictEqual(pickByLogin([{ id: 'u', label: 'alice' }, work], ['alice@work.com'])?.id, 'w');
});

test('two exact matches stay unsure, even if a looser match would name a third account', () => {
  const carol = { id: 'c', label: 'carol' };
  assert.strictEqual(pickByLogin([work, bob, carol], ['alice@work.com', 'bob', 'carol@example.com']), null);
});

test('repeated hints for one account still pick it', () => {
  picks(['alice@work.com', 'ALICE@work.com'], 'w');
});
