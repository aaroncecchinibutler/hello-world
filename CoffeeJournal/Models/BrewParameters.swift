import Foundation

/// Brew session parameters stored as a JSON blob inside CoffeeEntry.
/// Not a SwiftData @Model — always travels with its parent entry and is never queried independently.
struct BrewParameters: Codable, Equatable {
    var dosageGrams: Double
    var waterAmountML: Double
    var waterTempCelsius: Double
    var brewTimeSeconds: Int
    var grindSize: GrindSize
    /// Optional numeric grind setting (e.g. EK43 click count, Comandante clicks)
    var grindNumeric: Double?

    // MARK: Computed

    var brewRatio: Double {
        guard dosageGrams > 0 else { return 0 }
        return waterAmountML / dosageGrams
    }

    var brewTimeFormatted: String {
        let minutes = brewTimeSeconds / 60
        let seconds = brewTimeSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    var waterTempFahrenheit: Double {
        waterTempCelsius * 9 / 5 + 32
    }

    // MARK: Default

    static let `default` = BrewParameters(
        dosageGrams: 18.0,
        waterAmountML: 300.0,
        waterTempCelsius: 93.0,
        brewTimeSeconds: 240,
        grindSize: .medium,
        grindNumeric: nil
    )
}
