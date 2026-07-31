import SwiftUI
import StoreKit

/// In-app tip jar. Presents the three consumable tip products from
/// TipJarStore and drives the purchase flow. Complements — does not replace —
/// the external Ko-fi link in the About sheet; users choose whichever feels
/// right.
struct TipJarView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var store = TipJarStore()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 22) {
                    header
                    if store.products.isEmpty {
                        emptyState
                    } else {
                        productList
                    }
                    if let purchasedID = store.lastPurchasedProductID {
                        thankYouCard(for: purchasedID)
                    }
                    footer
                }
                .padding(.vertical, 24)
                .padding(.horizontal)
            }
            .navigationTitle("Tip Jar")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
            .task {
                await store.load()
            }
        }
    }

    private var header: some View {
        VStack(spacing: 10) {
            Image(systemName: "cup.and.saucer.fill")
                .font(.system(size: 40, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 84, height: 84)
                .background(
                    LinearGradient(
                        colors: [Color(red: 0.92, green: 0.55, blue: 0.25),
                                 Color(red: 0.75, green: 0.35, blue: 0.15)],
                        startPoint: .top, endPoint: .bottom
                    ),
                    in: .rect(cornerRadius: 20)
                )
            Text("Support the developer")
                .font(.title3.weight(.semibold))
            Text("If The Woodlands Fishing Guide has been useful, a small tip helps keep it updated, ad-light, and growing.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 8)
        }
        .padding(.top, 4)
    }

    private var productList: some View {
        VStack(spacing: 12) {
            ForEach(store.products, id: \.id) { product in
                Button {
                    Task { await store.purchase(product) }
                } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(product.displayName)
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.primary)
                            Text(product.description)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                                .multilineTextAlignment(.leading)
                        }
                        Spacer()
                        Text(product.displayPrice)
                            .font(.headline)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 6)
                            .background(Color.accentColor, in: .capsule)
                    }
                    .padding(14)
                    .background(Color.secondary.opacity(0.10), in: .rect(cornerRadius: 12))
                }
                .buttonStyle(.plain)
                .disabled(store.isPurchasing)
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 8) {
            Text("Tip options aren't available right now.")
                .font(.subheadline.weight(.medium))
            Text("Check your connection or try again in a moment. Ko-fi is still available from the About screen.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 20)
    }

    private func thankYouCard(for productID: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .font(.title2)
                .foregroundStyle(.green)
            VStack(alignment: .leading, spacing: 2) {
                Text("Thanks for the tip!")
                    .font(.subheadline.weight(.semibold))
                Text("It really does help keep this thing going.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(14)
        .background(Color.green.opacity(0.12), in: .rect(cornerRadius: 12))
    }

    private var footer: some View {
        Text("Tips are one-time purchases handled by Apple. They don't unlock any features — the whole app stays free.")
            .font(.caption)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 8)
    }
}
