import UIKit
import Foundation

import GOVKit

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
