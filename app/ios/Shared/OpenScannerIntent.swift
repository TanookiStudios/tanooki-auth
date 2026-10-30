import AppIntents
import Foundation

/// Opens the app on its QR scanner. Built into both the app and the widget extension, as Control Center
/// controls that open the app need.
@available(iOS 18.0, *)
struct OpenScannerIntent: AppIntent {
  static let title: LocalizedStringResource = "Scan 2FA QR code"
  static let description = IntentDescription("Opens Tanooki Auth's camera to add an account.")
  static let openAppWhenRun = true

  @MainActor
  func perform() async throws -> some IntentResult & OpensIntent {
    .result(opensIntent: OpenURLIntent(URL(string: "tanookiauth://scan")!))
  }
}
