import Foundation

protocol ImageSearchService: Sendable {
    func search(query: String, page: Int) async throws -> [ImageSearchResult]
}

// MARK: - Errors

enum ImageSearchError: LocalizedError {
    case missingAPIKey
    case missingSearchEngineID
    case invalidResponse
    case rateLimitExceeded
    case quotaExceeded
    case httpError(Int)

    var errorDescription: String? {
        switch self {
        case .missingAPIKey:
            return "Google API key is not configured. Please add it in Settings."
        case .missingSearchEngineID:
            return "Google Search Engine ID is not configured."
        case .invalidResponse:
            return "Received an unexpected response from the image search service."
        case .rateLimitExceeded:
            return "Too many requests. Please wait a moment and try again."
        case .quotaExceeded:
            return "Daily search quota exceeded. Please try again tomorrow."
        case .httpError(let code):
            return "Search request failed (HTTP \(code))."
        }
    }
}
