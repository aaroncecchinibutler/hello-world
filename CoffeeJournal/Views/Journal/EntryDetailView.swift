import SwiftUI

struct EntryDetailView: View {
    let entry: CoffeeEntry
    @State private var showingEditSheet = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {

                // Photo strip
                if !entry.photos.isEmpty {
                    photoStrip
                }

                // Header block
                VStack(alignment: .leading, spacing: 6) {
                    Text(entry.displayTitle)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(Color.textPrimary)

                    HStack(spacing: 6) {
                        Text(entry.roasterName)
                            .font(Constants.Typography.body)
                            .foregroundStyle(Color.textSecondary)

                        if !entry.originCountry.isEmpty {
                            dot
                            Text(entry.originCountry)
                                .font(Constants.Typography.body)
                                .foregroundStyle(Color.textSecondary)
                        }
                    }

                    StarRatingDisplayView(rating: entry.rating, starSize: 14)
                        .padding(.top, 2)
                }
                .padding(.horizontal, Constants.Layout.pageInset)
                .padding(.vertical, 16)

                hairline

                // Detail sections
                Group {
                    detailSection(title: "Origin") {
                        row("Country",  entry.originCountry)
                        row("Region",   entry.originRegion)
                        if let farm = entry.originFarm { row("Farm", farm) }
                        row("Process",  entry.processingMethod.displayName)
                        row("Roast",    entry.roastLevel.displayName)
                    }

                    hairline

                    detailSection(title: "Brew") {
                        let p = entry.brewParameters
                        row("Method",   entry.brewMethod.displayName)
                        row("Grind",    p.grindSize.displayName)
                        row("Dose",     String(format: "%.1f g", p.dosageGrams))
                        row("Water",    String(format: "%.0f ml", p.waterAmountML))
                        row("Ratio",    String(format: "1:%.1f", p.brewRatio))
                        row("Temp",     String(format: "%.0f°C", p.waterTempCelsius))
                        row("Time",     p.brewTimeFormatted)
                    }

                    if !entry.flavorTags.isEmpty {
                        hairline
                        detailSection(title: "Flavour") {
                            TagCloudView(
                                tags: entry.flavorTagNames,
                                selectedTags: Set(entry.flavorTagNames)
                            )
                        }
                    }

                    if !entry.personalNotes.isEmpty {
                        hairline
                        detailSection(title: "Notes") {
                            Text(entry.personalNotes)
                                .font(Constants.Typography.body)
                                .foregroundStyle(Color.textPrimary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }

                hairline

                Text("Brewed \(entry.dateBrewed.journalDisplayDateTime)")
                    .font(Constants.Typography.micro)
                    .foregroundStyle(Color.textTertiary)
                    .padding(.horizontal, Constants.Layout.pageInset)
                    .padding(.vertical, 12)
            }
        }
        .background(Color.appBackground)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Edit") { showingEditSheet = true }
                    .font(Constants.Typography.body.weight(.medium))
                    .foregroundStyle(Color.appAccent)
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            EntryFormView(mode: .edit(entry))
        }
    }

    // MARK: - Subviews

    private var photoStrip: some View {
        TabView {
            ForEach(entry.photos) { photo in
                CoffeePhotoView(photo: photo, contentMode: .fill).clipped()
            }
        }
        .tabViewStyle(.page)
        .frame(height: 240)
    }

    private var hairline: some View {
        Rectangle()
            .fill(Color.appBorder)
            .frame(height: Constants.Layout.borderWidth)
    }

    private var dot: some View {
        Circle()
            .fill(Color.textTertiary)
            .frame(width: 3, height: 3)
    }

    private func detailSection<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .sectionHeaderStyle()
            content()
        }
        .padding(.horizontal, Constants.Layout.pageInset)
        .padding(.vertical, 14)
    }

    private func row(_ label: String, _ value: String) -> some View {
        HStack(alignment: .top) {
            Text(label)
                .font(Constants.Typography.caption)
                .foregroundStyle(Color.textTertiary)
                .frame(width: 72, alignment: .leading)
            Text(value)
                .font(Constants.Typography.body)
                .foregroundStyle(Color.textPrimary)
            Spacer()
        }
    }
}
