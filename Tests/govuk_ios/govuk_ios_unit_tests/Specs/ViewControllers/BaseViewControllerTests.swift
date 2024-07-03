import UIKit
import Foundation
import XCTest

@testable import govuk_ios

class BaseViewControllerTests: XCTestCase {

    func test_preferredStatusBarStyle_returnsExpectedValue() {
        let subject = BaseViewController()
        XCTAssertEqual(subject.preferredStatusBarStyle, .lightContent)
    }

    func test_layoutMargins_returnsExpectedValue() {
        let subject = BaseViewController()
        let expectedInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        XCTAssertEqual(subject.view.layoutMargins, expectedInsets)
    }

}
