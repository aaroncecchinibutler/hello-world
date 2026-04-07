import SwiftUI

struct SettingsView: View {
    @Environment(SubscriptionService.self) private var subscription

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 1) {

                    // Premium
                    settingsSection(title: "Account") {
                        if subscription.isPremium {
                            settingsRow {
                                Image(systemName: "crown")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundStyle(Color.ratingGold)
                                Text("Premium Active")
                                    .font(Constants.Typography.body.weight(.medium))
                                    .foregroundStyle(Color.textPrimary)
                                Spacer()
                            }
                        } else {
                            NavigationLink(destination: SubscriptionView()) {
                                settingsRow {
                                    Image(systemName: "sparkles")
                                        .font(.system(size: 13, weight: .light))
                                        .foregroundStyle(Color.appAccent)
                                    Text("Upgrade to Premium")
                                        .font(Constants.Typography.body.weight(.medium))
                                        .foregroundStyle(Color.appAccent)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 11))
                                        .foregroundStyle(Color.textTertiary)
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    // Image search
                    settingsSection(title: "Image Search") {
                        NavigationLink(destination: APIKeySettingsView()) {
                            settingsRow {
                                Text("Google API Key")
                                    .font(Constants.Typography.body)
                                    .foregroundStyle(Color.textPrimary)
                                Spacer()
                                Text(AppConfiguration.hasGoogleAPIKey ? "Configured" : "Not set")
                                    .font(Constants.Typography.caption)
                                    .foregroundStyle(AppConfiguration.hasGoogleAPIKey ? Color.appAccent : Color.textTertiary)
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 11))
                                    .foregroundStyle(Color.textTertiary)
                            }
                        }
                        .buttonStyle(.plain)
                    }

                    // About
                    settingsSection(title: "About") {
                        settingsRow {
                            Text("Version")
                                .font(Constants.Typography.body)
                                .foregroundStyle(Color.textPrimary)
                            Spacer()
                            Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "—")
                                .font(Constants.Typography.caption)
                                .foregroundStyle(Color.textTertiary)
                        }
                        Link(destination: URL(string: "https://apps.apple.com")!) {
                            settingsRow {
                                Text("Rate on App Store")
                                    .font(Constants.Typography.body)
                                    .foregroundStyle(Color.textPrimary)
                                Spacer()
                                Image(systemName: "arrow.up.right")
                                    .font(.system(size: 11))
                                    .foregroundStyle(Color.textTertiary)
                            }
                        }
                        Link(destination: URL(string: "https://example.com/privacy")!) {
                            settingsRow {
                                Text("Privacy Policy")
                                    .font(Constants.Typography.body)
                                    .foregroundStyle(Color.textPrimary)
                                Spacer()
                                Image(systemName: "arrow.up.right")
                                    .font(.system(size: 11))
                                    .foregroundStyle(Color.textTertiary)
                            }
                        }
                    }
                }
                .padding(.top, 8)
            }
            .background(Color.appBackground)
            .navigationTitle("Settings")
            .toolbarBackground(Color.appBackground, for: .navigationBar)
        }
    }

    // MARK: - Helpers

    private func settingsSection<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .sectionHeaderStyle()
                .padding(.horizontal, Constants.Layout.pageInset)
                .padding(.top, 16)
                .padding(.bottom, 6)

            VStack(spacing: 0) {
                content()
            }
            .background(Color.appSurface)
            .overlay(Rectangle().fill(Color.appBorder).frame(height: Constants.Layout.borderWidth), alignment: .top)
            .overlay(Rectangle().fill(Color.appBorder).frame(height: Constants.Layout.borderWidth), alignment: .bottom)
        }
    }

    private func settingsRow<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        HStack(spacing: 10) {
            content()
        }
        .padding(.horizontal, Constants.Layout.pageInset)
        .padding(.vertical, 12)
        .overlay(Rectangle().fill(Color.appBorder).frame(height: Constants.Layout.borderWidth), alignment: .bottom)
    }
}
