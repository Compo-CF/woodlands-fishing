import Foundation
import CoreLocation

struct FishingSpot: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let latitude: Double
    let longitude: Double
    let manager: String
    let waterBodyType: WaterBody
    let access: AccessType
    let permitsRequired: [Permit]
    let catchAndReleaseOnly: Bool
    let bankFishing: Bool
    let boatAccess: BoatAccess
    let species: [Species]
    let parkingNotes: String?
    let restrictions: String?
    let description: String
    let sourceURL: String

    // v2.0 additions. All optional for backward compatibility with v1.x
    // cached data. Mirrors DESIGN_SYSTEM_V2.md Section 10.
    let coverPhotoURL: URL?
    let shadeLevel: ShadeLevel?
    let kidFriendly: Bool?
    let familyNotes: String?
    let bathroomType: BathroomType?
    let launchFee: String?
    let bestSeasonMonths: [Int]?       // 1-12, e.g. [3,4,5,10,11]
    let lastStockedDate: Date?         // populated by TPWD scraper (CFL spots)
    let usgsGaugeID: String?           // e.g. "08068090" Spring Creek near Spring

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    func distance(from location: CLLocation) -> CLLocationDistance {
        location.distance(from: CLLocation(latitude: latitude, longitude: longitude))
    }
}
