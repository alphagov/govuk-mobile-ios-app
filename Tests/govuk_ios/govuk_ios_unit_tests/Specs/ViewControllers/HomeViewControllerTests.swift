import Foundation
import UIKit
import Testing

import Factory

@testable import govuk_ios

@MainActor
struct HomeViewControllerTests {

    @Test
    func viewDidAppear_tracksScreen() {
        let mockAnalyticsService = MockAnalyticsService()
        Container.shared.analyticsService.register {
            mockAnalyticsService
        }
        let viewModel = HomeViewModel(
            configService: MockAppConfigService(),
            topicsService: MockTopicsService(),
            searchButtonPrimaryAction: { () -> Void in _ = true },
            recentActivityAction: { },
            topicAction: { _ in }
        )
        let subject = HomeViewController(viewModel: viewModel)
        subject.viewDidAppear(false)

        let screens = mockAnalyticsService._trackScreenReceivedScreens
        #expect(screens.count == 1)
        #expect(screens.first?.trackingName == subject.trackingName)
        #expect(screens.first?.trackingClass == subject.trackingClass)
    }
}
