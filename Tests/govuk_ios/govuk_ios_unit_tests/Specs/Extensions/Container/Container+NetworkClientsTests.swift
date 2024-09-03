import Foundation
import XCTest

import Factory

@testable import govuk_ios

class Container_NetworkClientTests: XCTestCase {
    func test_govukAPIClient_returnsExpectedResult() {
        _ = Container.shared.govukAPIClient()
    }
}
