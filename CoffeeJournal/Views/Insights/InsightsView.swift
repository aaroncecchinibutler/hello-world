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
                        description: "Discover your taste preferences with beautiful charts and data-driven insights from your journal.",
                        systemImage: "chart.bar.fill"
                    )
                }
            }
            .navigationTitle("Insights")
        }
        .task { await vm.computeInsights(from: entries) }
        .onChange(of: entries.count) {
            Task { await vm.computeInsights(from: entries) }
        }
    }

    @ViewBuilder
    private var premiumContent: some View {
        if vm.isLoading {
            ProgressView("Analysing your journal…")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if vm.insights.isEmpty {
            EmptyStateView(
                systemImage: "chart.bar",
                title: "No Insights Yet",
                message: "Add more entries to your journal to unlock personalised insights."
            )
        } else {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(vm.insights) { insight in
                        InsightCardView(insight: insight)
                    }
                }
                .padding()
            }
        }
    }
}
