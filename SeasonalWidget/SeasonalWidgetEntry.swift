import WidgetKit

struct SeasonalWidgetEntry: TimelineEntry {
    let date: Date
    let region: ProduceRegion
    let inSeasonItems: [ProduceItem]
    let highlightedItem: ProduceItem?
}
