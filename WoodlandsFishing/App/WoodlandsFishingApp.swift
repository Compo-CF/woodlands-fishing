import SwiftUI
import GoogleMobileAds
import AppTrackingTransparency

@main
struct WoodlandsFishingApp: App {
    @State private var store = SpotStore()
    @State private var locationManager = LocationManager()
    @State private var userData = UserDataStore()

    init() {
        // Initialize Google Mobile Ads SDK. Ads start loading immediately;
        // the BannerAdView call sites kick off individual requests when shown.
        GADMobileAds.sharedInstance().start(completionHandler: nil)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(store)
                .environment(locationManager)
                .environment(userData)
                .onChange(of: locationManager.location) { _, newValue in
                    store.userLocation = newValue
                }
                .task(id: locationManager.authorizationStatus) {
                    // Chain the App Tracking Transparency request to fire AFTER
                    // the location-permission prompt is resolved. iOS 17/18
                    // suppresses one system prompt when another is already up,
                    // and the map's location prompt fires first — so a pure
                    // time-based ATT request gets silently dropped on first
                    // launch. Sequencing them via .task(id:) on the location
                    // authorization status guarantees the ATT prompt actually
                    // appears.
                    //
                    // Flow on first launch:
                    //   1. authorizationStatus == .notDetermined → early return
                    //   2. user responds to the location prompt
                    //   3. authorizationStatus changes → .task(id:) re-fires
                    //   4. brief breathing room, then ATT prompt appears
                    guard locationManager.authorizationStatus != .notDetermined else { return }
                    try? await Task.sleep(nanoseconds: 700_000_000)
                    if ATTrackingManager.trackingAuthorizationStatus == .notDetermined {
                        _ = await ATTrackingManager.requestTrackingAuthorization()
                    }
                }
        }
    }
}
