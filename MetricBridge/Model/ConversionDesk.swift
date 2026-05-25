import SwiftUI
import Combine

enum AppearanceMode: String, CaseIterable, Identifiable, Codable {
    case system, light, dark
    var id: String { rawValue }
    var label: String { NSLocalizedString("appearance.\(rawValue)", comment: "") }
    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}

struct ConversionEntry: Identifiable, Codable, Equatable {
    let id: UUID
    let kind: MeasureKind
    let sourceCode: String
    let targetCode: String
    let inputValue: Double
    let outputValue: Double
    let stamp: Date

    init(kind: MeasureKind, sourceCode: String, targetCode: String, inputValue: Double, outputValue: Double) {
        self.id = UUID()
        self.kind = kind
        self.sourceCode = sourceCode
        self.targetCode = targetCode
        self.inputValue = inputValue
        self.outputValue = outputValue
        self.stamp = Date()
    }
}

struct PinnedPair: Identifiable, Codable, Equatable {
    let id: UUID
    let kind: MeasureKind
    let sourceCode: String
    let targetCode: String

    init(kind: MeasureKind, sourceCode: String, targetCode: String) {
        self.id = UUID()
        self.kind = kind
        self.sourceCode = sourceCode
        self.targetCode = targetCode
    }

    func sameRoute(as other: PinnedPair) -> Bool {
        kind == other.kind && sourceCode == other.sourceCode && targetCode == other.targetCode
    }
}

final class ConversionDesk: ObservableObject {

    private enum Key {
        static let kind       = "mb.desk.kind"
        static let source     = "mb.desk.sourceUnit"
        static let target     = "mb.desk.targetUnit"
        static let precision  = "mb.pref.precision"
        static let appearance = "mb.pref.appearance"
        static let history    = "mb.log.entries"
        static let pinned     = "mb.log.pinned"
    }

    @Published var kind: MeasureKind { didSet { reconcileUnits(); persistRoute() } }
    @Published var sourceUnit: MeasureUnit { didSet { persistRoute() } }
    @Published var targetUnit: MeasureUnit { didSet { persistRoute() } }
    @Published var precision: Int { didSet { defaults.set(precision, forKey: Key.precision) } }
    @Published var appearance: AppearanceMode { didSet { defaults.set(appearance.rawValue, forKey: Key.appearance) } }
    @Published private(set) var history: [ConversionEntry] = []
    @Published private(set) var pinned: [PinnedPair] = []

    private let defaults: UserDefaults
    private let historyLimit = 60

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults

        let storedKind = MeasureKind(rawValue: defaults.string(forKey: Key.kind) ?? "") ?? .length
        self.kind = storedKind
        let units = storedKind.units
        self.sourceUnit = storedKind.unit(forCode: defaults.string(forKey: Key.source) ?? "") ?? units.first!
        self.targetUnit = storedKind.unit(forCode: defaults.string(forKey: Key.target) ?? "")
            ?? (units.count > 1 ? units[1] : units[0])
        let storedPrecision = defaults.object(forKey: Key.precision) as? Int
        self.precision = storedPrecision ?? 4
        self.appearance = AppearanceMode(rawValue: defaults.string(forKey: Key.appearance) ?? "") ?? .system

        restore()
    }

    // MARK: Conversion

    func result(for raw: Double) -> Double {
        ConversionMath.convert(raw, from: sourceUnit, to: targetUnit, kind: kind)
    }

    func result(for raw: Double, into unit: MeasureUnit) -> Double {
        ConversionMath.convert(raw, from: sourceUnit, to: unit, kind: kind)
    }

    func swapUnits() {
        let s = sourceUnit
        sourceUnit = targetUnit
        targetUnit = s
    }

    private func reconcileUnits() {
        let units = kind.units
        if units.first(where: { $0.code == sourceUnit.code }) == nil { sourceUnit = units.first! }
        if units.first(where: { $0.code == targetUnit.code }) == nil {
            targetUnit = units.first(where: { $0.code != sourceUnit.code }) ?? units.first!
        }
    }

    func applyPinned(_ pair: PinnedPair) {
        applyRoute(kind: pair.kind, source: pair.sourceCode, target: pair.targetCode)
    }

    func applyEntry(_ entry: ConversionEntry) {
        applyRoute(kind: entry.kind, source: entry.sourceCode, target: entry.targetCode)
    }

    private func applyRoute(kind newKind: MeasureKind, source: String, target: String) {
        kind = newKind
        if let s = newKind.unit(forCode: source) { sourceUnit = s }
        if let t = newKind.unit(forCode: target) { targetUnit = t }
    }

    // MARK: History

    func logConversion(input: Double, output: Double) {
        guard input.isFinite, output.isFinite else { return }
        let entry = ConversionEntry(kind: kind, sourceCode: sourceUnit.code, targetCode: targetUnit.code,
                                    inputValue: input, outputValue: output)
        history.insert(entry, at: 0)
        if history.count > historyLimit { history.removeLast(history.count - historyLimit) }
        persistHistory()
    }

    func deleteHistory(at offsets: IndexSet) {
        history.remove(atOffsets: offsets)
        persistHistory()
    }

    func clearHistory() {
        history.removeAll()
        persistHistory()
    }

    // MARK: Pinned pairs

    var currentRouteIsPinned: Bool {
        let candidate = PinnedPair(kind: kind, sourceCode: sourceUnit.code, targetCode: targetUnit.code)
        return pinned.contains { $0.sameRoute(as: candidate) }
    }

    func togglePinCurrentRoute() {
        let candidate = PinnedPair(kind: kind, sourceCode: sourceUnit.code, targetCode: targetUnit.code)
        if let idx = pinned.firstIndex(where: { $0.sameRoute(as: candidate) }) {
            pinned.remove(at: idx)
        } else {
            pinned.insert(candidate, at: 0)
        }
        persistPinned()
    }

    func removePinned(at offsets: IndexSet) {
        pinned.remove(atOffsets: offsets)
        persistPinned()
    }

    // MARK: Load / save

    private func restore() {
        if let data = defaults.data(forKey: Key.history),
           let decoded = try? JSONDecoder().decode([ConversionEntry].self, from: data) {
            history = decoded
        }
        if let data = defaults.data(forKey: Key.pinned),
           let decoded = try? JSONDecoder().decode([PinnedPair].self, from: data) {
            pinned = decoded
        }
    }

    private func persistRoute() {
        defaults.set(kind.rawValue, forKey: Key.kind)
        defaults.set(sourceUnit.code, forKey: Key.source)
        defaults.set(targetUnit.code, forKey: Key.target)
    }

    private func persistHistory() {
        if let data = try? JSONEncoder().encode(history) { defaults.set(data, forKey: Key.history) }
    }

    private func persistPinned() {
        if let data = try? JSONEncoder().encode(pinned) { defaults.set(data, forKey: Key.pinned) }
    }
}
