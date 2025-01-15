import Foundation

extension Locale {
    public var analyticsLanguageCode: String {
        return language.languageCode?.identifier ?? "Unknown"
    }
}
