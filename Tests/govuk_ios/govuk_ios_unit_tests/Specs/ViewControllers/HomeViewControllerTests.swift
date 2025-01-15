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
            topicAction: { _ in },
            editAction: { },
            allTopicsAction: { }
        )
        let viewModel = HomeViewModel(
            analyticsService: MockAnalyticsService(),
            configService: MockAppConfigService(),
            topicWidgetViewModel: topicsViewModel,
            searchAction: { () -> Void in _ = true },
            recentActivityAction: { }
        )
        let subject = HomeViewController(viewModel: viewModel)

        #expect(subject.title == "Home")
    }

    @Test
    func viewDidAppear_tracksScreen() {
        let mockAnalyticsService = MockAnalyticsService()
        let topicsViewModel = TopicsWidgetViewModel(
            topicsService: MockTopicsService(),
            topicAction: { _ in },
            editAction: { },
            allTopicsAction: { }
        )
        let viewModel = HomeViewModel(
            analyticsService: mockAnalyticsService,
            configService: MockAppConfigService(),
            topicWidgetViewModel: topicsViewModel,
            searchAction: { () -> Void in _ = true },
            recentActivityAction: { }
        )
        let subject = HomeViewController(viewModel: viewModel)
        subject.viewDidAppear(false)

        let screens = mockAnalyticsService._trackScreenReceivedScreens
        #expect(screens.count == 1)
        #expect(screens.first?.trackingName == subject.trackingName)
        #expect(screens.first?.trackingClass == subject.trackingClass)
        #expect(screens.first?.additionalParameters.count == 0)
    }
    
    @Test
    func scrollToTop_scrollsContentToTop() {
        let topicsViewModel = TopicsWidgetViewModel(
            topicsService: MockTopicsService(),
            topicAction: { _ in },
            editAction: { },
            allTopicsAction: { }
        )
        let viewModel = HomeViewModel(
            analyticsService: MockAnalyticsService(),
            configService: MockAppConfigService(),
            topicWidgetViewModel: topicsViewModel,
            searchAction: { () -> Void in _ = true },
            recentActivityAction: { }
        )
        let subject = HomeViewController(viewModel: viewModel)
        guard let scrollView: UIScrollView =
                subject.view.subviews.first(where: { $0 is UIScrollView } ) as? UIScrollView
        else {
            return
        }
        scrollView.setContentOffset(CGPoint(x: 0, y: 100), animated: false)
        subject.scrollToTop()
        #expect(scrollView.contentOffset.y == -72)
    }
}
