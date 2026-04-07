import Foundation

struct AppConfiguration {

    /// Google Custom Search Engine ID — stored in Info.plist via xcconfig (less sensitive)
    static var googleSearchEngineID: String {
        Bundle.main.infoDictionary?[Constants.InfoPlist.googleSearchEngineIDKey] as? String ?? ""
    }

    /// Google API key — stored in Keychain only, never in source or Info.plist
    static var googleAPIKey: String? {
        KeychainHelper.read(key: Constants.Keychain.googleAPIKey)
    }

    static func setGoogleAPIKey(_ key: String) {
        KeychainHelper.save(key: Constants.Keychain.googleAPIKey, value: key)
    }

    static func clearGoogleAPIKey() {
        KeychainHelper.delete(key: Constants.Keychain.googleAPIKey)
    }

    static var hasGoogleAPIKey: Bool {
        guard let key = googleAPIKey else { return false }
        return !key.isEmpty
    }
}
