import SwiftUI
import WidgetKit

@main
struct TanookiWidgets: WidgetBundle {
  var body: some Widget {
    FavoritesWidget()
    if #available(iOS 18.0, *) {
      ScanControl()
    }
  }
}

struct FavoritesEntry: TimelineEntry {
  let date: Date
  let favorites: [Favorite]
}

struct FavoritesProvider: TimelineProvider {
  func placeholder(in context: Context) -> FavoritesEntry {
    FavoritesEntry(date: Date(), favorites: [
      Favorite(issuer: "GitHub", label: "", secret: "JBSWY3DPEHPK3PXP", algorithm: "sha1", digits: 6, period: 30, type: nil),
    ])
  }

  func getSnapshot(in context: Context, completion: @escaping (FavoritesEntry) -> Void) {
    completion(context.isPreview ? placeholder(in: context) : FavoritesEntry(date: Date(), favorites: load()))
  }

  /// One entry per 30-second step for the next 10 minutes, then WidgetKit asks again.
  func getTimeline(in context: Context, completion: @escaping (Timeline<FavoritesEntry>) -> Void) {
    let favorites = load()
    let now = Date()
    let start = (now.timeIntervalSince1970 / 30).rounded(.down) * 30
    let entries = [FavoritesEntry(date: now, favorites: favorites)]
      + (1...20).map { FavoritesEntry(date: Date(timeIntervalSince1970: start + Double($0) * 30), favorites: favorites) }
    completion(Timeline(entries: entries, policy: .atEnd))
  }

  private func load() -> [Favorite] { FavoriteStore.load(group: FavoriteStore.sharedGroup) }
}

struct FavoritesWidget: Widget {
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: "Favorites", provider: FavoritesProvider()) { entry in
      FavoritesView(entry: entry)
        .containerBackground(.fill.tertiary, for: .widget)
    }
    .configurationDisplayName("Favorite codes")
    .description("Codes for the accounts you starred. Turn on Settings > Show codes on widgets and watch in Tanooki Auth.")
    .supportedFamilies([.systemSmall, .systemMedium, .systemLarge, .accessoryRectangular, .accessoryInline, .accessoryCircular])
  }
}

struct FavoritesView: View {
  @Environment(\.widgetFamily) private var family
  let entry: FavoritesEntry

  private var limit: Int {
    switch family {
    case .systemSmall: return 2
    case .systemMedium: return 3
    case .systemLarge: return 7
    case .accessoryRectangular: return 2
    default: return 1
    }
  }

  private func code(_ f: Favorite) -> String { TOTP.grouped(f.code(at: entry.date)) }

  /// When this favorite's code changes next.
  private func expiry(_ f: Favorite) -> Date {
    let t = entry.date.timeIntervalSince1970
    return Date(timeIntervalSince1970: (t / Double(f.period)).rounded(.down) * Double(f.period) + Double(f.period))
  }

  var body: some View {
    let shown = Array(entry.favorites.prefix(limit))
    if shown.isEmpty {
      switch family {
      case .accessoryInline: Text("Star a favorite in Tanooki Auth")
      case .accessoryCircular: Image(systemName: "star")
      default:
        Text("Star an account in Tanooki Auth, then turn on Settings > Show codes on widgets and watch.")
          .font(.caption)
      }
    } else {
      switch family {
      case .accessoryInline:
        // Codes are hidden on the Lock Screen while the phone is locked.
        Text("\(shown[0].title) \(code(shown[0]))").privacySensitive()
      case .accessoryCircular:
        VStack(spacing: 0) {
          Text(String(code(shown[0]).prefix(4)))
          Text(String(code(shown[0]).dropFirst(4)))
        }
        .font(.system(size: 13, weight: .bold, design: .monospaced))
        .privacySensitive()
      default:
        VStack(alignment: .leading, spacing: family == .accessoryRectangular ? 0 : 6) {
          ForEach(shown, id: \.self) { f in
            HStack(alignment: .firstTextBaseline) {
              VStack(alignment: .leading, spacing: 0) {
                Text(f.title).font(.caption2).foregroundStyle(.secondary).lineLimit(1)
                Text(code(f))
                  .font(.system(family == .accessoryRectangular ? .body : .title3, design: .monospaced).weight(.bold))
                  .privacySensitive()
              }
              Spacer(minLength: 4)
              if family != .accessoryRectangular {
                Text(timerInterval: entry.date...expiry(f), countsDown: true)
                  .font(.caption2.monospacedDigit())
                  .foregroundStyle(.secondary)
                  .frame(width: 30, alignment: .trailing)
              }
            }
          }
          Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
      }
    }
  }
}
