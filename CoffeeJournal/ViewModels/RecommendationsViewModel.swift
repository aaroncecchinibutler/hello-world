import Foundation
import Observation

@Observable
final class RecommendationsViewModel {

    var recommendations: [CoffeeRecommendation] = []
    var isLoading: Bool = false
    var error: Error? = nil

    private let engine = RecommendationEngine()

    func loadRecommendations(basedOn entries: [CoffeeEntry]) async {
        isLoading = true
        defer { isLoading = false }
        let result = await engine.generate(from: entries)
        await MainActor.run { recommendations = result }
    }
}
