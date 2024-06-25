import UIKit
import Foundation

extension AppEvent {
    static var appLoaded: AppEvent {
        let device = UIDevice.current
        let deviceModel = DeviceModel()

        return .init(
            name: "app_loaded",
            params: [
                "device_model": deviceModel.description,
                "system_name": device.systemName,
                "system_version": device.systemVersion
            ]
        )
    }
}
