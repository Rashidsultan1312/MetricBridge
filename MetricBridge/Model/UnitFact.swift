import Foundation

struct UnitFact: Identifiable, Hashable {
    let id: String
    let kind: MeasureKind
    let titleKey: String
    let bodyKey: String
}

enum UnitFactCatalog {
    static let entries: [UnitFact] = [
        .init(id: "length.meter",       kind: .length,       titleKey: "fact.length.meter.title",       bodyKey: "fact.length.meter.body"),
        .init(id: "length.lightYear",   kind: .length,       titleKey: "fact.length.lightYear.title",   bodyKey: "fact.length.lightYear.body"),
        .init(id: "mass.kilogram",      kind: .mass,         titleKey: "fact.mass.kilogram.title",      bodyKey: "fact.mass.kilogram.body"),
        .init(id: "mass.troyOunce",     kind: .mass,         titleKey: "fact.mass.troyOunce.title",     bodyKey: "fact.mass.troyOunce.body"),
        .init(id: "temperature.celsius",kind: .temperature,  titleKey: "fact.temperature.celsius.title",bodyKey: "fact.temperature.celsius.body"),
        .init(id: "temperature.absolute",kind: .temperature, titleKey: "fact.temperature.absolute.title",bodyKey: "fact.temperature.absolute.body"),
        .init(id: "volume.liter",       kind: .volume,       titleKey: "fact.volume.liter.title",       bodyKey: "fact.volume.liter.body"),
        .init(id: "volume.gallons",     kind: .volume,       titleKey: "fact.volume.gallons.title",     bodyKey: "fact.volume.gallons.body"),
        .init(id: "area.hectare",       kind: .area,         titleKey: "fact.area.hectare.title",       bodyKey: "fact.area.hectare.body"),
        .init(id: "speed.mach",         kind: .speed,        titleKey: "fact.speed.mach.title",         bodyKey: "fact.speed.mach.body"),
        .init(id: "data.byte",          kind: .data,         titleKey: "fact.data.byte.title",          bodyKey: "fact.data.byte.body"),
        .init(id: "time.second",        kind: .time,         titleKey: "fact.time.second.title",        bodyKey: "fact.time.second.body"),
        .init(id: "pressure.bar",       kind: .pressure,     titleKey: "fact.pressure.bar.title",       bodyKey: "fact.pressure.bar.body"),
        .init(id: "energy.joule",       kind: .energy,       titleKey: "fact.energy.joule.title",       bodyKey: "fact.energy.joule.body"),
        .init(id: "power.watt",         kind: .power,        titleKey: "fact.power.watt.title",         bodyKey: "fact.power.watt.body"),
        .init(id: "frequency.hertz",    kind: .frequency,    titleKey: "fact.frequency.hertz.title",    bodyKey: "fact.frequency.hertz.body"),
        .init(id: "fuel.lp100",         kind: .fuelEconomy,  titleKey: "fact.fuel.lp100.title",         bodyKey: "fact.fuel.lp100.body"),
        .init(id: "angle.radian",       kind: .angle,        titleKey: "fact.angle.radian.title",       bodyKey: "fact.angle.radian.body"),
    ]

    static func facts(for kind: MeasureKind) -> [UnitFact] {
        entries.filter { $0.kind == kind }
    }
}
