import SwiftUI
import MapKit

struct MapTabView: View {
    @Environment(SpotStore.self) private var store
    @Environment(LocationManager.self) private var locationManager
    @State private var selectedSpot: FishingSpot?
    // .automatic frames whatever spots are currently loaded, so the map adapts
    // to any geographic coverage without a hardcoded region.
    @State private var position: MapCameraPosition = .automatic

    var body: some View {
        @Bindable var store = store
        NavigationStack {
            Map(position: $position, selection: $selectedSpot) {
                ForEach(store.filteredSpots) { spot in
                    Marker(spot.name, systemImage: "fish.fill", coordinate: spot.coordinate)
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
            .sheet(item: $selectedSpot) { spot in
                NavigationStack {
                    SpotDetailView(spot: spot)
                }
                .presentationDetents([.medium, .large])
            }
            .onAppear {
                if locationManager.authorizationStatus == .notDetermined {
                    locationManager.requestPermission()
                }
            }
            .navigationTitle("Woodlands Fishing")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
