import SwiftUI

/// Displays a CoffeePhoto, handling both local UIImage data and remote URLs.
struct CoffeePhotoView: View {
    let photo: CoffeePhoto
    var contentMode: ContentMode = .fill

    var body: some View {
        Group {
            if let uiImage = photo.uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
            } else if let url = photo.remoteURL {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    case .success(let image):
                        image.resizable().aspectRatio(contentMode: contentMode)
                    case .failure:
                        Image(systemName: "photo.badge.exclamationmark")
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Image(systemName: "photo")
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}

/// Loads and displays an image from a URL string inline.
struct RemoteImageView: View {
    let urlString: String
    var contentMode: ContentMode = .fill

    var body: some View {
        if let url = URL(string: urlString) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image.resizable().aspectRatio(contentMode: contentMode)
                case .failure:
                    Image(systemName: "photo.badge.exclamationmark").foregroundStyle(.secondary)
                @unknown default:
                    EmptyView()
                }
            }
        } else {
            Image(systemName: "link.badge.plus").foregroundStyle(.secondary)
        }
    }
}
