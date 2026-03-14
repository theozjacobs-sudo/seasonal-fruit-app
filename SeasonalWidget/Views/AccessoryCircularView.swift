import SwiftUI
import WidgetKit

struct AccessoryCircularView: View {
    let entry: SeasonalWidgetEntry

    private var totalProduce: Int {
        SeasonalData.shared.allProduce.count
    }

    var body: some View {
        if let item = entry.highlightedItem {
            Gauge(value: Double(entry.inSeasonItems.count),
                  in: 0...Double(max(totalProduce, 1))) {
                Text(item.emoji)
            } currentValueLabel: {
                Text(item.emoji)
                    .font(.system(size: 20))
            }
            .gaugeStyle(.accessoryCircularCapacity)
            .widgetAccentable()
        } else {
            ZStack {
                AccessoryWidgetBackground()
                Image(systemName: "leaf.fill")
            }
        }
    }
}
