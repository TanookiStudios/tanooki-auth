import Cocoa
import FlutterMacOS
import ScreenCaptureKit

class MainFlutterWindow: NSWindow {
  private var channel: FlutterMethodChannel?
  private var statusItem: NSStatusItem?

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
        case "captureScreen":
          MainFlutterWindow.captureScreens(result)
        case "typeText":
          MainFlutterWindow.typeText(call.arguments as? String ?? "", result)
        default:
          result(FlutterMethodNotImplemented)
        }
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
    if !CGPreflightPostEventAccess() {
      CGRequestPostEventAccess() // the system asks once; after that the app explains where the switch is
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
      for unit in text.utf16 {
        var c = unit
        for down in [true, false] {
          let event = CGEvent(keyboardEventSource: source, virtualKey: 0, keyDown: down)
          event?.keyboardSetUnicodeString(stringLength: 1, unicodeString: &c)
          event?.post(tap: .cghidEventTap)
        }
      }
      result(nil)
    }
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
