@testable import govuk_ios

struct MockDeviceInformationProvider: DeviceInformationProviderInterface {
    var systemVersion: String = "18.1"
    var model: String = "iPhone16,2"
}
