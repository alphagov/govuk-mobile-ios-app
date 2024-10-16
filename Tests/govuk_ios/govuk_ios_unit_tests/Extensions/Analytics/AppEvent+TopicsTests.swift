import Foundation
import Testing

@testable import  govuk_ios

@Suite
struct AppEvent_TopicsTests {
    @Test(arguments:[true, false])
    func toggleTopic_returnsExpectedResult(isFavorite: Bool) {
        let expectedTitle = UUID().uuidString
        let expectedValue = isFavorite ? "On" : "Off"
        let result = AppEvent.toggleTopic(
            title: expectedTitle,
            isFavorite: isFavorite
        )
        #expect(result.name == "Function")
        #expect(result.params?.count == 4)
        #expect(result.params?["text"] as? String == expectedTitle)
        #expect(result.params?["type"] as? String == "toggle")
        #expect(result.params?["section"] as? String == "Topics")
        #expect(result.params?["action"] as? String == expectedValue)
    }
}

