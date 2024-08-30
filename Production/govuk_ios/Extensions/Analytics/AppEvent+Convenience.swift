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
}
