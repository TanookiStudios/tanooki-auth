import SwiftUI
import WidgetKit

/// Watch face complication (Premium): the code of the one favorite picked on the iPhone (Settings > Watch
/// face favorite), with a countdown. Codes are worked out here on the watch from the favorites copy the
/// watch app keeps in the keychain it shares with this extension; one timeline entry per code, made ahead.
/// Plus a Smart Stack widget (see FavoriteSmartStack) built from the same pieces.
@main
struct TanookiWatchWidgets: WidgetBundle {
  var body: some Widget {
    FavoriteComplication()
    FavoriteSmartStack()
  }
}

struct ComplicationEntry: TimelineEntry {
  let date: Date
  let favorite: Favorite?
  var relevance: TimelineEntryRelevance? = nil
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

/// Smart Stack widget: a favorite's code and countdown (see SmartStack in Shared/FavoriteStore.swift for
/// which one). Right after the iPhone copies a favorite's code it asks to go on top of the stack. It shows
/// only what the watch already has: no ask-first or travel-hidden accounts, and nothing while the decoy is open.
struct SmartStackProvider: TimelineProvider {
  func placeholder(in context: Context) -> ComplicationEntry { ComplicationProvider().placeholder(in: context) }

  func getSnapshot(in context: Context, completion: @escaping (ComplicationEntry) -> Void) {
    completion(context.isPreview ? placeholder(in: context) : current().entries[0])
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<ComplicationEntry>) -> Void) {
    completion(current())
  }

  private func current() -> Timeline<ComplicationEntry> {
    let group = FavoriteStore.sharedGroup
    return Self.timeline(FavoriteStore.load(group: group), copied: FavoriteStore.loadCopied(group: group), now: Date())
  }

  static func timeline(_ list: [Favorite], copied: FavoriteStore.Copied?, now: Date) -> Timeline<ComplicationEntry> {
    let pick = SmartStack.pick(list, copied: copied, now: now)
    let base = ComplicationProvider.timeline(pick.favorite, now: now)
    let entries = base.entries.map { e in
      let s = SmartStack.score(pick.favorite, boostedUntil: pick.boostedUntil, at: e.date)
      return ComplicationEntry(date: e.date, favorite: e.favorite, relevance: TimelineEntryRelevance(score: s.score, duration: s.duration))
    }
    // When the boost ends, look again, so the watch face favorite comes back.
    return Timeline(entries: entries, policy: pick.boostedUntil.map { .after($0) } ?? base.policy)
  }
}

struct FavoriteSmartStack: Widget {
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: "FavoriteSmartStack", provider: SmartStackProvider()) { entry in
      ComplicationView(entry: entry)
        .containerBackground(.fill.tertiary, for: .widget)
    }
    .configurationDisplayName("Favorite code")
    .description("A favorite's code in the Smart Stack. It comes to the top right after you copy that code on your iPhone.")
    .supportedFamilies([.accessoryRectangular])
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
