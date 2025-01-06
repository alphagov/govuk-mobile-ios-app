import UIKit
import Foundation
import Testing

import Factory

@testable import GOVKitTestUtilities
@testable import govuk_ios

@MainActor
@Suite
struct SearchViewControllerTests {

    @Test
    func viewDidAppear_tracksScreen() {
        let mockAnalyticsService = MockAnalyticsService()
        let viewModel = SearchViewModel(
            analyticsService: mockAnalyticsService,
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
        #expect(screens.count == 1)
        #expect(screens.first?.trackingName == subject.trackingName)
        #expect(screens.first?.trackingClass == subject.trackingClass)
    }
}
