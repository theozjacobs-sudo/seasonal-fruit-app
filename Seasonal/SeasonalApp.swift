import SwiftUI

@main
struct SeasonalApp: App {
    @StateObject private var locationService = LocationService()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(locationService)
        }
    }
}
