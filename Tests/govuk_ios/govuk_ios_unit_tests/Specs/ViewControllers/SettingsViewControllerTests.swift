import UIKit
import Foundation
import XCTest

@testable import govuk_ios

class SettingsViewControllerTests: XCTestCase {
    func test_settings_hasCorrectBackgroundColor() {
        let subject = SettingsViewController()
        let view = subject.view
        XCTAssertEqual(view?.backgroundColor, UIColor.primaryBackground)
    }
}
