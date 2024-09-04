import UIKit
import Foundation

extension AppEvent {
    static var appLoaded: AppEvent {
        let deviceModel = DeviceModel()

        return .init(
            name: "app_loaded",
            params: ["device_model": deviceModel.description]
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
