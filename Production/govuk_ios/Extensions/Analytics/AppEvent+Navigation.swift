import Foundation
import GOVKit

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
}
