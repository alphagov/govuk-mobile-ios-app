import UIKit
import Foundation

extension AppEvent {
    static var appLoaded: AppEvent {
        let deviceModel = DeviceModel()

        return .init(
            name: "app_loaded",
            params: [
                "device_model": deviceModel.description
            ]
        )
    }

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

    static func searchItemNavigation(title: String,
                                     url: URL,
                                     external: Bool) -> AppEvent {
        navigation(
            text: title,
            type: "SearchResult",
            external: external,
            extraParams: ["url": url.absoluteString]
        )
    }

    static func navigation(text: String,
                           type: String,
                           external: Bool,
                           extraParams: [String: Any?] = [:]) -> AppEvent {
        let defaultParams: [String: Any?] = [
            "text": text,
            "type": type,
            "external": external,
            "language": Locale.current.analyticsLanguageCode
        ]
        let params = defaultParams.merging(extraParams) { (current, _) in current }

        return .init(
            name: "Navigation",
            params: params.compactMapValues({ $0 })
        )
    }

    static func searchTerm(term: String) -> AppEvent {
        .init(
            name: "Search",
            params: [
                "text": term
            ]
        )
    }
}
