import Foundation
import SwiftUI

enum WaterBody: String, Codable, CaseIterable {
    case pond, lake, creek, river
}

enum AccessType: String, Codable, CaseIterable {
    case publicOpen
    case publicLimited
    case privateContact      // Private, but may fish with owner's permission
    case privateNoAccess

    var displayName: String {
        switch self {
        case .publicOpen: "Public"
        case .publicLimited: "Public (limited)"
        case .privateContact: "Private — contact owner"
        case .privateNoAccess: "Private — no access"
        }
    }

    // Legacy color map kept for ClusteredMapView; v2.0 views use the FG
    // palette (see SpotDetailView.fgPinColor).
    var pinColor: Color {
        switch self {
        case .publicOpen: .green
        case .publicLimited: .yellow
        case .privateContact: .gray
        case .privateNoAccess: .red
        }
    }
}

enum Permit: String, Codable, CaseIterable {
    case tpwdFreshwater
    case none

    var displayName: String {
        switch self {
        case .tpwdFreshwater: "Texas Freshwater Fishing License"
        case .none: "No license required"
        }
    }

    var infoURL: URL? {
        switch self {
        case .tpwdFreshwater:
            URL(string: "https://tpwd.texas.gov/regulations/outdoor-annual/licenses/fishing-licenses-stamps-tags-packages/fishing-licenses-and-packages")
        case .none:
            nil
        }
    }
}

enum BoatAccess: String, Codable {
    case none
    case kayakCanoe
    case trailerRamp

    var displayName: String {
        switch self {
        case .none: "No boats"
        case .kayakCanoe: "Kayak / canoe"
        case .trailerRamp: "Boat ramp"
        }
    }
}

enum Species: String, Codable, CaseIterable {
    case largemouthBass
    case channelCatfish
    case bluegill
    case crappie
    case redearSunfish
    case spottedGar
    case whiteBass
    case hybridStripedBass

    var displayName: String {
        switch self {
        case .largemouthBass: "Largemouth bass"
        case .channelCatfish: "Channel catfish"
        case .bluegill: "Bluegill"
        case .crappie: "Crappie"
        case .redearSunfish: "Redear sunfish"
        case .spottedGar: "Spotted gar"
        case .whiteBass: "White bass"
        case .hybridStripedBass: "Hybrid striped bass"
        }
    }
}

// v2.0 schema additions.
enum ShadeLevel: String, Codable, CaseIterable {
    case none
    case partial
    case full

    var displayName: String {
        switch self {
        case .none: "No shade"
        case .partial: "Partial shade"
        case .full: "Full shade"
        }
    }
}

enum BathroomType: String, Codable, CaseIterable {
    case none
    case portable
    case permanent

    var displayName: String {
        switch self {
        case .none: "No bathroom"
        case .portable: "Portable bathroom"
        case .permanent: "Permanent bathroom"
        }
    }
}
