import SwiftUI
import WidgetKit

struct AccessoryCircularView: View {
    let entry: SeasonalWidgetEntry

    var body: some View {
        ZStack {
            AccessoryWidgetBackground()
            if let item = entry.highlightedItem {
                VStack(spacing: 0) {
                    Text(item.emoji)
                        .font(.title3)
                    Text(item.name)
                        .font(.system(size: 8))
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                }
            } else {
                Image(systemName: "leaf.fill")
            }
        }
    }
}
