import SwiftUI

struct MeasureUnit: Identifiable, Equatable, Hashable {
    let code: String
    let factor: Double

    var id: String { code }
    var name: String { NSLocalizedString("unit.\(code)", comment: "") }
}

extension MeasureUnit {
    static let lengthSet: [MeasureUnit] = [
        .init(code: "mm", factor: 0.001),
        .init(code: "cm", factor: 0.01),
        .init(code: "m", factor: 1),
        .init(code: "km", factor: 1000),
        .init(code: "in", factor: 0.0254),
        .init(code: "ft", factor: 0.3048),
        .init(code: "yd", factor: 0.9144),
        .init(code: "mi", factor: 1609.344),
        .init(code: "nmi", factor: 1852)
    ]

    static let massSet: [MeasureUnit] = [
        .init(code: "mg", factor: 0.000001),
        .init(code: "g", factor: 0.001),
        .init(code: "kg", factor: 1),
        .init(code: "t", factor: 1000),
        .init(code: "oz", factor: 0.028349523125),
        .init(code: "lb", factor: 0.45359237),
        .init(code: "st", factor: 6.35029318)
    ]

    static let temperatureSet: [MeasureUnit] = [
        .init(code: "celsius", factor: 1),
        .init(code: "fahrenheit", factor: 1),
        .init(code: "kelvin", factor: 1),
        .init(code: "rankine", factor: 1)
    ]

    static let volumeSet: [MeasureUnit] = [
        .init(code: "ml", factor: 0.000001),
        .init(code: "l", factor: 0.001),
        .init(code: "m3", factor: 1),
        .init(code: "tsp", factor: 0.00000492892159375),
        .init(code: "tbsp", factor: 0.0000147867647812),
        .init(code: "flozUS", factor: 0.0000295735295625),
        .init(code: "cupUS", factor: 0.0002365882365),
        .init(code: "ptUS", factor: 0.000473176473),
        .init(code: "galUS", factor: 0.003785411784),
        .init(code: "galUK", factor: 0.00454609)
    ]

    static let areaSet: [MeasureUnit] = [
        .init(code: "mm2", factor: 0.000001),
        .init(code: "cm2", factor: 0.0001),
        .init(code: "m2", factor: 1),
        .init(code: "ha", factor: 10000),
        .init(code: "km2", factor: 1000000),
        .init(code: "in2", factor: 0.00064516),
        .init(code: "ft2", factor: 0.09290304),
        .init(code: "yd2", factor: 0.83612736),
        .init(code: "acre", factor: 4046.8564224),
        .init(code: "mi2", factor: 2589988.110336)
    ]

    static let speedSet: [MeasureUnit] = [
        .init(code: "mps", factor: 1),
        .init(code: "kph", factor: 0.277777777778),
        .init(code: "mph", factor: 0.44704),
        .init(code: "fps", factor: 0.3048),
        .init(code: "knot", factor: 0.514444444444),
        .init(code: "mach", factor: 343)
    ]

    static let dataSet: [MeasureUnit] = [
        .init(code: "bit", factor: 0.125),
        .init(code: "B", factor: 1),
        .init(code: "kB", factor: 1000),
        .init(code: "MB", factor: 1000000),
        .init(code: "GB", factor: 1000000000),
        .init(code: "TB", factor: 1000000000000),
        .init(code: "KiB", factor: 1024),
        .init(code: "MiB", factor: 1048576),
        .init(code: "GiB", factor: 1073741824),
        .init(code: "TiB", factor: 1099511627776)
    ]

    static let timeSet: [MeasureUnit] = [
        .init(code: "ms", factor: 0.001),
        .init(code: "s", factor: 1),
        .init(code: "min", factor: 60),
        .init(code: "h", factor: 3600),
        .init(code: "day", factor: 86400),
        .init(code: "week", factor: 604800),
        .init(code: "month", factor: 2629800),
        .init(code: "year", factor: 31557600)
    ]

    static let pressureSet: [MeasureUnit] = [
        .init(code: "Pa", factor: 1),
        .init(code: "hPa", factor: 100),
        .init(code: "kPa", factor: 1000),
        .init(code: "bar", factor: 100000),
        .init(code: "atm", factor: 101325),
        .init(code: "mmHg", factor: 133.322387415),
        .init(code: "inHg", factor: 3386.388157),
        .init(code: "psi", factor: 6894.757293168)
    ]

    // Base: joule
    static let energySet: [MeasureUnit] = [
        .init(code: "J", factor: 1),
        .init(code: "kJ", factor: 1000),
        .init(code: "cal", factor: 4.184),
        .init(code: "kcal", factor: 4184),
        .init(code: "Wh", factor: 3600),
        .init(code: "kWh", factor: 3600000),
        .init(code: "BTU", factor: 1055.05585262),
        .init(code: "ftlb", factor: 1.3558179483)
    ]

    // Base: watt
    static let powerSet: [MeasureUnit] = [
        .init(code: "W", factor: 1),
        .init(code: "kW", factor: 1000),
        .init(code: "MW", factor: 1000000),
        .init(code: "hp", factor: 745.6998715823),
        .init(code: "ps", factor: 735.49875),
        .init(code: "BTUh", factor: 0.29307107017),
        .init(code: "ftlbs", factor: 1.3558179483)
    ]

    // Base: hertz
    static let frequencySet: [MeasureUnit] = [
        .init(code: "Hz", factor: 1),
        .init(code: "kHz", factor: 1000),
        .init(code: "MHz", factor: 1000000),
        .init(code: "GHz", factor: 1000000000),
        .init(code: "rpm", factor: 0.0166666666667)
    ]

    // Base: km per litre. "L100km" is reciprocal — handled in ConversionMath.
    static let fuelEconomySet: [MeasureUnit] = [
        .init(code: "kmL", factor: 1),
        .init(code: "L100km", factor: 1),
        .init(code: "mpgUS", factor: 0.4251437075),
        .init(code: "mpgUK", factor: 0.3540061899)
    ]

    // Base: degree
    static let angleSet: [MeasureUnit] = [
        .init(code: "deg", factor: 1),
        .init(code: "rad", factor: 57.295779513082323),
        .init(code: "grad", factor: 0.9),
        .init(code: "arcmin", factor: 0.0166666666667),
        .init(code: "arcsec", factor: 0.000277777777778),
        .init(code: "turn", factor: 360)
    ]
}
