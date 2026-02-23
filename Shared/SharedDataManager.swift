import Foundation

final class SharedDataManager {
    static let shared = SharedDataManager()

    private let defaults: UserDefaults?

    private init() {
        defaults = UserDefaults(suiteName: SharedConstants.appGroupID)
    }

    var currentRegion: ProduceRegion {
        if let useManual = defaults?.bool(forKey: SharedConstants.useManualOverrideKey),
           useManual,
           let raw = defaults?.string(forKey: SharedConstants.manualOverrideKey),
           let region = ProduceRegion(rawValue: raw) {
            return region
        }
        if let raw = defaults?.string(forKey: SharedConstants.regionKey),
           let region = ProduceRegion(rawValue: raw) {
            return region
        }
        return .northAmericaTemperate
    }

    func saveDetectedRegion(_ region: ProduceRegion) {
        defaults?.set(region.rawValue, forKey: SharedConstants.regionKey)
    }

    func saveManualOverride(_ region: ProduceRegion, enabled: Bool) {
        defaults?.set(region.rawValue, forKey: SharedConstants.manualOverrideKey)
        defaults?.set(enabled, forKey: SharedConstants.useManualOverrideKey)
    }
}
