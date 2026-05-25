import SwiftUI

struct FormulaCard: View {
    let kind: MeasureKind
    let titleKey: LocalizedStringKey
    let formula: String
    let exampleKey: LocalizedStringKey

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: kind.glyph)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(CategoryAccent.tint(for: kind))
                Text(titleKey)
                    .font(.subheadline.weight(.semibold))
            }
            Text(formula)
                .font(.system(.body, design: .monospaced))
                .padding(10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(CategoryAccent.surface(for: kind))
                )
                .foregroundStyle(.primary)
            Text(exampleKey)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Palette.cardFill)
        )
    }
}

enum FormulaCatalog {
    struct Entry: Identifiable {
        let id: String
        let kind: MeasureKind
        let titleKey: LocalizedStringKey
        let formula: String
        let exampleKey: LocalizedStringKey
    }

    static let entries: [Entry] = [
        .init(id: "len.mi_km", kind: .length, titleKey: "formula.len.mi_km.title",
              formula: "mi = km × 0.6213712",
              exampleKey: "formula.len.mi_km.example"),
        .init(id: "tmp.c_f", kind: .temperature, titleKey: "formula.tmp.c_f.title",
              formula: "°F = °C × 9⁄5 + 32",
              exampleKey: "formula.tmp.c_f.example"),
        .init(id: "tmp.c_k", kind: .temperature, titleKey: "formula.tmp.c_k.title",
              formula: "K = °C + 273.15",
              exampleKey: "formula.tmp.c_k.example"),
        .init(id: "mass.kg_lb", kind: .mass, titleKey: "formula.mass.kg_lb.title",
              formula: "lb = kg × 2.2046226",
              exampleKey: "formula.mass.kg_lb.example"),
        .init(id: "vol.l_gal", kind: .volume, titleKey: "formula.vol.l_gal.title",
              formula: "gal (US) = L × 0.264172",
              exampleKey: "formula.vol.l_gal.example"),
        .init(id: "spd.mph_kmh", kind: .speed, titleKey: "formula.spd.mph_kmh.title",
              formula: "km/h = mph × 1.609344",
              exampleKey: "formula.spd.mph_kmh.example"),
        .init(id: "pwr.w_hp", kind: .power, titleKey: "formula.pwr.w_hp.title",
              formula: "hp = W ÷ 745.6999",
              exampleKey: "formula.pwr.w_hp.example"),
        .init(id: "ang.deg_rad", kind: .angle, titleKey: "formula.ang.deg_rad.title",
              formula: "rad = deg × π⁄180",
              exampleKey: "formula.ang.deg_rad.example"),
        .init(id: "fuel.lp100_mpg", kind: .fuelEconomy, titleKey: "formula.fuel.lp100_mpg.title",
              formula: "mpg(US) = 235.2146 ÷ L/100km",
              exampleKey: "formula.fuel.lp100_mpg.example"),
    ]

    static func formulas(for kind: MeasureKind) -> [Entry] {
        entries.filter { $0.kind == kind }
    }
}
