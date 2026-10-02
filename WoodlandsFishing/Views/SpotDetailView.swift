import SwiftUI
import MapKit

struct SpotDetailView: View {
    let spot: FishingSpot
    @Environment(UserDataStore.self) private var userData
    @State private var showingLogVisit = false
    @State private var weatherRefreshToken = UUID()

    private var shareText: String {
        """
        Check out \(spot.name) in The Woodlands Fishing Guide.
        https://apps.apple.com/us/app/the-woodlands-fishing-guide/id6773332173
        """
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: FG.space.xxl) {
                heroCard
                titleBlock
                weatherSection
                atAGlanceSection
                speciesSection
                permitsSection
                detailsSection
                visitsSection
                directionsCTA
                sourceFooter
            }
            .padding(FG.space.lg)
            .padding(.bottom, FG.space.xxxl)
        }
        .background(Color.fgBone.ignoresSafeArea())
        .refreshable {
            weatherRefreshToken = UUID()
            try? await Task.sleep(for: .seconds(0.7))
        }
        .navigationTitle(spot.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                ShareLink(item: shareText, subject: Text(spot.name)) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.fgBodyBold)
                        .foregroundStyle(Color.fgDeepLake)
                }
                .accessibilityLabel("Share this spot")
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    userData.toggleFavorite(spot.id)
                } label: {
                    Image(systemName: userData.isFavorite(spot.id) ? "heart.fill" : "heart")
                        .foregroundStyle(Color.fgAmber)
                        .font(.fgBodyBold)
                }
                .accessibilityLabel(userData.isFavorite(spot.id) ? "Remove from favorites" : "Add to favorites")
            }
        }
        .sheet(isPresented: $showingLogVisit) {
            LogVisitSheet(spot: spot)
                .environment(userData)
        }
        .onAppear {
            userData.recordViewed(spot.id)
        }
    }

    // MARK: - Hero
    // Programmatic Field Guide hero: sunset gradient + sun + pine silhouettes
    // + ripple lines. Placeholder for a real coverPhotoURL painting later
    // (task #3 schema migration will add that field).
    private var heroCard: some View {
        ZStack {
            // Sunset-to-water vertical gradient
            LinearGradient(
                stops: [
                    .init(color: Color.fgDeepLake, location: 0.0),
                    .init(color: Color.fgAmber.opacity(0.9), location: 0.45),
                    .init(color: Color.fgDeepLake, location: 0.6),
                    .init(color: Color.fgDeepLake, location: 1.0)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            // Sun disc, upper-right
            Circle()
                .fill(Color.fgAmber)
                .frame(width: 72, height: 72)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding(.top, FG.space.xl)
                .padding(.trailing, FG.space.x4)
            // Pine silhouettes on the right horizon
            HStack(alignment: .bottom, spacing: 6) {
                pine(height: 50)
                pine(height: 68)
                pine(height: 44)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
            .padding(.trailing, FG.space.xl)
            .padding(.vertical, FG.space.xxl)
            // Ripple lines centered toward the bottom
            VStack(spacing: 10) {
                ripple(width: 120)
                ripple(width: 80)
                ripple(width: 50)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, FG.space.xxxl)
        }
        .frame(height: 220)
        .clipShape(RoundedRectangle(cornerRadius: FG.radius.lg, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: FG.radius.lg, style: .continuous)
                .stroke(Color.fgInk.opacity(0.9), lineWidth: FG.stroke.medium)
        )
    }

    private func pine(height: CGFloat) -> some View {
        Triangle()
            .fill(Color.fgPine)
            .frame(width: height * 0.5, height: height)
    }

    private func ripple(width: CGFloat) -> some View {
        Rectangle()
            .fill(Color.fgBone.opacity(0.5))
            .frame(width: width, height: 2)
    }

    // MARK: - Title + access badge
    private var titleBlock: some View {
        VStack(alignment: .leading, spacing: FG.space.sm) {
            Text(spot.name)
                .font(.fgDisplayXL)
                .foregroundStyle(Color.fgInk)
                .fixedSize(horizontal: false, vertical: true)
            if !spot.description.isEmpty {
                Text(firstSentence(of: spot.description))
                    .font(.fgSerifItalic)
                    .foregroundStyle(Color.fgSlate)
                    .fixedSize(horizontal: false, vertical: true)
            }
            FGBadge(text: accessBadgeText, color: spot.access.fgPinColor)
            if let last = userData.lastVisit(for: spot.id) {
                Text("Last fished \(last.date.formatted(.relative(presentation: .named)))")
                    .font(.fgCaption)
                    .foregroundStyle(Color.fgSlate)
            }
        }
    }

    private var accessBadgeText: String {
        var parts = [spot.access.displayName]
        if spot.bankFishing { parts.append("Bank") }
        switch spot.boatAccess {
        case .kayakCanoe: parts.append("Kayak")
        case .trailerRamp: parts.append("Boat ramp")
        case .none: break
        }
        if spot.catchAndReleaseOnly { parts.append("C&R only") }
        return parts.joined(separator: " · ")
    }

    private func firstSentence(of text: String) -> String {
        if let end = text.firstIndex(where: { $0 == "." || $0 == "!" || $0 == "?" }) {
            return String(text[...end])
        }
        return text
    }

    // MARK: - Section 1: Today on the water
    private var weatherSection: some View {
        VStack(alignment: .leading, spacing: FG.space.md) {
            FGSectionHeader(title: "Today on the water")
            WeatherCard(latitude: spot.latitude, longitude: spot.longitude, refreshToken: weatherRefreshToken)
        }
    }

    // MARK: - Section 2: At a glance
    private var atAGlanceSection: some View {
        VStack(alignment: .leading, spacing: FG.space.md) {
            FGSectionHeader(title: "At a glance")
            FlowChips(chips: atAGlanceChips)
        }
    }

    private var atAGlanceChips: [String] {
        var chips: [String] = []
        if spot.bankFishing { chips.append("Bank access") }
        switch spot.boatAccess {
        case .kayakCanoe: chips.append("Kayak OK")
        case .trailerRamp: chips.append("Boat ramp")
        case .none: break
        }
        if spot.catchAndReleaseOnly { chips.append("Catch & release only") }
        return chips
    }

    // MARK: - Section 3: Species
    @ViewBuilder
    private var speciesSection: some View {
        if !spot.species.isEmpty {
            VStack(alignment: .leading, spacing: FG.space.md) {
                FGSectionHeader(title: "Species")
                FlowChips(chips: spot.species.map(\.displayName))
            }
        }
    }

    // MARK: - Section 4: Permits
    private var permitsSection: some View {
        VStack(alignment: .leading, spacing: FG.space.md) {
            FGSectionHeader(title: "Permits")
            VStack(alignment: .leading, spacing: FG.space.md) {
                ForEach(spot.permitsRequired, id: \.self) { permit in
                    if let url = permit.infoURL {
                        Link(destination: url) {
                            HStack {
                                Text(permit.displayName)
                                    .font(.fgBody)
                                    .foregroundStyle(Color.fgInk)
                                Spacer()
                                Image(systemName: "arrow.up.right")
                                    .font(.fgCaption)
                                    .foregroundStyle(Color.fgSlate)
                            }
                        }
                    } else {
                        Text(permit.displayName)
                            .font(.fgBody)
                            .foregroundStyle(Color.fgInk)
                    }
                }
                Text("Anyone under 17 is exempt from the state license requirement.")
                    .font(.fgCaption)
                    .foregroundStyle(Color.fgSlate)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .fgCard(fill: .fgKraft)
        }
    }

    // MARK: - Section 5: Details (manager, parking, restrictions, description)
    private var detailsSection: some View {
        VStack(alignment: .leading, spacing: FG.space.md) {
            FGSectionHeader(title: "Details")
            VStack(alignment: .leading, spacing: FG.space.lg) {
                FGDataRow(label: "Manager", value: spot.manager)
                if let parking = spot.parkingNotes {
                    FGDataRow(label: "Access & parking", value: parking)
                }
                if let restrictions = spot.restrictions {
                    FGDataRow(label: "Restrictions", value: restrictions)
                }
                if !spot.description.isEmpty {
                    Text(spot.description)
                        .font(.fgBody)
                        .foregroundStyle(Color.fgInk)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }

    // MARK: - Section 6: Your visits
    private var visitsSection: some View {
        let visits = userData.visits(for: spot.id)
        return VStack(alignment: .leading, spacing: FG.space.md) {
            HStack {
                FGSectionHeader(title: "Your visits")
            }
            VStack(alignment: .leading, spacing: FG.space.md) {
                HStack {
                    Button {
                        showingLogVisit = true
                    } label: {
                        Label("Log visit", systemImage: "plus")
                            .font(.fgBodyBold)
                            .foregroundStyle(Color.fgPine)
                    }
                    Spacer()
                }
                if visits.isEmpty {
                    Text("No visits logged yet. Tap Log visit after you fish here.")
                        .font(.fgBodySm)
                        .foregroundStyle(Color.fgSlate)
                } else {
                    VStack(spacing: 0) {
                        ForEach(Array(visits.prefix(5).enumerated()), id: \.element.id) { index, visit in
                            VStack(alignment: .leading, spacing: FG.space.xs) {
                                Text(visit.date.formatted(date: .abbreviated, time: .omitted))
                                    .font(.fgBodyBold)
                                    .foregroundStyle(Color.fgInk)
                                if !visit.note.isEmpty {
                                    Text(visit.note)
                                        .font(.fgCaption)
                                        .foregroundStyle(Color.fgSlate)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, FG.space.md)
                            if index < min(visits.count, 5) - 1 {
                                FGHairline()
                            }
                        }
                    }
                    if visits.count > 5 {
                        Text("+ \(visits.count - 5) more")
                            .font(.fgCaption)
                            .foregroundStyle(Color.fgSlate)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .fgCard(fill: .fgKraft)
        }
    }

    // MARK: - CTA
    private var directionsCTA: some View {
        FGButton(
            title: "Get directions in Apple Maps",
            systemImage: "arrow.triangle.turn.up.right.diamond.fill",
            style: .primary,
            action: openInMaps
        )
        .opacity(spot.access == .privateNoAccess ? 0.4 : 1)
        .allowsHitTesting(spot.access != .privateNoAccess)
    }

    // MARK: - Source footer
    @ViewBuilder
    private var sourceFooter: some View {
        if let url = URL(string: spot.sourceURL) {
            Link(destination: url) {
                HStack(spacing: FG.space.xs) {
                    Text("Verify info at source")
                        .font(.fgCaption)
                    Image(systemName: "arrow.up.right")
                        .font(.fgMicro)
                }
                .foregroundStyle(Color.fgSlate)
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

// MARK: - Supporting shapes & chip layout

// Simple isoceles triangle for pine silhouettes.
private struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.midX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        p.closeSubpath()
        return p
    }
}

// Lays out FGChips in rows that wrap when they'd overflow the container.
// Uses the iOS 16+ Layout protocol for a greedy row-packing flow.
private struct FlowChips: View {
    let chips: [String]
    var body: some View {
        FlowLayout(spacing: FG.space.sm) {
            ForEach(chips, id: \.self) { chip in
                FGChip(text: chip)
            }
        }
    }
}

private struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        var totalHeight: CGFloat = 0
        var rowWidth: CGFloat = 0
        var rowHeight: CGFloat = 0
        var maxRowWidth: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if rowWidth + size.width > maxWidth && rowWidth > 0 {
                totalHeight += rowHeight + spacing
                maxRowWidth = max(maxRowWidth, rowWidth - spacing)
                rowWidth = size.width + spacing
                rowHeight = size.height
            } else {
                rowWidth += size.width + spacing
                rowHeight = max(rowHeight, size.height)
            }
        }
        totalHeight += rowHeight
        maxRowWidth = max(maxRowWidth, rowWidth - spacing)
        return CGSize(
            width: maxWidth.isFinite ? maxWidth : maxRowWidth,
            height: totalHeight
        )
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x: CGFloat = bounds.minX
        var y: CGFloat = bounds.minY
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > bounds.maxX && x > bounds.minX {
                x = bounds.minX
                y += rowHeight + spacing
                rowHeight = 0
            }
            subview.place(
                at: CGPoint(x: x, y: y),
                anchor: .topLeading,
                proposal: ProposedViewSize(size)
            )
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}

// MARK: - AccessType -> FG palette
// Scoped to this view for now; migrated into Enums.swift during task #6 pass.
private extension AccessType {
    var fgPinColor: Color {
        switch self {
        case .publicOpen: .fgPine
        case .publicLimited: .fgAmber
        case .privateContact: .fgSlate
        case .privateNoAccess: .fgRust
        }
    }
}
