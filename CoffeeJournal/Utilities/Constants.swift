import Foundation
import CoreGraphics

enum Constants {

    enum Layout {
        static let cornerRadius: CGFloat = 12
        static let cardPadding: CGFloat = 16
        static let smallPadding: CGFloat = 8
        static let iconSize: CGFloat = 44
    }

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

    enum Flavor {
        static let presetTags: [(name: String, category: FlavorCategory)] = [
            ("Chocolate", .chocolate),
            ("Dark Chocolate", .chocolate),
            ("Milk Chocolate", .chocolate),
            ("Cocoa", .chocolate),
            ("Caramel", .caramel),
            ("Toffee", .caramel),
            ("Brown Sugar", .caramel),
            ("Molasses", .caramel),
            ("Hazelnut", .nutty),
            ("Almond", .nutty),
            ("Walnut", .nutty),
            ("Peanut", .nutty),
            ("Citrus", .citrus),
            ("Lemon", .citrus),
            ("Orange", .citrus),
            ("Grapefruit", .citrus),
            ("Lime", .citrus),
            ("Bergamot", .citrus),
            ("Blueberry", .berry),
            ("Strawberry", .berry),
            ("Raspberry", .berry),
            ("Blackberry", .berry),
            ("Cherry", .berry),
            ("Cranberry", .berry),
            ("Apple", .fruit),
            ("Peach", .fruit),
            ("Apricot", .fruit),
            ("Mango", .fruit),
            ("Pineapple", .fruit),
            ("Jasmine", .floral),
            ("Rose", .floral),
            ("Lavender", .floral),
            ("Hibiscus", .floral),
            ("Cinnamon", .spice),
            ("Clove", .spice),
            ("Cardamom", .spice),
            ("Black Pepper", .spice),
            ("Earthy", .earthy),
            ("Cedar", .earthy),
            ("Tobacco", .earthy),
            ("Oak", .earthy),
            ("Herbal", .earthy),
            ("Savory", .savory),
            ("Umami", .savory),
        ]
    }

    enum StoreKit {
        static let monthlyProductID = "com.coffeejournal.premium.monthly"
        static let annualProductID  = "com.coffeejournal.premium.annual"
    }

    enum Keychain {
        static let googleAPIKey = "google_api_key"
    }

    enum InfoPlist {
        static let googleSearchEngineIDKey = "GOOGLE_SEARCH_ENGINE_ID"
    }

    enum Insights {
        /// Minimum entries in a group before generating an insight for it
        static let minimumGroupSize = 3
        /// Minimum Cohen's d to surface an insight
        static let minimumEffectSize = 0.3
    }
}
