import Foundation
import UIKit
import Testing
import GOVKit

@testable import govuk_ios

@Suite
@MainActor
struct HomeViewModelTests {
    @Test
    func widgets_returnsArrayOfWidgets() {
        let topicsViewModel = TopicsWidgetViewModel(
            topicsService: MockTopicsService(),
            topicAction: { _ in },
            editAction: { },
            allTopicsAction: { }
        )
        let subject = HomeViewModel(
            analyticsService: MockAnalyticsService(),
            configService: MockAppConfigService(),
            topicWidgetViewModel: topicsViewModel,
            feedbackAction: { },
            searchAction: { () -> Void in _ = true },
            recentActivityAction: { },
            widgetBuilder: WidgetBuilder(analytics: MockAnalyticsService(),
                                         configService: MockAppConfigService(),
                                         topicWidgetViewModel: topicsViewModel,
                                         feedbackAction: { },
                                         searchAction: { },
                                         recentActivityAction: { })
        )
        let widgets = subject.widgets

        #expect((widgets as Any) is [WidgetView])
        #expect(widgets.count == 4)
    }

    @Test
    func widgets_featureDisabled_doesntReturnWidget() {
        let configService = MockAppConfigService()
        configService.features = []

        let topicsViewModel = TopicsWidgetViewModel(
            topicsService: MockTopicsService(),
            topicAction: { _ in },
            editAction: { },
            allTopicsAction: { }
        )
        let subject = HomeViewModel(
            analyticsService: MockAnalyticsService(),
            configService: configService,
            topicWidgetViewModel: topicsViewModel,
            feedbackAction: { },
            searchAction: { },
            recentActivityAction: { },
            widgetBuilder: WidgetBuilder(analytics: MockAnalyticsService(),
                                         configService: MockAppConfigService(),
                                         topicWidgetViewModel: topicsViewModel,
                                         feedbackAction: { },
                                         searchAction: { },
                                         recentActivityAction: { })
        )
        let widgets = subject.widgets

        #expect(widgets.count == 1)
    }

}
