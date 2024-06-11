import UIKit
import Foundation
import XCTest

@testable import govuk_ios

class BaseViewControllerTests: XCTestCase {

    func test_preferredStatusBarStyle_returnsExpectedValue() {
        let subject = BaseViewController()
        XCTAssertEqual(subject.preferredStatusBarStyle, .lightContent)
    }

}
