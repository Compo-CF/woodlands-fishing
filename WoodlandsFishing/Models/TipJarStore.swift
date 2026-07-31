import Foundation
import StoreKit

/// Loads the three consumable "tip jar" products from StoreKit 2 and drives
/// the purchase flow. The product identifiers here must match products
/// configured in App Store Connect for this app:
///   - com.compofelice.WoodlandsFishing.tip.small   ($0.99)
///   - com.compofelice.WoodlandsFishing.tip.medium  ($2.99)
///   - com.compofelice.WoodlandsFishing.tip.large   ($4.99)
///
/// All three are **Consumable** (users can tip repeatedly). There is nothing
/// to unlock server-side — a successful purchase simply flips a local
/// "thanks" state and finishes the transaction so it doesn't linger.
@Observable
@MainActor
final class TipJarStore {
    /// Products, once loaded from StoreKit — empty until `load()` returns.
    var products: [Product] = []
    /// True while a purchase is being processed.
    var isPurchasing = false
    /// Set to a product's ID immediately after a successful purchase so the
    /// UI can show a thank-you state. Cleared when the sheet dismisses.
    var lastPurchasedProductID: String?

    static let productIDs: [String] = [
        "com.compofelice.WoodlandsFishing.tip.small",
        "com.compofelice.WoodlandsFishing.tip.medium",
        "com.compofelice.WoodlandsFishing.tip.large",
    ]

    /// Load product metadata. Safe to call multiple times. Silently no-ops
    /// on error (offline, TestFlight without IAP config, etc.) — the
    /// TipJarView shows an empty state in that case.
    func load() async {
        do {
            let fetched = try await Product.products(for: Self.productIDs)
            // Sort by price so small → medium → large regardless of the
            // order in which App Store Connect returns them.
            products = fetched.sorted { $0.price < $1.price }
        } catch {
            products = []
        }
    }

    /// Kick off a purchase. Returns true on success. Sets `lastPurchasedProductID`
    /// so the calling view can show a thank-you state.
    @discardableResult
    func purchase(_ product: Product) async -> Bool {
        guard !isPurchasing else { return false }
        isPurchasing = true
        defer { isPurchasing = false }
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                // For consumables we only care that the purchase completed —
                // no entitlement to grant. Finish the transaction so it
                // doesn't reappear on next launch.
                if case .verified(let transaction) = verification {
                    await transaction.finish()
                    lastPurchasedProductID = product.id
                    return true
                }
                return false
            case .userCancelled, .pending:
                return false
            @unknown default:
                return false
            }
        } catch {
            return false
        }
    }
}
