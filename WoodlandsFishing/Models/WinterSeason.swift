import Foundation

/// The Winter Crappie Spots season (In-App Event "Winter Crappie Spots").
/// The Spots-tab banner only shows December through February; the deep link
/// `woodlandsfishing://winter` opens the collection any time.
enum WinterSeason {
    static let months: Set<Int> = [12, 1, 2]
    static let label = "Dec 1 – Feb 28"

    static func isActive(on date: Date = .now, calendar: Calendar = .current) -> Bool {
        months.contains(calendar.component(.month, from: date))
    }

    /// Spots in the dataset that list crappie, the species this collection is
    /// built around. Driven by `species` in Spots.json, nothing hard-coded.
    static func spots(from all: [FishingSpot]) -> [FishingSpot] {
        all.filter { $0.species.contains(.crappie) && $0.access != .privateNoAccess }
            .sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }
}
