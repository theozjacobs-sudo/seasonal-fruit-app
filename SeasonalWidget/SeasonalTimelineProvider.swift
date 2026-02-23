import WidgetKit

struct SeasonalTimelineProvider: TimelineProvider {
    func placeholder(in context: Context) -> SeasonalWidgetEntry {
        SeasonalWidgetEntry(
            date: Date(),
            region: .northAmericaTemperate,
            inSeasonItems: Array(SeasonalData.shared.allProduce.prefix(6)),
            highlightedItem: SeasonalData.shared.allProduce.first
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (SeasonalWidgetEntry) -> Void) {
        completion(makeEntry(for: Date()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SeasonalWidgetEntry>) -> Void) {
        var entries: [SeasonalWidgetEntry] = []
        let calendar = Calendar.current
        let now = Date()

        for dayOffset in 0..<7 {
            guard let entryDate = calendar.date(byAdding: .day, value: dayOffset, to: now) else { continue }
            entries.append(makeEntry(for: entryDate))
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

    private func makeEntry(for date: Date) -> SeasonalWidgetEntry {
        let region = SharedDataManager.shared.currentRegion
        let month = Calendar.current.component(.month, from: date)
        let items = SeasonalData.shared.inSeason(for: region, month: month)

        // Use a deterministic "random" based on day so it changes daily
        let day = Calendar.current.component(.day, from: date)
        let highlighted = items.isEmpty ? nil : items[day % items.count]

        return SeasonalWidgetEntry(
            date: date,
            region: region,
            inSeasonItems: items,
            highlightedItem: highlighted
        )
    }
}
