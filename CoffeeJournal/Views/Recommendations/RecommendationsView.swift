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
                    VStack(spacing: 8) {
                        ProgressView().tint(Color.appAccent)
                        Text("Finding matches…")
                            .font(Constants.Typography.caption)
                            .foregroundStyle(Color.textTertiary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if vm.recommendations.isEmpty {
                    EmptyStateView(
                        systemImage: "sparkles",
                        title: "No Recommendations Yet",
                        message: "Add journal entries so we can learn your taste profile."
                    )
                } else {
                    list
                }
            }
            .background(Color.appBackground)
            .navigationTitle("Discover")
            .toolbarBackground(Color.appBackground, for: .navigationBar)
        }
        .task { await vm.loadRecommendations(basedOn: entries) }
        .onChange(of: entries.count) {
            Task { await vm.loadRecommendations(basedOn: entries) }
        }
    }

    private var list: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                ForEach(vm.recommendations.prefix(freeLimit)) { rec in
                    RecommendationCardView(recommendation: rec)
                }

                if vm.recommendations.count > freeLimit {
                    if subscription.isPremium {
                        ForEach(vm.recommendations.dropFirst(freeLimit)) { rec in
                            RecommendationCardView(recommendation: rec)
                        }
                    } else {
                        lockedBanner
                    }
                }
            }
            .padding(.horizontal, Constants.Layout.pageInset)
            .padding(.vertical, Constants.Layout.pageInset)
        }
    }

    private var lockedBanner: some View {
        VStack(spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "lock")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(Color.textTertiary)
                Text("\(vm.recommendations.count - freeLimit) more recommendations unlocked with Premium")
                    .font(Constants.Typography.caption)
                    .foregroundStyle(Color.textSecondary)
                Spacer()
            }

            NavigationLink(destination: SubscriptionView()) {
                Text("Upgrade to Premium →")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(LinearPrimaryButtonStyle())
        }
        .linearCard()
    }
}
