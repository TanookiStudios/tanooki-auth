#if canImport(ActivityKit)
import ActivityKit
import Foundation

/// The Live Activity shown after copying a code (Premium, Settings > Code on Lock Screen after copying):
/// the account's name, that one code, and a countdown to when it stops working. Started by the app
/// (AppDelegate.swift), drawn by the widget extension (CodeActivityWidget.swift). Never holds a secret.
@available(iOS 16.2, *)
struct CodeActivityAttributes: ActivityAttributes {
  struct ContentState: Codable, Hashable {
    let code: String
    let expires: Date
  }

  let title: String
}
#endif
