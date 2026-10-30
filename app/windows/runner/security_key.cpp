// tanooki/securitykey on Windows: YubiKey and other FIDO2 security keys through webauthn.dll, the native half of
// app/lib/core/security_key.dart. Same methods and error codes as the Apple side (SecurityKey.swift):
//   available  "ok"; "osTooOld" when webauthn.dll is older than API version 4 (no hmac-secret in sign-ins);
//              "unsupported" when there is no webauthn.dll at all.
//   register   {rp, userId, name, salt} -> {id}: makes a credential with the hmac-secret extension.
//   assert     {rp, ids, salt} -> {id, prf}: Windows turns [salt] into the hmac-secret input the way WebAuthn's
//              PRF does (SHA-256("WebAuthn PRF" || 0 || salt)), so a key gives the same output as on a Mac.
// webauthn.dll is loaded at run time so the app still starts on Windows versions without it.
#include "security_key.h"

#include <windows.h>
#include <bcrypt.h>
#include <webauthn.h>

#include <cstdio>
#include <functional>
#include <string>
#include <thread>
#include <vector>

namespace {

using flutter::EncodableList;
using flutter::EncodableMap;
using flutter::EncodableValue;
using Bytes = std::vector<uint8_t>;

struct Api {
  HMODULE dll = nullptr;
  decltype(&WebAuthNGetApiVersionNumber) version = nullptr;
  decltype(&WebAuthNAuthenticatorMakeCredential) make = nullptr;
  decltype(&WebAuthNAuthenticatorGetAssertion) get = nullptr;
  decltype(&WebAuthNFreeCredentialAttestation) free_attestation = nullptr;
  decltype(&WebAuthNFreeAssertion) free_assertion = nullptr;
  decltype(&WebAuthNGetErrorName) error_name = nullptr;
};

const Api& api() {
  static const Api a = [] {
    Api x;
    x.dll = LoadLibraryW(L"webauthn.dll");
    if (x.dll == nullptr) return x;
    x.version = reinterpret_cast<decltype(x.version)>(GetProcAddress(x.dll, "WebAuthNGetApiVersionNumber"));
    x.make = reinterpret_cast<decltype(x.make)>(GetProcAddress(x.dll, "WebAuthNAuthenticatorMakeCredential"));
    x.get = reinterpret_cast<decltype(x.get)>(GetProcAddress(x.dll, "WebAuthNAuthenticatorGetAssertion"));
    x.free_attestation = reinterpret_cast<decltype(x.free_attestation)>(GetProcAddress(x.dll, "WebAuthNFreeCredentialAttestation"));
    x.free_assertion = reinterpret_cast<decltype(x.free_assertion)>(GetProcAddress(x.dll, "WebAuthNFreeAssertion"));
    x.error_name = reinterpret_cast<decltype(x.error_name)>(GetProcAddress(x.dll, "WebAuthNGetErrorName"));
    return x;
  }();
  return a;
}

bool Usable() {
  const Api& a = api();
  return a.version && a.make && a.get && a.free_attestation && a.free_assertion &&
         a.version() >= WEBAUTHN_API_VERSION_4;
}

std::wstring Wide(const std::string& s) {
  const int n = MultiByteToWideChar(CP_UTF8, 0, s.c_str(), -1, nullptr, 0);
  std::wstring w(n > 0 ? n - 1 : 0, L'\0');
  if (n > 1) MultiByteToWideChar(CP_UTF8, 0, s.c_str(), -1, w.data(), n);
  return w;
}

Bytes Random(size_t n) {
  Bytes b(n);
  BCryptGenRandom(nullptr, b.data(), static_cast<ULONG>(n), BCRYPT_USE_SYSTEM_PREFERRED_RNG);
  return b;
}

std::string B64Url(const Bytes& b) {
  static const char* t = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_";
  std::string s;
  for (size_t i = 0; i < b.size(); i += 3) {
    const uint32_t v = (b[i] << 16) | (i + 1 < b.size() ? b[i + 1] << 8 : 0) | (i + 2 < b.size() ? b[i + 2] : 0);
    s += t[(v >> 18) & 63];
    s += t[(v >> 12) & 63];
    if (i + 1 < b.size()) s += t[(v >> 6) & 63];
    if (i + 2 < b.size()) s += t[v & 63];
  }
  return s;
}

const EncodableValue* Arg(const EncodableMap& m, const char* key) {
  auto it = m.find(EncodableValue(key));
  return it == m.end() ? nullptr : &it->second;
}

Bytes BytesArg(const EncodableMap& m, const char* key) {
  const auto* v = Arg(m, key);
  const auto* b = v ? std::get_if<Bytes>(v) : nullptr;
  return b ? *b : Bytes();
}

std::string StringArg(const EncodableMap& m, const char* key) {
  const auto* v = Arg(m, key);
  const auto* s = v ? std::get_if<std::string>(v) : nullptr;
  return s ? *s : std::string();
}

// What the calling thread hands back to the platform thread: a value, or an error code and message.
struct Outcome {
  bool ok = false;
  EncodableValue value;
  std::string code, message;
};

Outcome Fail(HRESULT hr) {
  Outcome o;
  const Api& a = api();
  const std::wstring name = a.error_name ? a.error_name(hr) : L"";
  if (hr == NTE_USER_CANCELLED || hr == HRESULT_FROM_WIN32(ERROR_CANCELLED)) {
    o.code = "canceled";
  } else if (name == L"InvalidStateError") {
    o.code = "exists";
  } else if (name == L"NotAllowedError") {
    o.code = "notAllowed";
  } else {
    o.code = "failed";
  }
  char buf[32];
  sprintf_s(buf, "0x%08lX", static_cast<unsigned long>(hr));
  o.message = std::string(buf);
  return o;
}

WEBAUTHN_CLIENT_DATA ClientData(const std::string& json) {
  return {WEBAUTHN_CLIENT_DATA_CURRENT_VERSION, static_cast<DWORD>(json.size()),
          reinterpret_cast<PBYTE>(const_cast<char*>(json.data())), WEBAUTHN_HASH_ALGORITHM_SHA_256};
}

Outcome Register(HWND hwnd, const EncodableMap& args) {
  const std::wstring rp_id = Wide(StringArg(args, "rp"));
  const std::wstring name = Wide(StringArg(args, "name"));
  Bytes user_id = BytesArg(args, "userId");
  const std::string json = "{\"type\":\"webauthn.create\",\"challenge\":\"" + B64Url(Random(32)) +
                           "\",\"origin\":\"https://" + StringArg(args, "rp") + "\"}";
  WEBAUTHN_RP_ENTITY_INFORMATION rp = {WEBAUTHN_RP_ENTITY_INFORMATION_CURRENT_VERSION, rp_id.c_str(), L"Tanooki Auth", nullptr};
  WEBAUTHN_USER_ENTITY_INFORMATION user = {WEBAUTHN_USER_ENTITY_INFORMATION_CURRENT_VERSION, static_cast<DWORD>(user_id.size()),
                                           user_id.data(), name.c_str(), nullptr, name.c_str()};
  WEBAUTHN_COSE_CREDENTIAL_PARAMETER param = {WEBAUTHN_COSE_CREDENTIAL_PARAMETER_CURRENT_VERSION, WEBAUTHN_CREDENTIAL_TYPE_PUBLIC_KEY,
                                              WEBAUTHN_COSE_ALGORITHM_ECDSA_P256_WITH_SHA256};
  WEBAUTHN_COSE_CREDENTIAL_PARAMETERS params = {1, &param};
  WEBAUTHN_CLIENT_DATA client = ClientData(json);
  BOOL hmac_secret = TRUE;
  WEBAUTHN_EXTENSION ext = {WEBAUTHN_EXTENSIONS_IDENTIFIER_HMAC_SECRET, sizeof(BOOL), &hmac_secret};

  WEBAUTHN_AUTHENTICATOR_MAKE_CREDENTIAL_OPTIONS opts = {};
  opts.dwVersion = WEBAUTHN_AUTHENTICATOR_MAKE_CREDENTIAL_OPTIONS_VERSION_4;
  opts.dwTimeoutMilliseconds = 60000;
  opts.Extensions = {1, &ext};
  opts.dwAuthenticatorAttachment = WEBAUTHN_AUTHENTICATOR_ATTACHMENT_CROSS_PLATFORM;  // a key, not Windows Hello
  opts.dwUserVerificationRequirement = WEBAUTHN_USER_VERIFICATION_REQUIREMENT_DISCOURAGED;
  opts.dwAttestationConveyancePreference = WEBAUTHN_ATTESTATION_CONVEYANCE_PREFERENCE_NONE;

  PWEBAUTHN_CREDENTIAL_ATTESTATION att = nullptr;
  const HRESULT hr = api().make(hwnd, &rp, &user, &params, &client, &opts, &att);
  if (FAILED(hr) || att == nullptr) return Fail(hr);
  bool hmac_on = false;
  if (att->dwVersion >= WEBAUTHN_CREDENTIAL_ATTESTATION_VERSION_2) {
    for (DWORD i = 0; i < att->Extensions.cExtensions; i++) {
      const auto& e = att->Extensions.pExtensions[i];
      if (wcscmp(e.pwszExtensionIdentifier, WEBAUTHN_EXTENSIONS_IDENTIFIER_HMAC_SECRET) == 0 && e.cbExtension == sizeof(BOOL)) {
        hmac_on = *static_cast<BOOL*>(e.pvExtension) != FALSE;
      }
    }
  }
  Outcome o;
  if (!hmac_on) {
    o.code = "noPrf";
  } else {
    o.ok = true;
    o.value = EncodableValue(EncodableMap{
        {EncodableValue("id"), EncodableValue(Bytes(att->pbCredentialId, att->pbCredentialId + att->cbCredentialId))}});
  }
  api().free_attestation(att);
  return o;
}

Outcome Assert(HWND hwnd, const EncodableMap& args) {
  const std::wstring rp_id = Wide(StringArg(args, "rp"));
  Bytes salt = BytesArg(args, "salt");
  std::vector<Bytes> ids;
  if (const auto* list = Arg(args, "ids")) {
    if (const auto* l = std::get_if<EncodableList>(list)) {
      for (const auto& v : *l) {
        if (const auto* b = std::get_if<Bytes>(&v)) ids.push_back(*b);
      }
    }
  }
  std::vector<WEBAUTHN_CREDENTIAL> creds;
  for (auto& id : ids) {
    creds.push_back({WEBAUTHN_CREDENTIAL_CURRENT_VERSION, static_cast<DWORD>(id.size()), id.data(), WEBAUTHN_CREDENTIAL_TYPE_PUBLIC_KEY});
  }
  const std::string json = "{\"type\":\"webauthn.get\",\"challenge\":\"" + B64Url(Random(32)) +
                           "\",\"origin\":\"https://" + StringArg(args, "rp") + "\"}";
  WEBAUTHN_CLIENT_DATA client = ClientData(json);
  WEBAUTHN_HMAC_SECRET_SALT prf_salt = {static_cast<DWORD>(salt.size()), salt.data(), 0, nullptr};
  WEBAUTHN_HMAC_SECRET_SALT_VALUES salts = {&prf_salt, 0, nullptr};

  WEBAUTHN_AUTHENTICATOR_GET_ASSERTION_OPTIONS opts = {};
  opts.dwVersion = WEBAUTHN_AUTHENTICATOR_GET_ASSERTION_OPTIONS_VERSION_6;
  opts.dwTimeoutMilliseconds = 60000;
  opts.CredentialList = {static_cast<DWORD>(creds.size()), creds.data()};
  opts.dwAuthenticatorAttachment = WEBAUTHN_AUTHENTICATOR_ATTACHMENT_CROSS_PLATFORM;
  opts.dwUserVerificationRequirement = WEBAUTHN_USER_VERIFICATION_REQUIREMENT_DISCOURAGED;
  opts.pHmacSecretSaltValues = &salts;

  PWEBAUTHN_ASSERTION as = nullptr;
  const HRESULT hr = api().get(hwnd, rp_id.c_str(), &client, &opts, &as);
  if (FAILED(hr) || as == nullptr) return Fail(hr);
  Outcome o;
  EncodableMap reply{{EncodableValue("id"), EncodableValue(Bytes(as->Credential.pbId, as->Credential.pbId + as->Credential.cbId))}};
  if (as->dwVersion >= WEBAUTHN_ASSERTION_VERSION_3 && as->pHmacSecret != nullptr && as->pHmacSecret->cbFirst > 0) {
    reply[EncodableValue("prf")] = EncodableValue(Bytes(as->pHmacSecret->pbFirst, as->pHmacSecret->pbFirst + as->pHmacSecret->cbFirst));
    o.ok = true;
    o.value = EncodableValue(reply);
  } else {
    o.code = "noPrf";
  }
  api().free_assertion(as);
  return o;
}

}  // namespace

void HandleSecurityKey(const flutter::MethodCall<EncodableValue>& call, std::unique_ptr<flutter::MethodResult<EncodableValue>> result,
                       HWND hwnd, std::function<void(std::function<void()>)> on_platform_thread) {
  const std::string& method = call.method_name();
  if (method == "available") {
    result->Success(EncodableValue(Usable() ? "ok" : api().dll ? "osTooOld" : "unsupported"));
    return;
  }
  if (method != "register" && method != "assert") {
    result->NotImplemented();
    return;
  }
  if (!Usable()) {
    result->Error("osTooOld");
    return;
  }
  const auto* map = std::get_if<EncodableMap>(call.arguments());
  EncodableMap args = map ? *map : EncodableMap();
  // webauthn.dll shows its own window and blocks until the key answers, so it runs off the platform thread.
  std::shared_ptr<flutter::MethodResult<EncodableValue>> shared(result.release());
  std::thread([=]() {
    const Outcome o = method == "register" ? Register(hwnd, args) : Assert(hwnd, args);
    on_platform_thread([shared, o]() {
      if (o.ok) {
        shared->Success(o.value);
      } else {
        shared->Error(o.code, o.message);
      }
    });
  }).detach();
}
