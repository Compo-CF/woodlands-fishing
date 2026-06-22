import SwiftUI
import MapKit

/// UIKit-bridged MKMapView with native pin clustering. SwiftUI's Map (iOS 17/18)
/// doesn't expose `clusteringIdentifier` or `MKClusterAnnotation` — to get
/// production-quality clustering for 75+ pins we drop down to MKMapView, which
/// has battle-tested clustering built in. Tap a cluster to zoom into it; tap
/// a single pin to open the spot detail sheet.
struct ClusteredMapView: UIViewRepresentable {
    let spots: [FishingSpot]
    let favoriteIDs: Set<UUID>
    @Binding var selectedSpot: FishingSpot?

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.showsCompass = true
        mapView.showsScale = true
        mapView.pointOfInterestFilter = .excludingAll
        mapView.register(
            SpotAnnotationView.self,
            forAnnotationViewWithReuseIdentifier: SpotAnnotationView.reuseID
        )
        mapView.register(
            ClusterAnnotationView.self,
            forAnnotationViewWithReuseIdentifier: ClusterAnnotationView.reuseID
        )
        return mapView
    }

    func updateUIView(_ mapView: MKMapView, context: Context) {
        // We always remove and re-add all spot annotations on update. With 75–100
        // spots this is fast and avoids diffing complexity when favorites change
        // (since the favorite state changes the marker glyph).
        let oldAnnotations = mapView.annotations.compactMap { $0 as? SpotAnnotation }
        mapView.removeAnnotations(oldAnnotations)

        let newAnnotations = spots.map {
            SpotAnnotation(spot: $0, isFavorite: favoriteIDs.contains($0.id))
        }
        mapView.addAnnotations(newAnnotations)

        // First load: frame to fit everything. After that, leave the user's
        // chosen viewport alone so adding/removing favorites doesn't reframe.
        if !context.coordinator.didFitInitial && !spots.isEmpty {
            mapView.showAnnotations(newAnnotations, animated: false)
            context.coordinator.didFitInitial = true
        }
    }

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    final class Coordinator: NSObject, MKMapViewDelegate {
        let parent: ClusteredMapView
        var didFitInitial = false
        init(_ parent: ClusteredMapView) { self.parent = parent }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MKUserLocation { return nil }
            if annotation is MKClusterAnnotation {
                return mapView.dequeueReusableAnnotationView(
                    withIdentifier: ClusterAnnotationView.reuseID, for: annotation
                )
            }
            if annotation is SpotAnnotation {
                return mapView.dequeueReusableAnnotationView(
                    withIdentifier: SpotAnnotationView.reuseID, for: annotation
                )
            }
            return nil
        }

        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            // Tapping a cluster zooms in.
            if let cluster = view.annotation as? MKClusterAnnotation {
                mapView.deselectAnnotation(cluster, animated: false)
                let span = MKCoordinateSpan(
                    latitudeDelta: mapView.region.span.latitudeDelta * 0.5,
                    longitudeDelta: mapView.region.span.longitudeDelta * 0.5
                )
                let region = MKCoordinateRegion(center: cluster.coordinate, span: span)
                mapView.setRegion(region, animated: true)
                return
            }
            // Tapping a single spot opens the SwiftUI detail sheet.
            if let spotAnno = view.annotation as? SpotAnnotation {
                parent.selectedSpot = spotAnno.spot
                mapView.deselectAnnotation(spotAnno, animated: true)
            }
        }
    }
}

/// MKAnnotation wrapper around a FishingSpot. Holds favorite state so the
/// view can pick the right glyph without a separate lookup.
final class SpotAnnotation: NSObject, MKAnnotation {
    let spot: FishingSpot
    let isFavorite: Bool
    init(spot: FishingSpot, isFavorite: Bool) {
        self.spot = spot
        self.isFavorite = isFavorite
    }
    var coordinate: CLLocationCoordinate2D { spot.coordinate }
    var title: String? { spot.name }
}

/// Individual spot pin. Color reflects access type; glyph is a fish or a
/// heart if the user has starred this spot. `clusteringIdentifier` enables
/// Apple's built-in clustering algorithm.
final class SpotAnnotationView: MKMarkerAnnotationView {
    static let reuseID = "SpotAnnotation"

    override var annotation: MKAnnotation? {
        didSet {
            guard let spotAnno = annotation as? SpotAnnotation else { return }
            clusteringIdentifier = "fishingSpot"
            displayPriority = .defaultHigh
            canShowCallout = false  // we open the SwiftUI sheet instead

            let color: UIColor
            switch spotAnno.spot.access {
            case .publicOpen: color = .systemGreen
            case .publicLimited: color = .systemYellow
            case .privateNoAccess: color = .systemRed
            }
            markerTintColor = color
            glyphImage = UIImage(systemName: spotAnno.isFavorite ? "heart.fill" : "fish.fill")
        }
    }
}

/// Cluster pin shown when several spots are nearby. Displays a member count.
final class ClusterAnnotationView: MKMarkerAnnotationView {
    static let reuseID = "ClusterAnnotation"

    override var annotation: MKAnnotation? {
        didSet {
            guard let cluster = annotation as? MKClusterAnnotation else { return }
            markerTintColor = UIColor(red: 0.04, green: 0.42, blue: 0.45, alpha: 1.0)
            glyphText = "\(cluster.memberAnnotations.count)"
            displayPriority = .defaultHigh
        }
    }
}
