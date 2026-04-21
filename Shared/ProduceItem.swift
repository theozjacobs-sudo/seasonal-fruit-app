import Foundation

enum ProduceCategory: String, Codable, CaseIterable {
    case fruit
    case vegetable
}

struct SeasonWindow: Codable, Hashable {
    let region: String
    let months: [Int]
}

struct RipenessTip: Codable, Hashable {
    let title: String
    let description: String
    let sfSymbol: String
}

struct ProduceItem: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let category: ProduceCategory
    let emoji: String
    let colorHex: String
    let seasons: [SeasonWindow]
    let ripenessTips: [RipenessTip]
    let funFact: String
    let storageTip: String
    let iconAsset: String?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        category = try container.decode(ProduceCategory.self, forKey: .category)
        emoji = try container.decode(String.self, forKey: .emoji)
        colorHex = try container.decode(String.self, forKey: .colorHex)
        seasons = try container.decode([SeasonWindow].self, forKey: .seasons)
        ripenessTips = try container.decode([RipenessTip].self, forKey: .ripenessTips)
        funFact = try container.decode(String.self, forKey: .funFact)
        storageTip = try container.decode(String.self, forKey: .storageTip)
        iconAsset = try container.decodeIfPresent(String.self, forKey: .iconAsset)
    }

    func isPeakSeason(for region: ProduceRegion, month: Int) -> Bool {
        guard let window = seasons.first(where: { $0.region == region.rawValue }) else { return false }
        let months = window.months
        guard months.contains(month) else { return false }
        let prev = month == 1 ? 12 : month - 1
        let next = month == 12 ? 1 : month + 1
        return months.contains(prev) && months.contains(next)
    }
}
