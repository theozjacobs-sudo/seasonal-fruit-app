import SwiftUI
import WidgetKit

struct AccessoryRectangularView: View {
    let entry: SeasonalWidgetEntry

    var body: some View {
        HStack(spacing: 8) {
            VStack(alignment: .leading, spacing: 0) {
                Text("\(entry.inSeasonItems.count)")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .widgetAccentable()
                Text("in season")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            Divider()

            VStack(alignment: .leading, spacing: 2) {
                ForEach(Array(entry.inSeasonItems.prefix(3))) { item in
                    HStack(spacing: 3) {
                        Text(item.emoji)
                            .font(.system(size: 10))
                        Text(item.name)
                            .font(.system(size: 10))
                            .lineLimit(1)
                    }
                }
            }
        }
    }
}
