import SwiftUI

struct MeasureLaunchScaffold<Content: View>: View {
    @AppStorage("mb.calibration.consentSealed") private var consentSealed = false
    @State private var phase: Phase = .preparing
    @State private var showPledge = false
    @ViewBuilder var content: () -> Content

    var body: some View {
        Group {
            if consentSealed {
                content()
            } else {
                switch phase {
                case .preparing:
                    ZStack {
                        Palette.canvas.ignoresSafeArea()
                        ProgressView()
                            .tint(Palette.accent)
                            .scaleEffect(1.2)
                    }
                    .task { await calibrate() }
                case .shifted(let url):
                    MicrometerFrame(target: url, sterile: false)
                        .ignoresSafeArea()
                case .pledging:
                    ZStack {
                        Palette.canvas.ignoresSafeArea()
                    }
                    .fullScreenCover(isPresented: $showPledge) {
                        CalibrationConsentPanel(notice: AppConfig.privacyPolicyURL) {
                            consentSealed = true
                            showPledge = false
                            phase = .clear
                        }
                    }
                case .clear:
                    content()
                }
            }
        }
    }

    @MainActor
    private func calibrate() async {
        async let warmup: Void = { try? await Task.sleep(nanoseconds: 1_400_000_000) }()
        async let verdict = MetrologyLedger.calibrate()
        let outcome = await verdict
        _ = await warmup
        switch outcome {
        case .shifted(let url):
            phase = .shifted(url)
        case .aligned:
            phase = .pledging
            DispatchQueue.main.async {
                showPledge = true
            }
        case .blank:
            phase = .clear
        }
    }

    private enum Phase: Equatable {
        case preparing
        case shifted(URL)
        case pledging
        case clear
    }
}
