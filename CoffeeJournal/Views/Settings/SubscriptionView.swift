import SwiftUI
import StoreKit

struct PaywallView: View {
    let featureName: String
    var description: String = ""
    var systemImage: String = "lock.fill"

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: systemImage)
                .font(.system(size: 60))
                .foregroundStyle(Color.brewBrown)

            VStack(spacing: 8) {
                Text("\(featureName) is a Premium Feature")
                    .font(.title2.bold())
                    .multilineTextAlignment(.center)
                Text(description.isEmpty ? "Upgrade to Coffee Journal Premium to unlock this feature." : description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            NavigationLink("View Premium Plans") {
                SubscriptionView()
            }
            .buttonStyle(.borderedProminent)
            .tint(Color.brewBrown)

            Spacer()
        }
        .padding()
    }
}

struct SubscriptionView: View {
    @Environment(SubscriptionService.self) private var subscription
    @State private var isRestoring = false

    private let features: [String] = [
        "Personalised taste insights & charts",
        "Full coffee recommendations",
        "Export journal as CSV or PDF",
        "iCloud sync across all devices",
        "Priority support"
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                // Hero
                VStack(spacing: 8) {
                    Image(systemName: "cup.and.saucer.fill")
                        .font(.system(size: 64))
                        .foregroundStyle(Color.brewBrown)
                    Text("Coffee Journal Premium")
                        .font(.largeTitle.bold())
                        .multilineTextAlignment(.center)
                    Text("The complete coffee experience")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.top)

                // Feature list
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(features, id: \.self) { feature in
                        HStack(spacing: 12) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(Color.brewBrown)
                            Text(feature)
                                .font(.subheadline)
                        }
                    }
                }
                .padding()
                .background(Color(uiColor: .secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: Constants.Layout.cornerRadius))
                .padding(.horizontal)

                // Products
                if subscription.availableProducts.isEmpty {
                    ProgressView()
                } else {
                    VStack(spacing: 12) {
                        ForEach(subscription.availableProducts, id: \.id) { product in
                            ProductButton(product: product) {
                                Task { await subscription.purchase(product) }
                            }
                        }
                    }
                    .padding(.horizontal)
                }

                // Restore
                Button {
                    isRestoring = true
                    Task {
                        await subscription.restorePurchases()
                        isRestoring = false
                    }
                } label: {
                    if isRestoring {
                        ProgressView()
                    } else {
                        Text("Restore Purchases")
                    }
                }
                .buttonStyle(.plain)
                .foregroundStyle(.secondary)
                .font(.caption)

                Text("Subscriptions auto-renew. Cancel anytime in App Store settings.")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.bottom)
            }
        }
        .navigationTitle("Premium")
        .navigationBarTitleDisplayMode(.inline)
        .task { await subscription.loadProducts() }
    }
}

private struct ProductButton: View {
    let product: Product
    let onPurchase: () -> Void

    var body: some View {
        Button(action: onPurchase) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(product.displayName)
                        .font(.headline)
                    if let period = product.subscription?.subscriptionPeriod {
                        Text(periodLabel(period))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                Spacer()
                Text(product.displayPrice)
                    .font(.headline)
                    .foregroundStyle(Color.brewBrown)
            }
            .padding()
            .background(Color(uiColor: .secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: Constants.Layout.cornerRadius))
        }
        .buttonStyle(.plain)
    }

    private func periodLabel(_ period: Product.SubscriptionPeriod) -> String {
        switch period.unit {
        case .month: return "per month, billed monthly"
        case .year:  return "per year — best value"
        default:     return ""
        }
    }
}
