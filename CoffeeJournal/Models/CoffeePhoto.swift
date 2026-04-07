import Foundation
import SwiftData
import UIKit

@Model
final class CoffeePhoto {
    /// Compressed JPEG data for locally captured/selected photos
    var imageData: Data?
    /// Remote URL string for web-searched images or user-pasted URLs
    var remoteURLString: String?
    var caption: String?
    var createdAt: Date
    var source: PhotoSource

    init(
        imageData: Data? = nil,
        remoteURLString: String? = nil,
        caption: String? = nil,
        source: PhotoSource
    ) {
        self.imageData = imageData
        self.remoteURLString = remoteURLString
        self.caption = caption
        self.createdAt = Date()
        self.source = source
    }

    // MARK: Convenience

    @Transient
    var uiImage: UIImage? {
        guard let data = imageData else { return nil }
        return UIImage(data: data)
    }

    @Transient
    var remoteURL: URL? {
        guard let str = remoteURLString else { return nil }
        return URL(string: str)
    }

    /// True if this photo has any displayable content
    @Transient
    var hasContent: Bool {
        imageData != nil || remoteURLString != nil
    }
}
