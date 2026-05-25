import SwiftUI

struct RootView: View {
    @AppStorage("mb.onboarding.seen") private var onboardingSeen = false

    var body: some View {
        MeasureLaunchScaffold {
            if onboardingSeen {
                MainTabView()
            } else {
                OnboardingFlow()
            }
        }
    }
}
