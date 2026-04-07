import SwiftUI

struct APIKeySettingsView: View {
    @State private var apiKey: String = ""
    @State private var showKey: Bool = false
    @State private var showingSaved = false

    var body: some View {
        Form {
            Section {
                HStack {
                    if showKey {
                        TextField("Paste your API key", text: $apiKey)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                    } else {
                        SecureField("Paste your API key", text: $apiKey)
                    }
                    Button {
                        showKey.toggle()
                    } label: {
                        Image(systemName: showKey ? "eye.slash" : "eye")
                            .foregroundStyle(.secondary)
                    }
                }
            } header: {
                Text("Google API Key")
            } footer: {
                Text("Required for online image search. Your key is stored securely in the iOS Keychain and never transmitted to our servers.")
            }

            Section {
                Button("Save Key") {
                    AppConfiguration.setGoogleAPIKey(apiKey)
                    showingSaved = true
                }
                .disabled(apiKey.trimmingCharacters(in: .whitespaces).isEmpty)

                if AppConfiguration.hasGoogleAPIKey {
                    Button("Remove Key", role: .destructive) {
                        AppConfiguration.clearGoogleAPIKey()
                        apiKey = ""
                    }
                }
            }

            Section("How to get an API key") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("1. Go to console.cloud.google.com")
                    Text("2. Enable the Custom Search API")
                    Text("3. Create credentials → API Key")
                    Text("4. Go to cse.google.com to create a Custom Search Engine, enable Image Search")
                    Text("5. Copy your API Key here and your Search Engine ID into the app's Info.plist as GOOGLE_SEARCH_ENGINE_ID")
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Image Search Setup")
        .onAppear {
            apiKey = AppConfiguration.googleAPIKey ?? ""
        }
        .alert("Saved", isPresented: $showingSaved) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Your API key has been saved to the Keychain.")
        }
    }
}
