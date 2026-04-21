import SwiftUI
import WidgetKit

struct LargeWidgetView: View {
    let entry: SeasonalWidgetEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("In Season")
                        .font(.headline)
                    Text("\(entry.date.formatted(.dateTime.month(.wide))) \u{2022} \(entry.region.displayName)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Text("\(entry.inSeasonItems.count) items")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }

            Divider()

            ForEach(Array(entry.inSeasonItems.prefix(8))) { item in
                HStack(spacing: 10) {
                    Text(item.emoji)
                        .font(.title3)
                    VStack(alignment: .leading, spacing: 1) {
                        Text(item.name)
                            .font(.subheadline.weight(.medium))
                        Text(item.category.rawValue.capitalized)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                }
            }

            Spacer(minLength: 0)
        }
    }
}
