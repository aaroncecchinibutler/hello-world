import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            JournalListView()
                .tabItem {
                    Label("Journal", systemImage: "book.closed")
                }

            InsightsView()
                .tabItem {
                    Label("Insights", systemImage: "chart.bar")
                }

            RecommendationsView()
                .tabItem {
                    Label("Discover", systemImage: "sparkles")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
        // Tab bar: use appSurface + appBorder line, accent on selected
        .tint(Color.appAccent)
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.appSurface
            // 1 pt top border instead of default shadow
            appearance.shadowColor = UIColor.appBorder
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(ModelContainerFactory.makePreviewContainer())
        .environment(SubscriptionService())
}
