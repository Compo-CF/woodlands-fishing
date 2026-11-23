import SwiftUI

/// A seasonal collection (Winter Crappie Spots, White Bass Run, ...), opened by
/// `woodlandsfishing://season/<id>` or a seasonal banner on the Spots tab.
struct SeasonCollectionView: View {
    let season: Season
    @Environment(SpotStore.self) private var store
    @Environment(\.dismiss) private var dismiss

    private var spots: [FishingSpot] { season.spots(from: store.spots) }
    private var rampSpots: [FishingSpot] { spots.filter { $0.boatAccess == .trailerRamp } }
    private var shoreSpots: [FishingSpot] { spots.filter { $0.boatAccess != .trailerRamp } }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: FG.space.xl) {
                    header
                    if !season.tips.isEmpty { tips }
                    if !shoreSpots.isEmpty {
                        section("Shore & kayak", spots: shoreSpots)
                    }
                    if !rampSpots.isEmpty {
                        section("Boat ramps", spots: rampSpots)
                    }
                    if let note = season.footnote {
                        Text(note)
                            .font(.fgCaption)
                            .foregroundStyle(Color.fgSlate)
                    }
                }
                .padding(FG.space.lg)
            }
            .background(Color.fgBone.ignoresSafeArea())
            .navigationTitle(season.title)
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: FishingSpot.self) { spot in
                SpotDetailView(spot: spot)
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: FG.space.sm) {
            FGBadge(text: "\(season.kicker) · \(season.label)", color: .fgAmber)
            Text(season.title)
                .font(.fgDisplayLg)
                .foregroundStyle(Color.fgInk)
            Text(season.subtitleText(count: spots.count))
                .font(.fgSerifItalicSm)
                .foregroundStyle(Color.fgSlate)
        }
    }

    private var tips: some View {
        VStack(alignment: .leading, spacing: FG.space.md) {
            FGSectionHeader(title: "Field notes")
            ForEach(season.tips, id: \.self) { tip in
                HStack(alignment: .top, spacing: FG.space.md) {
                    Image(systemName: tip.icon)
                        .foregroundStyle(Color.fgDeepLake)
                        .frame(width: 22)
                    Text(tip.text)
                        .font(.fgBodySm)
                        .foregroundStyle(Color.fgInk)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .fgCard()
    }

    private func section(_ title: String, spots: [FishingSpot]) -> some View {
        VStack(alignment: .leading, spacing: FG.space.sm) {
            FGSectionHeader(title: title, trailing: "\(spots.count)")
            ForEach(spots) { spot in
                NavigationLink(value: spot) {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(spot.name)
                                .font(.fgBodyBold)
                                .foregroundStyle(Color.fgInk)
                                .multilineTextAlignment(.leading)
                            Text("\(spot.access.displayName) · \(spot.boatAccess.displayName)")
                                .font(.fgCaption)
                                .foregroundStyle(Color.fgSlate)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(Color.fgSlate)
                    }
                    .padding(.vertical, FG.space.sm)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                FGHairline()
            }
        }
    }
}

/// Banner at the top of the Spots tab while a season is active.
struct SeasonBanner: View {
    let season: Season
    let count: Int
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: FG.space.md) {
                Image(systemName: season.icon)
                    .font(.title2)
                    .foregroundStyle(Color.fgAmber)
                    .frame(width: 30)
                VStack(alignment: .leading, spacing: 2) {
                    Text(season.title)
                        .font(.fgBodyBold)
                        .foregroundStyle(Color.fgInk)
                    Text("\(count) spots · \(season.label)")
                        .font(.fgCaption)
                        .foregroundStyle(Color.fgSlate)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(Color.fgSlate)
            }
        }
        .buttonStyle(.plain)
    }
}
