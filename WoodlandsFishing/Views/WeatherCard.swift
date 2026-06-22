import SwiftUI

/// Compact weather card shown on the spot detail screen. Fetches current
/// conditions from Open-Meteo on appear. Silently hides itself if the
/// network is unavailable — fishing apps don't need a fail loudly here.
struct WeatherCard: View {
    let latitude: Double
    let longitude: Double

    @State private var snapshot: WeatherService.Snapshot?
    @State private var didFail = false

    var body: some View {
        Group {
            if let snapshot {
                loaded(snapshot)
            } else if didFail {
                // Quiet failure — no card.
                EmptyView()
            } else {
                placeholder
            }
        }
        .task {
            do {
                snapshot = try await WeatherService.fetch(latitude: latitude, longitude: longitude)
            } catch {
                didFail = true
            }
        }
    }

    private func loaded(_ snap: WeatherService.Snapshot) -> some View {
        HStack(spacing: 14) {
            Image(systemName: snap.conditionSymbol)
                .font(.title2)
                .foregroundStyle(iconColor(for: snap.weatherCode))
                .frame(width: 36, height: 36)
            VStack(alignment: .leading, spacing: 2) {
                Text("Current conditions")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)
                Text(snap.summary)
                    .font(.subheadline.weight(.medium))
            }
            Spacer()
        }
        .padding(14)
        .background(Color.blue.opacity(0.08), in: .rect(cornerRadius: 12))
    }

    private var placeholder: some View {
        HStack(spacing: 14) {
            ProgressView()
                .frame(width: 36, height: 36)
            Text("Loading current conditions…")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
        }
        .padding(14)
        .background(Color.blue.opacity(0.05), in: .rect(cornerRadius: 12))
    }

    private func iconColor(for code: Int) -> Color {
        switch code {
        case 0, 1, 2: .orange
        case 3, 45, 48: .gray
        case 51...86: .blue
        case 95, 96, 99: .purple
        default: .secondary
        }
    }
}
