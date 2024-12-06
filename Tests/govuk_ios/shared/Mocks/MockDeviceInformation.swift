@testable import govuk_ios

struct MockDeviceInformation: DeviceInformationInterface {
    var systemVersion: String = "18.1"
    var model: String = "iPhone16,2"
}
