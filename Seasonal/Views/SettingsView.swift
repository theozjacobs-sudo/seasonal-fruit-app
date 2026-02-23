import SwiftUI
import WidgetKit

struct SettingsView: View {
    @EnvironmentObject var locationService: LocationService
    @State private var useManualRegion = false
    @State private var selectedRegion: ProduceRegion = .northAmericaTemperate

    var body: some View {
        Form {
            Section("Location") {
                if let region = locationService.detectedRegion {
                    LabeledContent("Detected Region") {
                        Text("\(region.flag) \(region.displayName)")
                    }
                }
                if let country = locationService.countryName {
                    LabeledContent("Country", value: country)
                }
                if locationService.locationStatus == .denied {
                    Label("Location access denied. Enable in Settings.", systemImage: "location.slash.fill")
                        .foregroundStyle(.orange)
                        .font(.caption)
                }
                if locationService.locationStatus == .error {
                    Label("Could not determine location.", systemImage: "exclamationmark.triangle.fill")
                        .foregroundStyle(.orange)
                        .font(.caption)
                }

                Toggle("Override Region Manually", isOn: $useManualRegion)

                if useManualRegion {
                    Picker("Region", selection: $selectedRegion) {
                        ForEach(ProduceRegion.allCases) { region in
                            Text("\(region.flag) \(region.displayName)").tag(region)
                        }
                    }
                }
            }

            Section("About") {
                LabeledContent("Version", value: "1.0.0")
                LabeledContent("Produce Items", value: "\(SeasonalData.shared.allProduce.count)")
            }
        }
        .navigationTitle("Settings")
        .onAppear {
            let defaults = UserDefaults(suiteName: SharedConstants.appGroupID)
            useManualRegion = defaults?.bool(forKey: SharedConstants.useManualOverrideKey) ?? false
            if let raw = defaults?.string(forKey: SharedConstants.manualOverrideKey),
               let region = ProduceRegion(rawValue: raw) {
                selectedRegion = region
            }
        }
        .onChange(of: useManualRegion) { _, enabled in
            SharedDataManager.shared.saveManualOverride(selectedRegion, enabled: enabled)
            WidgetCenter.shared.reloadAllTimelines()
        }
        .onChange(of: selectedRegion) { _, region in
            if useManualRegion {
                SharedDataManager.shared.saveManualOverride(region, enabled: true)
                WidgetCenter.shared.reloadAllTimelines()
            }
        }
    }
}
