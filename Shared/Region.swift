import Foundation

enum ProduceRegion: String, Codable, CaseIterable, Identifiable {
    // North America
    case northAmericaTemperate = "na_temperate"
    case northAmericaWarm = "na_warm"
    case northAmericaWestCoast = "na_west_coast"

    // Europe
    case northernEurope = "eu_northern"
    case mediterraneanEurope = "eu_mediterranean"
    case centralEurope = "eu_central"

    // Asia-Pacific
    case eastAsia = "ap_east"
    case southeastAsia = "ap_southeast"
    case southAsia = "ap_south"
    case australasia = "ap_australasia"

    // Latin America
    case tropicalLatinAmerica = "la_tropical"
    case temperateLatinAmerica = "la_temperate"

    // Africa
    case northAfrica = "af_north"
    case subSaharanAfrica = "af_subsaharan"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .northAmericaTemperate: return "North America (Temperate)"
        case .northAmericaWarm: return "North America (Warm)"
        case .northAmericaWestCoast: return "North America (West Coast)"
        case .northernEurope: return "Northern Europe"
        case .mediterraneanEurope: return "Mediterranean Europe"
        case .centralEurope: return "Central Europe"
        case .eastAsia: return "East Asia"
        case .southeastAsia: return "Southeast Asia"
        case .southAsia: return "South Asia"
        case .australasia: return "Australia & New Zealand"
        case .tropicalLatinAmerica: return "Tropical Latin America"
        case .temperateLatinAmerica: return "Temperate South America"
        case .northAfrica: return "North Africa"
        case .subSaharanAfrica: return "Sub-Saharan Africa"
        }
    }

    var flag: String {
        switch self {
        case .northAmericaTemperate, .northAmericaWarm, .northAmericaWestCoast: return "\u{1F1FA}\u{1F1F8}"
        case .northernEurope: return "\u{1F1EC}\u{1F1E7}"
        case .mediterraneanEurope: return "\u{1F1EE}\u{1F1F9}"
        case .centralEurope: return "\u{1F1E9}\u{1F1EA}"
        case .eastAsia: return "\u{1F1EF}\u{1F1F5}"
        case .southeastAsia: return "\u{1F1F9}\u{1F1ED}"
        case .southAsia: return "\u{1F1EE}\u{1F1F3}"
        case .australasia: return "\u{1F1E6}\u{1F1FA}"
        case .tropicalLatinAmerica: return "\u{1F1E7}\u{1F1F7}"
        case .temperateLatinAmerica: return "\u{1F1E6}\u{1F1F7}"
        case .northAfrica: return "\u{1F1F2}\u{1F1E6}"
        case .subSaharanAfrica: return "\u{1F1F0}\u{1F1EA}"
        }
    }
}
