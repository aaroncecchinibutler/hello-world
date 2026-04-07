import Foundation

enum StatisticsCalculator {

    // MARK: - Basic stats

    static func average(_ values: [Double]) -> Double {
        guard !values.isEmpty else { return 0 }
        return values.reduce(0, +) / Double(values.count)
    }

    static func variance(_ values: [Double]) -> Double {
        guard values.count > 1 else { return 0 }
        let mean = average(values)
        return values.map { pow($0 - mean, 2) }.reduce(0, +) / Double(values.count - 1)
    }

    static func standardDeviation(_ values: [Double]) -> Double {
        sqrt(variance(values))
    }

    // MARK: - Effect size

    /// Cohen's d — effect size between two groups.
    /// Threshold: small ≥ 0.2, medium ≥ 0.5, large ≥ 0.8
    static func cohensD(groupA: [Double], groupB: [Double]) -> Double {
        guard groupA.count >= 2, groupB.count >= 2 else { return 0 }
        let meanDiff = abs(average(groupA) - average(groupB))
        let pooledSD = pooledStandardDeviation(groupA: groupA, groupB: groupB)
        guard pooledSD > 0 else { return 0 }
        return meanDiff / pooledSD
    }

    static func pooledStandardDeviation(groupA: [Double], groupB: [Double]) -> Double {
        let nA = Double(groupA.count)
        let nB = Double(groupB.count)
        let varA = variance(groupA)
        let varB = variance(groupB)
        return sqrt(((nA - 1) * varA + (nB - 1) * varB) / (nA + nB - 2))
    }

    // MARK: - Correlation

    /// Pearson correlation coefficient between two equal-length arrays
    static func pearsonCorrelation(_ xs: [Double], _ ys: [Double]) -> Double {
        guard xs.count == ys.count, xs.count >= 3 else { return 0 }
        let n = Double(xs.count)
        let meanX = average(xs)
        let meanY = average(ys)
        let numerator   = zip(xs, ys).map { ($0 - meanX) * ($1 - meanY) }.reduce(0, +)
        let denomX      = sqrt(xs.map { pow($0 - meanX, 2) }.reduce(0, +))
        let denomY      = sqrt(ys.map { pow($0 - meanY, 2) }.reduce(0, +))
        guard denomX > 0 && denomY > 0 else { return 0 }
        return numerator / (denomX * denomY)
    }

    // MARK: - Grouped averages

    struct GroupStat<K: Hashable> {
        let key: K
        let average: Double
        let count: Int
        let values: [Double]
    }

    static func groupedAverages<K: Hashable>(
        pairs: [(key: K, value: Double)]
    ) -> [GroupStat<K>] {
        var groups: [K: [Double]] = [:]
        for pair in pairs { groups[pair.key, default: []].append(pair.value) }
        return groups.map { key, vals in
            GroupStat(key: key, average: average(vals), count: vals.count, values: vals)
        }.sorted { $0.average > $1.average }
    }
}
