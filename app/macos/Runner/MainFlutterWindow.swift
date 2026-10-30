import Cocoa
import FlutterMacOS
import ScreenCaptureKit

class MainFlutterWindow: NSWindow {
  private var channel: FlutterMethodChannel?
  private var statusItem: NSStatusItem?
  private let pasteOnce = PasteOnce()

  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)
    self.contentMinSize = NSSize(width: 360, height: 480)

    RegisterGeneratedPlugins(registry: flutterViewController)

    let channel = FlutterMethodChannel(name: "tanooki/window", binaryMessenger: flutterViewController.engine.binaryMessenger)
    self.channel = channel
    channel.setMethodCallHandler { [weak self] call, result in
        switch call.method {
        case "focus":
          // Lets the app come to the front when the browser extension asks for a confirmation.
          NSApp.activate(ignoringOtherApps: true)
          self?.makeKeyAndOrderFront(nil)
          result(nil)
        case "setSecure":
          // Keeps the window out of screenshots and screen sharing.
          self?.sharingType = (call.arguments as? Bool ?? false) ? .none : .readOnly
          result(nil)
        case "copyOnce":
          // "Clear after one paste": see PasteOnce.swift.
          self?.pasteOnce.copy(call.arguments as? String ?? "")
          result(nil)
        case "clearOnce":
          self?.pasteOnce.clear()
          result(nil)
        case "captureScreen":
          MainFlutterWindow.captureScreens(result)
        case "typeText":
          MainFlutterWindow.typeText(call.arguments as? String ?? "", result)
        case "typePlan":
          // What typeText would do, without pressing anything: lets tests check the keys and the permission state.
          result([
            "trusted": MainFlutterWindow.canType(),
            "axTrusted": AXIsProcessTrusted(),
            "events": MainFlutterWindow.keyEvents(call.arguments as? String ?? "").map { [Int($0.unit), $0.down] as [Any] },
          ])
        case "requestTypeAccess":
          // Only after the user clicked "Open System Settings": shows the system prompt and lists the app under Accessibility.
          CGRequestPostEventAccess()
          result(nil)
        case "trayStatus":
          result(self?.statusItem?.button?.image != nil && self?.statusItem?.isVisible == true)
        case "trayClick":
          // Same path as a real click on the menu bar icon.
          self?.statusItem?.button?.performClick(nil)
          result(nil)
        case "setDockIcon":
          // Premium app icon: changes the Dock icon while the app runs (nil puts the bundle icon back).
          // macOS has no lasting switch for this, so the app sets it again at every launch.
          let data = (call.arguments as? FlutterStandardTypedData)?.data
          let image = data.flatMap(NSImage.init(data:))
          if data != nil && image == nil {
            return result(FlutterError(code: "badImage", message: nil, details: nil))
          }
          NSApp.applicationIconImage = image
          result(nil)
        default:
          result(FlutterMethodNotImplemented)
        }
      }

    // Lock on sleep: the screen locking, the Mac going to sleep, or the display sleeping tells the app, which
    // locks itself if "Lock when the computer sleeps" is on.
    let lockNow: (Notification) -> Void = { [weak self] _ in self?.channel?.invokeMethod("screenLocked", arguments: nil) }
    DistributedNotificationCenter.default().addObserver(
      forName: NSNotification.Name("com.apple.screenIsLocked"), object: nil, queue: .main, using: lockNow)
    for name in [NSWorkspace.willSleepNotification, NSWorkspace.screensDidSleepNotification, NSWorkspace.sessionDidResignActiveNotification] {
      NSWorkspace.shared.notificationCenter.addObserver(forName: name, object: nil, queue: .main, using: lockNow)
    }

    // Menu bar icon: a click opens the quick pick list (search, click to copy, Type).
    let item = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    item.button?.image = NSImage(systemSymbolName: "lock.shield", accessibilityDescription: "Tanooki Auth")
    item.button?.toolTip = "Tanooki Auth"
    item.button?.target = self
    item.button?.action = #selector(statusItemClicked)
    statusItem = item

    super.awakeFromNib()
  }

  @objc private func statusItemClicked() {
    NSApp.activate(ignoringOtherApps: true)
    makeKeyAndOrderFront(nil)
    channel?.invokeMethod("trayClicked", arguments: nil)
  }

  /// Types [text] into the app that was in front before Tanooki Auth. Needs the Accessibility permission
  /// ("denied" until the user allows it). Never types into Tanooki Auth itself ("self").
  static func typeText(_ text: String, _ result: @escaping FlutterResult) {
    // No system prompt here: the app explains first, and asks the system only if the user agrees (requestTypeAccess).
    if !canType() {
      return result(FlutterError(code: "denied", message: nil, details: nil))
    }
    NSApp.hide(nil)
    // Give the other app a moment to take focus back before typing.
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
      guard let front = NSWorkspace.shared.frontmostApplication,
        front.processIdentifier != ProcessInfo.processInfo.processIdentifier
      else {
        NSApp.unhide(nil)
        NSApp.activate(ignoringOtherApps: true)
        return result(FlutterError(code: "self", message: nil, details: nil))
      }
      let source = CGEventSource(stateID: .hidSystemState)
      for key in keyEvents(text) {
        var c = key.unit
        let event = CGEvent(keyboardEventSource: source, virtualKey: 0, keyDown: key.down)
        event?.keyboardSetUnicodeString(stringLength: 1, unicodeString: &c)
        event?.post(tap: .cghidEventTap)
      }
      result(nil)
    }
  }

  /// Whether macOS lets the app press keys (System Settings > Privacy & Security > Accessibility).
  static func canType() -> Bool { CGPreflightPostEventAccess() }

  /// One key down and one key up per UTF-16 unit, carrying the character itself.
  static func keyEvents(_ text: String) -> [(unit: UniChar, down: Bool)] {
    text.utf16.flatMap { [(unit: $0, down: true), (unit: $0, down: false)] }
  }

  /// PNGs of every display, without Tanooki Auth's own windows. Needs the Screen Recording permission.
  static func captureScreens(_ result: @escaping FlutterResult) {
    if !CGPreflightScreenCaptureAccess() {
      CGRequestScreenCaptureAccess() // shows the system prompt the first time only
      return result(FlutterError(code: "denied", message: nil, details: nil))
    }
    guard #available(macOS 14.0, *) else {
      return result(FlutterError(code: "unsupported", message: "Needs macOS 14", details: nil))
    }
    Task {
      do {
        let content = try await SCShareableContent.excludingDesktopWindows(false, onScreenWindowsOnly: true)
        let me = content.applications.filter { $0.bundleIdentifier == Bundle.main.bundleIdentifier }
        var shots: [FlutterStandardTypedData] = []
        for display in content.displays {
          let filter = SCContentFilter(display: display, excludingApplications: me, exceptingWindows: [])
          let config = SCStreamConfiguration()
          config.width = Int(filter.contentRect.width * CGFloat(filter.pointPixelScale))
          config.height = Int(filter.contentRect.height * CGFloat(filter.pointPixelScale))
          config.showsCursor = false
          let image = try await SCScreenshotManager.captureImage(contentFilter: filter, configuration: config)
          if let png = NSBitmapImageRep(cgImage: image).representation(using: .png, properties: [:]) {
            shots.append(FlutterStandardTypedData(bytes: png))
          }
        }
        await MainActor.run { result(shots) }
      } catch {
        await MainActor.run { result(FlutterError(code: "failed", message: error.localizedDescription, details: nil)) }
      }
    }
  }
}
