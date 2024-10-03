import Foundation
import Testing

import Factory

@testable import govuk_ios

@Suite
struct Container_NetworkClientTests {
    @Test
    func govukAPIClient_returnsExpectedResult() {
        let result = Container.shared.govukAPIClient()
        #expect(result != nil)
    }
}
