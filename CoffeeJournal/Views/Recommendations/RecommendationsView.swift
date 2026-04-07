import SwiftUI
import SwiftData

struct RecommendationsView: View {
    @Environment(SubscriptionService.self) private var subscription
    @State private var vm = RecommendationsViewModel()
    @Query private var entries: [CoffeeEntry]

    private let freeLimit = 3

    var body: some View {
        NavigationStack {
            Group {
                if vm.isLoading {
                    ProgressView("Finding matches…")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if vm.recommendations.isEmpty {
                    EmptyStateView(
                        systemImage: "sparkles",
                        title: "No Recommendations Yet",
                        message: "Add journal entries so we can learn your taste profile."
                    )
                } else {
                    recommendationsList
                }
            }
            .navigationTitle("Discover")
        }
        .task { await vm.loadRecommendations(basedOn: entries) }
        .onChange(of: entries.count) {
            Task { await vm.loadRecommendations(basedOn: entries) }
        }
    }

    @ViewBuilder
    private var recommendationsList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(vm.recommendations.prefix(freeLimit)) { rec in
                    RecommendationCardView(recommendation: rec)
                }

                if vm.recommendations.count > freeLimit {
                    if subscription.isPremium {
                        ForEach(vm.recommendations.dropFirst(freeLimit)) { rec in
                            RecommendationCardView(recommendation: rec)
                        }
                    } else {
                        // Paywall interstitial
                        lockedSection
                    }
                }
            }
            .padding()
        }
    }

    private var lockedSection: some View {
        VStack(spacing: 16) {
            Image(systemName: "lock.fill")
                .font(.largeTitle)
                .foregroundStyle(Color.brewBrown)

            Text("\(vm.recommendations.count - freeLimit) More Recommendations")
                .font(.headline)

            Text("Upgrade to Premium to unlock your full personalised coffee discovery list.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            NavigationLink("Upgrade to Premium →") {
                SubscriptionView()
            }
            .buttonStyle(.borderedProminent)
            .tint(Color.brewBrown)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: Constants.Layout.cornerRadius))
    }
}
