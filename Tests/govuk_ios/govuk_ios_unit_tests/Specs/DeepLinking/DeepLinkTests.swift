import UIKit
import Foundation
import XCTest

@testable import govuk_ios

class DeepLinkTests: XCTestCase {

    func test_testDeeplink_hasCorrectPath() {
        let subject = TestDeepLink()
        XCTAssertEqual(subject.path, "/test")
    }

    func test_drivingDeeplink_hasCorrectPath() {
        let subject = DrivingDeepLink()
        XCTAssertEqual(subject.path, "/driving")
    }

    func test_permitDeeplink_hasCorrectPath() {
        let subject = PermitDeepLink()
        XCTAssertEqual(subject.path, "/driving/permit/123")
    }

}
