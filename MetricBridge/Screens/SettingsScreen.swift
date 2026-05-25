import SwiftUI

struct SettingsScreen: View {
    @EnvironmentObject private var desk: ConversionDesk
    @Environment(\.openURL) private var openURL
    @State private var confirmClear = false

    var body: some View {
        NavigationStack {
            Form {
                Section("settings.section.formatting") {
                    Stepper(value: $desk.precision, in: 0...10) {
                        HStack {
                            Text("settings.precision")
                            Spacer()
                            Text("\(desk.precision)").foregroundStyle(.secondary)
                        }
                    }
                    Picker("settings.appearance", selection: $desk.appearance) {
                        ForEach(AppearanceMode.allCases) { mode in
                            Text(mode.label).tag(mode)
                        }
                    }
                }

                Section("settings.section.data") {
                    Button(role: .destructive) {
                        confirmClear = true
                    } label: {
                        Label("settings.clearHistory", systemImage: "trash")
                    }
                    .disabled(desk.history.isEmpty)
                }

                Section("settings.section.about") {
                    Button {
                        if let url = supportMailURL() { openURL(url) }
                    } label: {
                        labelRow("settings.support", "envelope")
                    }
                    .tint(.primary)

                    NavigationLink {
                        PrivacyWebView()
                    } label: {
                        labelRow("settings.privacy", "hand.raised")
                    }

                    HStack {
                        Label("settings.version", systemImage: "info.circle")
                        Spacer()
                        Text(AppConfig.versionLine).foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("tab.settings")
            .navigationBarTitleDisplayMode(.inline)
            .confirmationDialog("settings.clearHistory.confirm", isPresented: $confirmClear, titleVisibility: .visible) {
                Button("settings.clearHistory", role: .destructive) { desk.clearHistory() }
                Button("action.cancel", role: .cancel) {}
            }
        }
    }

    private func labelRow(_ key: LocalizedStringKey, _ symbol: String) -> some View {
        Label(key, systemImage: symbol)
    }

    private func supportMailURL() -> URL? {
        let subject = NSLocalizedString("support.subject", comment: "")
        var c = URLComponents()
        c.scheme = "mailto"
        c.path = AppConfig.supportEmail
        c.queryItems = [URLQueryItem(name: "subject", value: subject)]
        return c.url
    }
}
