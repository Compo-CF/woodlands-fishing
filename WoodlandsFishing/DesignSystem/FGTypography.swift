import SwiftUI

// Field Guide v2.0 typography scale. Mirrors DESIGN_SYSTEM_V2.md Section 3.
//
// The display family uses SwiftUI's `.serif` design (New York on iOS) as a
// stand-in for Fraunces. Swap to a bundled Fraunces .ttf later by changing
// only this file: `.font(.custom("Fraunces-Bold", size: ...))`.
extension Font {
    // Display serif — titles, section heads, hero names.
    static let fgDisplayXL = Font.system(size: 34, weight: .bold, design: .serif)
    static let fgDisplayLg = Font.system(size: 28, weight: .bold, design: .serif)
    static let fgDisplayMd = Font.system(size: 24, weight: .bold, design: .serif)
    static let fgDisplaySm = Font.system(size: 20, weight: .bold, design: .serif)
    static let fgSerifItalic = Font.system(size: 18, weight: .regular, design: .serif).italic()
    static let fgSerifItalicSm = Font.system(size: 15, weight: .regular, design: .serif).italic()

    // Body sans — SF Pro Text at Dynamic Type-adjacent sizes.
    static let fgBody = Font.system(size: 17, weight: .regular, design: .default)
    static let fgBodyBold = Font.system(size: 17, weight: .semibold, design: .default)
    static let fgBodySm = Font.system(size: 15, weight: .regular, design: .default)
    static let fgCaption = Font.system(size: 13, weight: .regular, design: .default)
    static let fgCaptionBold = Font.system(size: 13, weight: .semibold, design: .default)
    static let fgMicro = Font.system(size: 11, weight: .regular, design: .default)

    // Mono — numeric data (weather, coords, timestamps) and spec labels.
    static let fgMono = Font.system(size: 15, weight: .regular, design: .monospaced)
    static let fgMonoSm = Font.system(size: 12, weight: .regular, design: .monospaced)
    static let fgMonoCaps = Font.system(size: 11, weight: .semibold, design: .monospaced)
}
