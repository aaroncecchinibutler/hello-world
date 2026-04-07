import SwiftUI
import SafariServices

struct RecommendationCardView: View {
    let recommendation: CoffeeRecommendation
    @State private var showingSafari = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        if recommendation.isSponsored {
                            Text("SPONSORED")
                                .font(.caption2)
                                .fontWeight(.semibold)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.secondary.opacity(0.2))
                                .clipShape(Capsule())
                        }
                        Spacer()
                    }
                    Text(recommendation.coffeeName)
                        .font(.headline)
                    Text(recommendation.roasterName)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    if let price = recommendation.priceUSD {
                        Text(String(format: "$%.2f", price))
                            .font(.headline)
                            .foregroundStyle(Color.brewBrown)
                    }
                    if let grams = recommendation.weightGrams {
                        Text("\(grams)g")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            // Tags
            HStack(spacing: 6) {
                TagChipView(name: recommendation.originCountry)
                TagChipView(name: recommendation.processingMethod.displayName)
                TagChipView(name: recommendation.roastLevel.displayName)
            }

            Text(recommendation.description)
                .font(.caption)
                .foregroundStyle(.secondary)

            // Flavor tags
            if !recommendation.flavorTags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(recommendation.flavorTags, id: \.self) { tag in
                            TagChipView(name: tag)
                        }
                    }
                }
            }

            // Match score bar
            if recommendation.matchScore > 0 {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Match Score")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule().fill(Color.secondary.opacity(0.2))
                            Capsule()
                                .fill(Color.brewBrown.gradient)
                                .frame(width: geo.size.width * recommendation.matchScore)
                        }
                    }
                    .frame(height: 6)
                }
            }

            // Buy button
            if recommendation.purchaseURL != nil {
                Button("Shop Now →") { showingSafari = true }
                    .buttonStyle(.borderedProminent)
                    .tint(Color.brewBrown)
            }
        }
        .cardStyle()
        .sheet(isPresented: $showingSafari) {
            if let url = recommendation.purchaseURL {
                SafariView(url: url)
            }
        }
    }
}

// MARK: - SafariView wrapper

struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}
