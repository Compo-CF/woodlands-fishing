import Foundation
import SwiftUI

enum WaterBody: String, Codable, CaseIterable {
    case pond, lake, creek, river
}

enum AccessType: String, Codable, CaseIterable {
    case publicOpen
    case publicLimited
    case privateNoAccess

    var displayName: String {
        switch self {
        case .publicOpen: "Public"
        case .publicLimited: "Public (limited)"
        case .privateNoAccess: "Private — no access"
        }
    }

    var pinColor: Color {
        switch self {
        case .publicOpen: .green
        case .publicLimited: .yellow
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
