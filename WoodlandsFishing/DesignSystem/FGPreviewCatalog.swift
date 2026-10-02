import SwiftUI

// Field Guide v2.0 preview catalog. Renders every component in both color
// schemes as a one-screen visual QA sheet. Not referenced at runtime.
struct FGCatalog: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: FG.space.xxxl) {
                swatches
                typography
                sectionHeader
                badges
                chips
                buttons
                dataRows
                card
                hairlines
            }
            .padding(FG.space.xl)
        }
        .background(Color.fgBone)
    }

    private var swatches: some View {
        VStack(alignment: .leading, spacing: FG.space.md) {
            FGSectionHeader(title: "Palette", trailing: "FGPalette")
            HStack(spacing: FG.space.sm) {
                swatch("Deep Lake", color: .fgDeepLake)
                swatch("Pine", color: .fgPine)
                swatch("Amber", color: .fgAmber)
                swatch("Rust", color: .fgRust)
            }
            HStack(spacing: FG.space.sm) {
                swatch("Bone", color: .fgBone, labelColor: .fgInk)
                swatch("Kraft", color: .fgKraft, labelColor: .fgInk)
                swatch("Ink", color: .fgInk, labelColor: .fgBone)
                swatch("Slate", color: .fgSlate)
            }
        }
    }

    private func swatch(_ name: String, color: Color, labelColor: Color = .fgBone) -> some View {
        VStack(spacing: FG.space.xs) {
            RoundedRectangle(cornerRadius: FG.radius.sm)
                .fill(color)
                .frame(height: 56)
                .overlay(
                    RoundedRectangle(cornerRadius: FG.radius.sm)
                        .stroke(Color.fgInk.opacity(0.3), lineWidth: FG.stroke.thin)
                )
            Text(name).font(.fgMicro).foregroundStyle(Color.fgInk)
        }
        .frame(maxWidth: .infinity)
    }

    private var typography: some View {
        VStack(alignment: .leading, spacing: FG.space.sm) {
            FGSectionHeader(title: "Typography", trailing: "FGTypography")
            Text("Display XL").font(.fgDisplayXL).foregroundStyle(Color.fgInk)
            Text("Display Lg").font(.fgDisplayLg).foregroundStyle(Color.fgInk)
            Text("Display Md").font(.fgDisplayMd).foregroundStyle(Color.fgInk)
            Text("Display Sm").font(.fgDisplaySm).foregroundStyle(Color.fgInk)
            Text("Serif italic for subtitles").font(.fgSerifItalic).foregroundStyle(Color.fgSlate)
            Text("Body copy at 17pt sits here.").font(.fgBody).foregroundStyle(Color.fgInk)
            Text("Body small at 15pt.").font(.fgBodySm).foregroundStyle(Color.fgSlate)
            Text("Caption at 13pt.").font(.fgCaption).foregroundStyle(Color.fgSlate)
            Text("30.12 inHg - 8 SW").font(.fgMono).foregroundStyle(Color.fgInk)
            Text("PUBLIC - BANK + KAYAK").font(.fgMonoCaps).tracking(1.2).foregroundStyle(Color.fgPine)
        }
    }

    private var sectionHeader: some View {
        VStack(alignment: .leading, spacing: FG.space.md) {
            FGSectionHeader(title: "Today on the water", trailing: "updated 9:41a")
            Text("A section head is a serif title plus a 2pt ink underline rule.")
                .font(.fgBody)
                .foregroundStyle(Color.fgSlate)
        }
    }

    private var badges: some View {
        VStack(alignment: .leading, spacing: FG.space.sm) {
            FGSectionHeader(title: "Badges")
            HStack(spacing: FG.space.md) {
                FGBadge(text: "Public - Bank + Kayak")
                FGBadge(text: "Private - No Access", color: .fgRust)
                FGBadge(text: "Stocked", color: .fgAmber)
            }
        }
    }

    private var chips: some View {
        VStack(alignment: .leading, spacing: FG.space.sm) {
            FGSectionHeader(title: "Chips")
            HStack(spacing: FG.space.sm) {
                FGChip(text: "Favorites", leadingSymbol: "star.fill", style: .filled)
                FGChip(text: "Public only")
                FGChip(text: "Boat ramp")
                FGChip(text: "Keep fish OK")
            }
            HStack(spacing: FG.space.sm) {
                FGChip(text: "Largemouth bass")
                FGChip(text: "Channel catfish")
                FGChip(text: "Bluegill")
            }
        }
    }

    private var buttons: some View {
        VStack(alignment: .leading, spacing: FG.space.md) {
            FGSectionHeader(title: "Buttons")
            FGButton(title: "Leave a tip", systemImage: "heart.fill", style: .primary) {}
            FGButton(title: "Get directions in Apple Maps", systemImage: "map", style: .primary) {}
            FGButton(title: "Submit a correction", style: .secondary) {}
        }
    }

    private var dataRows: some View {
        VStack(alignment: .leading, spacing: FG.space.md) {
            FGSectionHeader(title: "Data rows")
            HStack(alignment: .top, spacing: FG.space.xl) {
                FGDataRow(label: "Pressure", value: "30.12", monoValue: true)
                FGDataRow(label: "Wind", value: "8 SW", monoValue: true)
                FGDataRow(label: "Sunrise", value: "6:47a", monoValue: true)
                FGDataRow(label: "Sunset", value: "6:52p", monoValue: true)
            }
            HStack(alignment: .top, spacing: FG.space.xl) {
                FGDataRow(label: "Species", value: "4")
                FGDataRow(label: "Stocked", value: "Oct 12")
                FGDataRow(label: "Bathroom", value: "Portable")
                FGDataRow(label: "Family", value: "Yes")
            }
        }
    }

    private var card: some View {
        VStack(alignment: .leading, spacing: FG.space.md) {
            FGSectionHeader(title: "Field card")
            VStack(alignment: .leading, spacing: FG.space.sm) {
                FGBadge(text: "Public - Bank + Kayak")
                Text("Lake Woodlands")
                    .font(.fgDisplayLg)
                    .foregroundStyle(Color.fgInk)
                Text("Township-managed urban lake, 200 acres.")
                    .font(.fgBody)
                    .foregroundStyle(Color.fgSlate)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .fgCard()
        }
    }

    private var hairlines: some View {
        VStack(alignment: .leading, spacing: FG.space.md) {
            FGSectionHeader(title: "Hairlines")
            VStack(spacing: FG.space.md) {
                Text("Row above").font(.fgBody).foregroundStyle(Color.fgInk)
                FGHairline()
                Text("Row below").font(.fgBody).foregroundStyle(Color.fgInk)
            }
        }
    }
}

#Preview("Field Guide Catalog - Light") {
    FGCatalog()
        .preferredColorScheme(.light)
}

#Preview("Field Guide Catalog - Dark") {
    FGCatalog()
        .preferredColorScheme(.dark)
}
