import Foundation
import CoreLocation
import Observation

@Observable
final class SpotStore {
    var spots: [FishingSpot] = []
    var filter = SpotFilter()
    var userLocation: CLLocation?

    /// Remote source of truth. Edit `docs/Spots.json` in the repo, push to main,
    /// and GitHub Pages serves the update — every app picks it up on next launch.
    /// No app release is needed for data-only changes (new spots, fixed coords).
    private let remoteURL = URL(string: "https://compo-cf.github.io/woodlands-fishing/Spots.json")!

    /// Where we cache the last successfully fetched remote copy, for offline use.
    private var cacheURL: URL {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return dir.appendingPathComponent("Spots.cache.json")
    }

    init() {
        loadLocalFirst()
        Task { await refreshFromRemote() }
    }

    /// Synchronously load the best local data we have so the UI is never empty:
    /// prefer the cached remote copy from a previous launch, else the bundled seed.
    private func loadLocalFirst() {
        if let cached = try? Data(contentsOf: cacheURL), let decoded = Self.decode(cached) {
            spots = decoded
            return
        }
        loadBundled()
    }

    private func loadBundled() {
        guard let url = Bundle.main.url(forResource: "Spots", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let decoded = Self.decode(data) else {
            print("Bundled Spots.json missing or invalid")
            return
        }
        spots = decoded
    }

    /// Fetch the latest data from GitHub Pages. On success, update the UI and
    /// cache to disk for offline use and faster next launch. On any failure
    /// (offline, timeout, bad payload), silently keep whatever local data we had.
    @MainActor
    func refreshFromRemote() async {
        var request = URLRequest(url: remoteURL)
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.timeoutInterval = 10
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let http = response as? HTTPURLResponse,
                  http.statusCode == 200,
                  let decoded = Self.decode(data),
                  !decoded.isEmpty
            else { return }
            spots = decoded
            try? data.write(to: cacheURL, options: .atomic)
        } catch {
            // Offline or fetch failed — keep the local data from loadLocalFirst().
        }
    }

    private static func decode(_ data: Data) -> [FishingSpot]? {
        try? JSONDecoder().decode(SpotsFile.self, from: data).spots
    }

    /// Filter the spots. Pass the user's favorite IDs so the favorites chip
    /// can act on them — favorites live in UserDataStore, not SpotStore, so
    /// they're injected here at the call site.
    func filteredSpots(favoriteIDs: Set<UUID> = []) -> [FishingSpot] {
        spots.filter { spot in
            if filter.publicOnly && spot.access != .publicOpen { return false }
            if filter.keepFishOnly && spot.catchAndReleaseOnly { return false }
            if filter.bankOnly && !spot.bankFishing { return false }
            if filter.boatOnly && spot.boatAccess == .none { return false }
            if filter.favoritesOnly && !favoriteIDs.contains(spot.id) { return false }
            if !filter.selectedSpecies.isEmpty {
                if Set(spot.species).isDisjoint(with: filter.selectedSpecies) {
                    return false
                }
            }
            if !filter.searchText.isEmpty,
               !spot.name.localizedCaseInsensitiveContains(filter.searchText) {
                return false
            }
            return true
        }
    }

    /// Filtered spots sorted by distance from the user (if known).
    func sortedSpots(favoriteIDs: Set<UUID> = []) -> [FishingSpot] {
        let filtered = filteredSpots(favoriteIDs: favoriteIDs)
        guard let userLocation else { return filtered }
        return filtered.sorted {
            $0.distance(from: userLocation) < $1.distance(from: userLocation)
        }
    }
}

struct SpotFilter {
    var publicOnly: Bool = false
    var keepFishOnly: Bool = false
    var bankOnly: Bool = false
    var boatOnly: Bool = false
    var favoritesOnly: Bool = false
    var selectedSpecies: Set<Species> = []
    var searchText: String = ""
}

private struct SpotsFile: Codable {
    let spots: [FishingSpot]
}
