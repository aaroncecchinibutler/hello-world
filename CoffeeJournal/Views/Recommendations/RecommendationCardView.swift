import SwiftUI
import SafariServices

struct RecommendationCardView: View {
    let recommendation: CoffeeRecommendation
    @State private var showingSafari = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // Header
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .firstTextBaseline) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(recommendation.coffeeName)
                            .font(Constants.Typography.body.weight(.semibold))
                            .foregroundStyle(Color.textPrimary)
                        Text(recommendation.roasterName)
                            .font(Constants.Typography.caption)
                            .foregroundStyle(Color.textSecondary)
                    }
                    Spacer()
                    if let price = recommendation.priceUSD {
                        Text(String(format: "$%.0f", price))
                            .font(Constants.Typography.body.weight(.medium))
                            .foregroundStyle(Color.textPrimary)
                    }
                }

                // Attribute chips
                HStack(spacing: 4) {
                    if recommendation.isSponsored {
                        Text("Sponsored")
                            .font(Constants.Typography.micro)
                            .foregroundStyle(Color.textTertiary)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(Color.appSurfaceSunken)
                            .clipShape(Capsule())
                            .overlay(Capsule().strokeBorder(Color.appBorder, lineWidth: Constants.Layout.borderWidth))
                    }
                    TagChipView(name: recommendation.originCountry)
                    TagChipView(name: recommendation.processingMethod.displayName)
                    TagChipView(name: recommendation.roastLevel.displayName)
                }
            }
            .padding(Constants.Layout.cardPadding)

            Rectangle().fill(Color.appBorder).frame(height: Constants.Layout.borderWidth)

            // Description + flavours
            VStack(alignment: .leading, spacing: 8) {
                Text(recommendation.description)
                    .font(Constants.Typography.caption)
                    .foregroundStyle(Color.textSecondary)

                if !recommendation.flavorTags.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 4) {
                            ForEach(recommendation.flavorTags, id: \.self) {
                                TagChipView(name: $0)
                            }
                        }
                    }
                }
            }
            .padding(Constants.Layout.cardPadding)

            // Match score + CTA
            if recommendation.matchScore > 0 || recommendation.purchaseURL != nil {
                Rectangle().fill(Color.appBorder).frame(height: Constants.Layout.borderWidth)

                HStack(spacing: 12) {
                    if recommendation.matchScore > 0 {
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Match")
                                .font(Constants.Typography.micro)
                                .foregroundStyle(Color.textTertiary)
                            GeometryReader { geo in
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 2).fill(Color.appBorder)
                                    RoundedRectangle(cornerRadius: 2)
                                        .fill(Color.appAccent)
                                        .frame(width: geo.size.width * recommendation.matchScore)
                                }
                            }
                            .frame(height: 4)
                        }
                        .frame(maxWidth: .infinity)
                    }

                    if recommendation.purchaseURL != nil {
                        Button("Shop →") { showingSafari = true }
                            .buttonStyle(LinearButtonStyle())
                    }
                }
                .padding(.horizontal, Constants.Layout.cardPadding)
                .padding(.vertical, 10)
            }
        }
        .linearCard()
        .sheet(isPresented: $showingSafari) {
            if let url = recommendation.purchaseURL {
                SafariView(url: url)
            }
        }
    }
}

struct SafariView: UIViewControllerRepresentable {
    let url: URL
    func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}
