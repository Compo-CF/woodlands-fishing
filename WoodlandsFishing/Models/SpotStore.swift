import Foundation
import CoreLocation
import Observation

@Observable
final class SpotStore {
    var spots: [FishingSpot] = []
    var filter = SpotFilter()
    var userLocation: CLLocation?

    init() {
        load()
    }

    func load() {
        guard let url = Bundle.main.url(forResource: "Spots", withExtension: "json") else {
            print("Spots.json not found in bundle")
            return
        }
        do {
            let data = try Data(contentsOf: url)
            let wrapper = try JSONDecoder().decode(SpotsFile.self, from: data)
            self.spots = wrapper.spots
        } catch {
            print("Failed to decode Spots.json: \(error)")
        }
    }

    var filteredSpots: [FishingSpot] {
        spots.filter { spot in
            if filter.publicOnly && spot.access != .publicOpen { return false }
            if filter.keepFishOnly && spot.catchAndReleaseOnly { return false }
            if filter.bankOnly && !spot.bankFishing { return false }
            if filter.boatOnly && spot.boatAccess == .none { return false }
            if !filter.searchText.isEmpty,
               !spot.name.localizedCaseInsensitiveContains(filter.searchText) {
                return false
            }
            return true
        }
    }

    var spotsSortedByDistance: [FishingSpot] {
        guard let userLocation else { return filteredSpots }
        return filteredSpots.sorted {
            $0.distance(from: userLocation) < $1.distance(from: userLocation)
        }
    }
}

struct SpotFilter {
    var publicOnly: Bool = false
    var keepFishOnly: Bool = false
    var bankOnly: Bool = false
    var boatOnly: Bool = false
    var searchText: String = ""
}

private struct SpotsFile: Codable {
    let spots: [FishingSpot]
}
