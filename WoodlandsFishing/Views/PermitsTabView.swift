import SwiftUI

struct PermitsTabView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    PermitSection(
                        title: "Texas Freshwater License",
                        body: """
                        Required for anyone 17 or older fishing in public Texas waters. Residents born before January 1, 1931 are exempt.

                        Annual freshwater package: $30 resident · $58 non-resident · $12 senior (65+).

                        No license required when fishing from bank or pier inside a Texas State Park, or in fully enclosed private waters with landowner permission.
                        """,
                        linkTitle: "Buy a license at TPWD",
                        linkURL: "https://tpwd.texas.gov/regulations/outdoor-annual/licenses/fishing-licenses-stamps-tags-packages/fishing-licenses-and-packages"
                    )

                    PermitSection(
                        title: "The Woodlands Township Ponds",
                        body: """
                        The Township does NOT issue its own fishing permit — a state license is enough.

                        However, most Township ponds are catch-and-release only. The exceptions where you can keep fish are Lake Woodlands, Lake Paloma, and Bear Branch Reservoir.

                        Fishing is prohibited along the upper Waterway east of Riva Row Boat House.
                        """,
                        linkTitle: "Township Parks & Recreation",
                        linkURL: "https://www.thewoodlandstownship-tx.gov/Departments/Parks-Recreation"
                    )

                    PermitSection(
                        title: "Lake Conroe (SJRA)",
                        body: """
                        Standard TPWD license required — no extra SJRA permit.

                        Special regulations: largemouth bass 16″ minimum (vs. 14″ statewide). 5-fish daily bag for all black bass combined. Triploid grass carp must be released immediately.
                        """,
                        linkTitle: "TPWD Lake Conroe regs",
                        linkURL: "https://tpwd.texas.gov/fishboat/fish/recreational/lakes/conroe/"
                    )

                    PermitSection(
                        title: "W.G. Jones State Forest",
                        body: """
                        Two small ponds on FM 1488. Because this is a State Forest (not a State Park), the in-park license exemption does NOT apply — a standard TPWD freshwater license is required.
                        """,
                        linkTitle: "W.G. Jones State Forest",
                        linkURL: "https://tfsweb.tamu.edu/about/state-forests-and-arboretums/wg-jones-state-forest/"
                    )

                    Text("Rules change. Always verify with the official source before fishing.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .padding(.top)
                }
                .padding()
            }
            .navigationTitle("Permits & Rules")
        }
    }
}

private struct PermitSection: View {
    let title: String
    let body: String
    let linkTitle: String
    let linkURL: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.title3.weight(.semibold))
            Text(body)
                .font(.body)
            if let url = URL(string: linkURL) {
                Link(linkTitle, destination: url)
                    .font(.subheadline.weight(.medium))
            }
        }
        .padding()
        .background(Color.secondary.opacity(0.1), in: .rect(cornerRadius: 12))
    }
}
