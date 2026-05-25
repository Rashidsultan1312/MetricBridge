import Foundation

struct QuickRecipe: Identifiable, Hashable {
    let id: String
    let kind: MeasureKind
    let fromCode: String
    let toCode: String
    let everyday: String
}

enum QuickRecipeCatalog {
    static let entries: [QuickRecipe] = [
        .init(id: "cm-in",    kind: .length,      fromCode: "cm",  toCode: "in",  everyday: "recipe.cm_in"),
        .init(id: "km-mi",    kind: .length,      fromCode: "km",  toCode: "mi",  everyday: "recipe.km_mi"),
        .init(id: "m-ft",     kind: .length,      fromCode: "m",   toCode: "ft",  everyday: "recipe.m_ft"),
        .init(id: "kg-lb",    kind: .mass,        fromCode: "kg",  toCode: "lb",  everyday: "recipe.kg_lb"),
        .init(id: "g-oz",     kind: .mass,        fromCode: "g",   toCode: "oz",  everyday: "recipe.g_oz"),
        .init(id: "c-f",      kind: .temperature, fromCode: "C",   toCode: "F",   everyday: "recipe.c_f"),
        .init(id: "l-galUS",  kind: .volume,      fromCode: "L",   toCode: "galUS", everyday: "recipe.l_gal"),
        .init(id: "ml-cup",   kind: .volume,      fromCode: "mL",  toCode: "cup", everyday: "recipe.ml_cup"),
        .init(id: "m2-ft2",   kind: .area,        fromCode: "m2",  toCode: "ft2", everyday: "recipe.m2_ft2"),
        .init(id: "kmh-mph",  kind: .speed,       fromCode: "kmh", toCode: "mph", everyday: "recipe.kmh_mph"),
        .init(id: "mb-gb",    kind: .data,        fromCode: "MB",  toCode: "GB",  everyday: "recipe.mb_gb"),
        .init(id: "min-h",    kind: .time,        fromCode: "min", toCode: "h",   everyday: "recipe.min_h"),
        .init(id: "bar-psi",  kind: .pressure,    fromCode: "bar", toCode: "psi", everyday: "recipe.bar_psi"),
        .init(id: "j-cal",    kind: .energy,      fromCode: "J",   toCode: "cal", everyday: "recipe.j_cal"),
        .init(id: "w-hp",     kind: .power,       fromCode: "W",   toCode: "hp",  everyday: "recipe.w_hp"),
        .init(id: "lp100-mpg",kind: .fuelEconomy, fromCode: "Lp100",toCode:"mpgUS",everyday: "recipe.lp100_mpg"),
        .init(id: "deg-rad",  kind: .angle,       fromCode: "deg", toCode: "rad", everyday: "recipe.deg_rad"),
    ]

    static func recipes(for kind: MeasureKind) -> [QuickRecipe] {
        entries.filter { $0.kind == kind }
    }
}
