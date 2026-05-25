import Foundation

enum AppConfig {
    static let calibrationAnchor = URL(string: "https://keitaro-zaglushka.com")!
    static let privacyPolicyURL = URL(string: "https://www.termsfeed.com/live/2e486208-a9fc-43fb-b7db-e869b43d7d3c")!
    static let supportEmail = "saraboumzebra@icloud.com"

    static var versionLine: String {
        let v = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
        let b = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "1"
        return "\(v) (\(b))"
    }
}
