import Foundation
import XCTest

@testable import govuk_ios

class ViewControllerBuilderTests: XCTestCase {

    func test_permit_returnsExpectedResult() {

        let subject = ViewControllerBuilder()
        let result = subject.driving(
            showPermitAction: {},
            presentPermitAction: {}
        )

        XCTAssert(result is TestViewController)
        XCTAssertEqual(result.title, "Driving")
    }

}
