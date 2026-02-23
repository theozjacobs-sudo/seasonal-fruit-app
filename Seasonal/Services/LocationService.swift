import CoreLocation
import SwiftUI
import WidgetKit

enum LocationStatus {
    case unknown, requesting, denied, determined, error
}

@MainActor
final class LocationService: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()

    @Published var detectedRegion: ProduceRegion?
    @Published var locationStatus: LocationStatus = .unknown
    @Published var countryName: String?
    @Published var administrativeArea: String?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyReduced
    }

    func requestLocation() {
        locationStatus = .requesting
        locationManager.requestWhenInUseAuthorization()
    }

    private func reverseGeocode(_ location: CLLocation) async {
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            guard let placemark = placemarks.first else { return }

            countryName = placemark.country
            administrativeArea = placemark.administrativeArea
            let region = mapToRegion(
                countryCode: placemark.isoCountryCode ?? "",
                latitude: location.coordinate.latitude,
                adminArea: placemark.administrativeArea ?? ""
            )
            detectedRegion = region
            locationStatus = .determined

            SharedDataManager.shared.saveDetectedRegion(region)
            WidgetCenter.shared.reloadAllTimelines()
        } catch {
            locationStatus = .error
        }
    }

    func mapToRegion(countryCode: String, latitude: Double, adminArea: String) -> ProduceRegion {
        switch countryCode.uppercased() {
        // North America
        case "US":
            let westCoast = ["California", "Oregon", "Washington"]
            if westCoast.contains(adminArea) { return .northAmericaWestCoast }
            let warm = ["Florida", "Texas", "Arizona", "Louisiana",
                        "Georgia", "Alabama", "Mississippi",
                        "South Carolina", "New Mexico", "Nevada",
                        "Hawaii"]
            if warm.contains(adminArea) { return .northAmericaWarm }
            return .northAmericaTemperate
        case "CA":
            return .northAmericaTemperate
        case "MX":
            return .mexico

        // Europe
        case "GB", "IE", "SE", "NO", "DK", "FI", "IS", "NL", "BE":
            return .northernEurope
        case "ES", "IT", "GR", "PT", "HR", "CY", "MT", "TR":
            return .mediterraneanEurope
        case "DE", "AT", "CH", "PL", "CZ", "HU", "SK", "RO", "BG":
            return .centralEurope
        case "FR":
            return latitude < 44.0 ? .mediterraneanEurope : .centralEurope

        // Asia-Pacific
        case "JP", "KR", "TW":
            return .eastAsia
        case "CN":
            return latitude < 23.5 ? .southeastAsia : .eastAsia
        case "TH", "VN", "PH", "MY", "SG", "ID", "MM", "KH", "LA":
            return .southeastAsia
        case "IN", "LK", "BD", "NP", "PK":
            return .southAsia
        case "AU", "NZ":
            return .australasia

        // Latin America
        case "BR", "CO", "VE", "PE", "EC", "BO",
             "CR", "PA", "NI", "HN", "GT", "SV", "BZ",
             "CU", "DO", "JM", "HT", "TT", "PR":
            return .tropicalLatinAmerica
        case "AR", "CL", "UY", "PY":
            return .temperateLatinAmerica

        // Africa
        case "MA", "TN", "DZ", "EG", "LY":
            return .northAfrica
        case "ZA", "LS", "SZ", "BW", "NA", "MZ":
            return .southernAfrica
        case "KE", "NG", "GH", "TZ", "ET", "UG", "SN", "CI",
             "CM", "CD", "CG", "RW", "MW", "ZM", "ZW", "AO":
            return .tropicalAfrica

        default:
            if abs(latitude) < 23.5 { return .tropicalLatinAmerica }
            if abs(latitude) < 35 { return .mediterraneanEurope }
            return .northAmericaTemperate
        }
    }
}

extension LocationService: @preconcurrency CLLocationManagerDelegate {
    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        Task { @MainActor in
            switch manager.authorizationStatus {
            case .authorizedWhenInUse, .authorizedAlways:
                manager.requestLocation()
            case .denied, .restricted:
                locationStatus = .denied
            default:
                break
            }
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager,
                                     didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        Task { @MainActor in
            await reverseGeocode(location)
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager,
                                     didFailWithError error: Error) {
        Task { @MainActor in
            locationStatus = .error
        }
    }
}
