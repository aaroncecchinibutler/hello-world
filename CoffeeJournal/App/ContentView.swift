import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            JournalListView()
                .tabItem {
                    Label("Journal", systemImage: "book.closed.fill")
                }

            InsightsView()
                .tabItem {
                    Label("Insights", systemImage: "chart.bar.fill")
                }

            RecommendationsView()
                .tabItem {
                    Label("Discover", systemImage: "sparkles")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
        .tint(Color.brewBrown)
    }
}

#Preview {
    ContentView()
        .modelContainer(ModelContainerFactory.makePreviewContainer())
        .environment(SubscriptionService())
}
