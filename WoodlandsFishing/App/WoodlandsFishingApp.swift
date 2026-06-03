import SwiftUI
import GoogleMobileAds
import AppTrackingTransparency

@main
struct WoodlandsFishingApp: App {
    @State private var store = SpotStore()
    @State private var locationManager = LocationManager()

    init() {
        // Initialize Google Mobile Ads SDK. Ads start loading immediately;
        // the BannerAdView call sites kick off individual requests when shown.
        MobileAds.shared.start(completionHandler: nil)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(store)
                .environment(locationManager)
                .onChange(of: locationManager.location) { _, newValue in
                    store.userLocation = newValue
                }
                .task {
                    // Request App Tracking Transparency permission, but only
                    // after the user has seen the app for a second. Apple
                    // dislikes apps that slam users with system prompts on
                    // launch, and ads still serve (non-personalized) if denied.
                    try? await Task.sleep(nanoseconds: 1_500_000_000)
                    if ATTrackingManager.trackingAuthorizationStatus == .notDetermined {
                        _ = await ATTrackingManager.requestTrackingAuthorization()
                    }
                }
        }
    }
}
