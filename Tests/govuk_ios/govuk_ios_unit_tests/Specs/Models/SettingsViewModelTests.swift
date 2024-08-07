import Foundation
import XCTest

@testable import govuk_ios

class SettingsViewModelTests: XCTestCase {

    @MainActor
    func test_logScreen_tracksSettingsScreen() {
        let analyticsService = MockAnalyticsService()
        let subject = SettingsViewModel(analyticsService: analyticsService)
        subject.logScreen()

        XCTAssertEqual(analyticsService._trackScreensVisited.count, 1)
        XCTAssert(analyticsService._trackScreensVisited.first is SettingsScreen)
    }
}
