import SwiftUI
import SwiftData

@main
struct CoffeeJournalApp: App {

    @AppStorage("iCloudSyncEnabled") private var iCloudSyncEnabled: Bool = false
    @State private var subscriptionService = SubscriptionService()

    var container: ModelContainer {
        ModelContainerFactory.makeContainer(cloudKitEnabled: iCloudSyncEnabled)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(container)
                .environment(subscriptionService)
        }
    }
}
