import SwiftUI

/// First-launch walkthrough. Explains the color legend, catch-and-release
/// rules, and license requirements before the user starts tapping pins.
/// Dismissed via "Get Started" → flag stored in UserDataStore so it doesn't
/// re-appear on subsequent launches. Can be re-shown from the About sheet.
struct OnboardingSheet: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    header
                    section(
                        icon: "fish.fill",
                        iconColor: Color(red: 0.04, green: 0.42, blue: 0.45),
                        title: "75+ verified spots",
                        body: "Every public fishing spot in The Woodlands area — Township ponds, Lake Conroe ramps, Spring Creek access, Creekside Park lakes, plus nearby state forest waters."
                    )
                    legendSection
                    section(
                        icon: "doc.text.fill",
                        iconColor: .blue,
                        title: "Texas freshwater license",
                        body: "Anyone 17 or older needs a TPWD freshwater license to fish public waters. Under 17 is exempt. Tap a spot for permit details and a direct link to TPWD."
                    )
                    section(
                        icon: "arrow.triangle.2.circlepath",
                        iconColor: .green,
                        title: "Catch & release on most Township ponds",
                        body: "Only Lake Woodlands, Lake Paloma, and Bear Branch Reservoir let you keep fish. Every other Township pond is catch-and-release — flagged with an orange \"C&R\" tag in the app."
                    )
                    section(
                        icon: "antenna.radiowaves.left.and.right",
                        iconColor: .purple,
                        title: "Live updates",
                        body: "Spot data refreshes automatically every time you open the app — new lakes, coordinate fixes, and rule changes appear without needing an app update."
                    )
                }
                .padding(20)
            }
            .navigationTitle("Welcome")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Get Started") { dismiss() }
                        .font(.body.weight(.semibold))
                }
            }
        }
    }

    private var header: some View {
        VStack(spacing: 10) {
            Image(systemName: "fish.fill")
                .font(.system(size: 36, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 72, height: 72)
                .background(
                    LinearGradient(
                        colors: [Color(red: 0.04, green: 0.31, blue: 0.34),
                                 Color(red: 0.18, green: 0.66, blue: 0.70)],
                        startPoint: .top, endPoint: .bottom
                    ),
                    in: .rect(cornerRadius: 16)
                )
            Text("The Woodlands Fishing Guide")
                .font(.title3.weight(.semibold))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 8)
    }

    private var legendSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label {
                Text("Pin colors at a glance")
                    .font(.headline)
            } icon: {
                Image(systemName: "mappin.and.ellipse")
                    .foregroundStyle(.orange)
            }
            VStack(alignment: .leading, spacing: 10) {
                legendRow(color: .green, label: "Public", note: "Free for anyone to fish.")
                legendRow(color: .yellow, label: "Public (limited)", note: "Some restriction — partial bank, fee, or hours.")
                legendRow(color: .red, label: "Private", note: "Residents only. Shown so you don't waste a trip.")
            }
            .padding(.leading, 4)
        }
    }

    private func legendRow(color: Color, label: String, note: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)
                .padding(.top, 5)
            VStack(alignment: .leading, spacing: 1) {
                Text(label).font(.subheadline.weight(.semibold))
                Text(note).font(.caption).foregroundStyle(.secondary)
            }
        }
    }

    private func section(icon: String, iconColor: Color, title: String, body: String) -> some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(iconColor)
                .frame(width: 32, height: 32)
                .background(iconColor.opacity(0.12), in: .rect(cornerRadius: 8))
            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.subheadline.weight(.semibold))
                Text(body).font(.subheadline).foregroundStyle(.secondary)
            }
        }
    }
}
