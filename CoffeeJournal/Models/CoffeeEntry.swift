import Foundation
import SwiftData

@Model
final class CoffeeEntry {

    // MARK: - Identity

    var id: UUID
    var createdAt: Date
    var dateBrewed: Date

    // MARK: - Coffee Info

    var coffeeName: String
    var roasterName: String

    // MARK: - Origin

    var originCountry: String
    var originRegion: String
    var originFarm: String?

    // MARK: - Processing & Roast

    /// Stored as rawValue String for CloudKit compatibility
    var processingMethodRaw: String
    var roastLevelRaw: String

    // MARK: - Brew

    var brewMethodRaw: String
    /// JSON-encoded BrewParameters — embedded as blob to avoid unnecessary relationship
    var brewParametersData: Data?

    // MARK: - Evaluation

    /// 1–5 star rating
    var rating: Int
    var personalNotes: String

    // MARK: - Relationships

    @Relationship(deleteRule: .cascade)
    var photos: [CoffeePhoto] = []

    @Relationship
    var flavorTags: [FlavorTag] = []

    // MARK: - Init

    init(
        id: UUID = UUID(),
        coffeeName: String = "",
        roasterName: String = "",
        dateBrewed: Date = Date(),
        originCountry: String = "",
        originRegion: String = "",
        originFarm: String? = nil,
        processingMethod: ProcessingMethod = .washed,
        roastLevel: RoastLevel = .medium,
        brewMethod: BrewMethod = .pourOver,
        brewParameters: BrewParameters = .default,
        rating: Int = 3,
        personalNotes: String = ""
    ) {
        self.id = id
        self.createdAt = Date()
        self.dateBrewed = dateBrewed
        self.coffeeName = coffeeName
        self.roasterName = roasterName
        self.originCountry = originCountry
        self.originRegion = originRegion
        self.originFarm = originFarm
        self.processingMethodRaw = processingMethod.rawValue
        self.roastLevelRaw = roastLevel.rawValue
        self.brewMethodRaw = brewMethod.rawValue
        self.rating = rating
        self.personalNotes = personalNotes
        self.brewParametersData = try? JSONEncoder().encode(brewParameters)
    }

    // MARK: - Typed Accessors

    var processingMethod: ProcessingMethod {
        get { ProcessingMethod(rawValue: processingMethodRaw) ?? .washed }
        set { processingMethodRaw = newValue.rawValue }
    }

    var roastLevel: RoastLevel {
        get { RoastLevel(rawValue: roastLevelRaw) ?? .medium }
        set { roastLevelRaw = newValue.rawValue }
    }

    var brewMethod: BrewMethod {
        get { BrewMethod(rawValue: brewMethodRaw) ?? .pourOver }
        set { brewMethodRaw = newValue.rawValue }
    }

    var brewParameters: BrewParameters {
        get {
            guard let data = brewParametersData else { return .default }
            return (try? JSONDecoder().decode(BrewParameters.self, from: data)) ?? .default
        }
        set {
            brewParametersData = try? JSONEncoder().encode(newValue)
        }
    }

    // MARK: - Computed Helpers

    var primaryPhoto: CoffeePhoto? {
        photos.first
    }

    var flavorTagNames: [String] {
        flavorTags.map(\.name).sorted()
    }

    var displayTitle: String {
        coffeeName.isEmpty ? "Untitled Coffee" : coffeeName
    }

    var displaySubtitle: String {
        var parts: [String] = []
        if !roasterName.isEmpty { parts.append(roasterName) }
        if !originCountry.isEmpty { parts.append(originCountry) }
        return parts.joined(separator: " · ")
    }
}
