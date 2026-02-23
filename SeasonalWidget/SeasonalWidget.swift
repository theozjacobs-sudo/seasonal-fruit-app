import WidgetKit
import SwiftUI

struct SeasonalWidget: Widget {
    let kind: String = "SeasonalWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: SeasonalTimelineProvider()) { entry in
            SeasonalWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Seasonal Produce")
        .description("See what fruits and vegetables are in season right now.")
        .supportedFamilies([
            .systemSmall,
            .systemMedium,
            .systemLarge,
            .accessoryCircular,
            .accessoryRectangular
        ])
    }
}
