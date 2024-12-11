import Foundation
import UIKit

protocol DeviceInformationProviderInterface {
    var systemVersion: String { get }
    var model: String { get }
}

struct DeviceInformationProvider: DeviceInformationProviderInterface {
    var systemVersion: String {
        UIDevice.current.systemVersion
    }

    var model: String {
        var sysinfo = utsname()
        uname(&sysinfo)

        let data = Data(
            bytes: &sysinfo.machine,
            count: Int(_SYS_NAMELEN)
        )
        let modelName = String(
            bytes: data,
            encoding: .ascii
        )
        let trimmedModelName = modelName?.trimmingCharacters(
            in: .controlCharacters
        )
        return trimmedModelName ?? "Unknown"
    }
}
