import Foundation

struct ImageSearchResult: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let thumbnailURL: URL
    let fullsizeURL: URL
    /// The web page where this image was found
    let contextLink: URL

    var displayDomain: String {
        contextLink.host ?? contextLink.absoluteString
    }
}
