import Foundation
import UIKit
import Testing

@testable import govuk_ios
@testable import GOVKitTestUtilities

@Suite
@MainActor
struct HomeViewModelTests {
    @Test
    func widgets_returnsArrayOfWidgets() {
        let topicsViewModel = TopicsWidgetViewModel(
            topicsService: MockTopicsService(),
            analyticsService: MockAnalyticsService(),
            topicAction: { _ in },
            editAction: { },
            allTopicsAction: { }
        )
        let subject = HomeViewModel(
            analyticsService: MockAnalyticsService(),
            configService: MockAppConfigService(),
            topicWidgetViewModel: topicsViewModel,
            feedbackAction: { },
            recentActivityAction: { },
            urlOpener: MockURLOpener(),
            searchService: MockSearchService(),
            activityService: MockActivityService()
        )
        let widgets = subject.widgets

        #expect((widgets as Any) is [WidgetView])
        #expect(widgets.count == 2)
    }

    @Test
    func widgets_featureDisabled_doesntReturnWidget() {
        let configService = MockAppConfigService()
        configService.features = []

        let topicsViewModel = TopicsWidgetViewModel(
            topicsService: MockTopicsService(),
            analyticsService: MockAnalyticsService(),
            topicAction: { _ in },
            editAction: { },
            allTopicsAction: { }
        )
        let subject = HomeViewModel(
            analyticsService: MockAnalyticsService(),
            configService: configService,
            topicWidgetViewModel: topicsViewModel,
            feedbackAction: { },
            recentActivityAction: { },
            urlOpener: MockURLOpener(),
            searchService: MockSearchService(),
            activityService: MockActivityService()
        )
        let widgets = subject.widgets

        #expect(widgets.count == 0)
    }

}
