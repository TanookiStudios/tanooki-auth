import SwiftUI
import WidgetKit

/// Control Center (and Lock Screen / Action button) control that opens Tanooki Auth's QR scanner.
@available(iOS 18.0, *)
struct ScanControl: ControlWidget {
  var body: some ControlWidgetConfiguration {
    StaticControlConfiguration(kind: "com.tanookistudios.auth.scan") {
      ControlWidgetButton(action: OpenScannerIntent()) {
        Label("Scan 2FA QR", systemImage: "qrcode.viewfinder")
      }
    }
    .displayName("Scan 2FA QR")
    .description("Opens Tanooki Auth's camera to add an account.")
  }
}
