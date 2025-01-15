import Foundation
import Testing
import GOVKit

@testable import  govuk_ios

@Suite
struct AppEvent_NavigationTests {
    @Test
    func tabNavigation_returnsExpectedResult() {
        let expectedText = UUID().uuidString
        let result = AppEvent.tabNavigation(
            text: expectedText
        )

        #expect(result.name == "Navigation")
        #expect(result.params?.count == 4)
        #expect(result.params?["text"] as? String == expectedText)
        #expect(result.params?["type"] as? String == "Tab")
        #expect(result.params?["external"] as? Bool == false)
        #expect(result.params?["language"] as? String == "en")
    }

    @Test
    func buttonNavigation_external_returnsExpectedResult() {
        let expectedText = UUID().uuidString
        let result = AppEvent.buttonNavigation(
            text: expectedText,
            external: true
        )

        #expect(result.name == "Navigation")
        #expect(result.params?.count == 4)
        #expect(result.params?["text"] as? String == expectedText)
        #expect(result.params?["type"] as? String == "Button")
        #expect(result.params?["external"] as? Bool == true)
        #expect(result.params?["language"] as? String == "en")
    }

    @Test
    func buttonNavigation_internal_returnsExpectedResult() {
        let expectedText = UUID().uuidString
        let result = AppEvent.buttonNavigation(
            text: expectedText,
            external: false
        )

        #expect(result.name == "Navigation")
        #expect(result.params?.count == 4)
        #expect(result.params?["text"] as? String == expectedText)
        #expect(result.params?["type"] as? String == "Button")
        #expect(result.params?["external"] as? Bool == false)
        #expect(result.params?["language"] as? String == "en")
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
