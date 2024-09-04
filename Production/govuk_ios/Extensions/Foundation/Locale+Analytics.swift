import Foundation

extension Locale {
    var analyticsLanguageCode: String {
        let code: String?
        if #available(iOS 16, *) {
            code = language.languageCode?.identifier
        } else {
            code = languageCode
        }
        return code ?? "Unknown"
    }
}
