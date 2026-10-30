// Prints known-answer values for test/relay_protocol_test.dart, computed with Node's WebCrypto (the same
// crypto relay/test.mjs runs against the live relay), so the Dart client is checked against a second
// implementation. Run: node app/tool/make_relay_vectors.mjs
const { subtle } = globalThis.crypto;
const te = new TextEncoder();
const b64u = (b) => Buffer.from(b).toString('base64url');
const hkdf = async (ikm, salt, info, n) => new Uint8Array(await subtle.deriveBits({ name: 'HKDF', hash: 'SHA-256', salt, info: te.encode(info) }, await subtle.importKey('raw', ikm, 'HKDF', false, ['deriveBits']), n * 8));
const seq = (n, start) => Uint8Array.from({ length: n }, (_, i) => (start + i) & 255);
const seal = async (key, obj, aad, iv) => {
  const k = await subtle.importKey('raw', key, 'AES-GCM', false, ['encrypt']);
  return b64u(Buffer.concat([iv, new Uint8Array(await subtle.encrypt({ name: 'AES-GCM', iv, additionalData: te.encode(aad) }, k, te.encode(JSON.stringify(obj))))]));
};
// pkcs8 wrappers for raw 32-byte private keys
const pkcs8 = (oid, seed) => Buffer.concat([Buffer.from(`302e020100300506032b65${oid}04220420`, 'hex'), seed]);

const root = seq(32, 1);
const groupId = b64u(await hkdf(root, new Uint8Array(), 'TA-SYNC-GROUP-ID-1', 32));
const recordKey = await hkdf(root, new Uint8Array(), 'TA-SYNC-RECORD-KEY-1', 32);
const recordId = b64u(await hkdf(root, te.encode('account-uuid-1'), 'TA-SYNC-RECORD-ID-1', 32));
const record = await seal(recordKey, { id: 'account-uuid-1', purgedAt: 1793322371412 }, `TA-SYNC-1|${groupId}|${recordId}`, seq(12, 100));

const edSeed = seq(32, 50);
const ed = await subtle.importKey('pkcs8', pkcs8('70', edSeed), { name: 'Ed25519' }, true, ['sign']);
const sig = b64u(await subtle.sign({ name: 'Ed25519' }, ed, te.encode('TA-RELAY-1\nGET\n/v1/sync/x/devices\n1\nn\n47DEQpj8HBSa-_TImW-5JCeuQeRkm5NMpJWZG3hSuFU')));

const extSeed = seq(32, 150);
const phoneSeed = seq(32, 200);
const ext = await subtle.importKey('pkcs8', pkcs8('6e', extSeed), { name: 'X25519' }, true, ['deriveBits']);
const phone = await subtle.importKey('pkcs8', pkcs8('6e', phoneSeed), { name: 'X25519' }, true, ['deriveBits']);
const pubOf = async (k) => Buffer.from((await subtle.exportKey('jwk', k)).x, 'base64url');
const edPub = b64u(await pubOf(ed));
const extPub = b64u(await pubOf(ext));
const phonePub = b64u(await pubOf(phone));
const roomId = b64u(seq(32, 7));
const pairSecret = seq(32, 9);
const shared = new Uint8Array(await subtle.deriveBits({ name: 'X25519', public: await subtle.importKey('raw', Buffer.from(phonePub, 'base64url'), { name: 'X25519' }, false, []) }, ext, 256));
const okm = await hkdf(shared, pairSecret, `TA-LINK-1|${roomId}|${extPub}|${phonePub}`, 64);
const fill = await seal(okm.slice(0, 32), { t: 'fill-request', id: 'req1', ts: 1, host: 'github.com' }, `TA-LINK-1|${roomId}|e2p`, seq(12, 30));
console.log(JSON.stringify({ groupId, recordId, record, edPub, sig, extPub, phonePub, roomId, pairSecret: b64u(pairSecret), fill, keyP2E: b64u(okm.slice(32)) }, null, 2));
