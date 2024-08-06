import UIKit
import Foundation
import XCTest

@testable import govuk_ios

class SettingsViewControllerTests: XCTestCase {
    func test_settings_hasCorrectBackgroundColor() {
        let analyticsService = SettingsViewModel(analyticsService: MockAnalyticsService())
        let subject = SettingsViewController(viewModel: analyticsService)
        let view = subject.view
        XCTAssertEqual(view?.backgroundColor, UIColor.govUK.fills.surfaceBackground)
    }
}
