import SwiftUI
import SwiftData

struct InsightsView: View {
    @Environment(SubscriptionService.self) private var subscription
    @State private var vm = InsightsViewModel()
    @Query private var entries: [CoffeeEntry]

    var body: some View {
        NavigationStack {
            Group {
                if subscription.isPremium {
                    premiumContent
                } else {
                    PaywallView(
                        featureName: "Insights",
                        description: "Discover your taste preferences with charts and data-driven patterns from your journal.",
                        systemImage: "chart.bar"
                    )
                }
            }
            .background(Color.appBackground)
            .navigationTitle("Insights")
            .toolbarBackground(Color.appBackground, for: .navigationBar)
        }
        .task { await vm.computeInsights(from: entries) }
        .onChange(of: entries.count) {
            Task { await vm.computeInsights(from: entries) }
        }
    }

    @ViewBuilder
    private var premiumContent: some View {
        if vm.isLoading {
            VStack(spacing: 8) {
                ProgressView()
                    .tint(Color.appAccent)
                Text("Analysing your journal…")
                    .font(Constants.Typography.caption)
                    .foregroundStyle(Color.textTertiary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if vm.insights.isEmpty {
            EmptyStateView(
                systemImage: "chart.bar",
                title: "No Insights Yet",
                message: "Add more entries to unlock personalised taste patterns."
            )
        } else {
            ScrollView {
                LazyVStack(spacing: 10) {
                    ForEach(vm.insights) { insight in
                        InsightCardView(insight: insight)
                    }
                }
                .padding(.horizontal, Constants.Layout.pageInset)
                .padding(.vertical, Constants.Layout.pageInset)
            }
        }
    }
}
