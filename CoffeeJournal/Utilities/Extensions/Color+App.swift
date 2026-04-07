import SwiftUI

extension Color {
    static let coffeeBrown   = Color("CoffeeBrown",   bundle: .main)
    static let coffeeCreamy  = Color("CoffeeCreamy",  bundle: .main)
    static let coffeeDark    = Color("CoffeeDark",    bundle: .main)

    /// Fallbacks if asset catalog colors are missing
    static let brewBrown     = Color(red: 0.45, green: 0.28, blue: 0.12)
    static let brewCream     = Color(red: 0.98, green: 0.94, blue: 0.87)
    static let ratingGold    = Color(red: 0.98, green: 0.75, blue: 0.14)
}

extension ShapeStyle where Self == Color {
    static var ratingGold: Color { .ratingGold }
}
