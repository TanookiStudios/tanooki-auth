import AuthenticationServices
import Foundation
import LocalAuthentication
import Security

/// One account as the app hands it to the AutoFill extension (see autofillAccounts in
/// app/lib/core/widget_share.dart). Time-based only; never an account travel mode hides.
struct AutoFillAccount: Codable, Hashable {
  let id: String
  let issuer: String
  let label: String
  let secret: String
  let algorithm: String
  let digits: Int
  let period: Int
  /// "totp" or "steam".
  let type: String?
  /// Websites this account signs in to, as the app stores them ("github.com").
  let domains: [String]
  /// An "ask first" account: kept in a keychain item that needs Face ID / passcode to read.
  var requireAuth: Bool? = nil

  var title: String { issuer.isEmpty ? label : issuer }
  /// What the suggestion above the keyboard says: "GitHub (me)".
  var suggestionLabel: String { issuer.isEmpty || label.isEmpty ? title : "\(issuer) (\(label))" }

  func code(at date: Date) -> String? {
    guard let key = TOTP.base32Decode(secret) else { return nil }
    if type == "steam" { return TOTP.steam(key: key, at: date, period: period) }
    return TOTP.totp(key: key, at: date, period: period, digits: digits, algorithm: algorithm)
  }
}

/// Which accounts fit the website or app asking for a code. Mirrors AutofillMatch.kt (Android).
enum AutoFillMatch {
  /// Words in app ids that say nothing about the service ("com.github.android" -> "github").
  static let filler: Set<String> = ["com", "org", "net", "io", "co", "app", "apps", "android", "ios", "iphone",
                                    "mobile", "www", "client", "official", "inc", "llc", "ltd"]

  /// "https://www.GitHub.com/login" or "www.github.com" -> "github.com".
  static func host(_ s: String) -> String {
    var h = s.lowercased().trimmingCharacters(in: .whitespaces)
    if let r = h.range(of: "://") { h = String(h[r.upperBound...]) }
    h = String(h.prefix { $0 != "/" && $0 != ":" && $0 != "?" && $0 != "#" })
    if h.hasPrefix("www.") { h.removeFirst(4) }
    return h
  }

  /// "GitHub, Inc." -> "githubinc": letters and digits only, for comparing names.
  static func squash(_ s: String) -> String { String(s.lowercased().filter { $0.isLetter || $0.isNumber }) }

  /// The name part of a domain: "github" for "github.com" and "accounts.github.com".
  /// shortcut: takes the label before the last dot, so "bbc.co.uk" gives "co"; fine for name matching only.
  static func siteName(_ domain: String) -> String {
    let parts = host(domain).split(separator: ".")
    return parts.count >= 2 ? String(parts[parts.count - 2]) : parts.first.map(String.init) ?? ""
  }

  /// Names an app id may contain to match this account: its websites' names, else its service name.
  static func names(_ a: AutoFillAccount) -> Set<String> {
    var n = Set(a.domains.map(siteName).filter { !$0.isEmpty })
    let issuer = squash(a.issuer)
    if !issuer.isEmpty { n.insert(issuer) }
    return n
  }

  /// A website (domain or URL): the account's own website or one under it ("accounts.github.com" fits
  /// "github.com"). Accounts with no websites fall back to the service name ("GitHub" fits "github.com").
  static func matches(_ a: AutoFillAccount, site: String) -> Bool {
    let h = host(site)
    guard !h.isEmpty else { return false }
    let domains = a.domains.map(host).filter { !$0.isEmpty }
    if !domains.isEmpty { return domains.contains { h == $0 || h.hasSuffix("." + $0) } }
    return !squash(a.issuer).isEmpty && squash(a.issuer) == siteName(h)
  }

  /// An app, by its id ("com.github.stormbreaker" or "com.valvesoftware.android.steam.community"):
  /// one word of the id is one of the account's names.
  static func matches(_ a: AutoFillAccount, appID: String) -> Bool {
    let words = Set(appID.lowercased().split(separator: ".").map(String.init)).subtracting(filler)
    return !words.isDisjoint(with: names(a))
  }

  /// Accounts that fit any of the service identifiers, most specific identifier first.
  static func ranked(_ accounts: [AutoFillAccount], sites: [String], appIDs: [String] = []) -> [AutoFillAccount] {
    var out: [AutoFillAccount] = []
    for s in sites { for a in accounts where !out.contains(a) && matches(a, site: s) { out.append(a) } }
    for id in appIDs { for a in accounts where !out.contains(a) && matches(a, appID: id) { out.append(a) } }
    return out
  }
}

/// The copy of accounts the AutoFill extension reads, in the keychain group the app shares with its
/// extensions. Two items: plain accounts (readable once the iPhone has been unlocked since restart) and
/// "ask first" accounts (each read needs Face ID or the passcode). Only exists while "Fill codes with
/// AutoFill" is on; the app erases it when that is turned off.
enum AutoFillStore {
  private static let service = "com.tanookistudios.auth.autofill"
  private static let plain = "accounts", askFirst = "ask-first"

  private static func query(_ account: String, group: String?) -> [String: Any] {
    var q: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: service,
      kSecAttrAccount as String: account,
    ]
    if let group { q[kSecAttrAccessGroup as String] = group }
    return q
  }

  /// Replaces both lists from the app's JSON. An empty list erases them. Returns the accounts saved, so
  /// the caller can tell iOS which websites have codes.
  static func save(_ json: Data, group: String?) -> (status: OSStatus, accounts: [AutoFillAccount]) {
    SecItemDelete(query(plain, group: nil) as CFDictionary)
    SecItemDelete(query(askFirst, group: nil) as CFDictionary)
    guard let all = try? JSONDecoder().decode([AutoFillAccount].self, from: json), !all.isEmpty else {
      return (errSecSuccess, [])
    }
    let encoder = JSONEncoder()
    var status = errSecSuccess
    let open = all.filter { $0.requireAuth != true }, guarded = all.filter { $0.requireAuth == true }
    // The plain item also lists ask-first accounts by name (with no secret), so the picker can show them.
    let stubs = guarded.map { AutoFillAccount(id: $0.id, issuer: $0.issuer, label: $0.label, secret: "", algorithm: $0.algorithm,
                                              digits: $0.digits, period: $0.period, type: $0.type, domains: $0.domains, requireAuth: true) }
    if let data = try? encoder.encode(open + stubs) {
      var add = query(plain, group: group)
      add[kSecValueData as String] = data
      add[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
      status = SecItemAdd(add as CFDictionary, nil)
    }
    var saved = open
    // If this fails (no passcode), the stubs above stay; picking one then just finds nothing to fill.
    if !guarded.isEmpty, let data = try? encoder.encode(guarded),
       let access = SecAccessControlCreateWithFlags(nil, kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly, .userPresence, nil) {
      var add = query(askFirst, group: group)
      add[kSecValueData as String] = data
      add[kSecAttrAccessControl as String] = access
      // Fails on an iPhone with no passcode: those accounts are then simply not offered.
      if SecItemAdd(add as CFDictionary, nil) == errSecSuccess { saved += guarded }
    }
    return (status, saved)
  }

  /// The plain accounts, plus ask-first accounts with no secret. Never asks for Face ID.
  static func load(group: String?) -> [AutoFillAccount] { read(plain, group: group, prompt: nil) }

  /// The "ask first" accounts. iOS asks for Face ID or the passcode first, showing [prompt]; empty if
  /// the person cancels or the iPhone has no passcode.
  static func loadAskFirst(group: String?, prompt: String) -> [AutoFillAccount] { read(askFirst, group: group, prompt: prompt) }

  private static func read(_ account: String, group: String?, prompt: String?) -> [AutoFillAccount] {
    var q = query(account, group: group)
    q[kSecReturnData as String] = true
    q[kSecMatchLimit as String] = kSecMatchLimitOne
    if let prompt {
      let context = LAContext()
      context.localizedReason = prompt
      q[kSecUseAuthenticationContext as String] = context
    }
    var out: AnyObject?
    guard SecItemCopyMatching(q as CFDictionary, &out) == errSecSuccess, let data = out as? Data else { return [] }
    return (try? JSONDecoder().decode([AutoFillAccount].self, from: data)) ?? []
  }
}

/// Tells iOS which websites have codes, so it can offer them above the keyboard. Only works while
/// Tanooki Auth is switched on in Settings > General > AutoFill & Passwords; the extension calls this
/// again when it is switched on.
@available(iOS 18.0, *)
enum AutoFillIdentities {
  static func publish(_ accounts: [AutoFillAccount]) {
    let ids: [any ASCredentialIdentity] = accounts.flatMap { a in
      Set(a.domains.map(AutoFillMatch.host)).filter { !$0.isEmpty }.sorted().map {
        ASOneTimeCodeCredentialIdentity(serviceIdentifier: ASCredentialServiceIdentifier(identifier: $0, type: .domain),
                                        label: a.suggestionLabel, recordIdentifier: a.id)
      }
    }
    let store = ASCredentialIdentityStore.shared
    store.getState { state in
      guard state.isEnabled else { return }
      let done: (Bool, Error?) -> Void = { _, error in
        if let error { NSLog("TanookiAutoFill: updating suggestions failed: %@", error.localizedDescription) }
      }
      ids.isEmpty ? store.removeAllCredentialIdentities(done) : store.replaceCredentialIdentities(ids, completion: done)
    }
  }
}
