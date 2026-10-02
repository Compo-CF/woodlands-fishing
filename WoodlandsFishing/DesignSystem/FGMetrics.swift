import SwiftUI

// Field Guide v2.0 spacing, radius, and stroke tokens. Mirrors
// DESIGN_SYSTEM_V2.md Sections 4-6. A namespace enum keeps these out of the
// global Font/Color surface and reads clearly at call sites: FG.space.lg,
// FG.radius.card, FG.stroke.bold.
enum FG {
    enum space {
        static let xs: CGFloat  = 4
        static let sm: CGFloat  = 8
        static let md: CGFloat  = 12
        static let lg: CGFloat  = 16
        static let xl: CGFloat  = 20
        static let xxl: CGFloat = 24
        static let xxxl: CGFloat = 32
        static let x4: CGFloat  = 40
        static let x5: CGFloat  = 56
        static let x6: CGFloat  = 72
    }

    enum radius {
        static let xs: CGFloat  = 4
        static let sm: CGFloat  = 8
        static let md: CGFloat  = 12
        static let lg: CGFloat  = 16
        static let xl: CGFloat  = 24
        static let pill: CGFloat = 999
    }

    // Field Guide uses borders, not shadows. Three stroke weights carry the
    // whole visual language.
    enum stroke {
        static let hairline: CGFloat = 0.5  // slate @ 15% — subtle dividers
        static let thin: CGFloat     = 1    // slate @ 25% — standard dividers
        static let medium: CGFloat   = 1.5  // ink — card borders
        static let bold: CGFloat     = 2    // ink — section rules
    }
}
