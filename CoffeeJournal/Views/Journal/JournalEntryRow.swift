import SwiftUI

// MARK: - Linear-style row
// Dense, no card wrapping at the row level. List provides the surface.
// Left thumbnail, two-line text block, metadata trailing.

struct JournalEntryRow: View {
    let entry: CoffeeEntry

    var body: some View {
        HStack(spacing: 11) {
            // Thumbnail
            thumbnailView
                .frame(width: 44, height: 44)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .strokeBorder(Color.appBorder, lineWidth: Constants.Layout.borderWidth)
                )

            // Text block
            VStack(alignment: .leading, spacing: 2) {
                Text(entry.displayTitle)
                    .font(Constants.Typography.body.weight(.medium))
                    .foregroundStyle(Color.textPrimary)
                    .lineLimit(1)

                Text(entry.displaySubtitle)
                    .font(Constants.Typography.caption)
                    .foregroundStyle(Color.textSecondary)
                    .lineLimit(1)
            }

            Spacer(minLength: 8)

            // Trailing metadata
            VStack(alignment: .trailing, spacing: 3) {
                StarRatingDisplayView(rating: entry.rating, starSize: 10)

                Text(entry.dateBrewed.journalDisplayDate)
                    .font(Constants.Typography.micro)
                    .foregroundStyle(Color.textTertiary)
            }
        }
        .padding(.vertical, 6)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(entry.displayTitle), \(entry.roasterName), \(entry.rating) stars")
    }

    @ViewBuilder
    private var thumbnailView: some View {
        if let photo = entry.primaryPhoto {
            CoffeePhotoView(photo: photo, contentMode: .fill)
        } else {
            ZStack {
                Color.appSurfaceSunken
                Image(systemName: "cup.and.saucer")
                    .font(.system(size: 16, weight: .light))
                    .foregroundStyle(Color.textTertiary)
            }
        }
    }
}
