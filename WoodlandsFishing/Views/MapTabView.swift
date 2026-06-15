import SwiftUI
import MapKit

struct MapTabView: View {
    @Environment(SpotStore.self) private var store
    @Environment(LocationManager.self) private var locationManager
    @Environment(UserDataStore.self) private var userData
    @State private var selectedSpot: FishingSpot?
    @State private var showingAbout = false
    // .automatic frames whatever spots are currently loaded, so the map adapts
    // to any geographic coverage without a hardcoded region.
    @State private var position: MapCameraPosition = .automatic

    private let bannerAdUnitID = "ca-app-pub-1927040492403163/4580765066"

    var body: some View {
        @Bindable var store = store
        NavigationStack {
            Map(position: $position, selection: $selectedSpot) {
                ForEach(store.filteredSpots(favoriteIDs: userData.favoriteSpotIDs)) { spot in
                    Marker(spot.name, systemImage: userData.isFavorite(spot.id) ? "heart.fill" : "fish.fill", coordinate: spot.coordinate)
                        .tint(spot.access.pinColor)
                        .tag(spot)
                }
                UserAnnotation()
            }
            .mapControls {
                MapUserLocationButton()
                MapCompass()
                MapScaleView()
            }
            .safeAreaInset(edge: .top) {
                FilterBar(filter: $store.filter)
                    .background(.thinMaterial)
            }
            .safeAreaInset(edge: .bottom) {
                BannerAdView(adUnitID: bannerAdUnitID)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(.thinMaterial)
            }
            .sheet(item: $selectedSpot) { spot in
                NavigationStack {
                    SpotDetailView(spot: spot)
                }
                .presentationDetents([.medium, .large])
            }
            .sheet(isPresented: $showingAbout) {
                AboutSheet()
            }
            .onAppear {
                if locationManager.authorizationStatus == .notDetermined {
                    locationManager.requestPermission()
                }
            }
            .navigationTitle("Woodlands Fishing Guide")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAbout = true
                    } label: {
                        Image(systemName: "info.circle")
                            .font(.title3)
                    }
                    .accessibilityLabel("About this app")
                }
            }
        }
    }
}
