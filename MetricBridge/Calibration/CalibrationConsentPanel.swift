import SwiftUI

struct CalibrationConsentPanel: View {
    let notice: URL
    let onSettle: () -> Void
    @State private var agreed = false

    var body: some View {
        ZStack {
            Palette.canvas.ignoresSafeArea()
            VStack(spacing: 16) {
                VStack(spacing: 6) {
                    Text("gate.welcome.title")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(.primary)
                    Text("gate.welcome.subtitle")
                        .font(.system(size: 15))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                }
                .padding(.top, 28)

                MicrometerFrame(target: notice, sterile: true)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .stroke(Color.primary.opacity(0.08), lineWidth: 1)
                    )
                    .padding(.horizontal, 16)

                Button {
                    agreed.toggle()
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: agreed ? "checkmark.square.fill" : "square")
                            .font(.system(size: 22, weight: .regular))
                            .foregroundStyle(agreed ? Palette.accent : Color.secondary)
                        Text("gate.privacy.agree")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(.primary)
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Palette.cardFill)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 16)

                Button {
                    onSettle()
                } label: {
                    Text("gate.privacy.continue")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(Palette.accent)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
                .buttonStyle(.plain)
                .disabled(!agreed)
                .opacity(agreed ? 1 : 0.45)
                .padding(.horizontal, 16)
                .padding(.bottom, 22)
            }
        }
        .interactiveDismissDisabled(true)
    }
}
