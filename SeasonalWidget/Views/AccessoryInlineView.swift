import SwiftUI
import WidgetKit

struct AccessoryInlineView: View {
    let entry: SeasonalWidgetEntry

    var body: some View {
        if let item = entry.highlightedItem {
            Text("\(item.emoji) \(item.name) season!")
        } else {
            Text("Seasonal Produce")
        }
    }
}
