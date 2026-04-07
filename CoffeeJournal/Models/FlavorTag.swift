import Foundation
import SwiftData

/// A flavor descriptor shared across multiple CoffeeEntry records.
/// Stored as a proper @Model to enable cross-entry tag queries (e.g. "show all citrus entries").
@Model
final class FlavorTag {
    var name: String
    var category: FlavorCategory

    // Inverse relationship populated automatically by SwiftData
    var entries: [CoffeeEntry] = []

    init(name: String, category: FlavorCategory) {
        self.name = name
        self.category = category
    }
}
