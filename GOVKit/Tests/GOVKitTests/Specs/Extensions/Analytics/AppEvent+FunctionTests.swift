import Foundation
import Testing

@testable import GOVKit

@Suite
struct AppEvent_FunctionTests {
    @Test
    func function_returnsExpectedResult() {
        let expectedText = UUID().uuidString
        let expectedType = UUID().uuidString
        let expectedSection = UUID().uuidString
        let expectedAction = UUID().uuidString
        let result = AppEvent.function(
            text: expectedText,
            type: expectedType,
            section: expectedSection,
            action: expectedAction
        )

        #expect(result.name == "Function")
        #expect(result.params?["text"] as? String == expectedText)
        #expect(result.params?["type"] as? String == expectedType)
        #expect(result.params?["section"] as? String == expectedSection)
        #expect(result.params?["action"] as? String == expectedAction)
    }

    @Test
    func buttonFunction_returnsExpectedResult() {
        let expectedText = UUID().uuidString
        let expectedSection = UUID().uuidString
        let expectedAction = UUID().uuidString
        let result = AppEvent.buttonFunction(
            text: expectedText,
            section: expectedSection,
            action: expectedAction
        )

        #expect(result.name == "Function")
        #expect(result.params?["text"] as? String == expectedText)
        #expect(result.params?["type"] as? String == "Button")
        #expect(result.params?["section"] as? String == expectedSection)
        #expect(result.params?["action"] as? String == expectedAction)
    }
}

