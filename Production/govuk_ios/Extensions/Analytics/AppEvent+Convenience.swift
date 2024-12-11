import UIKit
import Foundation

extension AppEvent {
    static var appLoaded: AppEvent {
        let deviceInformationProvider = DeviceInformationProvider()

        return .init(
            name: "app_loaded",
            params: [
                "device_model": deviceInformationProvider.model
            ]
        )
    }
}
