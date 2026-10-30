"""Writes test/fixtures/import_* from each app's published export format.

The encrypted ones use Python's own scrypt / PBKDF2 / AES-GCM, so the Dart importers are checked
against an independent implementation. Password for every encrypted fixture: "test".
Run: python3 tool/make_import_fixtures.py
"""
import base64, hashlib, json, os, uuid
from cryptography.hazmat.primitives.ciphers.aead import AESGCM

OUT = os.path.join(os.path.dirname(__file__), '..', 'test', 'fixtures')
PW = b'test'

def w(name, text):
    with open(os.path.join(OUT, name), 'w') as f:
        f.write(text)

# Aegis vault format: github.com/beemdevelopment/Aegis/blob/master/docs/vault.md
aegis_entries = [
    {"type": "totp", "uuid": str(uuid.uuid4()), "name": "octo@example.com", "issuer": "GitHub", "note": "work laptop",
     "favorite": True, "icon": None, "info": {"secret": "JBSWY3DPEHPK3PXP", "algo": "SHA1", "digits": 6, "period": 30}, "groups": []},
    {"type": "totp", "uuid": str(uuid.uuid4()), "name": "me@example.com", "issuer": "Proton", "note": "",
     "favorite": False, "icon": None, "info": {"secret": "GEZDGNBVGY3TQOJQ", "algo": "SHA256", "digits": 8, "period": 60}, "groups": []},
    {"type": "hotp", "uuid": str(uuid.uuid4()), "name": "card", "issuer": "Bank", "note": "",
     "favorite": False, "icon": None, "info": {"secret": "NBSWY3DPO5XXE3DE", "algo": "SHA1", "digits": 6, "counter": 7}, "groups": []},
    {"type": "steam", "uuid": str(uuid.uuid4()), "name": "gamer", "issuer": "Steam", "note": "",
     "favorite": False, "icon": None, "info": {"secret": "MFRGGZDFMZTWQ2LK", "algo": "SHA1", "digits": 5, "period": 30}, "groups": []},
]
db = {"version": 3, "entries": aegis_entries, "groups": []}
w('import_aegis_plain.json', json.dumps({"version": 1, "header": {"slots": None, "params": None}, "db": db}, indent=2))

master = os.urandom(32)
salt = os.urandom(32)
n, r, p = 32768, 8, 1
kek = hashlib.scrypt(PW, salt=salt, n=n, r=r, p=p, dklen=32, maxmem=64 * 1024 * 1024)
knonce = os.urandom(12)
kct = AESGCM(kek).encrypt(knonce, master, None)
dnonce = os.urandom(12)
dct = AESGCM(master).encrypt(dnonce, json.dumps(db).encode(), None)
w('import_aegis_encrypted.json', json.dumps({
    "version": 1,
    "header": {
        "slots": [{"type": 1, "uuid": str(uuid.uuid4()), "key": kct[:-16].hex(),
                   "key_params": {"nonce": knonce.hex(), "tag": kct[-16:].hex()},
                   "n": n, "r": r, "p": p, "salt": salt.hex(), "repaired": True}],
        "params": {"nonce": dnonce.hex(), "tag": dct[-16:].hex()},
    },
    "db": base64.b64encode(dct[:-16]).decode(),
}, indent=2))

# 2FAS backup (.2fas), schema v4, as written by 2FAS for Android/iOS.
services = [
    {"name": "GitHub", "secret": "JBSWY3DPEHPK3PXP", "updatedAt": 1700000000000,
     "otp": {"label": "GitHub:octo@example.com", "account": "octo@example.com", "issuer": "GitHub",
             "digits": 6, "period": 30, "algorithm": "SHA1", "tokenType": "TOTP", "source": "Link"},
     "order": {"position": 0}, "icon": {"selected": "Label"}},
    {"name": "Dropbox", "secret": "KRUGKIDROVUWG2ZA", "updatedAt": 1700000000000,
     "otp": {"account": "demo@example.com", "issuer": "Dropbox", "digits": 6, "period": 30,
             "algorithm": "SHA1", "tokenType": "TOTP", "source": "Manual"},
     "order": {"position": 1}},
    {"name": "Steam", "secret": "MFRGGZDFMZTWQ2LK", "updatedAt": 1700000000000,
     "otp": {"account": "gamer", "issuer": "Steam", "digits": 5, "period": 30, "algorithm": "SHA1", "tokenType": "STEAM"},
     "order": {"position": 2}},
]
base = {"schemaVersion": 4, "appVersionCode": 5000000, "appOrigin": "android", "groups": []}
w('import_2fas_plain.2fas', json.dumps({**base, "services": services}, indent=2))
salt2 = os.urandom(256)
iv = os.urandom(12)
key2 = hashlib.pbkdf2_hmac('sha256', PW, salt2, 10000, 32)
ct2 = AESGCM(key2).encrypt(iv, json.dumps(services).encode(), None)
b64 = lambda b: base64.b64encode(b).decode()
w('import_2fas_encrypted.2fas', json.dumps({**base, "services": [],
    "servicesEncrypted": f"{b64(ct2)}:{b64(salt2)}:{b64(iv)}"}, indent=2))

# Authy: no official export. Shapes written by community exporters (authy-export, the Authy Desktop
# console scripts): JSON with name/secret/uri, sometimes decryptedSeed, and plain otpauth lists.
w('import_authy.json', json.dumps([
    {"name": "GitHub: octo@example.com", "secret": "JBSWY3DPEHPK3PXP",
     "uri": "otpauth://totp/GitHub:octo%40example.com?secret=JBSWY3DPEHPK3PXP&digits=6&period=30&issuer=GitHub"},
    {"name": "Discord", "decryptedSeed": "MFRGGZDFMZTWQ2LK", "digits": 6, "original_name": "Discord"},
    {"name": "Twitch", "secret_seed": "48656c6c6f21deadbeef", "digits": 7},
    {"name": "Broken"},
], indent=2))
w('import_authy.txt', "otpauth://totp/GitHub:octo%40example.com?secret=JBSWY3DPEHPK3PXP&issuer=GitHub\n"
  "otpauth://totp/Discord:tanooki?secret=MFRGGZDFMZTWQ2LK&issuer=Discord\n")

# Bitwarden unencrypted JSON and CSV exports (bitwarden.com/help/export-your-data, condensed).
w('import_bitwarden.json', json.dumps({"encrypted": False, "folders": [], "items": [
    {"id": str(uuid.uuid4()), "type": 1, "name": "GitHub", "favorite": False, "notes": None,
     "login": {"username": "octo@example.com", "password": "hunter2", "uris": [{"match": None, "uri": "https://github.com/login"}],
               "totp": "otpauth://totp/GitHub:octo%40example.com?secret=JBSWY3DPEHPK3PXP&issuer=GitHub"}},
    {"id": str(uuid.uuid4()), "type": 1, "name": "AWS", "favorite": False,
     "login": {"username": "root", "password": "x", "uris": [{"uri": "https://console.aws.amazon.com"}], "totp": "ONSW G4TF OQYT EMZU"}},
    {"id": str(uuid.uuid4()), "type": 1, "name": "No 2FA here",
     "login": {"username": "a", "password": "b", "uris": [], "totp": None}},
    {"id": str(uuid.uuid4()), "type": 1, "name": "Steam",
     "login": {"username": "gamer", "password": "c", "uris": [], "totp": "steam://MFRGGZDFMZTWQ2LK"}},
    {"id": str(uuid.uuid4()), "type": 2, "name": "A secure note"},
]}, indent=2))
w('import_bitwarden.csv',
  "folder,favorite,type,name,notes,fields,reprompt,login_uri,login_username,login_password,login_totp\n"
  ",,login,GitHub,,,0,https://github.com/login,octo@example.com,hunter2,otpauth://totp/GitHub:octo%40example.com?secret=JBSWY3DPEHPK3PXP&issuer=GitHub\n"
  "Work,1,login,\"Dropbox, Inc\",\"multi\nline note\",,0,https://www.dropbox.com,demo@example.com,pw,KRUGKIDROVUWG2ZA\n"
  ",,login,Plain login,,,0,https://example.com,me,pw,\n"
  ",,login,Bad secret,,,0,,me,pw,not*base32!\n")

# 1Password 8 CSV export (Title,Url,Username,Password,OTPAuth,Favorite,Archived,Tags,Notes).
w('import_1password.csv',
  "Title,Url,Username,Password,OTPAuth,Favorite,Archived,Tags,Notes\n"
  "GitHub,https://github.com,octo@example.com,hunter2,otpauth://totp/GitHub:octo%40example.com?secret=JBSWY3DPEHPK3PXP&issuer=GitHub,false,false,,\n"
  "Discord,https://discord.com/login,tanooki,pw,otpauth://totp/Discord:tanooki?secret=MFRGGZDFMZTWQ2LK&issuer=Discord&digits=6,true,false,games,\"says \"\"hi\"\"\"\n"
  "Email,https://mail.example.com,me,pw,,false,false,,\n")
print('ok')
