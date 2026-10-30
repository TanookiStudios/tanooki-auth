import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }

  // A tapped Spotlight result. The tanooki_cloud plugin (Spotlight.swift) listens for this notification,
  // since macOS plugins aren't told about user activities.
  override func application(_ application: NSApplication, continue userActivity: NSUserActivity,
                            restorationHandler: @escaping ([NSUserActivityRestoring]) -> Void) -> Bool {
    NotificationCenter.default.post(name: Notification.Name("TanookiSpotlightOpen"), object: userActivity)
    return true
  }
}
