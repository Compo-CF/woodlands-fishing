import SwiftUI

// Field Guide v2.0 component library. Mirrors DESIGN_SYSTEM_V2.md Section 7.
// Every component uses tokens from FGPalette, FGTypography, and FGMetrics.
// Keep this file flat so each view reads in isolation.

// MARK: - FGSectionHeader
// Serif title + 2pt ink rule + optional trailing italic. The rule is the
// field-guide "chapter" cue.
struct FGSectionHeader: View {
    let title: String
    var trailing: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: FG.space.sm) {
            HStack(alignment: .firstTextBaseline) {
                Text(title)
                    .font(.fgDisplayMd)
                    .foregroundStyle(Color.fgInk)
                Spacer(minLength: FG.space.md)
                if let trailing {
                    Text(trailing)
                        .font(.fgSerifItalic)
                        .foregroundStyle(Color.fgSlate)
                }
            }
            Rectangle()
                .fill(Color.fgInk)
                .frame(height: FG.stroke.bold)
        }
    }
}

// MARK: - FGCard
// Bone fill, 1.5pt ink border, radius.lg corners, space.lg padding. Field
// Guide uses borders, not shadows. Call site: `MyContent().fgCard()`.
struct FGCardStyle: ViewModifier {
    var padding: CGFloat = FG.space.lg
    var fill: Color = .fgBone

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: FG.radius.lg, style: .continuous)
                    .fill(fill)
            )
            .overlay(
                RoundedRectangle(cornerRadius: FG.radius.lg, style: .continuous)
                    .stroke(Color.fgInk.opacity(0.9), lineWidth: FG.stroke.medium)
            )
    }
}

extension View {
    func fgCard(padding: CGFloat = FG.space.lg, fill: Color = .fgBone) -> some View {
        modifier(FGCardStyle(padding: padding, fill: fill))
    }
}

// MARK: - FGBadge
// All-caps mono label used for access type ("PUBLIC - BANK + KAYAK") and
// status tags.
struct FGBadge: View {
    let text: String
    var color: Color = .fgPine

    var body: some View {
        Text(text.uppercased())
            .font(.fgMonoCaps)
            .tracking(1.2)
            .foregroundStyle(color)
    }
}

// MARK: - FGChip
// Pill-shape chip. `.filled` = amber + ink text (active state); `.outlined`
// = bone-filled + pine stroke + pine text (inactive state).
struct FGChip: View {
    enum Style { case filled, outlined }
    let text: String
    var leadingSymbol: String? = nil
    var style: Style = .outlined

    var body: some View {
        HStack(spacing: FG.space.xs) {
            if let leadingSymbol {
                Image(systemName: leadingSymbol)
                    .font(.fgCaptionBold)
            }
            Text(text)
                .font(.fgCaptionBold)
        }
        .padding(.horizontal, FG.space.md)
        .padding(.vertical, FG.space.sm)
        .background(
            Capsule().fill(style == .filled ? Color.fgAmber : Color.fgBone)
        )
        .overlay(
            Capsule().stroke(
                style == .filled ? Color.fgInk : Color.fgPine,
                lineWidth: FG.stroke.medium
            )
        )
        .foregroundStyle(style == .filled ? Color.fgInk : Color.fgPine)
    }
}

// MARK: - FGButton
// Primary = amber-filled, ink text (main CTA). Secondary = kraft-filled,
// pine stroke, pine text (quiet action).
struct FGButton: View {
    enum Style { case primary, secondary }
    let title: String
    var systemImage: String? = nil
    var style: Style = .primary
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: FG.space.sm) {
                if let systemImage {
                    Image(systemName: systemImage)
                        .font(.fgBodyBold)
                }
                Text(title)
                    .font(.fgBodyBold)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, FG.space.lg)
            .padding(.horizontal, FG.space.xl)
            .background(
                Capsule().fill(style == .primary ? Color.fgAmber : Color.fgKraft)
            )
            .overlay(
                Capsule().stroke(
                    style == .primary ? Color.fgInk : Color.fgPine,
                    lineWidth: FG.stroke.medium
                )
            )
            .foregroundStyle(style == .primary ? Color.fgInk : Color.fgPine)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - FGDataRow
// Mono-caps label stacked over a serif-bold value. Used in the weather grid
// and the stocked/species/bathroom row on SpotDetail.
struct FGDataRow: View {
    let label: String
    let value: String
    var monoValue: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: FG.space.xs) {
            Text(label.uppercased())
                .font(.fgMonoCaps)
                .tracking(1.1)
                .foregroundStyle(Color.fgSlate)
            Text(value)
                .font(monoValue ? .fgMono : .fgDisplaySm)
                .foregroundStyle(Color.fgInk)
        }
    }
}

// MARK: - FGHairline
// Horizontal rule in slate@25%, used between list rows and inside cards.
struct FGHairline: View {
    var color: Color = .fgSlate
    var opacity: Double = 0.25
    var height: CGFloat = FG.stroke.thin

    var body: some View {
        Rectangle()
            .fill(color.opacity(opacity))
            .frame(height: height)
    }
}
