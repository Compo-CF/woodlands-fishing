import SwiftUI

/// Seasonal collection behind the "Winter Crappie Spots" In-App Event.
/// Opened by `woodlandsfishing://winter` or the Winter banner on the Spots tab.
struct WinterSpotsView: View {
    @Environment(SpotStore.self) private var store
    @Environment(\.dismiss) private var dismiss

    private var spots: [FishingSpot] { WinterSeason.spots(from: store.spots) }
    private var rampSpots: [FishingSpot] { spots.filter { $0.boatAccess == .trailerRamp } }
    private var shoreSpots: [FishingSpot] { spots.filter { $0.boatAccess != .trailerRamp } }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: FG.space.xl) {
                    header
                    tips
                    if !shoreSpots.isEmpty {
                        section("Shore & kayak", spots: shoreSpots)
                    }
                    if !rampSpots.isEmpty {
                        section("Boat ramps", spots: rampSpots)
                    }
                    Text("These are the spots in this guide that list crappie. Always check each spot's permits and posted rules.")
                        .font(.fgCaption)
                        .foregroundStyle(Color.fgSlate)
                }
                .padding(FG.space.lg)
            }
            .background(Color.fgBone.ignoresSafeArea())
            .navigationTitle("Winter Spots")
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
            FGBadge(text: "Winter season · \(WinterSeason.label)", color: .fgAmber)
            Text("Winter Crappie Spots")
                .font(.fgDisplayLg)
                .foregroundStyle(Color.fgInk)
            Text("\(spots.count) public waters around The Woodlands and Lake Conroe where crappie are on the list.")
                .font(.fgSerifItalicSm)
                .foregroundStyle(Color.fgSlate)
        }
    }

    private var tips: some View {
        VStack(alignment: .leading, spacing: FG.space.md) {
            FGSectionHeader(title: "Cold-water notes")
            tip("snowflake", "Crappie keep feeding in cold water, so they are a good winter target when bass slow down.")
            tip("tortoise", "Fish slowly: small jigs or minnows near brush, docks and deeper water.")
            tip("sun.max", "The warmest hours of the day are often the best bite. Each spot's weather card shows live temperature, wind and pressure.")
        }
        .fgCard()
    }

    private func tip(_ icon: String, _ text: String) -> some View {
        HStack(alignment: .top, spacing: FG.space.md) {
            Image(systemName: icon)
                .foregroundStyle(Color.fgDeepLake)
                .frame(width: 22)
            Text(text)
                .font(.fgBodySm)
                .foregroundStyle(Color.fgInk)
                .fixedSize(horizontal: false, vertical: true)
        }
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

/// Banner at the top of the Spots tab during the winter season.
struct WinterBanner: View {
    let count: Int
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: FG.space.md) {
                Image(systemName: "snowflake")
                    .font(.title2)
                    .foregroundStyle(Color.fgAmber)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Winter Crappie Spots")
                        .font(.fgBodyBold)
                        .foregroundStyle(Color.fgInk)
                    Text("\(count) waters for the cold months · \(WinterSeason.label)")
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
