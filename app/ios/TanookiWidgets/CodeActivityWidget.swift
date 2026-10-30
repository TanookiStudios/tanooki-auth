import ActivityKit
import SwiftUI
import WidgetKit

/// Lock Screen and Dynamic Island view for CodeActivityAttributes (ios/Shared/CodeActivity.swift).
struct CodeActivityWidget: Widget {
  var body: some WidgetConfiguration {
    ActivityConfiguration(for: CodeActivityAttributes.self) { context in
      HStack {
        VStack(alignment: .leading, spacing: 2) {
          Text(context.attributes.title).font(.caption).foregroundStyle(.secondary).lineLimit(1)
          code(context)
            .font(.system(.title, design: .monospaced).weight(.bold))
        }
        Spacer()
        countdown(context).font(.title3.monospacedDigit()).frame(width: 64, alignment: .trailing)
      }
      .padding()
      .activityBackgroundTint(nil)
    } dynamicIsland: { context in
      DynamicIsland {
        DynamicIslandExpandedRegion(.leading) {
          Text(context.attributes.title).font(.caption).lineLimit(1)
        }
        DynamicIslandExpandedRegion(.trailing) {
          countdown(context).font(.caption.monospacedDigit()).frame(width: 44, alignment: .trailing)
        }
        DynamicIslandExpandedRegion(.bottom) {
          code(context).font(.system(.title2, design: .monospaced).weight(.bold))
        }
      } compactLeading: {
        Image(systemName: "lock.shield")
      } compactTrailing: {
        countdown(context).font(.caption2.monospacedDigit()).frame(width: 34)
      } minimal: {
        Image(systemName: "lock.shield")
      }
    }
  }

  /// The code, or "Expired" once its time is up (the app also ends the activity then).
  @ViewBuilder
  private func code(_ context: ActivityViewContext<CodeActivityAttributes>) -> some View {
    if context.isStale {
      Text("Expired")
    } else {
      Text(TOTP.grouped(context.state.code)).privacySensitive()
    }
  }

  private func countdown(_ context: ActivityViewContext<CodeActivityAttributes>) -> some View {
    Text(timerInterval: Date()...max(Date(), context.state.expires), countsDown: true)
  }
}
