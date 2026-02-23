import SwiftUI
import WidgetKit

struct MediumWidgetView: View {
    let entry: SeasonalWidgetEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("In Season Now")
                    .font(.headline)
                Spacer()
                Text(entry.date.formatted(.dateTime.month(.wide)))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 12) {
                ForEach(Array(entry.inSeasonItems.prefix(5))) { item in
                    VStack(spacing: 4) {
                        Text(item.emoji)
                            .font(.title2)
                        Text(item.name)
                            .font(.system(size: 10))
                            .lineLimit(1)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }
}
