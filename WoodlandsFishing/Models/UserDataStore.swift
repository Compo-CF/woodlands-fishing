import Foundation
import Observation

/// User-specific per-device state: favorites, fishing visit log, and the
/// has-seen-onboarding flag. Persisted to UserDefaults — no backend, no
/// account, the data stays on the user's device.
@Observable
final class UserDataStore {
    var favoriteSpotIDs: Set<UUID> = []
    var visits: [SpotVisit] = []

    private let defaults = UserDefaults.standard
    private let favoritesKey = "favorites.v1"
    private let visitsKey = "visits.v1"
    private let onboardingKey = "hasSeenOnboarding.v1"

    init() {
        load()
    }

    // MARK: - Favorites

    func isFavorite(_ spotID: UUID) -> Bool {
        favoriteSpotIDs.contains(spotID)
    }

    func toggleFavorite(_ spotID: UUID) {
        if favoriteSpotIDs.contains(spotID) {
            favoriteSpotIDs.remove(spotID)
        } else {
            favoriteSpotIDs.insert(spotID)
        }
        saveFavorites()
    }

    // MARK: - Visits

    func addVisit(spotID: UUID, date: Date, note: String) {
        visits.append(SpotVisit(id: UUID(), spotID: spotID, date: date, note: note))
        saveVisits()
    }

    func deleteVisit(id: UUID) {
        visits.removeAll { $0.id == id }
        saveVisits()
    }

    /// Most recent visit to this spot, if any.
    func lastVisit(for spotID: UUID) -> SpotVisit? {
        visits.filter { $0.spotID == spotID }.max { $0.date < $1.date }
    }

    /// All visits to this spot, newest first.
    func visits(for spotID: UUID) -> [SpotVisit] {
        visits.filter { $0.spotID == spotID }.sorted { $0.date > $1.date }
    }

    // MARK: - Onboarding

    var hasSeenOnboarding: Bool {
        get { defaults.bool(forKey: onboardingKey) }
        set { defaults.set(newValue, forKey: onboardingKey) }
    }

    // MARK: - Persistence

    private func load() {
        if let data = defaults.data(forKey: favoritesKey),
           let arr = try? JSONDecoder().decode([UUID].self, from: data) {
            favoriteSpotIDs = Set(arr)
        }
        if let data = defaults.data(forKey: visitsKey),
           let arr = try? JSONDecoder().decode([SpotVisit].self, from: data) {
            visits = arr
        }
    }

    private func saveFavorites() {
        if let data = try? JSONEncoder().encode(Array(favoriteSpotIDs)) {
            defaults.set(data, forKey: favoritesKey)
        }
    }

    private func saveVisits() {
        if let data = try? JSONEncoder().encode(visits) {
            defaults.set(data, forKey: visitsKey)
        }
    }
}

/// One logged visit to a spot. Date + optional note.
struct SpotVisit: Codable, Identifiable, Hashable {
    let id: UUID
    let spotID: UUID
    let date: Date
    let note: String
}
