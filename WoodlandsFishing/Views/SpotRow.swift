import SwiftUI
import CoreLocation

struct SpotRow: View {
    let spot: FishingSpot
    @Environment(SpotStore.self) private var store
    @Environment(UserDataStore.self) private var userData

    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(spot.access.pinColor)
                .frame(width: 10, height: 10)
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text(spot.name)
                        .font(.headline)
                    if userData.isFavorite(spot.id) {
                        Image(systemName: "heart.fill")
                            .font(.caption2)
                            .foregroundStyle(.pink)
                    }
                }
                HStack(spacing: 6) {
                    Text(spot.manager)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                    if spot.catchAndReleaseOnly {
                        Text("• C&R")
                            .font(.caption.weight(.medium))
                            .foregroundStyle(.orange)
                    }
                }
            }
            Spacer()
            if let distanceText {
                Text(distanceText)
                    .font(.caption.monospacedDigit())
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }

    private var distanceText: String? {
        guard let userLocation = store.userLocation else { return nil }
        let miles = spot.distance(from: userLocation) / 1609.34
        return String(format: "%.1f mi", miles)
    }
}
