// Native half of Tanooki Auth sync and phone link.
//   tanooki/icloud: available, list, read, write, delete inside iCloud Drive's app container
//                   (iCloud.com.tanookistudios.auth, folder Documents/TanookiAuthSync). Files hold only
//                   ciphertext; the app encrypts before it writes.
//   tanooki/push:   register -> APNs device token (hex), iOS only.
//   tanooki/folder: see FolderAccess.swift.
//   tanooki/spotlight: see Spotlight.swift.
#if os(iOS)
import Flutter
import UIKit
import UserNotifications
#else
import AppKit
import FlutterMacOS
#endif

struct CloudError: Error {
  let code: String
  let message: String
}

public class TanookiCloudPlugin: NSObject, FlutterPlugin {
  static let containerId = "iCloud.com.tanookistudios.auth"
  private let queue = DispatchQueue(label: "tanooki.icloud")
  private var root: URL?
  #if os(iOS)
  private var pushResult: FlutterResult?
  #endif

  public static func register(with registrar: FlutterPluginRegistrar) {
    #if os(iOS)
    let messenger = registrar.messenger()
    #else
    let messenger = registrar.messenger
    #endif
    let instance = TanookiCloudPlugin()
    registrar.addMethodCallDelegate(instance, channel: FlutterMethodChannel(name: "tanooki/icloud", binaryMessenger: messenger))
    FolderAccess.register(with: registrar) // tanooki/folder: automatic backups' folder (FolderAccess.swift)
    Spotlight.register(with: registrar) // tanooki/spotlight: account names in Spotlight (Spotlight.swift)
    #if os(iOS)
    registrar.addMethodCallDelegate(instance, channel: FlutterMethodChannel(name: "tanooki/push", binaryMessenger: messenger))
    registrar.addApplicationDelegate(instance)
    #endif
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let args = call.arguments as? [String: Any] ?? [:]
    let path = args["path"] as? String ?? ""
    #if os(iOS)
    if call.method == "register" { return registerForPush(result) }
    #endif
    queue.async {
      let reply: Any?
      do {
        switch call.method {
        case "available":
          // "ok"; "signedOut" (no iCloud account or iCloud Drive off); "notEnabled" (this build has no
          // iCloud entitlement, so the container can't be opened).
          reply = self.folder() != nil ? "ok" : FileManager.default.ubiquityIdentityToken == nil ? "signedOut" : "notEnabled"
        case "list": reply = try self.list(path)
        case "read": reply = try self.read(path)
        case "write": try self.write(path, args["text"] as? String ?? ""); reply = nil
        case "delete": try self.delete(path); reply = nil
        default: return DispatchQueue.main.async { result(FlutterMethodNotImplemented) }
        }
      } catch let e as CloudError {
        reply = FlutterError(code: e.code, message: e.message, details: nil)
      } catch {
        reply = FlutterError(code: "io", message: error.localizedDescription, details: nil)
      }
      DispatchQueue.main.async { result(reply) }
    }
  }

  // MARK: iCloud Drive

  /// The sync folder, or nil when iCloud Drive isn't usable (signed out, iCloud Drive off, or this build
  /// has no iCloud entitlement). Slow the first time, so only called on `queue`.
  private func folder() -> URL? {
    if let root { return root }
    guard FileManager.default.ubiquityIdentityToken != nil,
      let container = FileManager.default.url(forUbiquityContainerIdentifier: Self.containerId)
    else { return nil }
    let url = container.appendingPathComponent("Documents/TanookiAuthSync", isDirectory: true)
    try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
    root = url
    return url
  }

  private func url(_ path: String) throws -> URL {
    guard let base = folder() else {
      throw CloudError(code: "unavailable", message: "iCloud Drive isn't available")
    }
    guard !path.split(separator: "/").contains("..") else {
      throw CloudError(code: "badPath", message: path)
    }
    return path.isEmpty ? base : base.appendingPathComponent(path)
  }

  /// File names in a folder. Files iCloud hasn't downloaded yet show up as ".name.icloud"; those are
  /// listed under their real name and their download is started.
  private func list(_ path: String) throws -> [String] {
    let dir = try url(path)
    let items = (try? FileManager.default.contentsOfDirectory(atPath: dir.path)) ?? []
    return items.compactMap { name in
      if name.hasPrefix("."), name.hasSuffix(".icloud") {
        let real = String(name.dropFirst().dropLast(7))
        try? FileManager.default.startDownloadingUbiquitousItem(at: dir.appendingPathComponent(real))
        return real
      }
      return name.hasPrefix(".") ? nil : name
    }
  }

  private func coordinated(_ u: URL, writing: Bool, _ body: (URL) throws -> Void) throws {
    var coordError: NSError?
    var bodyError: Error?
    let c = NSFileCoordinator(filePresenter: nil)
    if writing {
      c.coordinate(writingItemAt: u, options: .forReplacing, error: &coordError) { do { try body($0) } catch { bodyError = error } }
    } else {
      c.coordinate(readingItemAt: u, options: [], error: &coordError) { do { try body($0) } catch { bodyError = error } }
    }
    if let e = coordError ?? bodyError { throw e }
  }

  /// Contents of a file, waiting up to 15 s for iCloud to download it. Nil if it doesn't exist.
  private func read(_ path: String) throws -> String? {
    let u = try url(path)
    let placeholder = u.deletingLastPathComponent().appendingPathComponent(".\(u.lastPathComponent).icloud")
    if !FileManager.default.fileExists(atPath: u.path) {
      guard FileManager.default.fileExists(atPath: placeholder.path) else { return nil }
      try? FileManager.default.startDownloadingUbiquitousItem(at: u)
      for _ in 0..<30 where !FileManager.default.fileExists(atPath: u.path) { Thread.sleep(forTimeInterval: 0.5) }
      guard FileManager.default.fileExists(atPath: u.path) else {
        throw CloudError(code: "downloading", message: "iCloud is still downloading \(u.lastPathComponent)")
      }
    }
    var text: String?
    try coordinated(u, writing: false) { text = try String(contentsOf: $0, encoding: .utf8) }
    return text
  }

  private func write(_ path: String, _ text: String) throws {
    let u = try url(path)
    try FileManager.default.createDirectory(at: u.deletingLastPathComponent(), withIntermediateDirectories: true)
    try coordinated(u, writing: true) { try Data(text.utf8).write(to: $0, options: .atomic) }
  }

  private func delete(_ path: String) throws {
    let u = try url(path)
    guard FileManager.default.fileExists(atPath: u.path) else { return }
    var coordError: NSError?
    var bodyError: Error?
    NSFileCoordinator(filePresenter: nil).coordinate(writingItemAt: u, options: .forDeleting, error: &coordError) {
      do { try FileManager.default.removeItem(at: $0) } catch { bodyError = error }
    }
    if let e = coordError ?? bodyError { throw e }
  }

  // MARK: Push (iOS)

  #if os(iOS)
  private func registerForPush(_ result: @escaping FlutterResult) {
    let center = UNUserNotificationCenter.current()
    // The relay's alert uses this category (relay/PROTOCOL.md 2.6); tapping it opens the app.
    center.setNotificationCategories([UNNotificationCategory(identifier: "TA_FILL_REQUEST", actions: [], intentIdentifiers: [])])
    center.requestAuthorization(options: [.alert, .sound]) { granted, error in
      DispatchQueue.main.async {
        guard granted else {
          return result(FlutterError(code: "denied", message: error?.localizedDescription, details: nil))
        }
        self.pushResult?(FlutterError(code: "superseded", message: nil, details: nil))
        self.pushResult = result
        UIApplication.shared.registerForRemoteNotifications()
        DispatchQueue.main.asyncAfter(deadline: .now() + 20) {
          self.pushResult?(FlutterError(code: "timeout", message: "iPhone didn't hand out a notification token", details: nil))
          self.pushResult = nil
        }
      }
    }
  }

  public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    pushResult?(deviceToken.map { String(format: "%02x", $0) }.joined())
    pushResult = nil
  }

  public func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    pushResult?(FlutterError(code: "failed", message: error.localizedDescription, details: nil))
    pushResult = nil
  }
  #endif
}
