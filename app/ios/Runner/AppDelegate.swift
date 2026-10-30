import ActivityKit
import Flutter
import UIKit
import WatchConnectivity
import WidgetKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    guard let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "TanookiWindow") else { return }
    FlutterMethodChannel(name: "tanooki/window", binaryMessenger: registrar.messenger())
      .setMethodCallHandler { call, result in
        guard call.method == "setSecure" else { return result(FlutterMethodNotImplemented) }
        ScreenShield.set(call.arguments as? Bool ?? false)
        result(nil)
      }
    guard let extrasRegistrar = engineBridge.pluginRegistry.registrar(forPlugin: "TanookiExtras") else { return }
    Extras.shared.attach(extrasRegistrar)
  }
}

/// Widgets, watch and the Control Center button: the native half of app/lib/core/widget_share.dart.
final class Extras: NSObject, FlutterSceneLifeCycleDelegate, WCSessionDelegate {
  static let shared = Extras()
  private var channel: FlutterMethodChannel?
  private var pendingAction: String?
  private var lastFavorites: Data?

  func attach(_ registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "tanooki/extras", binaryMessenger: registrar.messenger())
    channel.setMethodCallHandler { [weak self] call, result in
      guard let self else { return }
      switch call.method {
      case "setFavorites":
        let json = Data((call.arguments as? String ?? "[]").utf8)
        let status = FavoriteStore.save(json, group: FavoriteStore.sharedGroup)
        WidgetCenter.shared.reloadAllTimelines()
        self.sendToWatch(json)
        status == errSecSuccess
          ? result(nil)
          : result(FlutterError(code: "keychain\(status)", message: nil, details: nil))
      case "startCodeActivity":
        guard #available(iOS 16.2, *) else {
          return result(FlutterError(code: "unsupported", message: "Needs iOS 16.2", details: nil))
        }
        CodeActivity.start(call.arguments as? [String: Any] ?? [:], result)
      case "takeAction":
        result(self.pendingAction)
        self.pendingAction = nil
      case "getAppIcon":
        // Alternate icon sets are named AppIcon-<id> in Assets.xcassets; nil is the main icon.
        result(UIApplication.shared.alternateIconName.map { String($0.dropFirst("AppIcon-".count)) } ?? "default")
      case "setAppIcon":
        let id = call.arguments as? String ?? "default"
        guard UIApplication.shared.supportsAlternateIcons else {
          return result(FlutterError(code: "unsupported", message: nil, details: nil))
        }
        // iOS shows its own "You have changed the icon" alert; that's expected.
        UIApplication.shared.setAlternateIconName(id == "default" ? nil : "AppIcon-\(id)") { error in
          DispatchQueue.main.async {
            if let error {
              NSLog("TanookiAppIcon failed: %@", error.localizedDescription)
              result(FlutterError(code: "failed", message: error.localizedDescription, details: nil))
            } else {
              NSLog("TanookiAppIcon set: %@", id)
              result(nil)
            }
          }
        }
      #if DEBUG
      case "debugWidgetCodes":
        // Test-only: the codes the widgets would show right now, worked out by the widget code (never secrets).
        let now = Date()
        result(FavoriteStore.load(group: FavoriteStore.sharedGroup).map { [$0.title, $0.code(at: now)] })
      #endif
      default:
        result(FlutterMethodNotImplemented)
      }
    }
    self.channel = channel
    if #available(iOS 16.2, *) { CodeActivity.endExpired() } // left over from a run that was closed early
    registrar.addSceneDelegate(self)
    if WCSession.isSupported() {
      WCSession.default.delegate = self
      WCSession.default.activate()
    }
  }

  // MARK: Control Center button -> tanookiauth://scan

  private func handle(_ urls: Set<UIOpenURLContext>) -> Bool {
    if let file = urls.first(where: { $0.url.isFileURL && $0.url.pathExtension == "tanookishare" })?.url {
      // A shared account file tapped in Files, Mail or Messages: hand its text to the "Open a shared
      // account" flow. iOS copies it into our Inbox; delete that copy once read.
      let text = (try? String(contentsOf: file, encoding: .utf8)) ?? ""
      try? FileManager.default.removeItem(at: file)
      NSLog("TanookiShareFile: opened %ld bytes", text.utf8.count)
      pendingAction = "share:" + text
      channel?.invokeMethod("action", arguments: nil)
      return true
    }
    guard urls.contains(where: { $0.url.scheme == "tanookiauth" && $0.url.host == "scan" }) else { return false }
    pendingAction = "scan"
    channel?.invokeMethod("action", arguments: nil)
    return true
  }

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions?) -> Bool {
    handle(connectionOptions?.urlContexts ?? [])
  }

  func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) -> Bool {
    handle(URLContexts)
  }

  // MARK: Apple Watch

  /// The latest favorites (or an empty list) go to the watch app; WatchConnectivity keeps only the newest.
  private func sendToWatch(_ json: Data) {
    lastFavorites = json
    // Not gated on isWatchAppInstalled: it can read false for a moment after an update, and a missed
    // "turned off" message would leave codes on the watch. If it fails, the watch-state callback resends.
    guard WCSession.isSupported(), WCSession.default.activationState == .activated, WCSession.default.isPaired
    else { return }
    try? WCSession.default.updateApplicationContext(["favorites": json])
  }

  func session(_ session: WCSession, activationDidCompleteWith state: WCSessionActivationState, error: Error?) {
    if state == .activated, let json = lastFavorites { DispatchQueue.main.async { self.sendToWatch(json) } }
  }

  func sessionDidBecomeInactive(_ session: WCSession) {}

  func sessionDidDeactivate(_ session: WCSession) {
    session.activate() // switched to another watch
  }

  func sessionWatchStateDidChange(_ session: WCSession) {
    if let json = lastFavorites { DispatchQueue.main.async { self.sendToWatch(json) } }
  }
}

/// The copied-code Live Activity (ios/Shared/CodeActivity.swift). Only one at a time; it ends when the
/// code expires. The app keeps running in the background until then (a code lasts 30 s or so), and the
/// activity is marked stale at that moment anyway in case iOS stops the app sooner.
@available(iOS 16.2, *)
enum CodeActivity {
  static func start(_ args: [String: Any], _ result: @escaping FlutterResult) {
    guard ActivityAuthorizationInfo().areActivitiesEnabled else {
      return result(FlutterError(code: "disabled", message: "Live Activities are off for Tanooki Auth", details: nil))
    }
    let expires = Date(timeIntervalSince1970: ((args["expires"] as? NSNumber)?.doubleValue ?? 0) / 1000)
    let state = CodeActivityAttributes.ContentState(code: args["code"] as? String ?? "", expires: expires)
    let attributes = CodeActivityAttributes(title: args["title"] as? String ?? "")
    Task { @MainActor in
      for old in Activity<CodeActivityAttributes>.activities {
        await old.end(nil, dismissalPolicy: .immediate)
      }
      do {
        let activity = try Activity.request(attributes: attributes, content: ActivityContent(state: state, staleDate: expires), pushType: nil)
        endAt(expires, activity)
        result(nil)
      } catch {
        result(FlutterError(code: "failed", message: error.localizedDescription, details: nil))
      }
    }
  }

  private static func endAt(_ expires: Date, _ activity: Activity<CodeActivityAttributes>) {
    var task = UIBackgroundTaskIdentifier.invalid
    task = UIApplication.shared.beginBackgroundTask { UIApplication.shared.endBackgroundTask(task) }
    Task { @MainActor in
      try? await Task.sleep(nanoseconds: UInt64(max(0, expires.timeIntervalSinceNow) * 1_000_000_000))
      await activity.end(nil, dismissalPolicy: .immediate)
      UIApplication.shared.endBackgroundTask(task)
    }
  }

  static func endExpired() {
    Task {
      for a in Activity<CodeActivityAttributes>.activities where a.content.state.expires <= Date() {
        await a.end(nil, dismissalPolicy: .immediate)
      }
    }
  }
}

/// Hides the app from screenshots and screen recording. iOS has no switch for this, so the app's layer is
/// moved inside a password text field's secure layer, which iOS blanks out in every capture.
enum ScreenShield {
  private static var field: UITextField?

  static func set(_ on: Bool) {
    guard let window = UIApplication.shared.connectedScenes
      .compactMap({ $0 as? UIWindowScene })
      .flatMap(\.windows)
      .first(where: \.isKeyWindow) ?? UIApplication.shared.connectedScenes
      .compactMap({ $0 as? UIWindowScene }).first?.windows.first
    else { return }
    if field == nil {
      guard on else { return }
      let f = UITextField()
      f.isSecureTextEntry = true
      f.isUserInteractionEnabled = false
      window.addSubview(f)
      window.layer.superlayer?.addSublayer(f.layer)
      if #available(iOS 17.0, *) {
        f.layer.sublayers?.last?.addSublayer(window.layer)
      } else {
        f.layer.sublayers?.first?.addSublayer(window.layer)
      }
      field = f
    }
    field?.isSecureTextEntry = on
  }
}
