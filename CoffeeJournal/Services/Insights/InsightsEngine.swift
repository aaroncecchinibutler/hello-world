import Foundation

actor InsightsEngine {

    // MARK: - Public API

    func analyze(entries: [CoffeeEntry]) -> [Insight] {
        guard entries.count >= Constants.Insights.minimumGroupSize else {
            return [Insight(
                type: .notEnoughData,
                headline: "Keep brewing!",
                detail: "Add at least \(Constants.Insights.minimumGroupSize) entries to unlock insights.",
                significance: 0,
                chartData: []
            )]
        }

        var insights: [Insight] = []

        insights += analyzeByProcessingMethod(entries: entries)
        insights += analyzeByOrigin(entries: entries)
        insights += analyzeByBrewMethod(entries: entries)
        insights += analyzeByRoastLevel(entries: entries)
        insights += analyzeFlavorTags(entries: entries)
        insights += analyzeBrewRatio(entries: entries)

        return insights
            .filter { $0.significance >= Constants.Insights.minimumEffectSize }
            .sorted { $0.significance > $1.significance }
    }

    // MARK: - Analysis methods

    private func analyzeByProcessingMethod(entries: [CoffeeEntry]) -> [Insight] {
        let pairs = entries.map { (key: $0.processingMethod, value: Double($0.rating)) }
        let stats = StatisticsCalculator.groupedAverages(pairs: pairs)
        guard stats.count >= 2 else { return [] }

        let best  = stats.first!
        let worst = stats.last!
        guard best.count >= Constants.Insights.minimumGroupSize else { return [] }

        let d = StatisticsCalculator.cohensD(groupA: best.values, groupB: worst.values)
        guard d >= Constants.Insights.minimumEffectSize else { return [] }

        let chartData = stats.map {
            ChartDataPoint(label: $0.key.displayName, value: $0.average, count: $0.count)
        }
        return [Insight(
            type: .processingMethod,
            headline: "You love \(best.key.displayName) coffees",
            detail: "Avg \(String(format: "%.1f", best.average))★ vs \(String(format: "%.1f", worst.average))★ for \(worst.key.displayName)",
            significance: d,
            chartData: chartData
        )]
    }

    private func analyzeByOrigin(entries: [CoffeeEntry]) -> [Insight] {
        let pairs = entries
            .filter { !$0.originCountry.isEmpty }
            .map { (key: $0.originCountry, value: Double($0.rating)) }
        let stats = StatisticsCalculator.groupedAverages(pairs: pairs)
        guard stats.count >= 2, let best = stats.first, best.count >= Constants.Insights.minimumGroupSize else { return [] }
        let worst = stats.last!
        let d = StatisticsCalculator.cohensD(groupA: best.values, groupB: worst.values)
        guard d >= Constants.Insights.minimumEffectSize else { return [] }

        let chartData = stats.map {
            ChartDataPoint(label: $0.key, value: $0.average, count: $0.count)
        }
        return [Insight(
            type: .origin,
            headline: "\(best.key) coffees are your favourite",
            detail: "Avg \(String(format: "%.1f", best.average))★ from \(best.count) entries",
            significance: d,
            chartData: chartData
        )]
    }

    private func analyzeByBrewMethod(entries: [CoffeeEntry]) -> [Insight] {
        let pairs = entries.map { (key: $0.brewMethod, value: Double($0.rating)) }
        let stats = StatisticsCalculator.groupedAverages(pairs: pairs)
        guard stats.count >= 2, let best = stats.first, best.count >= Constants.Insights.minimumGroupSize else { return [] }
        let worst = stats.last!
        let d = StatisticsCalculator.cohensD(groupA: best.values, groupB: worst.values)
        guard d >= Constants.Insights.minimumEffectSize else { return [] }

        let chartData = stats.map {
            ChartDataPoint(label: $0.key.displayName, value: $0.average, count: $0.count)
        }
        return [Insight(
            type: .brewMethod,
            headline: "\(best.key.displayName) is your best brew method",
            detail: "Avg \(String(format: "%.1f", best.average))★ vs \(String(format: "%.1f", worst.average))★ for \(worst.key.displayName)",
            significance: d,
            chartData: chartData
        )]
    }

    private func analyzeByRoastLevel(entries: [CoffeeEntry]) -> [Insight] {
        let pairs = entries.map { (key: $0.roastLevel, value: Double($0.rating)) }
        let stats = StatisticsCalculator.groupedAverages(pairs: pairs)
        guard stats.count >= 2, let best = stats.first, best.count >= Constants.Insights.minimumGroupSize else { return [] }
        let worst = stats.last!
        let d = StatisticsCalculator.cohensD(groupA: best.values, groupB: worst.values)
        guard d >= Constants.Insights.minimumEffectSize else { return [] }

        let chartData = stats.map {
            ChartDataPoint(label: $0.key.displayName, value: $0.average, count: $0.count)
        }
        return [Insight(
            type: .roastLevel,
            headline: "You prefer \(best.key.displayName) roasts",
            detail: "Avg \(String(format: "%.1f", best.average))★ across \(best.count) entries",
            significance: d,
            chartData: chartData
        )]
    }

    private func analyzeFlavorTags(entries: [CoffeeEntry]) -> [Insight] {
        let topEntries = entries.filter { $0.rating >= 4 }
        guard topEntries.count >= Constants.Insights.minimumGroupSize else { return [] }

        var tagCounts: [String: Int] = [:]
        for entry in topEntries {
            for tag in entry.flavorTagNames { tagCounts[tag, default: 0] += 1 }
        }
        guard !tagCounts.isEmpty else { return [] }

        let sorted = tagCounts.sorted { $0.value > $1.value }
        let top = sorted.prefix(5)
        let chartData = top.map {
            ChartDataPoint(label: $0.key, value: Double($0.value), count: $0.value)
        }
        let topNames = top.prefix(3).map(\.key).joined(separator: ", ")
        let significance = min(1.0, Double(top.first?.value ?? 0) / Double(topEntries.count))

        return [Insight(
            type: .flavorFrequency,
            headline: "Your top flavours: \(topNames)",
            detail: "Found in your highest-rated coffees",
            significance: significance,
            chartData: chartData
        )]
    }

    private func analyzeBrewRatio(entries: [CoffeeEntry]) -> [Insight] {
        let pairs = entries.compactMap { entry -> (ratio: Double, rating: Double)? in
            let params = entry.brewParameters
            guard params.dosageGrams > 0, params.waterAmountML > 0 else { return nil }
            return (params.brewRatio, Double(entry.rating))
        }
        guard pairs.count >= Constants.Insights.minimumGroupSize else { return [] }

        let ratios  = pairs.map(\.ratio)
        let ratings = pairs.map(\.rating)
        let r = StatisticsCalculator.pearsonCorrelation(ratios, ratings)
        guard abs(r) >= 0.3 else { return [] }

        let direction = r > 0 ? "higher" : "lower"
        let avgRatio  = StatisticsCalculator.average(ratios)
        let chartData = [
            ChartDataPoint(label: "Correlation", value: r, count: pairs.count)
        ]
        return [Insight(
            type: .brewRatio,
            headline: "Your sweet spot: 1:\(String(format: "%.0f", avgRatio)) brew ratio",
            detail: "\(direction.capitalized) ratios tend to get better ratings (r=\(String(format: "%.2f", r)))",
            significance: abs(r),
            chartData: chartData
        )]
    }
}
