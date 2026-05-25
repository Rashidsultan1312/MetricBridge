import SwiftUI

struct CategoryBackdrop: View {
    let kind: MeasureKind
    var intensity: Double = 0.55

    var body: some View {
        GeometryReader { geo in
            Image(CategoryAccent.backdropName(for: kind))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: geo.size.width, height: geo.size.height)
                .opacity(intensity)
                .clipped()
        }
        .ignoresSafeArea()
    }
}

struct AccentScrim: View {
    let kind: MeasureKind

    var body: some View {
        CategoryAccent.tint(for: kind)
            .opacity(0.08)
            .ignoresSafeArea()
    }
}

struct CardGlow: View {
    let kind: MeasureKind
    var body: some View {
        RoundedRectangle(cornerRadius: 24, style: .continuous)
            .stroke(CategoryAccent.tint(for: kind).opacity(0.22), lineWidth: 1)
    }
}

struct AppBackdrop: View {
    var opacity: Double = 0.16

    var body: some View {
        ZStack {
            Palette.canvas
            Image("Backdrops/backdrop-length")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .opacity(opacity)
                .ignoresSafeArea()
        }
        .ignoresSafeArea()
    }
}
