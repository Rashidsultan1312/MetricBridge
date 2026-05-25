import Foundation

struct CategoryHero: Identifiable, Hashable {
    let id: MeasureKind
    let descriptionKey: String
    let unitCount: Int
    let primaryUnit: String
}

enum CategoryHeroCatalog {
    static let entries: [CategoryHero] = MeasureKind.allCases.map { kind in
        CategoryHero(
            id: kind,
            descriptionKey: "category.\(kind.rawValue).description",
            unitCount: kind.units.count,
            primaryUnit: kind.units.first?.code ?? ""
        )
    }

    static func hero(for kind: MeasureKind) -> CategoryHero {
        entries.first { $0.id == kind } ?? entries[0]
    }
}
