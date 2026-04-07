import Foundation

// MARK: - Insight

struct Insight: Identifiable {
    let id = UUID()
    let type: InsightType
    let headline: String
    let detail: String
    /// Effect size (Cohen's d or correlation strength). Used for sorting.
    let significance: Double
    let chartData: [ChartDataPoint]

    enum InsightType: String {
        case processingMethod
        case origin
        case brewMethod
        case roastLevel
        case flavorFrequency
        case brewRatio
        case notEnoughData
    }
}

// MARK: - ChartDataPoint

struct ChartDataPoint: Identifiable {
    let id = UUID()
    let label: String
    let value: Double
    let count: Int
}

// MARK: - UserTasteProfile

/// Derived from a user's journal entries. Used by RecommendationEngine.
struct UserTasteProfile {
    var topProcessingMethods: [ProcessingMethod: Double]  // method → avg rating
    var topOriginCountries:   [String: Double]            // country → avg rating
    var topBrewMethods:       [BrewMethod: Double]
    var topRoastLevels:       [RoastLevel: Double]
    var favoriteFlavors:      [String]                    // tag names, most-common-in-top-rated first
    var overallAverageRating: Double
    var entryCount: Int

    init(entries: [CoffeeEntry]) {
        self.entryCount = entries.count
        self.overallAverageRating = entries.isEmpty ? 0 :
            Double(entries.map(\.rating).reduce(0, +)) / Double(entries.count)

        // Group and average ratings by attribute
        self.topProcessingMethods = Self.averageRatings(
            entries: entries, key: \.processingMethod)
        self.topOriginCountries = Self.averageRatings(
            entries: entries, key: \.originCountry)
        self.topBrewMethods = Self.averageRatings(
            entries: entries, key: \.brewMethod)
        self.topRoastLevels = Self.averageRatings(
            entries: entries, key: \.roastLevel)

        // Flavor tags most common in top-rated (4+) entries
        let topEntries = entries.filter { $0.rating >= 4 }
        var tagCounts: [String: Int] = [:]
        for entry in topEntries {
            for tag in entry.flavorTagNames { tagCounts[tag, default: 0] += 1 }
        }
        self.favoriteFlavors = tagCounts.sorted { $0.value > $1.value }.map(\.key)
    }

    private static func averageRatings<K: Hashable>(
        entries: [CoffeeEntry],
        key: KeyPath<CoffeeEntry, K>
    ) -> [K: Double] {
        var groups: [K: [Int]] = [:]
        for entry in entries { groups[entry[keyPath: key], default: []].append(entry.rating) }
        return groups.mapValues { ratings in Double(ratings.reduce(0, +)) / Double(ratings.count) }
    }

    /// Score a candidate coffee (0.0–1.0) based on how well it matches this profile
    func score(_ candidate: CoffeeRecommendation) -> Double {
        guard entryCount > 0 else { return 0 }
        var scores: [Double] = []

        if let pm = topProcessingMethods[candidate.processingMethod] {
            scores.append(pm / 5.0)
        }
        if let country = topOriginCountries[candidate.originCountry] {
            scores.append(country / 5.0)
        }
        if let rl = topRoastLevels[candidate.roastLevel] {
            scores.append(rl / 5.0)
        }
        let flavorOverlap = candidate.flavorTags.filter { favoriteFlavors.contains($0) }.count
        if !candidate.flavorTags.isEmpty {
            scores.append(Double(flavorOverlap) / Double(candidate.flavorTags.count))
        }

        return scores.isEmpty ? 0 : scores.reduce(0, +) / Double(scores.count)
    }
}
