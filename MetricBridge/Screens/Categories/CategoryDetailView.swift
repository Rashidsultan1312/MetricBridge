import SwiftUI

struct CategoryDetailView: View {
    let kind: MeasureKind
    @EnvironmentObject private var desk: ConversionDesk
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                heroBanner
                quickRecipesSection
                unitsListSection
                factsSection
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(AppBackdrop())
        .navigationTitle(kind.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    desk.kind = kind
                    dismiss()
                } label: {
                    Label("action.openInConverter", systemImage: "arrow.left.arrow.right")
                        .labelStyle(.iconOnly)
                }
            }
        }
    }

    private var heroBanner: some View {
        ZStack(alignment: .leading) {
            Image(CategoryAccent.backdropName(for: kind))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 140)
                .clipped()
            VStack(alignment: .leading, spacing: 6) {
                Text(kind.title)
                    .font(.system(.title2, design: .rounded).weight(.bold))
                    .foregroundStyle(.primary)
                Text(L("category.\(kind.rawValue).description"))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            .padding(.horizontal, 18)
        }
        .frame(height: 140)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

    private var quickRecipesSection: some View {
        let recipes = QuickRecipeCatalog.recipes(for: kind)
        return VStack(spacing: 10) {
            HStack {
                Text("section.quickRecipes").upperLabel()
                Spacer()
            }
            if recipes.isEmpty {
                EmptyStateBox(symbol: "tray", titleKey: "empty.recipes.title", messageKey: "empty.recipes.body")
            } else {
                VStack(spacing: 8) {
                    ForEach(recipes) { recipe in recipeRow(recipe) }
                }
            }
        }
    }

    @ViewBuilder
    private func recipeRow(_ recipe: QuickRecipe) -> some View {
        let from = kind.unit(forCode: recipe.fromCode)
        let to = kind.unit(forCode: recipe.toCode)
        let preview: String = {
            guard let from, let to else { return "—" }
            let r = ConversionMath.convert(1, from: from, to: to, kind: kind)
            return "1 \(from.name) ≈ \(ConversionMath.display(r, precision: 3)) \(to.name)"
        }()
        Button {
            if let from, let to {
                desk.kind = kind
                desk.sourceUnit = from
                desk.targetUnit = to
                Haptics.tap()
                dismiss()
            }
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "rectangle.2.swap")
                    .foregroundStyle(CategoryAccent.tint(for: kind))
                VStack(alignment: .leading, spacing: 2) {
                    Text(preview).font(.subheadline.weight(.semibold))
                    Text(L(recipe.everyday))
                        .font(.caption).foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right").font(.caption2).foregroundStyle(.tertiary)
            }
            .padding(12)
            .background(RoundedRectangle(cornerRadius: 14, style: .continuous).fill(Palette.cardFill))
        }
        .buttonStyle(.plain)
    }

    private var unitsListSection: some View {
        VStack(spacing: 10) {
            HStack {
                Text("section.units").upperLabel()
                Spacer()
                Text("\(kind.units.count)")
                    .font(.caption2.weight(.bold))
                    .padding(.horizontal, 7).padding(.vertical, 2)
                    .background(Capsule().fill(CategoryAccent.surface(for: kind)))
                    .foregroundStyle(CategoryAccent.tint(for: kind))
            }
            VStack(spacing: 0) {
                ForEach(kind.units) { unit in
                    HStack {
                        Text(unit.name).font(.subheadline)
                        Spacer()
                        Text(unit.code)
                            .font(.caption.weight(.semibold).monospaced())
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 10).padding(.horizontal, 14)
                    if unit.id != kind.units.last?.id { InsetSeparator() }
                }
            }
            .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(Palette.cardFill))
        }
    }

    private var factsSection: some View {
        let facts = UnitFactCatalog.facts(for: kind)
        return VStack(spacing: 10) {
            HStack {
                Text("section.didYouKnow").upperLabel()
                Spacer()
            }
            if facts.isEmpty {
                EmptyStateBox(symbol: "lightbulb", titleKey: "empty.facts.title", messageKey: "empty.facts.body")
            } else {
                VStack(spacing: 10) {
                    ForEach(facts) { UnitFactCard(fact: $0) }
                }
            }
        }
    }
}
