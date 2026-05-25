import SwiftUI

struct MainTabView: View {
    @State private var selection = 0

    var body: some View {
        TabView(selection: $selection) {
            ConverterScreen()
                .tabItem { Label("tab.convert", systemImage: "arrow.left.arrow.right") }
                .tag(0)
            CategoriesScreen()
                .tabItem { Label("tab.categories", systemImage: "square.grid.2x2") }
                .tag(1)
            ReferenceScreen()
                .tabItem { Label("tab.reference", systemImage: "book.closed") }
                .tag(2)
            CheatsheetScreen()
                .tabItem { Label("tab.cheatsheet", systemImage: "list.bullet.rectangle") }
                .tag(3)
            SettingsScreen()
                .tabItem { Label("tab.settings", systemImage: "gearshape") }
                .tag(4)
        }
        .tint(Palette.accent)
    }
}
