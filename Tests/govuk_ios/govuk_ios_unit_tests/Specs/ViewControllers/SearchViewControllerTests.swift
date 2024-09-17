import UIKit
import Foundation
import XCTest

import Factory

@testable import govuk_ios

class SearchViewControllerTests: XCTestCase {
    
    func test_viewDidAppear_tracksScreen() {
        let mockAnalyticsService = MockAnalyticsService()
        Container.shared.analyticsService.register {
            mockAnalyticsService
        }
        let viewModel = SearchViewModel(analyticsService: MockAnalyticsService())
        let subject = SearchViewController(
            viewModel: viewModel,
            dismissAction: { }
        )
        subject.viewDidAppear(false)

        let screens = mockAnalyticsService._trackScreenReceivedScreens
        XCTAssertEqual(screens.count, 1)
        XCTAssertEqual(screens.first?.trackingName, subject.trackingName)
        XCTAssertEqual(screens.first?.trackingClass, subject.trackingClass)
    }
}
