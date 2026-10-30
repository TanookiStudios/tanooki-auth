import SwiftUI
import WidgetKit

/// Watch face complication (Premium): the code of the one favorite picked on the iPhone (Settings > Watch
/// face favorite), with a countdown. Codes are worked out here on the watch from the favorites copy the
/// watch app keeps in the keychain it shares with this extension; one timeline entry per code, made ahead.
@main
struct TanookiWatchWidgets: WidgetBundle {
  var body: some Widget {
    FavoriteComplication()
  }
}

struct ComplicationEntry: TimelineEntry {
  let date: Date
  let favorite: Favorite?
}

struct ComplicationProvider: TimelineProvider {
  func placeholder(in context: Context) -> ComplicationEntry {
    ComplicationEntry(date: Date(), favorite: Favorite(
      issuer: "GitHub", label: "", secret: "JBSWY3DPEHPK3PXP", algorithm: "sha1", digits: 6, period: 30, type: nil))
  }

  func getSnapshot(in context: Context, completion: @escaping (ComplicationEntry) -> Void) {
    completion(context.isPreview ? placeholder(in: context) : ComplicationEntry(date: Date(), favorite: chosen()))
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<ComplicationEntry>) -> Void) {
    completion(Self.timeline(chosen(), now: Date()))
  }

  /// One entry now, then one at the start of each of the next 60 codes; then WidgetKit asks again.
  /// With nothing chosen: one entry, until the watch app gets new favorites and reloads it.
  static func timeline(_ favorite: Favorite?, now: Date) -> Timeline<ComplicationEntry> {
    guard let favorite else { return Timeline(entries: [ComplicationEntry(date: now, favorite: nil)], policy: .never) }
    let period = Double(max(1, favorite.period))
    let start = (now.timeIntervalSince1970 / period).rounded(.down) * period
    let entries = [ComplicationEntry(date: now, favorite: favorite)]
      + (1...60).map { ComplicationEntry(date: Date(timeIntervalSince1970: start + Double($0) * period), favorite: favorite) }
    return Timeline(entries: entries, policy: .atEnd)
  }

  private func chosen() -> Favorite? {
    FavoriteStore.load(group: FavoriteStore.sharedGroup).first { $0.complication == true }
  }
}

struct FavoriteComplication: Widget {
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: "FavoriteComplication", provider: ComplicationProvider()) { entry in
      ComplicationView(entry: entry)
        .containerBackground(.fill.tertiary, for: .widget)
    }
    .configurationDisplayName("Favorite code")
    .description("One favorite's code. Pick it on your iPhone in Tanooki Auth: Settings > Watch face favorite.")
    .supportedFamilies([.accessoryCircular, .accessoryRectangular, .accessoryInline, .accessoryCorner])
  }
}

struct ComplicationView: View {
  @Environment(\.widgetFamily) private var family
  let entry: ComplicationEntry

  var body: some View {
    if let f = entry.favorite {
      let code = TOTP.grouped(f.code(at: entry.date))
      let period = Double(max(1, f.period))
      let expires = Date(timeIntervalSince1970: (entry.date.timeIntervalSince1970 / period).rounded(.down) * period + period)
      let countdown = Text(timerInterval: entry.date...expires, countsDown: true).monospacedDigit()
      switch family {
      case .accessoryInline:
        Text("\(f.badgedTitle) \(code)").privacySensitive()
      case .accessoryCircular:
        VStack(spacing: 0) {
          Text(code.split(separator: " ").first.map(String.init) ?? code)
          Text(code.split(separator: " ").dropFirst().joined())
        }
        .font(.system(size: 14, weight: .bold, design: .monospaced))
        .privacySensitive()
      case .accessoryCorner:
        Text(code.replacingOccurrences(of: " ", with: ""))
          .font(.system(size: 12, weight: .bold, design: .monospaced))
          .privacySensitive()
          .widgetLabel { countdown }
      default:
        VStack(alignment: .leading, spacing: 0) {
          Text(f.badgedTitle).font(.caption2).foregroundStyle(f.tint ?? .secondary).lineLimit(1).widgetAccentable()
          Text(code).font(.system(.title3, design: .monospaced).weight(.bold)).privacySensitive()
          countdown.font(.caption2).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
      }
    } else {
      switch family {
      case .accessoryRectangular: Text("Pick a favorite in Tanooki Auth on your iPhone").font(.caption2)
      case .accessoryInline: Text("Tanooki Auth")
      default: Image(systemName: "lock.shield")
      }
    }
  }
}
