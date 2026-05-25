import SwiftUI

struct ReferenceScreen: View {
    @State private var filter: MeasureKind? = nil

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    filterStrip
                    formulasSection
                    factsSection
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .background(AppBackdrop())
            .navigationTitle("tab.reference")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var filteredFormulas: [FormulaCatalog.Entry] {
        if let filter { return FormulaCatalog.formulas(for: filter) }
        return FormulaCatalog.entries
    }

    private var filteredFacts: [UnitFact] {
        if let filter { return UnitFactCatalog.facts(for: filter) }
        return UnitFactCatalog.entries
    }

    private var filterStrip: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ChipButton("filter.all", symbol: "circle.grid.3x3", selected: filter == nil) {
                    filter = nil
                }
                ForEach(MeasureKind.allCases) { kind in
                    ChipButton(verbatim: kind.title,
                               symbol: kind.glyph,
                               selected: filter == kind,
                               tint: CategoryAccent.tint(for: kind)) {
                        filter = (filter == kind) ? nil : kind
                    }
                }
            }
            .padding(.horizontal, 4)
        }
    }

    private var formulasSection: some View {
        VStack(spacing: 10) {
            HStack {
                Text("section.formulas").upperLabel()
                Spacer()
                Text("\(filteredFormulas.count)")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(.secondary)
            }
            if filteredFormulas.isEmpty {
                EmptyStateBox(symbol: "function",
                              titleKey: "empty.formulas.title",
                              messageKey: "empty.formulas.body")
            } else {
                VStack(spacing: 10) {
                    ForEach(filteredFormulas) { entry in
                        FormulaCard(kind: entry.kind,
                                    titleKey: entry.titleKey,
                                    formula: entry.formula,
                                    exampleKey: entry.exampleKey)
                    }
                }
            }
        }
    }

    private var factsSection: some View {
        VStack(spacing: 10) {
            HStack {
                Text("section.didYouKnow").upperLabel()
                Spacer()
                Text("\(filteredFacts.count)")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(.secondary)
            }
            if filteredFacts.isEmpty {
                EmptyStateBox(symbol: "lightbulb",
                              titleKey: "empty.facts.title",
                              messageKey: "empty.facts.body")
            } else {
                VStack(spacing: 10) {
                    ForEach(filteredFacts) { fact in
                        UnitFactCard(fact: fact)
                    }
                }
            }
        }
    }
}
