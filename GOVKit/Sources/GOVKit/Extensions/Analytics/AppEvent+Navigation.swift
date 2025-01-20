import Foundation

extension AppEvent {
    public static func navigation(text: String,
                                  type: String,
                                  external: Bool,
                                  additionalParams: [String: Any?] = [:]) -> AppEvent {
        let params: [String: Any?] = [
            "text": text,
            "type": type,
            "external": external,
            "language": Locale.current.analyticsLanguageCode
        ].merging(additionalParams) { (current, _) in current }

        return .init(
            name: "Navigation",
            params: params.compactMapValues { $0 }
        )
    }
}
