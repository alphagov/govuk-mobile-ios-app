import UIKit
import XCTest

import Factory

@testable import govuk_ios

@MainActor
final class SearchViewControllerTestsXC: XCTestCase {

    func test_viewDidAppear_tracksScreen() {
        let mockAnalyticsService = MockAnalyticsService()
        Container.shared.analyticsService.register {
            mockAnalyticsService
        }
        let viewModel = SearchViewModel(
            analyticsService: MockAnalyticsService(),
            searchService: MockSearchService(),
            activityService: MockActivityService(),
            urlOpener: MockURLOpener()
        )
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
