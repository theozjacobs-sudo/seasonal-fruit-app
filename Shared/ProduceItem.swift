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
}
