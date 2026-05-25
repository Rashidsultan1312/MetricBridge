import SwiftUI

struct CheatsheetScreen: View {
    @EnvironmentObject private var desk: ConversionDesk
    @State private var search = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    intro
                    searchField
                    grouped
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .background(AppBackdrop())
            .navigationTitle("tab.cheatsheet")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var intro: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("cheatsheet.intro.title")
                .font(.system(.title3, design: .rounded).weight(.bold))
            Text("cheatsheet.intro.body")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(Palette.cardFill))
    }

    private var searchField: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass").foregroundStyle(.secondary)
            TextField("cheatsheet.search", text: $search)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
            if !search.isEmpty {
                Button { search = "" } label: {
                    Image(systemName: "xmark.circle.fill").foregroundStyle(.tertiary)
                }
            }
        }
        .padding(.horizontal, 14).padding(.vertical, 11)
        .background(RoundedRectangle(cornerRadius: 14, style: .continuous).fill(Palette.cardFill))
    }

    private var grouped: some View {
        let groups = groupedRecipes()
        return VStack(spacing: 18) {
            ForEach(groups, id: \.0) { (kind, recipes) in
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 8) {
                        Image(systemName: kind.glyph)
                            .foregroundStyle(CategoryAccent.tint(for: kind))
                        Text(kind.title).font(.headline)
                        Spacer()
                        Text("\(recipes.count)")
                            .font(.caption2.weight(.bold))
                            .foregroundStyle(.secondary)
                    }
                    VStack(spacing: 8) {
                        ForEach(recipes) { recipe in
                            CheatRow(kind: kind, recipe: recipe) {
                                applyAndDismiss(kind: kind, recipe: recipe)
                            }
                        }
                    }
                }
            }
        }
    }

    private func groupedRecipes() -> [(MeasureKind, [QuickRecipe])] {
        let term = search.trimmingCharacters(in: .whitespaces).lowercased()
        return MeasureKind.allCases.compactMap { kind in
            let all = QuickRecipeCatalog.recipes(for: kind)
            let filtered = term.isEmpty ? all : all.filter { recipe in
                kind.title.lowercased().contains(term)
                || recipe.fromCode.lowercased().contains(term)
                || recipe.toCode.lowercased().contains(term)
            }
            return filtered.isEmpty ? nil : (kind, filtered)
        }
    }

    private func applyAndDismiss(kind: MeasureKind, recipe: QuickRecipe) {
        guard let from = kind.unit(forCode: recipe.fromCode),
              let to = kind.unit(forCode: recipe.toCode) else { return }
        desk.kind = kind
        desk.sourceUnit = from
        desk.targetUnit = to
        Haptics.tap()
    }
}
