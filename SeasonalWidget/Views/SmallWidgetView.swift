import SwiftUI
import WidgetKit

struct SmallWidgetView: View {
    let entry: SeasonalWidgetEntry

    var body: some View {
        if let item = entry.highlightedItem {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.emoji)
                    .font(.system(size: 40))

                Spacer()

                Text(item.name)
                    .font(.headline)
                    .lineLimit(1)
                Text("In Season")
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
                Text(entry.region.displayName)
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        } else {
            VStack {
                Image(systemName: "leaf.fill")
                    .font(.largeTitle)
                    .foregroundStyle(.green)
                Text("No data")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
