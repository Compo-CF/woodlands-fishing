import SwiftUI
import UIKit

// Field Guide v2.0 palette. Values mirror DESIGN_SYSTEM_V2.md Section 2.
// Each token resolves via UITraitCollection so views never branch on
// colorScheme manually.
extension Color {
    static let fgDeepLake = Color.fgAdaptive(
        light: (15,  59,  76),
        dark:  (142, 200, 216)
    )
    static let fgPine = Color.fgAdaptive(
        light: (46,  74,  59),
        dark:  (143, 184, 154)
    )
    static let fgAmber = Color.fgAdaptive(
        light: (217, 126, 42),
        dark:  (242, 168, 104)
    )
    static let fgRust = Color.fgAdaptive(
        light: (176, 74, 42),
        dark:  (230, 132, 94)
    )
    // Bone is the primary surface in light; flips to a near-black in dark so
    // the field-guide "paper" feel stays rather than becoming chrome blue-grey.
    static let fgBone = Color.fgAdaptive(
        light: (247, 241, 227),
        dark:  (21,  25,  28)
    )
    static let fgKraft = Color.fgAdaptive(
        light: (232, 223, 201),
        dark:  (36,  42,  47)
    )
    // Ink inverts for dark mode so copy stays readable on the bone surface.
    static let fgInk = Color.fgAdaptive(
        light: (26,  26,  26),
        dark:  (242, 238, 226)
    )
    static let fgSlate = Color.fgAdaptive(
        light: (92,  102, 112),
        dark:  (136, 145, 160)
    )

    static func fgAdaptive(light: (Int, Int, Int), dark: (Int, Int, Int)) -> Color {
        Color(UIColor { trait in
            let rgb = trait.userInterfaceStyle == .dark ? dark : light
            return UIColor(
                red:   CGFloat(rgb.0) / 255.0,
                green: CGFloat(rgb.1) / 255.0,
                blue:  CGFloat(rgb.2) / 255.0,
                alpha: 1
            )
        })
    }
}
