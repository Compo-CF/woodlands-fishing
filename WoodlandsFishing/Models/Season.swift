import Foundation

/// A seasonal collection (backs an App Store In-App Event). Defined in
/// `docs/Seasons.json` (GitHub Pages) with a bundled copy in Resources, so a
/// new season ships as a data push. Spots are picked by species from Spots.json.
struct Season: Codable, Identifiable, Hashable {
    struct Tip: Codable, Hashable {
        let icon: String   // SF Symbol
        let text: String
    }

    let id: String          // deep link: woodlandsfishing://season/<id>
    let title: String       // "Winter Crappie Spots"
    let kicker: String      // "Winter season"
    let subtitle: String    // "{count} public waters ..." ({count} is replaced)
    let start: String       // "MM-DD", inclusive, local time
    let end: String         // "MM-DD", inclusive; may wrap past Dec 31
    let label: String       // "Dec 1 – Feb 28"
    let species: [Species]  // a spot qualifies if it lists any of these
    let icon: String        // SF Symbol for the banner
    let tips: [Tip]
    let footnote: String?

    private static func mmdd(_ s: String) -> Int {
        let p = s.split(separator: "-").compactMap { Int($0) }
        return p.count == 2 ? p[0] * 100 + p[1] : 0
    }

    func isActive(on date: Date = .now, calendar: Calendar = .current) -> Bool {
        let c = calendar.dateComponents([.month, .day], from: date)
        let today = (c.month ?? 0) * 100 + (c.day ?? 0)
        let s = Self.mmdd(start), e = Self.mmdd(end)
        return s <= e ? (today >= s && today <= e) : (today >= s || today <= e)
    }

    func spots(from all: [FishingSpot]) -> [FishingSpot] {
        all.filter { spot in
            spot.access != .privateNoAccess && spot.species.contains(where: species.contains)
        }
        .sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }

    func subtitleText(count: Int) -> String {
        subtitle.replacingOccurrences(of: "{count}", with: String(count))
    }

    private struct File: Codable { let seasons: [Season] }

    /// Unknown species names in a newer remote file would fail the whole
    /// decode, so old builds keep their cached/bundled copy in that case.
    static func decode(_ data: Data) -> [Season]? {
        try? JSONDecoder().decode(File.self, from: data).seasons
    }
}
