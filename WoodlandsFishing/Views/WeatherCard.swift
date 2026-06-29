import SwiftUI

/// Compact weather card shown on the spot detail screen. Fetches current
/// conditions from Open-Meteo on appear and again whenever the parent
/// refresh token changes (pull-to-refresh on the spot detail). Silently
/// hides itself if the network is unavailable — fishing apps don't need to
/// fail loudly here.
struct WeatherCard: View {
    let latitude: Double
    let longitude: Double
    let refreshToken: UUID

    @State private var snapshot: WeatherService.Snapshot?
    @State private var fetchedAt: Date?
    @State private var didFail = false

    var body: some View {
        Group {
            if let snapshot, let fetchedAt {
                loaded(snapshot, fetchedAt: fetchedAt)
            } else if didFail {
                EmptyView()
            } else {
                placeholder
            }
        }
        .task(id: refreshToken) {
            do {
                snapshot = try await WeatherService.fetch(latitude: latitude, longitude: longitude)
                fetchedAt = .now
                didFail = false
            } catch {
                didFail = true
            }
        }
    }

    private func loaded(_ snap: WeatherService.Snapshot, fetchedAt: Date) -> some View {
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
                HStack(spacing: 6) {
                    Text("\(Int(snap.temperatureF.rounded()))°F")
                    Text("·").foregroundStyle(.tertiary)
                    Text(snap.conditionLabel)
                    Text("·").foregroundStyle(.tertiary)
                    // Arrow points the direction the wind is GOING (180° from
                    // the meteorological "from" direction). Wind from north
                    // (0°) blows south, so arrow.up rotated 180° points down.
                    Image(systemName: "arrow.up")
                        .font(.caption.weight(.semibold))
                        .rotationEffect(.degrees(Double(snap.windDirectionDegrees) + 180))
                    Text("\(Int(snap.windMph.rounded())) mph \(snap.windCardinal)")
                }
                .font(.subheadline.weight(.medium))
                .accessibilityElement(children: .combine)
                .accessibilityLabel(snap.summary)
                Text("Updated \(fetchedAt.formatted(date: .omitted, time: .shortened))")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
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
