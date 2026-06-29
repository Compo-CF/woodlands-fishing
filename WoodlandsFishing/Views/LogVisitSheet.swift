import SwiftUI
import StoreKit

/// Small sheet to log a fishing visit to a spot. Date defaults to today.
/// Note is optional. Visit is stored in UserDataStore (UserDefaults, local).
struct LogVisitSheet: View {
    let spot: FishingSpot
    @Environment(\.dismiss) private var dismiss
    @Environment(\.requestReview) private var requestReview
    @Environment(UserDataStore.self) private var userData

    @State private var date = Date()
    @State private var note = ""

    /// Visit counts at which to nudge for an App Store rating. Apple
    /// throttles `requestReview` to ~3 prompts per year per user anyway,
    /// so safe to fire at each milestone — the system decides whether
    /// the user actually sees it.
    private let ratingMilestones: Set<Int> = [3, 8, 20]

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    DatePicker("When", selection: $date, in: ...Date(), displayedComponents: .date)
                }
                Section {
                    TextField("Notes (optional)", text: $note, axis: .vertical)
                        .lineLimit(3...8)
                } header: {
                    Text("What happened?")
                } footer: {
                    Text("Catch, conditions, anything to remember. Stored only on this device.")
                }
            }
            .navigationTitle("Log a visit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        userData.addVisit(spotID: spot.id, date: date, note: note.trimmingCharacters(in: .whitespacesAndNewlines))
                        if ratingMilestones.contains(userData.visits.count) {
                            requestReview()
                        }
                        dismiss()
                    }
                    .font(.body.weight(.semibold))
                }
            }
        }
    }
}
