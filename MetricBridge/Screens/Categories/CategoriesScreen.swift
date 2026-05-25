import SwiftUI

struct CategoriesScreen: View {
    @EnvironmentObject private var desk: ConversionDesk
    private let columns = [GridItem(.flexible(), spacing: 14), GridItem(.flexible(), spacing: 14)]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 18) {
                    headerCard
                    LazyVGrid(columns: columns, spacing: 14) {
                        ForEach(MeasureKind.allCases) { kind in
                            NavigationLink(value: kind) {
                                CategoryCard(kind: kind, hero: CategoryHeroCatalog.hero(for: kind))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.bottom, 24)
            }
            .background(AppBackdrop())
            .navigationTitle("tab.categories")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: MeasureKind.self) { kind in
                CategoryDetailView(kind: kind)
            }
        }
    }

    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("categories.hero.title")
                .font(.system(.title2, design: .rounded).weight(.bold))
            Text("categories.hero.subtitle")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            HStack(spacing: 10) {
                StatBadge(titleKey: "stats.categories",
                          value: "\(MeasureKind.allCases.count)",
                          symbol: "square.grid.2x2.fill",
                          tint: Palette.accent)
                StatBadge(titleKey: "stats.units",
                          value: "\(MeasureKind.allCases.reduce(0) { $0 + $1.units.count })",
                          symbol: "list.bullet.rectangle.portrait.fill",
                          tint: Palette.accent)
            }
            .padding(.top, 4)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 22, style: .continuous).fill(Palette.cardFill))
        .padding(.horizontal, 16)
        .padding(.top, 6)
    }
}
