import Foundation

struct DeviceModel: CustomStringConvertible {
    var description: String {
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
