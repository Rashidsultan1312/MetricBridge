import SwiftUI
import UIKit

struct ConverterScreen: View {
    @EnvironmentObject private var desk: ConversionDesk
    @State private var inputText = "1"
    @State private var copiedFlash = false
    @State private var showAllUnits = false
    @FocusState private var fieldFocused: Bool

    private var inputValue: Double {
        Double(inputText.replacingOccurrences(of: ",", with: ".").trimmingCharacters(in: .whitespaces)) ?? 0
    }
    private var outputValue: Double { desk.result(for: inputValue) }
    private var outputText: String { ConversionMath.display(outputValue, precision: desk.precision) }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    if !desk.pinned.isEmpty { pinnedStrip }
                    kindStrip
                    VStack(spacing: 0) {
                        sourceCard
                        swapButton.padding(.vertical, -22).zIndex(1)
                        targetCard
                    }
                    rateLine
                    allUnitsPanel
                    pinButton
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 28)
            }
            .background(ConverterDecor(kind: desk.kind))
            .navigationTitle("tab.convert")
            .navigationBarTitleDisplayMode(.inline)
            .scrollDismissesKeyboard(.interactively)
            .onChange(of: fieldFocused) { focused in
                if !focused { commitToHistory() }
            }
            .overlay(alignment: .bottom) {
                if copiedFlash { copiedToast }
            }
        }
    }

    // MARK: Pinned strip

    private var pinnedStrip: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(desk.pinned) { pair in
                    Button {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        desk.applyPinned(pair)
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: pair.kind.glyph).font(.caption2.weight(.semibold))
                            Text(routeText(kind: pair.kind, from: pair.sourceCode, to: pair.targetCode))
                                .font(.caption.weight(.medium)).lineLimit(1)
                        }
                        .padding(.horizontal, 13).padding(.vertical, 8)
                        .foregroundStyle(Palette.accent)
                        .background(Capsule().fill(Palette.accentSoft))
                    }
                }
            }
            .padding(.bottom, 2)
        }
    }

    // MARK: Kind picker

    private var kindStrip: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(MeasureKind.allCases) { k in kindCell(k) }
            }
            .padding(.vertical, 2)
        }
    }

    private func kindCell(_ k: MeasureKind) -> some View {
        let selected = desk.kind == k
        return Button {
            UISelectionFeedbackGenerator().selectionChanged()
            desk.kind = k
            commitToHistory()
        } label: {
            VStack(spacing: 8) {
                Image(systemName: k.glyph).font(.system(size: 19, weight: .semibold)).frame(height: 22)
                Text(k.title)
                    .font(.caption2.weight(.semibold))
                    .lineLimit(1).minimumScaleFactor(0.75)
            }
            .frame(width: 84, height: 70)
            .frame(maxWidth: .infinity)
            .background(kindCellBackground(selected: selected))
            .foregroundStyle(selected ? Color.white : Color.secondary)
        }
    }

    @ViewBuilder
    private func kindCellBackground(selected: Bool) -> some View {
        let shape = RoundedRectangle(cornerRadius: 16, style: .continuous)
        if selected {
            shape.fill(Palette.accent)
        } else {
            shape.fill(Palette.cardFill)
        }
    }

    // MARK: Cards

    private var sourceCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            cardHeader("label.from", binding: sourceBinding)
            HStack(spacing: 12) {
                TextField("placeholder.value", text: $inputText)
                    .keyboardType(.numbersAndPunctuation)
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .focused($fieldFocused)
                    .submitLabel(.done)
                    .onSubmit { commitToHistory() }
                if !inputText.isEmpty {
                    Button { inputText = "" } label: {
                        Image(systemName: "xmark.circle.fill").font(.title2).foregroundStyle(.tertiary)
                    }
                }
            }
        }
        .padding(20)
        .padding(.bottom, 24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 22, style: .continuous).fill(Palette.cardFill))
    }

    private var targetCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            cardHeader("label.to", binding: targetBinding)
            Button { copyResult() } label: {
                HStack(spacing: 12) {
                    Text(outputText)
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundStyle(Palette.accent)
                        .lineLimit(1).minimumScaleFactor(0.35)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Image(systemName: "doc.on.doc.fill").font(.body).foregroundStyle(Palette.accent.opacity(0.5))
                }
            }
            .buttonStyle(.plain)
        }
        .padding(20)
        .padding(.top, 24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 22, style: .continuous).fill(Palette.cardFill))
    }

    private func cardHeader(_ key: LocalizedStringKey, binding: Binding<MeasureUnit>) -> some View {
        HStack {
            Text(key).font(.footnote.weight(.bold)).foregroundStyle(.secondary).textCase(.uppercase)
            Spacer()
            Picker("", selection: binding) {
                ForEach(desk.kind.units) { u in Text(u.name).tag(u) }
            }
            .pickerStyle(.menu)
            .tint(Palette.accent)
            .font(.subheadline.weight(.semibold))
            .padding(.horizontal, 12).padding(.vertical, 6)
            .background(Capsule().fill(Palette.accentSoft))
        }
    }

    private var rateLine: some View {
        let one = ConversionMath.convert(1, from: desk.sourceUnit, to: desk.targetUnit, kind: desk.kind)
        return Text("1 \(desk.sourceUnit.name) = \(ConversionMath.display(one, precision: max(desk.precision, 4))) \(desk.targetUnit.name)")
            .font(.footnote)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity)
            .multilineTextAlignment(.center)
            .padding(.top, -2)
    }

    private var allUnitsPanel: some View {
        DisclosureGroup(isExpanded: $showAllUnits) {
            VStack(spacing: 0) {
                ForEach(desk.kind.units) { u in
                    Button {
                        UISelectionFeedbackGenerator().selectionChanged()
                        desk.targetUnit = u
                        commitToHistory()
                    } label: {
                        HStack {
                            Text(u.name).foregroundStyle(.primary)
                            Spacer()
                            Text(ConversionMath.display(desk.result(for: inputValue, into: u), precision: desk.precision))
                                .foregroundStyle(u == desk.targetUnit ? Palette.accent : .secondary)
                                .fontWeight(u == desk.targetUnit ? .semibold : .regular)
                        }
                        .font(.subheadline)
                        .padding(.vertical, 9)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    if u.id != desk.kind.units.last?.id { Divider() }
                }
            }
        } label: {
            Label("section.allUnits", systemImage: "list.bullet")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Palette.accent)
        }
        .padding(.horizontal, 18).padding(.vertical, 14)
        .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(Palette.cardFill))
        .tint(Palette.accent)
    }

    private var sourceBinding: Binding<MeasureUnit> {
        Binding(get: { desk.sourceUnit }, set: { desk.sourceUnit = $0; commitToHistory() })
    }
    private var targetBinding: Binding<MeasureUnit> {
        Binding(get: { desk.targetUnit }, set: { desk.targetUnit = $0; commitToHistory() })
    }

    // MARK: Buttons

    private var swapButton: some View {
        Button {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            desk.swapUnits()
            commitToHistory()
        } label: {
            Image(systemName: "arrow.up.arrow.down")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 48, height: 48)
                .background(Circle().fill(Palette.accent))
                .overlay(Circle().stroke(Palette.canvas, lineWidth: 5))
        }
    }

    private var pinButton: some View {
        let pinned = desk.currentRouteIsPinned
        return Button {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            desk.togglePinCurrentRoute()
        } label: {
            Label(pinned ? "action.unpin" : "action.pin", systemImage: pinned ? "pin.slash.fill" : "pin.fill")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(pinned ? .white : Palette.accent)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(pinButtonBackground(pinned: pinned))
        }
    }

    @ViewBuilder
    private func pinButtonBackground(pinned: Bool) -> some View {
        let shape = RoundedRectangle(cornerRadius: 16, style: .continuous)
        if pinned { shape.fill(Palette.accent) }
        else { shape.fill(Palette.accentSoft) }
    }

    private var copiedToast: some View {
        Text("toast.copied")
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(.white)
            .padding(.horizontal, 18).padding(.vertical, 10)
            .background(Capsule().fill(.black.opacity(0.82)))
            .padding(.bottom, 24)
            .transition(.move(edge: .bottom).combined(with: .opacity))
    }

    // MARK: Actions

    private func copyResult() {
        UIPasteboard.general.string = outputText
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        commitToHistory()
        withAnimation(.easeOut(duration: 0.2)) { copiedFlash = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
            withAnimation(.easeIn(duration: 0.25)) { copiedFlash = false }
        }
    }

    private func commitToHistory() {
        let raw = inputValue
        guard raw != 0 else { return }
        desk.logConversion(input: raw, output: desk.result(for: raw))
    }

    private func routeText(kind: MeasureKind, from: String, to: String) -> String {
        let f = kind.unit(forCode: from)?.name ?? from
        let t = kind.unit(forCode: to)?.name ?? to
        return "\(f) → \(t)"
    }
}
