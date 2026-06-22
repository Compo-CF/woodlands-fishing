import SwiftUI

/// About sheet shown from the Map tab's top-right info button.
/// Lists version, support / Ko-fi link, contact, GitHub, privacy policy.
struct AboutSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showingOnboardingReplay = false
    @State private var showingSubmitSpot = false

    private var versionString: String {
        let v = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "?"
        let b = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "?"
        return "Version \(v) (\(b))"
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    header
                    linksCard
                    suggestSpotButton
                    showIntroButton
                    footer
                }
                .padding(.vertical, 24)
                .padding(.horizontal)
            }
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
            .sheet(isPresented: $showingOnboardingReplay) {
                OnboardingSheet()
            }
            .sheet(isPresented: $showingSubmitSpot) {
                SubmitSpotSheet()
            }
        }
    }

    private var suggestSpotButton: some View {
        Button {
            showingSubmitSpot = true
        } label: {
            HStack {
                Image(systemName: "plus.circle.fill")
                    .foregroundStyle(.green)
                Text("Suggest a missing spot")
                    .font(.subheadline.weight(.medium))
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(14)
            .background(Color.green.opacity(0.10), in: .rect(cornerRadius: 12))
            .foregroundStyle(.primary)
        }
    }

    private var showIntroButton: some View {
        Button {
            showingOnboardingReplay = true
        } label: {
            HStack {
                Image(systemName: "sparkles")
                Text("Show app intro again")
                    .font(.subheadline.weight(.medium))
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(14)
            .background(Color.secondary.opacity(0.10), in: .rect(cornerRadius: 12))
            .foregroundStyle(.primary)
        }
    }

    private var header: some View {
        VStack(spacing: 10) {
            Image(systemName: "fish.fill")
                .font(.system(size: 44, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 88, height: 88)
                .background(
                    LinearGradient(
                        colors: [Color(red: 0.04, green: 0.31, blue: 0.34),
                                 Color(red: 0.18, green: 0.66, blue: 0.70)],
                        startPoint: .top, endPoint: .bottom
                    ),
                    in: .rect(cornerRadius: 20)
                )
            Text("The Woodlands Fishing Guide")
                .font(.title3.weight(.semibold))
                .multilineTextAlignment(.center)
            Text(versionString)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.top, 8)
    }

    private var linksCard: some View {
        VStack(spacing: 0) {
            AboutLink(
                icon: "heart.fill",
                iconBg: .pink,
                title: "Support the project",
                subtitle: "Tip via Ko-fi",
                url: "https://ko-fi.com/subtlefoodie"
            )
            Divider().padding(.leading, 58)
            AboutLink(
                icon: "envelope.fill",
                iconBg: .blue,
                title: "Contact",
                subtitle: "anthony@subtlefoodie.com",
                url: "mailto:anthony@subtlefoodie.com"
            )
            Divider().padding(.leading, 58)
            AboutLink(
                icon: "chevron.left.forwardslash.chevron.right",
                iconBg: .black,
                title: "View on GitHub",
                subtitle: "Compo-CF/woodlands-fishing",
                url: "https://github.com/Compo-CF/woodlands-fishing"
            )
            Divider().padding(.leading, 58)
            AboutLink(
                icon: "doc.text.fill",
                iconBg: .gray,
                title: "Privacy Policy",
                subtitle: nil,
                url: "https://compo-cf.github.io/woodlands-fishing/privacy.html"
            )
        }
        .background(Color.secondary.opacity(0.10), in: .rect(cornerRadius: 14))
    }

    private var footer: some View {
        Text("Spot data is compiled from public sources. Permit and fishing rules can change — verify with the official source linked on each spot.")
            .font(.caption)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 12)
    }
}

private struct AboutLink: View {
    let icon: String
    let iconBg: Color
    let title: String
    let subtitle: String?
    let url: String

    var body: some View {
        Link(destination: URL(string: url)!) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.callout)
                    .foregroundStyle(.white)
                    .frame(width: 30, height: 30)
                    .background(iconBg, in: .rect(cornerRadius: 7))
                VStack(alignment: .leading, spacing: 1) {
                    Text(title)
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.primary)
                    if let subtitle {
                        Text(subtitle)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                Spacer()
                Image(systemName: "arrow.up.right.square")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            .padding(14)
        }
    }
}
