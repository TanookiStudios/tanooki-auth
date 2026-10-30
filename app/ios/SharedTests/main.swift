import Foundation

// RFC 6238 Appendix B. Built and run by scripts/check-native-totp.sh together with ../Shared/TOTP.swift.
let seeds = [
  "sha1": "12345678901234567890",
  "sha256": "12345678901234567890123456789012",
  "sha512": "1234567890123456789012345678901234567890123456789012345678901234",
]
let vectors: [(Double, String, String)] = [
  (59, "sha1", "94287082"), (59, "sha256", "46119246"), (59, "sha512", "90693936"),
  (1111111109, "sha1", "07081804"), (1111111109, "sha256", "68084774"), (1111111109, "sha512", "25091201"),
  (1111111111, "sha1", "14050471"), (1111111111, "sha256", "67062674"), (1111111111, "sha512", "99943326"),
  (1234567890, "sha1", "89005924"), (1234567890, "sha256", "91819424"), (1234567890, "sha512", "93441116"),
  (2000000000, "sha1", "69279037"), (2000000000, "sha256", "90698825"), (2000000000, "sha512", "38618901"),
  (20000000000, "sha1", "65353130"), (20000000000, "sha256", "77737706"), (20000000000, "sha512", "47863826"),
]
var failed = 0
for (t, alg, want) in vectors {
  let got = TOTP.totp(key: Data(seeds[alg]!.utf8), at: Date(timeIntervalSince1970: t), digits: 8, algorithm: alg)
  if got != want {
    print("FAIL t=\(Int(t)) \(alg): got \(got), want \(want)")
    failed += 1
  }
}
// Base32 path the widgets use: "12345678901234567890" encoded, 6 digits.
let b32 = TOTP.base32Decode("GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ")!
let six = TOTP.totp(key: b32, at: Date(timeIntervalSince1970: 59))
if six != "287082" { print("FAIL base32 6-digit: got \(six)"); failed += 1 }
// Steam Guard: same seed, checked against an independent Python implementation (hmac module).
let steamVectors: [(Double, String)] = [(59, "PV9M4"), (1111111109, "PY4YB"), (1234567890, "VHHQY"), (2000000000, "9N776"),
  // Together these use every letter of the Steam alphabet, so a wrong letter anywhere fails.
  (60, "B26KJ"), (90, "5H85C"), (120, "6Y9J3"), (150, "MD224"), (180, "P2GRF"), (210, "C9PRW"), (300, "X5TCK")]
for (t, want) in steamVectors {
  let got = TOTP.steam(key: Data(seeds["sha1"]!.utf8), at: Date(timeIntervalSince1970: t))
  if got != want { print("FAIL steam t=\(Int(t)): got \(got), want \(want)"); failed += 1 }
}
print(failed == 0 ? "Swift TOTP: all \(vectors.count + 1) RFC 6238 checks and \(steamVectors.count) Steam checks pass" : "Swift TOTP: \(failed) checks FAILED")
exit(failed == 0 ? 0 : 1)
