import SwiftUI

@main
struct WoodlandsFishingApp: App {
    @State private var store = SpotStore()
    @State private var locationManager = LocationManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(store)
                .environment(locationManager)
                .onChange(of: locationManager.location) { _, newValue in
                    store.userLocation = newValue
                }
        }
    }
}
