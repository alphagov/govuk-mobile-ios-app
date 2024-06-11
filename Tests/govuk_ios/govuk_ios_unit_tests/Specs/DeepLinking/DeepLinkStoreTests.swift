import UIKit
import Foundation
import XCTest

@testable import govuk_ios

class DeepLinkStoreTests: XCTestCase {

    func test_drivingDeeplinkStore_hasCorrectDeepLinks() {
        let subject = DrivingDeepLinkStore()
        XCTAssertEqual(subject.deeplinks.count, 2)
    }

    func test_testDeeplinkStore_hasCorrectDeepLinks() {
        let subject = TestDeepLinkStore()
        XCTAssertEqual(subject.deeplinks.count, 1)
    }

}
