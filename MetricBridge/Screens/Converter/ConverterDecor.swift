import SwiftUI

struct ConverterDecor: View {
    let kind: MeasureKind

    var body: some View {
        ZStack {
            Palette.canvas
            Image(CategoryAccent.backdropName(for: kind))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .opacity(0.16)
                .ignoresSafeArea()
            CategoryAccent.tint(for: kind)
                .opacity(0.04)
                .ignoresSafeArea()
        }
        .ignoresSafeArea()
    }
}

struct ConverterHero: View {
    let kind: MeasureKind
    let sourceUnit: String
    let targetUnit: String

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(CategoryAccent.surface(for: kind))
                Image(systemName: kind.glyph)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(CategoryAccent.tint(for: kind))
            }
            .frame(width: 44, height: 44)
            VStack(alignment: .leading, spacing: 2) {
                Text(kind.title)
                    .font(.subheadline.weight(.bold))
                Text("\(sourceUnit) → \(targetUnit)")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(.horizontal, 16).padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Palette.cardFill.opacity(0.85))
        )
    }
}
