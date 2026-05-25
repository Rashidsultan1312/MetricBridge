import SwiftUI

enum MeasureKind: String, CaseIterable, Identifiable, Codable {
    case length, mass, temperature, volume, area, speed, data, time, pressure, energy, power, frequency, fuelEconomy, angle

    var id: String { rawValue }

    var title: String { NSLocalizedString("kind.\(rawValue)", comment: "") }

    var glyph: String {
        switch self {
        case .length: return "ruler"
        case .mass: return "scalemass"
        case .temperature: return "thermometer.medium"
        case .volume: return "drop"
        case .area: return "square.dashed"
        case .speed: return "speedometer"
        case .data: return "internaldrive"
        case .time: return "clock"
        case .pressure: return "gauge.with.dots.needle.bottom.50percent"
        case .energy: return "bolt.fill"
        case .power: return "bolt.circle"
        case .frequency: return "waveform.path"
        case .fuelEconomy: return "fuelpump"
        case .angle: return "angle"
        }
    }

    var units: [MeasureUnit] {
        switch self {
        case .length: return MeasureUnit.lengthSet
        case .mass: return MeasureUnit.massSet
        case .temperature: return MeasureUnit.temperatureSet
        case .volume: return MeasureUnit.volumeSet
        case .area: return MeasureUnit.areaSet
        case .speed: return MeasureUnit.speedSet
        case .data: return MeasureUnit.dataSet
        case .time: return MeasureUnit.timeSet
        case .pressure: return MeasureUnit.pressureSet
        case .energy: return MeasureUnit.energySet
        case .power: return MeasureUnit.powerSet
        case .frequency: return MeasureUnit.frequencySet
        case .fuelEconomy: return MeasureUnit.fuelEconomySet
        case .angle: return MeasureUnit.angleSet
        }
    }

    func unit(forCode code: String) -> MeasureUnit? {
        units.first { $0.code == code }
    }
}
