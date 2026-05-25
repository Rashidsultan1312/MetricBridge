import SwiftUI

struct CategoryCard: View {
    let kind: MeasureKind
    let hero: CategoryHero

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: kind.glyph)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(CategoryAccent.tint(for: kind))
                    )
                Spacer(minLength: 0)
                Text("\(hero.unitCount)")
                    .font(.caption.weight(.bold))
                    .padding(.horizontal, 8).padding(.vertical, 4)
                    .background(Capsule().fill(CategoryAccent.surface(for: kind)))
                    .foregroundStyle(CategoryAccent.tint(for: kind))
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(kind.title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text(L(hero.descriptionKey))
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Palette.cardFill)
        )
    }
}
