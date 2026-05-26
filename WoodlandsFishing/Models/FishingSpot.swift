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

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    func distance(from location: CLLocation) -> CLLocationDistance {
        location.distance(from: CLLocation(latitude: latitude, longitude: longitude))
    }
}
