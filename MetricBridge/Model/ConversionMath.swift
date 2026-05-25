import Foundation

enum ConversionMath {

    static func convert(_ value: Double, from src: MeasureUnit, to dst: MeasureUnit, kind: MeasureKind) -> Double {
        if kind == .temperature {
            let kelvin = toKelvin(value, from: src.code)
            return fromKelvin(kelvin, to: dst.code)
        }
        if kind == .fuelEconomy {
            let kmPerL = toKmPerL(value, from: src.code)
            return fromKmPerL(kmPerL, to: dst.code)
        }
        guard src.factor != 0 else { return value }
        let base = value * src.factor
        return base / dst.factor
    }

    private static func toKmPerL(_ v: Double, from code: String) -> Double {
        switch code {
        case "L100km": return v == 0 ? .infinity : 100 / v
        case "mpgUS":  return v * 0.4251437075
        case "mpgUK":  return v * 0.3540061899
        default:       return v
        }
    }

    private static func fromKmPerL(_ kmL: Double, to code: String) -> Double {
        switch code {
        case "L100km": return kmL == 0 ? .infinity : 100 / kmL
        case "mpgUS":  return kmL / 0.4251437075
        case "mpgUK":  return kmL / 0.3540061899
        default:       return kmL
        }
    }

    private static func toKelvin(_ v: Double, from code: String) -> Double {
        switch code {
        case "celsius":    return v + 273.15
        case "fahrenheit": return (v - 32) * 5 / 9 + 273.15
        case "kelvin":     return v
        case "rankine":    return v * 5 / 9
        default:           return v
        }
    }

    private static func fromKelvin(_ k: Double, to code: String) -> Double {
        switch code {
        case "celsius":    return k - 273.15
        case "fahrenheit": return (k - 273.15) * 9 / 5 + 32
        case "kelvin":     return k
        case "rankine":    return k * 9 / 5
        default:           return k
        }
    }

    static func display(_ value: Double, precision: Int) -> String {
        guard value.isFinite else { return "—" }
        let p = max(0, min(precision, 10))
        let mag = abs(value)
        if mag != 0, mag < 1e-7 || mag >= 1e12 {
            let f = NumberFormatter()
            f.numberStyle = .scientific
            f.maximumFractionDigits = min(p, 6)
            f.exponentSymbol = "e"
            return f.string(from: NSNumber(value: value)) ?? "—"
        }
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.usesGroupingSeparator = true
        f.minimumFractionDigits = 0
        f.maximumFractionDigits = p
        return f.string(from: NSNumber(value: value)) ?? String(value)
    }
}
