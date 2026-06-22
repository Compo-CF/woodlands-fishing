import SwiftUI

struct MapTabView: View {
    @Environment(SpotStore.self) private var store
    @Environment(LocationManager.self) private var locationManager
    @Environment(UserDataStore.self) private var userData
    @State private var selectedSpot: FishingSpot?
    @State private var showingAbout = false

    private let bannerAdUnitID = "ca-app-pub-1927040492403163/4580765066"

    var body: some View {
        @Bindable var store = store
        NavigationStack {
            ClusteredMapView(
                spots: store.filteredSpots(favoriteIDs: userData.favoriteSpotIDs),
                favoriteIDs: userData.favoriteSpotIDs,
                selectedSpot: $selectedSpot
            )
            .ignoresSafeArea(edges: .horizontal)
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
