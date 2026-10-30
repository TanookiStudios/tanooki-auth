import CryptoKit
import Foundation

/// RFC 4226 / 6238 codes for the widgets and watch. Mirrors app/lib/core/totp.dart; checked against the
/// RFC 6238 Appendix B vectors by scripts/check-native-totp.sh.
enum TOTP {
  static func base32Decode(_ input: String) -> Data? {
    let alphabet = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ234567")
    var buffer = 0, bits = 0
    var out = Data()
    for ch in input.uppercased() where !" =-".contains(ch) {
      guard let v = alphabet.firstIndex(of: ch) else { return nil }
      buffer = (buffer << 5) | v
      bits += 5
      if bits >= 8 {
        bits -= 8
        out.append(UInt8((buffer >> bits) & 0xff))
      }
    }
    return out.isEmpty ? nil : out
  }

  static func hotp(key: Data, counter: UInt64, digits: Int = 6, algorithm: String = "sha1") -> String {
    let msg = withUnsafeBytes(of: counter.bigEndian) { Data($0) }
    let k = SymmetricKey(data: key)
    let mac: [UInt8]
    switch algorithm {
    case "sha256": mac = Array(HMAC<SHA256>.authenticationCode(for: msg, using: k))
    case "sha512": mac = Array(HMAC<SHA512>.authenticationCode(for: msg, using: k))
    default: mac = Array(HMAC<Insecure.SHA1>.authenticationCode(for: msg, using: k))
    }
    let offset = Int(mac[mac.count - 1] & 0x0f)
    let binary = (Int(mac[offset] & 0x7f) << 24) | (Int(mac[offset + 1]) << 16)
      | (Int(mac[offset + 2]) << 8) | Int(mac[offset + 3])
    var mod = 1
    for _ in 0..<digits { mod *= 10 }
    let s = String(binary % mod)
    return String(repeating: "0", count: max(0, digits - s.count)) + s
  }

  static func totp(key: Data, at date: Date, period: Int = 30, digits: Int = 6, algorithm: String = "sha1") -> String {
    hotp(key: key, counter: UInt64(max(0, date.timeIntervalSince1970)) / UInt64(period), digits: digits, algorithm: algorithm)
  }

  /// Steam Guard's alphabet (mirrors steamAlphabet in app/lib/core/totp.dart).
  static let steamAlphabet = Array("23456789BCDFGHJKMNPQRTVWXY")

  /// Steam Guard code: HMAC-SHA1 TOTP, the 31-bit number written as 5 characters, lowest first (mod 26).
  static func steam(key: Data, at date: Date, period: Int = 30) -> String {
    let counter = UInt64(max(0, date.timeIntervalSince1970)) / UInt64(period)
    let msg = withUnsafeBytes(of: counter.bigEndian) { Data($0) }
    let mac = Array(HMAC<Insecure.SHA1>.authenticationCode(for: msg, using: SymmetricKey(data: key)))
    let offset = Int(mac[mac.count - 1] & 0x0f)
    var v = (Int(mac[offset] & 0x7f) << 24) | (Int(mac[offset + 1]) << 16)
      | (Int(mac[offset + 2]) << 8) | Int(mac[offset + 3])
    var out = ""
    for _ in 0..<5 {
      out.append(steamAlphabet[v % steamAlphabet.count])
      v /= steamAlphabet.count
    }
    return out
  }

  /// "123 456" / "1234 5678", like the app.
  static func grouped(_ code: String) -> String {
    let half = code.count == 6 ? 3 : code.count == 8 ? 4 : 0
    guard half > 0 else { return code }
    return String(code.prefix(half)) + " " + String(code.suffix(code.count - half))
  }
}
