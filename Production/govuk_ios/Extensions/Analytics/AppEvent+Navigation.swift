import Foundation

extension AppEvent {
    static func tabNavigation(text: String) -> AppEvent {
        navigation(
            text: text,
            type: "Tab",
            external: false
        )
    }

    static func buttonNavigation(text: String,
                                 external: Bool) -> AppEvent {
        navigation(
            text: text,
            type: "Button",
            external: external
        )
    }

    static func widgetNavigation(text: String) -> AppEvent {
        navigation(
            text: text,
            type: "Widget",
            external: false
        )
    }

    static func navigation(text: String,
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
