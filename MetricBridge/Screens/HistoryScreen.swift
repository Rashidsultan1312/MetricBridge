import SwiftUI

struct HistoryScreen: View {
    @EnvironmentObject private var desk: ConversionDesk

    private static let timeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .short
        f.timeStyle = .short
        return f
    }()

    var body: some View {
        NavigationStack {
            Group {
                if desk.history.isEmpty && desk.pinned.isEmpty {
                    emptyState
                } else {
                    List {
                        if !desk.pinned.isEmpty {
                            Section("section.pinned") {
                                ForEach(desk.pinned) { pair in
                                    Button { desk.applyPinned(pair) } label: { pinnedRow(pair) }
                                        .tint(.primary)
                                }
                                .onDelete { desk.removePinned(at: $0) }
                            }
                        }
                        if !desk.history.isEmpty {
                            Section("section.recent") {
                                ForEach(desk.history) { entry in
                                    Button { desk.applyEntry(entry) } label: { historyRow(entry) }
                                        .tint(.primary)
                                }
                                .onDelete { desk.deleteHistory(at: $0) }
                            }
                        }
                    }
                }
            }
            .navigationTitle("tab.history")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if !desk.history.isEmpty {
                    ToolbarItem(placement: .topBarTrailing) { EditButton() }
                }
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "clock.arrow.circlepath")
                .font(.system(size: 46))
                .foregroundStyle(.secondary)
            Text("history.empty.title").font(.headline)
            Text("history.empty.body").font(.subheadline).foregroundStyle(.secondary)
                .multilineTextAlignment(.center).padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Palette.canvas.ignoresSafeArea())
    }

    private func pinnedRow(_ pair: PinnedPair) -> some View {
        HStack(spacing: 12) {
            Image(systemName: pair.kind.glyph).foregroundStyle(Palette.accent).frame(width: 24)
            VStack(alignment: .leading, spacing: 2) {
                Text(pair.kind.title).font(.subheadline.weight(.semibold))
                routeLabel(kind: pair.kind, from: pair.sourceCode, to: pair.targetCode)
                    .font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right").font(.caption.weight(.bold)).foregroundStyle(.tertiary)
        }
    }

    private func historyRow(_ entry: ConversionEntry) -> some View {
        HStack(spacing: 12) {
            Image(systemName: entry.kind.glyph).foregroundStyle(Palette.accent).frame(width: 24)
            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 4) {
                    Text(ConversionMath.display(entry.inputValue, precision: desk.precision))
                    unitName(entry.kind, entry.sourceCode)
                    Image(systemName: "arrow.right").font(.caption2)
                    Text(ConversionMath.display(entry.outputValue, precision: desk.precision))
                        .fontWeight(.semibold)
                    unitName(entry.kind, entry.targetCode)
                }
                .font(.subheadline)
                Text(Self.timeFormatter.string(from: entry.stamp))
                    .font(.caption2).foregroundStyle(.secondary)
            }
        }
    }

    private func routeLabel(kind: MeasureKind, from: String, to: String) -> some View {
        HStack(spacing: 4) {
            unitName(kind, from)
            Image(systemName: "arrow.right").font(.caption2)
            unitName(kind, to)
        }
    }

    private func unitName(_ kind: MeasureKind, _ code: String) -> Text {
        if let u = kind.unit(forCode: code) { return Text(u.name) }
        return Text(code)
    }
}
