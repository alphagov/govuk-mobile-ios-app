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

    static func widgetNavigation(text: String,
                                 external: Bool = false,
                                 params: [String: String]? = nil) -> AppEvent {
        var mergedParams = ["section": "Homepage"]
        if let params = params {
            mergedParams.merge(params) { (_, new) in new }
        }
        return navigation(
            text: text,
            type: "Widget",
            external: external,
            additionalParams: mergedParams
        )
    }

    static func deeplinkNavigation(isDeeplinkFound: Bool, url: String) -> AppEvent {
        navigation(
            text: isDeeplinkFound ? "Opened" : "Failed",
            type: "DeepLink",
            external: false,
            additionalParams: ["url": url]
        )
    }
}
