// tanooki/folder: a user-picked folder the app can keep writing to after a restart (automatic backups).
//   pick              -> {ref, name} or nil if cancelled. ref is a base64 security-scoped bookmark.
//   bookmark {path}   -> {ref, name} for a folder the app can already reach (integration tests).
//   open {ref}        -> {path, ref}; starts security-scoped access. ref is refreshed when the old one went stale.
//   close {path}      -> stops that access.
// Error codes are the Dart AutoBackupFailure names: folderGone, permissionLost, other.
#if os(iOS)
import Flutter
import UIKit
import UniformTypeIdentifiers
#else
import AppKit
import FlutterMacOS
#endif

struct FolderError: Error {
  let code: String
  let message: String?
}

class FolderAccess: NSObject, FlutterPlugin {
  private var open: [String: URL] = [:]
  #if os(iOS)
  private var pickResult: FlutterResult?
  #endif

  #if os(macOS)
  private static let createOptions: URL.BookmarkCreationOptions = [.withSecurityScope]
  private static let resolveOptions: URL.BookmarkResolutionOptions = [.withSecurityScope, .withoutUI]
  #else
  private static let createOptions: URL.BookmarkCreationOptions = []
  private static let resolveOptions: URL.BookmarkResolutionOptions = [.withoutUI]
  #endif

  static func register(with registrar: FlutterPluginRegistrar) {
    #if os(iOS)
    let messenger = registrar.messenger()
    #else
    let messenger = registrar.messenger
    #endif
    registrar.addMethodCallDelegate(FolderAccess(), channel: FlutterMethodChannel(name: "tanooki/folder", binaryMessenger: messenger))
  }

  func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let args = call.arguments as? [String: Any] ?? [:]
    do {
      switch call.method {
      case "pick": pick(result)
      case "bookmark": result(try bookmark(URL(fileURLWithPath: args["path"] as? String ?? "", isDirectory: true)))
      case "open": result(try openRef(args["ref"] as? String ?? ""))
      case "close":
        if let u = open.removeValue(forKey: args["path"] as? String ?? "") { u.stopAccessingSecurityScopedResource() }
        result(nil)
      default: result(FlutterMethodNotImplemented)
      }
    } catch let e as FolderError {
      result(FlutterError(code: e.code, message: e.message, details: nil))
    } catch {
      result(FlutterError(code: "other", message: error.localizedDescription, details: nil))
    }
  }

  private func bookmark(_ url: URL) throws -> [String: String] {
    do {
      let data = try url.bookmarkData(options: Self.createOptions, includingResourceValuesForKeys: nil, relativeTo: nil)
      return ["ref": data.base64EncodedString(), "name": FileManager.default.displayName(atPath: url.path)]
    } catch {
      throw FolderError(code: "permissionLost", message: error.localizedDescription)
    }
  }

  private func openRef(_ ref: String) throws -> [String: String] {
    guard let data = Data(base64Encoded: ref) else { throw FolderError(code: "folderGone", message: "bad bookmark") }
    var stale = false
    let url: URL
    do {
      url = try URL(resolvingBookmarkData: data, options: Self.resolveOptions, relativeTo: nil, bookmarkDataIsStale: &stale)
    } catch let e as NSError {
      // A bookmark whose folder was deleted (or whose drive is unplugged) fails to resolve, usually as
      // "isn't in the correct format" (NSFileReadCorruptFileError). Only a no-permission error means permission.
      let denied = e.domain == NSCocoaErrorDomain && (e.code == NSFileReadNoPermissionError || e.code == NSFileWriteNoPermissionError)
      throw FolderError(code: denied ? "permissionLost" : "folderGone", message: e.localizedDescription)
    }
    // A bookmark follows a moved folder, including into the Trash; a folder in the Trash counts as gone.
    if url.path.contains("/.Trash/") || !FileManager.default.fileExists(atPath: url.path) {
      throw FolderError(code: "folderGone", message: url.path)
    }
    // Folders the app can already reach (inside its own container) need no security scope.
    let started = url.startAccessingSecurityScopedResource()
    guard started || FileManager.default.isWritableFile(atPath: url.path) else {
      throw FolderError(code: "permissionLost", message: url.path)
    }
    if started {
      if let old = open[url.path] { old.stopAccessingSecurityScopedResource() }
      open[url.path] = url
    }
    let fresh = stale ? (try? bookmark(url))?["ref"] ?? ref : ref
    return ["path": url.path, "ref": fresh]
  }

  #if os(macOS)
  private func pick(_ result: @escaping FlutterResult) {
    let panel = NSOpenPanel()
    panel.canChooseDirectories = true
    panel.canChooseFiles = false
    panel.canCreateDirectories = true
    panel.allowsMultipleSelection = false
    panel.message = "Choose a folder for automatic backups"
    panel.prompt = "Choose"
    guard panel.runModal() == .OK, let url = panel.url else { return result(nil) }
    do { result(try bookmark(url)) } catch let e as FolderError { result(FlutterError(code: e.code, message: e.message, details: nil)) } catch { result(nil) }
  }
  #else
  private func pick(_ result: @escaping FlutterResult) {
    guard let top = Self.topController() else {
      return result(FlutterError(code: "other", message: "no window to show the folder picker in", details: nil))
    }
    pickResult?(nil)
    pickResult = result
    let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.folder])
    picker.delegate = self
    picker.allowsMultipleSelection = false
    top.present(picker, animated: true)
  }

  private static func topController() -> UIViewController? {
    let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
    var top = scenes.flatMap { $0.windows }.first { $0.isKeyWindow }?.rootViewController
    while let presented = top?.presentedViewController { top = presented }
    return top
  }
  #endif
}

#if os(iOS)
extension FolderAccess: UIDocumentPickerDelegate {
  func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
    guard let url = urls.first else { return documentPickerWasCancelled(controller) }
    let scoped = url.startAccessingSecurityScopedResource()
    defer { if scoped { url.stopAccessingSecurityScopedResource() } }
    do { pickResult?(try bookmark(url)) } catch let e as FolderError { pickResult?(FlutterError(code: e.code, message: e.message, details: nil)) } catch { pickResult?(nil) }
    pickResult = nil
  }

  func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
    pickResult?(nil)
    pickResult = nil
  }
}
#endif
