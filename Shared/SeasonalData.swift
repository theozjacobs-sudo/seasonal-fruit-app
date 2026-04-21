import Foundation

final class SeasonalData {
    static let shared = SeasonalData()

    private(set) var allProduce: [ProduceItem] = []

    private init() {
        loadData()
    }

    private func loadData() {
        // Try main bundle first (app), then look in widget bundle
        guard let url = Bundle.main.url(forResource: "produce_data", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            return
        }
        let decoder = JSONDecoder()
        allProduce = (try? decoder.decode([ProduceItem].self, from: data)) ?? []
    }

    func inSeason(for region: ProduceRegion, month: Int) -> [ProduceItem] {
        allProduce.filter { item in
            item.seasons.contains { window in
                window.region == region.rawValue && window.months.contains(month)
            }
        }
    }

    func comingSoon(for region: ProduceRegion, month: Int) -> [ProduceItem] {
        let nextMonth = (month % 12) + 1
        let currentIDs = Set(inSeason(for: region, month: month).map(\.id))
        return allProduce.filter { item in
            !currentIDs.contains(item.id) &&
            item.seasons.contains { window in
                window.region == region.rawValue && window.months.contains(nextMonth)
            }
        }
    }
}
