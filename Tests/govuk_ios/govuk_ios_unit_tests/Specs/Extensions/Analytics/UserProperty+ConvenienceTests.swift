import Foundation
import Testing

@testable import govuk_ios

@Suite
struct UserProperty_ConvenienceTests {
    @Test
    func topicsCustomised_returnsExpectedResult() {
        let result = UserProperty.topicsCustomised
        #expect(result.key == "topics_customised")
        #expect(result.value == "true")
    }
}
