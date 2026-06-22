import SwiftUI
import CoreLocation

/// Lets the user suggest a new fishing spot. Submits via the device's mail
/// composer (a pre-filled email to the project maintainer) — no backend,
/// no account required. The maintainer reviews and adds to Spots.json,
/// which goes live for all users on the next app launch via the
/// remote-fetch pipeline.
struct SubmitSpotSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(LocationManager.self) private var locationManager

    @State private var spotName: String = ""
    @State private var managerName: String = ""
    @State private var notes: String = ""
    @State private var useMyLocation: Bool = true
    @State private var manualLat: String = ""
    @State private var manualLon: String = ""

    private let contactEmail = "anthony@subtlefoodie.com"

    private var resolvedCoordinate: CLLocationCoordinate2D? {
        if useMyLocation, let loc = locationManager.location {
            return loc.coordinate
        }
        if let lat = Double(manualLat), let lon = Double(manualLon) {
            return CLLocationCoordinate2D(latitude: lat, longitude: lon)
        }
        return nil
    }

    private var canSubmit: Bool {
        !spotName.trimmingCharacters(in: .whitespaces).isEmpty && resolvedCoordinate != nil
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Lake / pond / spot name", text: $spotName)
                        .textInputAutocapitalization(.words)
                    TextField("Who manages it? (e.g. Township, HOA)", text: $managerName)
                        .textInputAutocapitalization(.words)
                } header: {
                    Text("The basics")
                }

                Section {
                    Toggle("Use my current location", isOn: $useMyLocation)
                        .disabled(locationManager.location == nil)
                    if !useMyLocation {
                        TextField("Latitude (e.g. 30.1438)", text: $manualLat)
                            .keyboardType(.numbersAndPunctuation)
                        TextField("Longitude (e.g. -95.5273)", text: $manualLon)
                            .keyboardType(.numbersAndPunctuation)
                    }
                    if let coord = resolvedCoordinate {
                        Text(String(format: "%.4f, %.4f", coord.latitude, coord.longitude))
                            .font(.caption.monospacedDigit())
                            .foregroundStyle(.secondary)
                    }
                } header: {
                    Text("Where is it?")
                } footer: {
                    Text("Pro tip: in Google Maps, long-press the exact spot, then tap the coordinates at the top to copy them.")
                }

                Section {
                    TextField("Notes (optional)", text: $notes, axis: .vertical)
                        .lineLimit(4...10)
                } header: {
                    Text("Anything else?")
                } footer: {
                    Text("Species, access (bank/boat), parking, known restrictions, catch-and-release rules — anything you know that would help others.")
                }

                Section {
                    Button {
                        sendEmail()
                    } label: {
                        HStack {
                            Spacer()
                            Label("Send suggestion", systemImage: "paperplane.fill")
                                .font(.body.weight(.semibold))
                            Spacer()
                        }
                    }
                    .disabled(!canSubmit)
                } footer: {
                    Text("Opens your Mail app with a pre-filled message to the developer. Once received, the spot is verified and added to the live data — usually within a few days. No account, no signup.")
                }
            }
            .navigationTitle("Suggest a spot")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }

    private func sendEmail() {
        guard let coord = resolvedCoordinate else { return }
        let subject = "New fishing spot suggestion: \(spotName)"
        let body = """
        Name: \(spotName)
        Manager: \(managerName.isEmpty ? "(unknown)" : managerName)
        Coordinates: \(String(format: "%.6f, %.6f", coord.latitude, coord.longitude))

        Notes:
        \(notes.isEmpty ? "(none)" : notes)

        — Submitted from The Woodlands Fishing Guide app
        """
        let mailto = "mailto:\(contactEmail)?subject=\(subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&body=\(body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        if let url = URL(string: mailto) {
            UIApplication.shared.open(url)
            dismiss()
        }
    }
}
