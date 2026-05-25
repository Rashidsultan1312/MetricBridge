import SwiftUI

enum CategoryAccent {
    static func tint(for kind: MeasureKind) -> Color {
        switch kind {
        case .length:      return Color(red: 0.35, green: 0.43, blue: 0.57)
        case .mass:        return Color(red: 0.55, green: 0.41, blue: 0.29)
        case .temperature: return Color(red: 0.78, green: 0.37, blue: 0.29)
        case .volume:      return Color(red: 0.29, green: 0.51, blue: 0.68)
        case .area:        return Color(red: 0.37, green: 0.57, blue: 0.37)
        case .speed:       return Color(red: 0.43, green: 0.35, blue: 0.68)
        case .data:        return Color(red: 0.29, green: 0.39, blue: 0.51)
        case .time:        return Color(red: 0.60, green: 0.51, blue: 0.31)
        case .pressure:    return Color(red: 0.53, green: 0.33, blue: 0.37)
        case .energy:      return Color(red: 0.78, green: 0.61, blue: 0.23)
        case .power:       return Color(red: 0.70, green: 0.43, blue: 0.29)
        case .frequency:   return Color(red: 0.31, green: 0.49, blue: 0.71)
        case .fuelEconomy: return Color(red: 0.45, green: 0.49, blue: 0.35)
        case .angle:       return Color(red: 0.41, green: 0.45, blue: 0.58)
        }
    }

    static func surface(for kind: MeasureKind) -> Color {
        tint(for: kind).opacity(0.10)
    }

    static func backdrop(for kind: MeasureKind) -> Image {
        Image("Backdrops/backdrop-\(kind.rawValue)")
    }

    static func backdropName(for kind: MeasureKind) -> String {
        "Backdrops/backdrop-\(kind.rawValue)"
    }
}
