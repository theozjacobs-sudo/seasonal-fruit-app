import SwiftUI

struct ContentView: View {
    @EnvironmentObject var locationService: LocationService

    var body: some View {
        TabView {
            NavigationStack {
                ProduceListView()
            }
            .tabItem {
                Label("In Season", systemImage: "leaf.fill")
            }

            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Label("Settings", systemImage: "gearshape.fill")
            }
        }
        .tint(.green)
        .onAppear {
            locationService.requestLocation()
        }
    }
}
