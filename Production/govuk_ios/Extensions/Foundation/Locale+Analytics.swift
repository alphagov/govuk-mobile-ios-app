import Foundation

extension Locale {
    var analyticsLanguageCode: String {
        return language.languageCode?.identifier ?? "Unknown"
    }
}
