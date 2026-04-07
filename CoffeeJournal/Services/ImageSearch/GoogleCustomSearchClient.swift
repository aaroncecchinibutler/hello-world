import Foundation

final class GoogleCustomSearchClient: ImageSearchService {

    private let session: URLSession
    private static let baseURL = "https://www.googleapis.com/customsearch/v1"

    init(session: URLSession = .shared) {
        self.session = session
    }

    func search(query: String, page: Int = 0) async throws -> [ImageSearchResult] {
        guard let apiKey = AppConfiguration.googleAPIKey, !apiKey.isEmpty else {
            throw ImageSearchError.missingAPIKey
        }
        let engineID = AppConfiguration.googleSearchEngineID
        guard !engineID.isEmpty else {
            throw ImageSearchError.missingSearchEngineID
        }

        var components = URLComponents(string: Self.baseURL)!
        components.queryItems = [
            URLQueryItem(name: "key",        value: apiKey),
            URLQueryItem(name: "cx",         value: engineID),
            URLQueryItem(name: "q",          value: query),
            URLQueryItem(name: "searchType", value: "image"),
            URLQueryItem(name: "num",        value: "10"),
            URLQueryItem(name: "start",      value: "\(max(1, page * 10 + 1))")
        ]

        guard let url = components.url else {
            throw ImageSearchError.invalidResponse
        }

        let (data, response) = try await session.data(from: url)

        guard let http = response as? HTTPURLResponse else {
            throw ImageSearchError.invalidResponse
        }

        switch http.statusCode {
        case 200:
            break
        case 429:
            throw ImageSearchError.rateLimitExceeded
        case 403:
            // Google returns 403 on quota exceeded
            throw ImageSearchError.quotaExceeded
        default:
            throw ImageSearchError.httpError(http.statusCode)
        }

        let decoded = try JSONDecoder().decode(GoogleSearchResponse.self, from: data)
        return (decoded.items ?? []).compactMap { item in
            guard let thumbURL = URL(string: item.image.thumbnailLink),
                  let fullURL  = URL(string: item.link),
                  let contextURL = URL(string: item.image.contextLink)
            else { return nil }
            return ImageSearchResult(
                id: item.link,
                title: item.title,
                thumbnailURL: thumbURL,
                fullsizeURL: fullURL,
                contextLink: contextURL
            )
        }
    }

    // MARK: - Decodable response types

    private struct GoogleSearchResponse: Decodable {
        let items: [GoogleSearchItem]?
    }

    private struct GoogleSearchItem: Decodable {
        let title: String
        let link: String
        let image: GoogleImageMeta
    }

    private struct GoogleImageMeta: Decodable {
        let thumbnailLink: String
        let contextLink: String
    }
}
