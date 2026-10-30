import SwiftUI
import WatchConnectivity

/// Apple Watch app: favorites' codes, worked out on the watch. The list arrives from the iPhone app over
/// WatchConnectivity and is kept in the watch's own keychain.
@main
struct TanookiWatchApp: App {
  @StateObject private var link = PhoneLink()

  var body: some Scene {
    WindowGroup {
      ContentView(favorites: link.favorites)
    }
  }
}

final class PhoneLink: NSObject, ObservableObject, WCSessionDelegate {
  @Published var favorites: [Favorite] = FavoriteStore.load(group: nil)

  override init() {
    super.init()
    WCSession.default.delegate = self
    WCSession.default.activate()
    #if DEBUG
    selfTest()
    #endif
  }

  private func store(_ context: [String: Any]) {
    guard let json = context["favorites"] as? Data else { return }
    FavoriteStore.save(json, group: nil)
    let list = FavoriteStore.load(group: nil)
    DispatchQueue.main.async {
      self.favorites = list
      #if DEBUG
      self.selfTest()
      #endif
    }
  }

  func session(_ session: WCSession, activationDidCompleteWith state: WCSessionActivationState, error: Error?) {
    if state == .activated { store(session.receivedApplicationContext) }
  }

  func session(_ session: WCSession, didReceiveApplicationContext context: [String: Any]) {
    store(context)
  }

  #if DEBUG
  /// Test-only (launch with TA_SELFTEST=1): prints the codes on screen so a script can compare them with
  /// the phone's. Codes only, never secrets, and not in release builds.
  private func selfTest() {
    guard ProcessInfo.processInfo.environment["TA_SELFTEST"] == "1" else { return }
    let now = Date()
    print("TA_WATCH_CODES \(Int(now.timeIntervalSince1970)) " + favorites.map { "\($0.title)=\($0.code(at: now))" }.joined(separator: " "))
    fflush(stdout)
  }
  #endif
}

struct ContentView: View {
  let favorites: [Favorite]

  var body: some View {
    TimelineView(.periodic(from: .now, by: 1)) { context in
      if favorites.isEmpty {
        ScrollView {
          Text("No favorites yet.\n\nOn your iPhone, open Tanooki Auth, star an account, and turn on Settings > Show codes on widgets and watch.")
            .font(.footnote)
            .multilineTextAlignment(.center)
        }
      } else {
        List(favorites, id: \.self) { f in
          VStack(alignment: .leading, spacing: 2) {
            Text(f.title).font(.footnote).foregroundStyle(.secondary).lineLimit(1)
            HStack {
              Text(TOTP.grouped(f.code(at: context.date)))
                .font(.system(.title3, design: .monospaced).weight(.bold))
                .privacySensitive()
              Spacer()
              let t = Int(context.date.timeIntervalSince1970)
              Text("\(f.period - t % f.period)s").font(.footnote.monospacedDigit()).foregroundStyle(.secondary)
            }
          }
        }
      }
    }
  }
}
