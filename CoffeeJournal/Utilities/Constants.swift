import Foundation
import CoreGraphics
import SwiftUI

enum Constants {

    // MARK: - Layout
    // Linear uses tight, precise spacing — not Apple's generous defaults.

    enum Layout {
        /// Default card / section corner radius (Linear uses ~6–8pt)
        static let cornerRadius: CGFloat = 7
        /// Inner card padding
        static let cardPadding: CGFloat = 14
        /// Tight padding for dense rows
        static let rowPadding: CGFloat = 10
        static let smallPadding: CGFloat = 6
        /// Page-level horizontal inset
        static let pageInset: CGFloat = 16
        /// Standard icon tap target
        static let iconSize: CGFloat = 32
        /// 1 pt border (retina-sharp)
        static let borderWidth: CGFloat = 1 / UIScreen.main.scale * 2
    }

    // MARK: - Typography
    // Linear uses Inter. On iOS we use SF Pro with tight tracking.

    enum Typography {
        /// Page / screen title
        static let title      = Font.system(size: 15, weight: .semibold)
        /// Section header
        static let label      = Font.system(size: 12, weight: .medium)
        /// Primary row text
        static let body       = Font.system(size: 14, weight: .regular)
        /// Secondary row text / metadata
        static let caption    = Font.system(size: 12, weight: .regular)
        /// Smallest label (badges, timestamps)
        static let micro      = Font.system(size: 11, weight: .medium)
        /// Numbers / data (monospaced feel)
        static let mono       = Font.system(size: 13, weight: .regular).monospacedDigit()
    }

    // MARK: - Brew defaults

    enum Brew {
        static let defaultDoseGrams: Double = 18.0
        static let defaultWaterML: Double = 300.0
        static let defaultTempCelsius: Double = 93.0
        static let defaultTimeSeconds: Int = 240

        static let doseRange: ClosedRange<Double> = 5...50
        static let waterRange: ClosedRange<Double> = 50...1000
        static let tempRange: ClosedRange<Double> = 60...100
        static let timeRange: ClosedRange<Int> = 10...1800
    }

    // MARK: - Flavour presets

    enum Flavor {
        static let presetTags: [(name: String, category: FlavorCategory)] = [
            ("Chocolate", .chocolate), ("Dark Chocolate", .chocolate),
            ("Milk Chocolate", .chocolate), ("Cocoa", .chocolate),
            ("Caramel", .caramel), ("Toffee", .caramel),
            ("Brown Sugar", .caramel), ("Molasses", .caramel),
            ("Hazelnut", .nutty), ("Almond", .nutty),
            ("Walnut", .nutty), ("Peanut", .nutty),
            ("Citrus", .citrus), ("Lemon", .citrus),
            ("Orange", .citrus), ("Grapefruit", .citrus),
            ("Lime", .citrus), ("Bergamot", .citrus),
            ("Blueberry", .berry), ("Strawberry", .berry),
            ("Raspberry", .berry), ("Blackberry", .berry),
            ("Cherry", .berry), ("Cranberry", .berry),
            ("Apple", .fruit), ("Peach", .fruit),
            ("Apricot", .fruit), ("Mango", .fruit), ("Pineapple", .fruit),
            ("Jasmine", .floral), ("Rose", .floral),
            ("Lavender", .floral), ("Hibiscus", .floral),
            ("Cinnamon", .spice), ("Clove", .spice),
            ("Cardamom", .spice), ("Black Pepper", .spice),
            ("Earthy", .earthy), ("Cedar", .earthy),
            ("Tobacco", .earthy), ("Oak", .earthy), ("Herbal", .earthy),
            ("Savory", .savory), ("Umami", .savory),
        ]
    }

    // MARK: - StoreKit

    enum StoreKit {
        static let monthlyProductID = "com.coffeejournal.premium.monthly"
        static let annualProductID  = "com.coffeejournal.premium.annual"
    }

    // MARK: - Keychain

    enum Keychain {
        static let googleAPIKey = "google_api_key"
    }

    enum InfoPlist {
        static let googleSearchEngineIDKey = "GOOGLE_SEARCH_ENGINE_ID"
    }

    // MARK: - Insights

    enum Insights {
        static let minimumGroupSize = 3
        static let minimumEffectSize = 0.3
    }
}
