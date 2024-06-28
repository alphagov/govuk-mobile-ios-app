import Foundation

struct DeviceModel: CustomStringConvertible {
    var description: String {
        var sysinfo = utsname()
        uname(&sysinfo)

        guard let name = String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)?
            .trimmingCharacters(in: .controlCharacters) else {
            return "Unknown"
        }
        return name
    }
}
