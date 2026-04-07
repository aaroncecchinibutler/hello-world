import Foundation

struct CoffeeRecommendation: Identifiable, Codable {
    let id: String
    let coffeeName: String
    let roasterName: String
    let originCountry: String
    let originRegion: String
    let processingMethod: ProcessingMethod
    let roastLevel: RoastLevel
    let flavorTags: [String]
    let description: String
    let priceUSD: Double?
    let weightGrams: Int?
    /// Affiliate or direct purchase URL string
    let purchaseURLString: String?
    /// Whether this slot is a sponsored/paid placement (must be shown to user)
    let isSponsored: Bool

    var purchaseURL: URL? {
        guard let str = purchaseURLString else { return nil }
        return URL(string: str)
    }

    /// Score assigned by RecommendationEngine — not stored in JSON
    var matchScore: Double = 0

    enum CodingKeys: String, CodingKey {
        case id, coffeeName, roasterName, originCountry, originRegion
        case processingMethod, roastLevel, flavorTags, description
        case priceUSD, weightGrams, purchaseURLString, isSponsored
    }
}
