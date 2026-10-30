import AppKit

/// "Clear after one paste" (Settings, Mac). The code goes on the pasteboard as a promise: macOS asks us for
/// the text only when something pastes it. We hand it over that once, then empty the pasteboard a moment
/// later (the pasting app may read it more than once within the same paste).
/// Checked by scripts/check-paste-once.sh, which reads a pasteboard twice from another process.
final class PasteOnce: NSObject, NSPasteboardItemDataProvider {
  private let pasteboard: NSPasteboard
  private var code: String?
  private var ours = -1 // the pasteboard's changeCount right after we wrote; anything else means someone copied since

  init(pasteboard: NSPasteboard = .general) {
    self.pasteboard = pasteboard
  }

  func copy(_ code: String) {
    self.code = code
    pasteboard.clearContents()
    let item = NSPasteboardItem()
    item.setDataProvider(self, forTypes: [.string])
    pasteboard.writeObjects([item])
    ours = pasteboard.changeCount
  }

  /// Empties the pasteboard if it still holds our code, without reading it (a read would count as the paste).
  func clear() {
    code = nil
    if pasteboard.changeCount == ours { pasteboard.clearContents() }
  }

  func pasteboard(_ pasteboard: NSPasteboard?, item: NSPasteboardItem, provideDataForType type: NSPasteboard.PasteboardType) {
    guard let code else { return }
    item.setString(code, forType: type)
    self.code = nil
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in self?.clear() }
  }

  func pasteboardFinishedWithDataProvider(_ pasteboard: NSPasteboard) {}
}
