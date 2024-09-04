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

    static func navigation(text: String,
                           type: String,
                           external: Bool) -> AppEvent {
        .init(
            name: "Navigation",
            params: [
                "text": text,
                "type": type,
                "external": external,
                "language": Locale.current.analyticsLanguageCode
            ].compactMapValues({ $0 })
        )
    }

    static func searchTerm(term: String) -> AppEvent {
        let deviceModel = DeviceModel()

        return .init(
            name: "Search",
            params: [
                "text": term
            ]
        )
    }
}
