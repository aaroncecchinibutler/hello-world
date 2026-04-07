import Foundation

actor RecommendationEngine {

    private var catalog: [CoffeeRecommendation] = []

    // MARK: - Public API

    func loadCatalog() async {
        guard let url = Bundle.main.url(forResource: "CoffeeCatalog", withExtension: "json") else {
            return
        }
        guard let data = try? Data(contentsOf: url) else { return }
        catalog = (try? JSONDecoder().decode([CoffeeRecommendation].self, from: data)) ?? []
    }

    func generate(from entries: [CoffeeEntry], limit: Int = 20) async -> [CoffeeRecommendation] {
        if catalog.isEmpty { await loadCatalog() }
        guard !entries.isEmpty else { return Array(catalog.prefix(limit)) }

        let profile = UserTasteProfile(entries: entries)

        // Exclude coffees already in the journal
        let journaledNames = Set(entries.map { "\($0.coffeeName.lowercased())-\($0.roasterName.lowercased())" })

        var scored = catalog
            .filter { rec in
                let key = "\(rec.coffeeName.lowercased())-\(rec.roasterName.lowercased())"
                return !journaledNames.contains(key)
            }
            .map { rec -> CoffeeRecommendation in
                var r = rec
                r.matchScore = profile.score(rec)
                return r
            }

        // Sponsored slots always float to the top (max 2), clearly labeled
        let sponsored = scored.filter(\.isSponsored).prefix(2)
        let organic   = scored.filter { !$0.isSponsored }
            .sorted { $0.matchScore > $1.matchScore }
            .prefix(limit - sponsored.count)

        return Array(sponsored) + Array(organic)
    }
}
