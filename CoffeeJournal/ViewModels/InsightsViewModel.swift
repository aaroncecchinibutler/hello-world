import Foundation
import Observation

@Observable
final class InsightsViewModel {

    var insights: [Insight] = []
    var isLoading: Bool = false
    var error: Error? = nil

    private let engine = InsightsEngine()

    func computeInsights(from entries: [CoffeeEntry]) async {
        isLoading = true
        defer { isLoading = false }
        let result = await engine.analyze(entries: entries)
        await MainActor.run { insights = result }
    }
}
