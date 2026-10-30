import Flutter
import UIKit

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
