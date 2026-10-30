// Run from the repo root: node --test extension/test/lookalike.test.cjs
const test = require('node:test');
const assert = require('node:assert');
const { domainToASCII } = require('node:url');
const { lookalikeOf, punyDecode } = require('../lookalike.js');

const saved = ['github.com', 'paypal.com', 'bankofamerica.com', 'x.com', 'amazon.co.uk'];
const warns = (host, as) => assert.strictEqual(lookalikeOf(host, saved), as, host);
const quiet = (host) => assert.strictEqual(lookalikeOf(host, saved), null, host);

test('saved sites and their subdomains are never flagged', () => {
  for (const h of ['github.com', 'www.github.com', 'gist.github.com', 'paypal.com', 'x.com', 'www.amazon.co.uk']) quiet(h);
});

test('unrelated and merely similar sites are not flagged', () => {
  for (const h of ['gitlab.com', 'example.com', 'githubusercontent.com', 'y.com', 'xbox.com', 'amazing.com', '127.0.0.1', 'localhost', '']) quiet(h);
});

test('typos within the allowed edit distance', () => {
  warns('gihtub.com', 'github.com'); // swapped letters
  warns('githubb.com', 'github.com');
  warns('githu.com', 'github.com');
  warns('paypa1.com', 'paypal.com'); // 1 reads as l
  warns('bankofamerlca.com', 'bankofamerica.com');
  warns('bankofamrica.co', 'bankofamerica.com');
  warns('bankofamercia.com', 'bankofamerica.com'); // two edits on a long name
  quiet('gitxyb.com'); // two edits on a six-letter name is too loose
});

test('same name under another ending', () => {
  warns('github.co', 'github.com');
  warns('amazon.com', 'amazon.co.uk');
});

test('homoglyphs and punycode', () => {
  const cyr = domainToASCII('gіthub.com'); // Cyrillic і
  assert.match(cyr, /^xn--/);
  warns(cyr, 'github.com');
  warns(domainToASCII('раураl.com'), 'paypal.com'); // all Cyrillic
  warns(domainToASCII('gíthub.com'), 'github.com'); // accent
  warns('rnicrosoft-github.com', 'github.com');
  assert.strictEqual(punyDecode('bcher-kva'), 'bücher');
  assert.strictEqual(punyDecode(domainToASCII('пример.com').split('.')[0].slice(4)), 'пример');
});

test('saved name embedded in another domain', () => {
  warns('github.com.evil.io', 'github.com');
  warns('github-login.com', 'github.com');
  warns('secure-paypal.net', 'paypal.com');
  warns('login.github.com-verify.ru', 'github.com');
});

test('bad punycode does not throw', () => {
  quiet('xn--zz.com');
  quiet('xn--.com');
});
