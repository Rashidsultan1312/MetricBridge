import SwiftUI

struct CheatRow: View {
    let kind: MeasureKind
    let recipe: QuickRecipe
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                Image(systemName: kind.glyph)
                    .font(.callout.weight(.semibold))
                    .foregroundStyle(.white)
                    .frame(width: 34, height: 34)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(CategoryAccent.tint(for: kind))
                    )
                VStack(alignment: .leading, spacing: 2) {
                    Text(routeText)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary)
                    Text(L(recipe.everyday))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
                Spacer()
                Text(rateValue)
                    .font(.footnote.weight(.semibold).monospacedDigit())
                    .foregroundStyle(CategoryAccent.tint(for: kind))
            }
            .padding(.vertical, 10).padding(.horizontal, 14)
            .background(RoundedRectangle(cornerRadius: 14, style: .continuous).fill(Palette.cardFill))
        }
        .buttonStyle(.plain)
    }

    private var routeText: String {
        let from = kind.unit(forCode: recipe.fromCode)?.name ?? recipe.fromCode
        let to = kind.unit(forCode: recipe.toCode)?.name ?? recipe.toCode
        return "\(from) → \(to)"
    }

    private var rateValue: String {
        guard let from = kind.unit(forCode: recipe.fromCode),
              let to = kind.unit(forCode: recipe.toCode) else { return "" }
        let v = ConversionMath.convert(1, from: from, to: to, kind: kind)
        return "× \(ConversionMath.display(v, precision: 4))"
    }
}
