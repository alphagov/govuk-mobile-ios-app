import Foundation
import Testing

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

    @Test
    func navigation_returnsExpectedResult() {
        let expectedText = UUID().uuidString
        let expectedType = UUID().uuidString
        let expectedExternal = Int.random(in: 1...100) % 2 == 0
        let result = AppEvent.navigation(
            text: expectedText,
            type: expectedType,
            external: expectedExternal
        )

        #expect(result.name == "Navigation")
        #expect(result.params?.count == 4)
        #expect(result.params?["text"] as? String == expectedText)
        #expect(result.params?["type"] as? String == expectedType)
        #expect(result.params?["external"] as? Bool == expectedExternal)
        #expect(result.params?["language"] as? String == "en")
    }

    @Test
    func navigation_additionalParams_returnsExpectedResult() {
        let expectedText = UUID().uuidString
        let expectedType = UUID().uuidString
        let expectedNewParam = UUID().uuidString
        let expectedExternal = Int.random(in: 1...100) % 2 == 0
        let result = AppEvent.navigation(
            text: expectedText,
            type: expectedType,
            external: expectedExternal,
            additionalParams: [
                "type": "new type to be ignored",
                "newParam": expectedNewParam
            ]
        )

        #expect(result.name == "Navigation")
        #expect(result.params?.count == 5)
        #expect(result.params?["text"] as? String == expectedText)
        #expect(result.params?["type"] as? String == expectedType)
        #expect(result.params?["newParam"] as? String == expectedNewParam)
        #expect(result.params?["external"] as? Bool == expectedExternal)
        #expect(result.params?["language"] as? String == "en")
    }
}
