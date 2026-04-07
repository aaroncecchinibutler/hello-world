import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(SubscriptionService.self) private var subscription
    @Environment(\.modelContext) private var context

    var body: some View {
        NavigationStack {
            Form {
                // Premium status
                Section {
                    if subscription.isPremium {
                        HStack {
                            Image(systemName: "crown.fill")
                                .foregroundStyle(Color.ratingGold)
                            Text("Premium Active")
                                .fontWeight(.semibold)
                        }
                    } else {
                        NavigationLink(destination: SubscriptionView()) {
                            HStack {
                                Image(systemName: "sparkles")
                                    .foregroundStyle(Color.brewBrown)
                                Text("Upgrade to Premium")
                                    .fontWeight(.semibold)
                            }
                        }
                    }
                }

                // Image search
                Section("Image Search") {
                    NavigationLink("Google API Key Setup") {
                        APIKeySettingsView()
                    }
                    HStack {
                        Text("Status")
                        Spacer()
                        Text(AppConfiguration.hasGoogleAPIKey ? "Configured" : "Not configured")
                            .foregroundStyle(AppConfiguration.hasGoogleAPIKey ? .green : .secondary)
                    }
                }

                // About
                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "—")
                            .foregroundStyle(.secondary)
                    }
                    Link("Rate on App Store", destination: URL(string: "https://apps.apple.com")!)
                    Link("Privacy Policy", destination: URL(string: "https://example.com/privacy")!)
                }
            }
            .navigationTitle("Settings")
        }
    }
}
