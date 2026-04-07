import SwiftUI

// MARK: - Semantic color system
//
// Light mode: warm tan palette (Linear-inspired, not cold white)
// Dark mode:  pure greyscale — zero color tints
//
// Usage: always reference semantic tokens, never raw hex.

extension Color {

    // MARK: Backgrounds

    /// Page / window background
    static var appBackground: Color {
        Color("AppBackground")
    }

    /// Elevated surface: cards, sheets, grouped rows
    static var appSurface: Color {
        Color("AppSurface")
    }

    /// Sunken / inset surface (e.g. text inputs, sliders)
    static var appSurfaceSunken: Color {
        Color("AppSurfaceSunken")
    }

    // MARK: Borders

    /// Default 1 pt border for cards and inputs
    static var appBorder: Color {
        Color("AppBorder")
    }

    /// Stronger border for focused / interactive states
    static var appBorderStrong: Color {
        Color("AppBorderStrong")
    }

    // MARK: Text

    static var textPrimary: Color {
        Color("TextPrimary")
    }

    static var textSecondary: Color {
        Color("TextSecondary")
    }

    static var textTertiary: Color {
        Color("TextTertiary")
    }

    // MARK: Accent (light mode: warm brown; dark mode: white)

    static var appAccent: Color {
        Color("AppAccent")
    }

    /// Accent with reduced opacity for backgrounds
    static var appAccentSubtle: Color {
        Color("AppAccentSubtle")
    }

    // MARK: Rating gold (same in both modes)

    static var ratingGold: Color { Color(hex: "#D4971A") }

    // MARK: Hardcoded fallbacks (used when asset catalog colors are absent)
    // These match the xcassets values defined below in the Color extension.

    static var brewBrown: Color   { Color(hex: "#7C5C3A") }   // light accent
    static var brewCream: Color   { Color(hex: "#F5EFE4") }   // light bg
}

// MARK: - Hex convenience

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8)  & 0xFF) / 255
        let b = Double(int         & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

// MARK: - UIColor semantic tokens (for non-SwiftUI contexts)

extension UIColor {
    static var appBackground:    UIColor { UIColor(named: "AppBackground")    ?? UIColor(hex: "#F2EBE0") }
    static var appSurface:       UIColor { UIColor(named: "AppSurface")       ?? UIColor(hex: "#FAF6EF") }
    static var appBorder:        UIColor { UIColor(named: "AppBorder")        ?? UIColor(hex: "#DDD4C6") }
    static var textPrimary:      UIColor { UIColor(named: "TextPrimary")      ?? UIColor(hex: "#1C1714") }
    static var textSecondary:    UIColor { UIColor(named: "TextSecondary")    ?? UIColor(hex: "#7A6F65") }

    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        self.init(
            red:   CGFloat((int >> 16) & 0xFF) / 255,
            green: CGFloat((int >> 8)  & 0xFF) / 255,
            blue:  CGFloat(int         & 0xFF) / 255,
            alpha: 1
        )
    }
}

// MARK: - Asset catalog color definitions
//
// Add these entries to Assets.xcassets → New Color Set for each name.
// The values below are the design spec:
//
// AppBackground
//   Light:  #F2EBE0   (warm tan)
//   Dark:   #0E0E0E   (near-black)
//
// AppSurface
//   Light:  #FAF6EF   (lighter cream)
//   Dark:   #1A1A1A
//
// AppSurfaceSunken
//   Light:  #EDE5D8
//   Dark:   #111111
//
// AppBorder
//   Light:  #DDD4C6   (1 pt border, replaces shadows)
//   Dark:   #2A2A2A
//
// AppBorderStrong
//   Light:  #B8A898
//   Dark:   #444444
//
// TextPrimary
//   Light:  #1C1714
//   Dark:   #F0F0F0
//
// TextSecondary
//   Light:  #7A6F65
//   Dark:   #8A8A8A
//
// TextTertiary
//   Light:  #A89D94
//   Dark:   #555555
//
// AppAccent
//   Light:  #7C5C3A   (warm brown)
//   Dark:   #E8E8E8   (near-white — greyscale dark mode)
//
// AppAccentSubtle
//   Light:  #EDE0D0
//   Dark:   #252525
