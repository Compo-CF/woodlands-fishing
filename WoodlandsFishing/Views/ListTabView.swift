import SwiftUI

struct ListTabView: View {
    @Environment(SpotStore.self) private var store
    @Environment(UserDataStore.self) private var userData
    @State private var navigationPath: [FishingSpot] = []

    /// Look up the FishingSpot objects behind the recently-viewed ID list.
    /// Silently drops any IDs whose spots no longer exist in the current
    /// dataset (e.g. a spot removed via the remote-fetch update).
    private var recentlyViewedSpots: [FishingSpot] {
        userData.recentlyViewedSpotIDs.compactMap { id in
            store.spots.first(where: { $0.id == id })
        }
    }

    var body: some View {
        @Bindable var store = store
        NavigationStack(path: $navigationPath) {
            List {
                if !recentlyViewedSpots.isEmpty && store.filter.searchText.isEmpty {
                    Section {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(recentlyViewedSpots) { spot in
                                    NavigationLink(value: spot) {
                                        RecentSpotCard(spot: spot)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal, 2)
                        }
                        .listRowInsets(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
                    } header: {
                        Text("Recently viewed")
                    }
                }
                Section {
                    ForEach(store.sortedSpots(favoriteIDs: userData.favoriteSpotIDs)) { spot in
                        NavigationLink(value: spot) {
                            SpotRow(spot: spot)
                        }
                    }
                } header: {
                    if !recentlyViewedSpots.isEmpty && store.filter.searchText.isEmpty {
                        Text("All spots")
                    }
                }
            }
            .navigationDestination(for: FishingSpot.self) { spot in
                SpotDetailView(spot: spot)
            }
            .searchable(text: $store.filter.searchText, prompt: "Search spots")
            .navigationTitle("Spots")
        }
        .onChange(of: store.pendingDeepLinkedSpotID) { _, newValue in
            guard let id = newValue else { return }
            if let spot = store.spots.first(where: { $0.id == id }) {
                navigationPath = [spot]
            }
            // Clear the signal so subsequent identical deep links still fire.
            store.pendingDeepLinkedSpotID = nil
        }
    }
}

/// Compact card used in the Recently Viewed horizontal scroll. Larger than
/// a list row so it reads at a glance from the tab; shows access-pin color,
/// name, and manager.
private struct RecentSpotCard: View {
    let spot: FishingSpot

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                Circle()
                    .fill(spot.access.pinColor)
                    .frame(width: 8, height: 8)
                Text(spot.access.displayName)
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)
            }
            Text(spot.name)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
            Text(spot.manager)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
        .frame(width: 170, alignment: .leading)
        .padding(12)
        .background(Color.secondary.opacity(0.10), in: .rect(cornerRadius: 12))
    }
}
