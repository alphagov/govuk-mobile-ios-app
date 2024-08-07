import Foundation
import XCTest

@testable import govuk_ios

class HomeViewModelTests: XCTestCase {

    @MainActor
    func test_widgets_returnsArrayOfWidgets() {
        let subject = HomeViewModel(analyticsService: MockAnalyticsService())
        let widgets = subject.widgets

        XCTAssert((widgets as Any) is [HomeWidgetViewModel])
    }

    @MainActor
    func test_logScreen_tracksHomeScreen() {
        let analyticsService = MockAnalyticsService()
        let subject = HomeViewModel(analyticsService: analyticsService)
        subject.logScreen()

        XCTAssertEqual(analyticsService._trackScreensVisited.count, 1)
        XCTAssert(analyticsService._trackScreensVisited.first is HomeScreen)
    }
}
