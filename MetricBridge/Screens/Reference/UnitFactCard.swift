import SwiftUI

struct UnitFactCard: View {
    let fact: UnitFact

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: "sparkles")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(CategoryAccent.tint(for: fact.kind))
                Text(L(fact.titleKey))
                    .font(.subheadline.weight(.semibold))
                Spacer()
                Text(fact.kind.title)
                    .font(.caption2.weight(.bold))
                    .padding(.horizontal, 7).padding(.vertical, 2)
                    .background(Capsule().fill(CategoryAccent.surface(for: fact.kind)))
                    .foregroundStyle(CategoryAccent.tint(for: fact.kind))
            }
            Text(L(fact.bodyKey))
                .font(.footnote)
                .foregroundStyle(.secondary)
                .lineLimit(5)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Palette.cardFill)
        )
    }
}
