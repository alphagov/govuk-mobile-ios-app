import Foundation
import Testing

@testable import govuk_ios

@Suite
struct AppEvent_ConvenienceTests {

    @Test
    func appLoaded_returnsExpectedResult() {
        let result = AppEvent.appLoaded

        #expect(result.name == "app_loaded")
        #expect(result.params?.count == 1)
        #expect(result.params?["device_model"] as? String == DeviceInformationProvider().model)
    }

}
