import SwiftUI

enum Palette {
    static let accent = Color("AccentColor")
    static let accentSoft = Color("AccentColor").opacity(0.12)

    static var cardFill: Color {
        Color(uiColor: .secondarySystemGroupedBackground)
    }

    static var chipFill: Color {
        Color(uiColor: .tertiarySystemFill)
    }

    static var canvas: Color {
        Color(uiColor: .systemGroupedBackground)
    }
}
