import SwiftUI

@main
struct MetricBridgeApp: App {
    @StateObject private var desk = ConversionDesk()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(desk)
                .preferredColorScheme(desk.appearance.colorScheme)
                .tint(Palette.accent)
        }
    }
}
