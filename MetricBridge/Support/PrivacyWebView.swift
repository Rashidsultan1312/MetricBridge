import SwiftUI

struct PrivacyWebView: View {
    var body: some View {
        MicrometerFrame(target: AppConfig.privacyPolicyURL, sterile: true)
            .navigationTitle("settings.privacy")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .tabBar)
    }
}
