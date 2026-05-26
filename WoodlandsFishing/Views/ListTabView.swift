import SwiftUI

struct ListTabView: View {
    @Environment(SpotStore.self) private var store

    var body: some View {
        @Bindable var store = store
        NavigationStack {
            List {
                ForEach(store.spotsSortedByDistance) { spot in
                    NavigationLink(value: spot) {
                        SpotRow(spot: spot)
                    }
                }
            }
            .navigationDestination(for: FishingSpot.self) { spot in
                SpotDetailView(spot: spot)
            }
            .searchable(text: $store.filter.searchText, prompt: "Search spots")
            .navigationTitle("Spots")
        }
    }
}
