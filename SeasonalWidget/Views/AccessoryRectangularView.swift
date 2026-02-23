import SwiftUI
import WidgetKit

struct AccessoryRectangularView: View {
    let entry: SeasonalWidgetEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("In Season")
                .font(.headline)
                .widgetAccentable()

            HStack(spacing: 6) {
                ForEach(Array(entry.inSeasonItems.prefix(3))) { item in
                    HStack(spacing: 2) {
                        Text(item.emoji)
                            .font(.caption2)
                        Text(item.name)
                            .font(.caption2)
                            .lineLimit(1)
                    }
                }
            }
        }
    }
}
