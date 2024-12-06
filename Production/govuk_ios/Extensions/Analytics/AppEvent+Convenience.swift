import UIKit
import Foundation

extension AppEvent {
    static var appLoaded: AppEvent {
        let deviceInformation = DeviceInformation()

        return .init(
            name: "app_loaded",
            params: [
                "device_model": deviceInformation.model
            ]
        )
    }
}
