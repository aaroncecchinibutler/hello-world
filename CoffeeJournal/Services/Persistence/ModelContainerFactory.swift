import Foundation
import SwiftData

enum ModelContainerFactory {

    static let schema = Schema([
        CoffeeEntry.self,
        FlavorTag.self,
        CoffeePhoto.self
    ])

    /// Production container — persisted to disk with optional iCloud sync
    static func makeContainer(cloudKitEnabled: Bool = false) -> ModelContainer {
        let cloudKitDB: ModelConfiguration.CloudKitDatabase = cloudKitEnabled ? .automatic : .none
        let config = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false,
            cloudKitDatabase: cloudKitDB
        )
        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }

    /// In-memory container for SwiftUI previews and unit tests
    static func makeInMemoryContainer() -> ModelContainer {
        let config = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: true
        )
        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Failed to create in-memory ModelContainer: \(error)")
        }
    }

    /// Seeds the in-memory container with sample data for previews
    @MainActor
    static func makePreviewContainer() -> ModelContainer {
        let container = makeInMemoryContainer()
        let context = container.mainContext

        // Create sample flavor tags
        let chocolate = FlavorTag(name: "Chocolate", category: .chocolate)
        let citrus    = FlavorTag(name: "Citrus", category: .citrus)
        let blueberry = FlavorTag(name: "Blueberry", category: .berry)
        let caramel   = FlavorTag(name: "Caramel", category: .caramel)
        let floral    = FlavorTag(name: "Jasmine", category: .floral)

        [chocolate, citrus, blueberry, caramel, floral].forEach { context.insert($0) }

        // Sample entries
        let entry1 = CoffeeEntry(
            coffeeName: "Yirgacheffe Natural",
            roasterName: "Onyx Coffee Lab",
            dateBrewed: Date(),
            originCountry: "Ethiopia",
            originRegion: "Yirgacheffe",
            processingMethod: .natural,
            roastLevel: .light,
            brewMethod: .v60,
            rating: 5,
            personalNotes: "Incredibly floral with a clean, bright finish."
        )
        entry1.flavorTags = [blueberry, floral, citrus]

        let entry2 = CoffeeEntry(
            coffeeName: "Huila Washed",
            roasterName: "Counter Culture",
            dateBrewed: Calendar.current.date(byAdding: .day, value: -3, to: Date())!,
            originCountry: "Colombia",
            originRegion: "Huila",
            processingMethod: .washed,
            roastLevel: .mediumLight,
            brewMethod: .pourOver,
            rating: 4,
            personalNotes: "Sweet and balanced, great everyday drinker."
        )
        entry2.flavorTags = [caramel, chocolate]

        let entry3 = CoffeeEntry(
            coffeeName: "Kenya AA",
            roasterName: "Blue Bottle",
            dateBrewed: Calendar.current.date(byAdding: .day, value: -7, to: Date())!,
            originCountry: "Kenya",
            originRegion: "Nyeri",
            processingMethod: .washed,
            roastLevel: .light,
            brewMethod: .chemex,
            rating: 4,
            personalNotes: "Bright blackcurrant, tomato-like acidity."
        )
        entry3.flavorTags = [citrus, blueberry]

        [entry1, entry2, entry3].forEach { context.insert($0) }

        return container
    }
}
