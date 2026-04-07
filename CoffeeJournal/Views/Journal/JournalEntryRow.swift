import SwiftUI

struct JournalEntryRow: View {
    let entry: CoffeeEntry

    var body: some View {
        HStack(spacing: 12) {
            // Thumbnail
            thumbnailView
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.brewCream)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(entry.displayTitle)
                    .font(.headline)
                    .lineLimit(1)

                Text(entry.displaySubtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)

                HStack(spacing: 6) {
                    StarRatingDisplayView(rating: entry.rating, starSize: 11)

                    Text("·")
                        .foregroundStyle(.secondary)

                    Text(entry.processingMethod.displayName)
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text("·")
                        .foregroundStyle(.secondary)

                    Text(entry.brewMethod.displayName)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            Text(entry.dateBrewed.journalDisplayDate)
                .font(.caption2)
                .foregroundStyle(.tertiary)
                .multilineTextAlignment(.trailing)
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(entry.displayTitle), \(entry.roasterName), \(entry.rating) stars, \(entry.dateBrewed.journalDisplayDate)")
    }

    @ViewBuilder
    private var thumbnailView: some View {
        if let photo = entry.primaryPhoto {
            CoffeePhotoView(photo: photo, contentMode: .fill)
        } else {
            Image(systemName: "cup.and.saucer.fill")
                .font(.title2)
                .foregroundStyle(Color.brewBrown)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.brewCream)
        }
    }
}
