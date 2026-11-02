import Foundation
import Security

/// A picture shared to Tanooki Auth from the share sheet (TanookiShare), on its way to the app. It holds someone's
/// 2FA QR code, so it waits in the keychain group only this app and its extensions can read (no App Group needed),
/// stays on this device only, and the app removes it as soon as it reads it.
enum SharedImage {
  private static let service = "com.tanookistudios.auth.sharedimage"
  private static let account = "image"

  private static func query(_ group: String?) -> [String: Any] {
    var q: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: service,
      kSecAttrAccount as String: account,
    ]
    if let group { q[kSecAttrAccessGroup as String] = group }
    return q
  }

  @discardableResult
  static func save(_ data: Data, group: String?) -> OSStatus {
    SecItemDelete(query(group) as CFDictionary)
    var add = query(group)
    add[kSecValueData as String] = data
    add[kSecAttrAccessible as String] = kSecAttrAccessibleWhenUnlockedThisDeviceOnly
    return SecItemAdd(add as CFDictionary, nil)
  }

  /// The waiting picture, removed from the keychain as it's read; nil when there is none.
  static func take(group: String?) -> Data? {
    var q = query(group)
    q[kSecReturnData as String] = true
    q[kSecMatchLimit as String] = kSecMatchLimitOne
    var out: AnyObject?
    guard SecItemCopyMatching(q as CFDictionary, &out) == errSecSuccess, let data = out as? Data else { return nil }
    SecItemDelete(query(group) as CFDictionary)
    return data
  }
}
