import Foundation
import Testing

import Factory

@testable import govuk_ios

@Suite
struct Container_NetworkClientTests {
    @Test
    func searchAPIClient_returnsExpectedResult() {
        let result = Container.shared.searchAPIClient()
        #expect(result != nil)
    }
}
