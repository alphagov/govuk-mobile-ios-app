import UIKit
import Foundation

extension AppEvent {
    static var appLoaded: AppEvent {
        let device = UIDevice.current
        return .init(
            name: "app_loaded",
            params: [
                "device_name": device.name,
                "device_model": device.model,
                "system_name": device.systemName,
                "system_version": device.systemVersion
            ]
        )
    }
}
