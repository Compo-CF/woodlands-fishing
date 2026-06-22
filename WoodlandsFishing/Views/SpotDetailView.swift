import SwiftUI
import MapKit

struct SpotDetailView: View {
    let spot: FishingSpot
    @Environment(UserDataStore.self) private var userData
    @State private var showingLogVisit = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                mapSnippet
                accessBadge
                WeatherCard(latitude: spot.latitude, longitude: spot.longitude)
                permitBlock
                infoBlock
                directionsButton
                visitsBlock
                sourceLink
            }
            .padding()
        }
        .navigationTitle(spot.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    userData.toggleFavorite(spot.id)
                } label: {
                    Image(systemName: userData.isFavorite(spot.id) ? "heart.fill" : "heart")
                        .foregroundStyle(.pink)
                        .font(.title3)
                }
                .accessibilityLabel(userData.isFavorite(spot.id) ? "Remove from favorites" : "Add to favorites")
            }
        }
        .sheet(isPresented: $showingLogVisit) {
            LogVisitSheet(spot: spot)
                .environment(userData)
        }
    }

    private var mapSnippet: some View {
        Map(initialPosition: .region(
            MKCoordinateRegion(
                center: spot.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
        )) {
            Marker(spot.name, systemImage: "fish.fill", coordinate: spot.coordinate)
                .tint(spot.access.pinColor)
        }
        .frame(height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .allowsHitTesting(false)
    }

    private var accessBadge: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(spot.access.pinColor)
                .frame(width: 10, height: 10)
            Text(spot.access.displayName)
                .font(.subheadline.weight(.semibold))
            if spot.catchAndReleaseOnly {
                Text("• Catch & release only")
                    .font(.subheadline)
                    .foregroundStyle(.orange)
            }
            Spacer()
            if let last = userData.lastVisit(for: spot.id) {
                Text("Last fished \(last.date.formatted(.relative(presentation: .named)))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var permitBlock: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("Permits & licenses", systemImage: "doc.text.fill")
                .font(.headline)
            ForEach(spot.permitsRequired, id: \.self) { permit in
                if let url = permit.infoURL {
                    Link(destination: url) {
                        HStack {
                            Text(permit.displayName)
                                .font(.subheadline)
                            Spacer()
                            Image(systemName: "arrow.up.right.square")
                                .foregroundStyle(.secondary)
                        }
                    }
                } else {
                    Text(permit.displayName)
                        .font(.subheadline)
                }
            }
            Text("Anyone under 17 is exempt from the state license requirement.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color.secondary.opacity(0.1), in: .rect(cornerRadius: 12))
    }

    private var infoBlock: some View {
        VStack(alignment: .leading, spacing: 12) {
            infoRow("Manager", spot.manager)
            infoRow("Bank fishing", spot.bankFishing ? "Yes" : "No")
            infoRow("Boats", spot.boatAccess.displayName)
            if !spot.species.isEmpty {
                infoRow("Species", spot.species.map(\.displayName).joined(separator: ", "))
            }
            if let parking = spot.parkingNotes {
                infoRow("Access & parking", parking)
            }
            if let restrictions = spot.restrictions {
                infoRow("Restrictions", restrictions)
            }
            Text(spot.description)
                .font(.body)
                .padding(.top, 4)
        }
    }

    private func infoRow(_ label: String, _ value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label.uppercased())
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.secondary)
            Text(value)
                .font(.subheadline)
        }
    }

    private var directionsButton: some View {
        Button(action: openInMaps) {
            Label("Directions in Apple Maps", systemImage: "arrow.triangle.turn.up.right.diamond.fill")
                .frame(maxWidth: .infinity)
                .padding()
                .background(spot.access == .privateNoAccess ? Color.gray : Color.accentColor, in: .rect(cornerRadius: 12))
                .foregroundStyle(.white)
                .font(.headline)
        }
        .disabled(spot.access == .privateNoAccess)
    }

    private var visitsBlock: some View {
        let visits = userData.visits(for: spot.id)
        return VStack(alignment: .leading, spacing: 10) {
            HStack {
                Label("Your visits", systemImage: "calendar")
                    .font(.headline)
                Spacer()
                Button {
                    showingLogVisit = true
                } label: {
                    Label("Log visit", systemImage: "plus.circle.fill")
                        .font(.subheadline.weight(.semibold))
                }
            }
            if visits.isEmpty {
                Text("No visits logged yet. Tap Log visit after you fish here.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(visits.prefix(5)) { visit in
                    VStack(alignment: .leading, spacing: 2) {
                        Text(visit.date.formatted(date: .abbreviated, time: .omitted))
                            .font(.subheadline.weight(.medium))
                        if !visit.note.isEmpty {
                            Text(visit.note)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 12)
                    .background(Color.secondary.opacity(0.08), in: .rect(cornerRadius: 8))
                }
                if visits.count > 5 {
                    Text("+ \(visits.count - 5) more")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .background(Color.secondary.opacity(0.1), in: .rect(cornerRadius: 12))
    }

    @ViewBuilder
    private var sourceLink: some View {
        if let url = URL(string: spot.sourceURL) {
            Link(destination: url) {
                Text("Verify info at source ↗")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func openInMaps() {
        let placemark = MKPlacemark(coordinate: spot.coordinate)
        let item = MKMapItem(placemark: placemark)
        item.name = spot.name
        item.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ])
    }
}
