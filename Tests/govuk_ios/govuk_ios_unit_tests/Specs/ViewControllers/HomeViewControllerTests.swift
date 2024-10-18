import Foundation
import UIKit
import Testing

import Factory

@testable import govuk_ios

@MainActor
struct HomeViewControllerTests {
    @Test
    func init_hasExpectedValues() {
        let topicsViewModel = TopicsWidgetViewModel(
            topicsService: MockTopicsService(),
            analyticsService: MockAnalyticsService(),
            topicAction: { _ in },
            editAction: { _ in }
        )
        let viewModel = HomeViewModel(
            analyticsService: MockAnalyticsService(),
            configService: MockAppConfigService(),
            searchButtonPrimaryAction: { () -> Void in _ = true },
            recentActivityAction: { },
            topicWidgetViewModel: topicsViewModel
        )
        let subject = HomeViewController(viewModel: viewModel)

        #expect(subject.title == "Home")
    }

    @Test
    func viewDidAppear_tracksScreen() {
        let mockAnalyticsService = MockAnalyticsService()
        Container.shared.analyticsService.register {
            mockAnalyticsService
        }
        let topicsViewModel = TopicsWidgetViewModel(
            topicsService: MockTopicsService(),
            analyticsService: MockAnalyticsService(),
            topicAction: { _ in },
            editAction: { _ in }
        )
        let viewModel = HomeViewModel(
            analyticsService: MockAnalyticsService(),
            configService: MockAppConfigService(),
            searchButtonPrimaryAction: { () -> Void in _ = true },
            recentActivityAction: { },
            topicWidgetViewModel: topicsViewModel
        )
        let subject = HomeViewController(viewModel: viewModel)
        subject.viewDidAppear(false)

        let screens = mockAnalyticsService._trackScreenReceivedScreens
        #expect(screens.count == 1)
        #expect(screens.first?.trackingName == subject.trackingName)
        #expect(screens.first?.trackingClass == subject.trackingClass)
    }
}
