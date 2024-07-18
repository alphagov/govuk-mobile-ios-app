import Foundation
import UIKit
import XCTest

@testable import govuk_ios

class UIAlertAction_ConvenienceTests: XCTestCase {
    func test_ok_returnsExpectedResult() {
        let subject = UIAlertAction.ok(handler: nil)

        XCTAssertEqual(subject.title, "OK")
    }
}
