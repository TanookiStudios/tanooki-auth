// tanooki/spotlight: account names in Spotlight search (iOS, macOS), the native half of
// app/lib/core/spotlight.dart.
//   index(json)  replaces every item with [{id, issuer, label}]; "[]" removes them all. Names only: the
//                app never sends codes or secrets here.
//   takeOpen     the account id of a tapped result the app hasn't handled yet, or nil (read once).
// A tapped result reaches the app as an NSUserActivity: through the scene delegate on iOS, and through
// Notification "TanookiSpotlightOpen" posted by the Mac app's AppDelegate (macOS plugins can't see it).
import CoreSpotlight
#if os(iOS)
import Flutter
import UIKit
import UniformTypeIdentifiers
#else
import AppKit
import FlutterMacOS
import UniformTypeIdentifiers
#endif

final class Spotlight: NSObject {
  static let domain = "com.tanookistudios.auth.accounts"
  static let openNotification = Notification.Name("TanookiSpotlightOpen")
  private var channel: FlutterMethodChannel?
  private var pendingOpen: String?

  static func register(with registrar: FlutterPluginRegistrar) {
    #if os(iOS)
    let messenger = registrar.messenger()
    #else
    let messenger = registrar.messenger
    #endif
    let instance = Spotlight()
    let channel = FlutterMethodChannel(name: "tanooki/spotlight", binaryMessenger: messenger)
    instance.channel = channel
    channel.setMethodCallHandler(instance.handle)
    #if os(iOS)
    registrar.addSceneDelegate(instance)
    #else
    NotificationCenter.default.addObserver(forName: openNotification, object: nil, queue: .main) { note in
      if let activity = note.object as? NSUserActivity { _ = instance.open(activity) }
    }
    #endif
  }

  private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "index":
      let json = Data((call.arguments as? String ?? "[]").utf8)
      let list = (try? JSONSerialization.jsonObject(with: json)) as? [[String: String]] ?? []
      Self.replaceAll(list) { error in
        DispatchQueue.main.async {
          error == nil ? result(nil) : result(FlutterError(code: "index", message: error!.localizedDescription, details: nil))
        }
      }
    case "takeOpen":
      result(pendingOpen)
      pendingOpen = nil
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  /// Deletes every Tanooki Auth item, then adds [list]. Account ids are the item ids.
  static func replaceAll(_ list: [[String: String]], completion: @escaping (Error?) -> Void) {
    let index = CSSearchableIndex.default()
    index.deleteSearchableItems(withDomainIdentifiers: [domain]) { error in
      if let error { return completion(error) }
      guard !list.isEmpty else { return completion(nil) }
      let items = list.compactMap { a -> CSSearchableItem? in
        guard let id = a["id"] else { return nil }
        let issuer = a["issuer"] ?? "", label = a["label"] ?? ""
        let attrs = CSSearchableItemAttributeSet(contentType: .content)
        attrs.title = issuer.isEmpty ? label : issuer
        attrs.contentDescription = issuer.isEmpty ? "Tanooki Auth" : label.isEmpty ? "Tanooki Auth" : "\(label) · Tanooki Auth"
        attrs.keywords = [issuer, label, "2FA", "code"].filter { !$0.isEmpty }
        return CSSearchableItem(uniqueIdentifier: id, domainIdentifier: domain, attributeSet: attrs)
      }
      index.indexSearchableItems(items, completionHandler: completion)
    }
  }

  /// A tapped Spotlight result: remember its account id and tell the app. False for other activities.
  func open(_ activity: NSUserActivity) -> Bool {
    guard activity.activityType == CSSearchableItemActionType,
      let id = activity.userInfo?[CSSearchableItemActivityIdentifier] as? String
    else { return false }
    pendingOpen = id
    channel?.invokeMethod("open", arguments: nil)
    return true
  }
}

#if os(iOS)
extension Spotlight: FlutterSceneLifeCycleDelegate {
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions?) -> Bool {
    (connectionOptions?.userActivities ?? []).contains { open($0) }
  }

  func scene(_ scene: UIScene, continue userActivity: NSUserActivity) -> Bool {
    open(userActivity)
  }
}
#endif
