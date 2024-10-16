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
        #expect(result.params?["device_model"] as? String == DeviceModel().description)
    }
    
    @Test
    func widgetNavigation_internal_returnsExpectedResult() {
        let expectedText = UUID().uuidString
        let result = AppEvent.widgetNavigation(
            text: expectedText
        )

        #expect(result.name == "Navigation")
        #expect(result.params?.count == 4)
        #expect(result.params?["text"] as? String == expectedText)
        #expect(result.params?["type"] as? String == "Widget")
        #expect(result.params?["external"] as? Bool == false)
        #expect(result.params?["language"] as? String == "en")
    }
}
