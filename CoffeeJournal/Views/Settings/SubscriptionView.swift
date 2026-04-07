import SwiftUI
import StoreKit

// MARK: - Paywall

struct PaywallView: View {
    let featureName: String
    var description: String = ""
    var systemImage: String = "lock"

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Image(systemName: systemImage)
                .font(.system(size: 36, weight: .light))
                .foregroundStyle(Color.textTertiary)

            VStack(spacing: 6) {
                Text("\(featureName) — Premium")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.textPrimary)
                Text(description.isEmpty
                     ? "Upgrade to Coffee Journal Premium to unlock this feature."
                     : description)
                    .font(Constants.Typography.caption)
                    .foregroundStyle(Color.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
            }

            NavigationLink("View Plans") {
                SubscriptionView()
            }
            .buttonStyle(LinearButtonStyle())

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appBackground)
    }
}

// MARK: - Subscription

struct SubscriptionView: View {
    @Environment(SubscriptionService.self) private var subscription
    @State private var isRestoring = false

    private let features: [(icon: String, text: String)] = [
        ("chart.bar",    "Personalised taste insights & charts"),
        ("sparkles",     "Full coffee recommendations"),
        ("arrow.up.doc", "Export journal as CSV or PDF"),
        ("icloud",       "iCloud sync across devices"),
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {

                // Hero
                VStack(spacing: 8) {
                    Image(systemName: "cup.and.saucer")
                        .font(.system(size: 40, weight: .light))
                        .foregroundStyle(Color.appAccent)
                    Text("Coffee Journal Premium")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(Color.textPrimary)
                    Text("The complete coffee experience")
                        .font(Constants.Typography.caption)
                        .foregroundStyle(Color.textSecondary)
                }
                .padding(.vertical, 28)

                Rectangle().fill(Color.appBorder).frame(height: Constants.Layout.borderWidth)

                // Features
                VStack(spacing: 0) {
                    ForEach(features, id: \.text) { feature in
                        HStack(spacing: 12) {
                            Image(systemName: feature.icon)
                                .font(.system(size: 13, weight: .light))
                                .foregroundStyle(Color.appAccent)
                                .frame(width: 18)
                            Text(feature.text)
                                .font(Constants.Typography.body)
                                .foregroundStyle(Color.textPrimary)
                            Spacer()
                        }
                        .padding(.horizontal, Constants.Layout.pageInset)
                        .padding(.vertical, 12)
                        .overlay(
                            Rectangle().fill(Color.appBorder).frame(height: Constants.Layout.borderWidth),
                            alignment: .bottom
                        )
                    }
                }
                .background(Color.appSurface)

                // Products
                VStack(spacing: 8) {
                    if subscription.availableProducts.isEmpty {
                        ProgressView().tint(Color.appAccent).padding()
                    } else {
                        ForEach(subscription.availableProducts, id: \.id) { product in
                            ProductRow(product: product) {
                                Task { await subscription.purchase(product) }
                            }
                        }
                    }
                }
                .padding(.horizontal, Constants.Layout.pageInset)
                .padding(.top, 16)

                // Restore
                Button {
                    isRestoring = true
                    Task {
                        await subscription.restorePurchases()
                        isRestoring = false
                    }
                } label: {
                    Group {
                        if isRestoring { ProgressView().tint(Color.appAccent) }
                        else { Text("Restore Purchases") }
                    }
                }
                .font(Constants.Typography.caption)
                .foregroundStyle(Color.textTertiary)
                .padding(.top, 14)

                Text("Subscriptions auto-renew. Cancel anytime in App Store settings.")
                    .font(Constants.Typography.micro)
                    .foregroundStyle(Color.textTertiary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .padding(.top, 8)
                    .padding(.bottom, 24)
            }
        }
        .background(Color.appBackground)
        .navigationTitle("Premium")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.appBackground, for: .navigationBar)
        .task { await subscription.loadProducts() }
    }
}

private struct ProductRow: View {
    let product: Product
    let onPurchase: () -> Void

    var body: some View {
        Button(action: onPurchase) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(product.displayName)
                        .font(Constants.Typography.body.weight(.medium))
                        .foregroundStyle(Color.textPrimary)
                    if let period = product.subscription?.subscriptionPeriod {
                        Text(periodLabel(period))
                            .font(Constants.Typography.caption)
                            .foregroundStyle(Color.textTertiary)
                    }
                }
                Spacer()
                Text(product.displayPrice)
                    .font(Constants.Typography.body.weight(.semibold))
                    .foregroundStyle(Color.appAccent)
            }
            .padding(Constants.Layout.cardPadding)
            .linearCard()
        }
        .buttonStyle(.plain)
    }

    private func periodLabel(_ period: Product.SubscriptionPeriod) -> String {
        switch period.unit {
        case .month: return "per month · billed monthly"
        case .year:  return "per year · best value"
        default:     return ""
        }
    }
}
