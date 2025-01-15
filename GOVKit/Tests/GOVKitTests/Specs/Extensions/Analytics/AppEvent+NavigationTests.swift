import Foundation
import Testing

@testable import GOVKit

@Suite
struct AppEvent_NavigationTests {
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
