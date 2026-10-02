import SwiftUI

/// Field Guide weather card. Big serif temperature, condition line, 2x2 mono
/// data grid for pressure/wind/sunrise/sunset. Hides itself silently on
/// network failure — a fishing app doesn't need to shout about missing data.
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
        VStack(alignment: .leading, spacing: FG.space.lg) {
            // Hero: big serif temperature + condition line
            HStack(alignment: .top, spacing: FG.space.lg) {
                VStack(alignment: .leading, spacing: FG.space.xs) {
                    HStack(alignment: .firstTextBaseline, spacing: 2) {
                        Text("\(Int(snap.temperatureF.rounded()))")
                            .font(.system(size: 64, weight: .bold, design: .serif))
                            .foregroundStyle(Color.fgInk)
                        Text("°F")
                            .font(.fgSerifItalic)
                            .foregroundStyle(Color.fgSlate)
                    }
                    Text(snap.conditionLabel)
                        .font(.fgSerifItalic)
                        .foregroundStyle(Color.fgSlate)
                }
                Spacer()
                Image(systemName: snap.conditionSymbol)
                    .font(.system(size: 36, weight: .regular))
                    .foregroundStyle(iconColor(for: snap.weatherCode))
                    .accessibilityHidden(true)
            }

            FGHairline()

            // 2x2 mono data grid
            HStack(alignment: .top, spacing: FG.space.xl) {
                FGDataRow(
                    label: "Pressure",
                    value: String(format: "%.2f", snap.pressureInHg),
                    monoValue: true
                )
                FGDataRow(
                    label: "Wind",
                    value: "\(Int(snap.windMph.rounded())) \(snap.windCardinal)",
                    monoValue: true
                )
                if let sunrise = snap.sunrise {
                    FGDataRow(
                        label: "Sunrise",
                        value: sunrise.formatted(date: .omitted, time: .shortened),
                        monoValue: true
                    )
                }
                if let sunset = snap.sunset {
                    FGDataRow(
                        label: "Sunset",
                        value: sunset.formatted(date: .omitted, time: .shortened),
                        monoValue: true
                    )
                }
            }

            Text("Updated \(fetchedAt.formatted(date: .omitted, time: .shortened))")
                .font(.fgMicro)
                .foregroundStyle(Color.fgSlate)
                .accessibilityElement(children: .combine)
                .accessibilityLabel(snap.summary)
        }
        .fgCard(fill: .fgKraft)
    }

    private var placeholder: some View {
        HStack(spacing: FG.space.md) {
            ProgressView()
                .tint(Color.fgSlate)
            Text("Loading current conditions…")
                .font(.fgBodySm)
                .foregroundStyle(Color.fgSlate)
            Spacer()
        }
        .fgCard(fill: .fgKraft)
    }

    private func iconColor(for code: Int) -> Color {
        switch code {
        case 0, 1, 2: .fgAmber         // clear/mainly clear
        case 3, 45, 48: .fgSlate        // overcast/fog
        case 51...86: .fgDeepLake       // precipitation
        case 95, 96, 99: .fgRust        // thunderstorm
        default: .fgSlate
        }
    }
}
