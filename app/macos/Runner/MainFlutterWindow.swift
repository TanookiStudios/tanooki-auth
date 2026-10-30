import Cocoa
import FlutterMacOS
import ScreenCaptureKit

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)
    self.contentMinSize = NSSize(width: 360, height: 480)

    RegisterGeneratedPlugins(registry: flutterViewController)

    FlutterMethodChannel(name: "tanooki/window", binaryMessenger: flutterViewController.engine.binaryMessenger)
      .setMethodCallHandler { [weak self] call, result in
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
        default:
          result(FlutterMethodNotImplemented)
        }
      }

    super.awakeFromNib()
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
