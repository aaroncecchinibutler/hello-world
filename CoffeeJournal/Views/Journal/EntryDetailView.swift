import SwiftUI

struct EntryDetailView: View {
    let entry: CoffeeEntry
    @State private var showingEditSheet = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                // Photo carousel
                if !entry.photos.isEmpty {
                    photoCarousel
                }

                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text(entry.displayTitle)
                        .font(.largeTitle.bold())

                    Text(entry.roasterName)
                        .font(.title3)
                        .foregroundStyle(.secondary)

                    StarRatingDisplayView(rating: entry.rating, starSize: 20)
                }
                .padding(.horizontal)

                // Detail cards
                Group {
                    detailCard(title: "Origin") {
                        DetailRow(label: "Country",    value: entry.originCountry)
                        DetailRow(label: "Region",     value: entry.originRegion)
                        if let farm = entry.originFarm { DetailRow(label: "Farm", value: farm) }
                    }

                    detailCard(title: "Coffee") {
                        DetailRow(label: "Processing", value: entry.processingMethod.displayName)
                        DetailRow(label: "Roast",      value: entry.roastLevel.displayName)
                    }

                    detailCard(title: "Brew") {
                        let params = entry.brewParameters
                        DetailRow(label: "Method",     value: entry.brewMethod.displayName)
                        DetailRow(label: "Grind",      value: params.grindSize.displayName)
                        DetailRow(label: "Dose",       value: "\(params.dosageGrams, specifier: "%.1f") g")
                        DetailRow(label: "Water",      value: "\(params.waterAmountML, specifier: "%.0f") ml")
                        DetailRow(label: "Temp",       value: "\(params.waterTempCelsius, specifier: "%.0f")°C")
                        DetailRow(label: "Time",       value: params.brewTimeFormatted)
                        DetailRow(label: "Ratio",      value: "1:\(params.brewRatio, specifier: "%.1f")")
                    }

                    if !entry.flavorTags.isEmpty {
                        detailCard(title: "Flavour Notes") {
                            TagCloudView(tags: entry.flavorTagNames, selectedTags: Set(entry.flavorTagNames))
                                .padding(.top, 4)
                        }
                    }

                    if !entry.personalNotes.isEmpty {
                        detailCard(title: "Notes") {
                            Text(entry.personalNotes)
                                .font(.body)
                        }
                    }
                }
                .padding(.horizontal)

                Text("Brewed on \(entry.dateBrewed.journalDisplayDateTime)")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                    .padding(.horizontal)
                    .padding(.bottom)
            }
        }
        .navigationTitle(entry.displayTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Edit") { showingEditSheet = true }
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            EntryFormView(mode: .edit(entry))
        }
    }

    // MARK: - Subviews

    private var photoCarousel: some View {
        TabView {
            ForEach(entry.photos) { photo in
                CoffeePhotoView(photo: photo, contentMode: .fill)
                    .clipped()
            }
        }
        .tabViewStyle(.page)
        .frame(height: 260)
        .clipShape(RoundedRectangle(cornerRadius: 0))
    }

    private func detailCard<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .foregroundStyle(.primary)
            content()
        }
        .cardStyle()
    }
}

private struct DetailRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(width: 90, alignment: .leading)
            Text(value)
                .font(.subheadline)
            Spacer()
        }
    }
}
