import Foundation
import Security

/// One favorite as the app hands it over (see app/lib/core/widget_share.dart).
struct Favorite: Codable, Hashable {
  let issuer: String
  let label: String
  let secret: String
  let algorithm: String
  let digits: Int
  let period: Int
  /// "totp" or "steam". Optional so favorites saved before Steam support still load.
  let type: String?
  /// The one favorite picked for the watch face complication (Premium). Absent on all the others.
  var complication: Bool? = nil

  var title: String { issuer.isEmpty ? label : issuer }

  func code(at date: Date) -> String {
    guard let key = TOTP.base32Decode(secret) else { return "------" }
    if type == "steam" { return TOTP.steam(key: key, at: date, period: period) }
    return TOTP.totp(key: key, at: date, period: period, digits: digits, algorithm: algorithm)
  }
}

/// The favorites copy shared with the widgets (through a keychain group only this app and its widgets
/// can read) or kept on the watch (in a keychain group shared with the watch's complication). Only exists while "Show codes on widgets and
/// watch" is on; the app erases it when that is turned off.
enum FavoriteStore {
  private static let service = "com.tanookistudios.auth.favorites"
  private static let account = "favorites"

  /// The shared keychain group, from Info.plist (TAKeychainGroup = $(AppIdentifierPrefix)com.tanookistudios.auth.shared).
  /// On the watch: $(AppIdentifierPrefix)com.tanookistudios.auth.watch, shared with the complication.
  static var sharedGroup: String? { Bundle.main.object(forInfoDictionaryKey: "TAKeychainGroup") as? String }

  private static func query(_ group: String?) -> [String: Any] {
    var q: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: service,
      kSecAttrAccount as String: account,
    ]
    if let group { q[kSecAttrAccessGroup as String] = group }
    return q
  }

  /// Replaces the stored list. An empty list erases it.
  @discardableResult
  static func save(_ json: Data, group: String?) -> OSStatus {
    // No group here: erases every copy, including one an older watch build kept in its own keychain.
    SecItemDelete(query(nil) as CFDictionary)
    guard let list = try? JSONDecoder().decode([Favorite].self, from: json), !list.isEmpty else { return errSecSuccess }
    var add = query(group)
    add[kSecValueData as String] = json
    // Readable after the first unlock since restart, so widgets can refresh in the background. They still
    // hide the codes while the device is locked (privacySensitive).
    add[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
    return SecItemAdd(add as CFDictionary, nil)
  }

  static func load(group: String?) -> [Favorite] {
    var q = query(group)
    q[kSecReturnData as String] = true
    q[kSecMatchLimit as String] = kSecMatchLimitOne
    var out: AnyObject?
    guard SecItemCopyMatching(q as CFDictionary, &out) == errSecSuccess, let data = out as? Data else { return [] }
    return (try? JSONDecoder().decode([Favorite].self, from: data)) ?? []
  }
}
