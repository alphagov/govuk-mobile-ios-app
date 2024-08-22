import UIKit
import Foundation
import XCTest

@testable import govuk_ios

class SettingsViewControllerTests: XCTestCase {
    func test_settings_hasCorrectBackgroundColor() {
        let viewModel = SettingsViewModel()
        let subject = SettingsViewController(viewModel: viewModel)
        let view = subject.view
        XCTAssertEqual(view?.backgroundColor, UIColor.govUK.fills.surfaceBackground)
        XCTAssertEqual(subject.title, "Settings")
    }
}
