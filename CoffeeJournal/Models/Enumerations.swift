import Foundation

// MARK: - ProcessingMethod

enum ProcessingMethod: String, CaseIterable, Codable, Identifiable {
    case washed
    case natural
    case honey
    case anaerobic
    case wetHulled
    case carbonic

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .washed:    return "Washed"
        case .natural:   return "Natural"
        case .honey:     return "Honey"
        case .anaerobic: return "Anaerobic"
        case .wetHulled: return "Wet Hulled"
        case .carbonic:  return "Carbonic Maceration"
        }
    }
}

// MARK: - RoastLevel

enum RoastLevel: String, CaseIterable, Codable, Identifiable {
    case light
    case mediumLight
    case medium
    case mediumDark
    case dark

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .light:       return "Light"
        case .mediumLight: return "Medium-Light"
        case .medium:      return "Medium"
        case .mediumDark:  return "Medium-Dark"
        case .dark:        return "Dark"
        }
    }
}

// MARK: - BrewMethod

enum BrewMethod: String, CaseIterable, Codable, Identifiable {
    case pourOver
    case espresso
    case frenchPress
    case aeropress
    case coldBrew
    case chemex
    case v60
    case kalita
    case moka
    case siphon
    case drip

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .pourOver:   return "Pour Over"
        case .espresso:   return "Espresso"
        case .frenchPress: return "French Press"
        case .aeropress:  return "AeroPress"
        case .coldBrew:   return "Cold Brew"
        case .chemex:     return "Chemex"
        case .v60:        return "V60"
        case .kalita:     return "Kalita Wave"
        case .moka:       return "Moka Pot"
        case .siphon:     return "Siphon"
        case .drip:       return "Drip"
        }
    }

    var systemImageName: String {
        switch self {
        case .espresso:   return "cup.and.saucer.fill"
        case .frenchPress: return "cup.and.saucer"
        case .coldBrew:   return "snowflake"
        default:          return "drop.fill"
        }
    }
}

// MARK: - GrindSize

enum GrindSize: String, CaseIterable, Codable, Identifiable {
    case extraFine
    case fine
    case mediumFine
    case medium
    case mediumCoarse
    case coarse
    case extraCoarse

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .extraFine:    return "Extra Fine"
        case .fine:         return "Fine"
        case .mediumFine:   return "Medium-Fine"
        case .medium:       return "Medium"
        case .mediumCoarse: return "Medium-Coarse"
        case .coarse:       return "Coarse"
        case .extraCoarse:  return "Extra Coarse"
        }
    }

    /// Normalized value 0–1 for slider mapping (extraFine=0, extraCoarse=1)
    var normalizedValue: Double {
        let index = Double(GrindSize.allCases.firstIndex(of: self) ?? 3)
        return index / Double(GrindSize.allCases.count - 1)
    }

    static func fromNormalizedValue(_ value: Double) -> GrindSize {
        let index = Int((value * Double(allCases.count - 1)).rounded())
        return allCases[max(0, min(allCases.count - 1, index))]
    }
}

// MARK: - PhotoSource

enum PhotoSource: String, Codable {
    case camera
    case library
    case webSearch
    case url
}

// MARK: - FlavorCategory

enum FlavorCategory: String, CaseIterable, Codable, Identifiable {
    case fruit
    case citrus
    case berry
    case floral
    case nutty
    case chocolate
    case caramel
    case spice
    case earthy
    case savory

    var id: String { rawValue }

    var displayName: String { rawValue.capitalized }

    var emoji: String {
        switch self {
        case .fruit:     return "🍎"
        case .citrus:    return "🍋"
        case .berry:     return "🫐"
        case .floral:    return "🌸"
        case .nutty:     return "🥜"
        case .chocolate: return "🍫"
        case .caramel:   return "🍮"
        case .spice:     return "🌶"
        case .earthy:    return "🌿"
        case .savory:    return "🧂"
        }
    }
}
