import SwiftUI

struct FilterBar: View {
    @Binding var filter: SpotFilter

    // The handful of species worth surfacing as filter chips. These are the
    // ones that appear most often across the spot dataset; rarer species
    // (e.g. spotted gar, redear sunfish) stay in the per-spot detail but
    // aren't crowded into the filter row.
    private let speciesChips: [Species] = [
        .largemouthBass, .bluegill, .channelCatfish, .crappie, .whiteBass,
    ]

    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                TextField("Search spots", text: $filter.searchText)
                    .textFieldStyle(.plain)
                    .autocorrectionDisabled()
                if !filter.searchText.isEmpty {
                    Button {
                        filter.searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(.systemGray6), in: .capsule)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    FilterChip(title: "★ Favorites", isOn: $filter.favoritesOnly, accent: .pink)
                    FilterChip(title: "Public only", isOn: $filter.publicOnly)
                    FilterChip(title: "Keep fish OK", isOn: $filter.keepFishOnly)
                    FilterChip(title: "Bank access", isOn: $filter.bankOnly)
                    FilterChip(title: "Boat access", isOn: $filter.boatOnly)
                }
                .padding(.horizontal, 2)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(speciesChips, id: \.self) { species in
                        SpeciesChip(species: species, selected: $filter.selectedSpecies)
                    }
                }
                .padding(.horizontal, 2)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
    }
}

private struct FilterChip: View {
    let title: String
    @Binding var isOn: Bool
    var accent: Color = .accentColor

    var body: some View {
        Button {
            isOn.toggle()
        } label: {
            Text(title)
                .font(.subheadline)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isOn ? accent : Color.secondary.opacity(0.15), in: .capsule)
                .foregroundStyle(isOn ? .white : .primary)
        }
        .buttonStyle(.plain)
    }
}

private struct SpeciesChip: View {
    let species: Species
    @Binding var selected: Set<Species>

    private var shortName: String {
        switch species {
        case .largemouthBass: "Bass"
        case .bluegill: "Bluegill"
        case .channelCatfish: "Catfish"
        case .crappie: "Crappie"
        case .redearSunfish: "Redear"
        case .spottedGar: "Gar"
        case .whiteBass: "White bass"
        case .hybridStripedBass: "Hybrid bass"
        }
    }

    private var isOn: Bool { selected.contains(species) }

    var body: some View {
        Button {
            if selected.contains(species) {
                selected.remove(species)
            } else {
                selected.insert(species)
            }
        } label: {
            Text(shortName)
                .font(.subheadline)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isOn ? Color.accentColor : Color.secondary.opacity(0.15), in: .capsule)
                .foregroundStyle(isOn ? .white : .primary)
        }
        .buttonStyle(.plain)
    }
}
