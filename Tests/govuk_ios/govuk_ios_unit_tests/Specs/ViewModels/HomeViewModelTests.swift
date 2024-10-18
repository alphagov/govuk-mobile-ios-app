import Foundation
import UIKit
import Testing

@testable import govuk_ios

@Suite
@MainActor
struct HomeViewModelTests {
    @Test
    func widgets_returnsArrayOfWidgets() {
        let topicsViewModel = TopicsWidgetViewModel(
            topicsService: MockTopicsService(),
            topicAction: { _ in },
            editAction: { }
        )
        let subject = HomeViewModel(
            analyticsService: MockAnalyticsService(),
            configService: MockAppConfigService(),
            topicWidgetViewModel: topicsViewModel,
            searchAction: { () -> Void in _ = true },
            recentActivityAction: { }
        )
        let widgets = subject.widgets

        #expect((widgets as Any) is [WidgetView])
        #expect(widgets.count == 3)
    }

    @Test
    func widgets_featureDisabled_doesntReturnWidget() {
        let configService = MockAppConfigService()
        configService.features = []

        let topicsViewModel = TopicsWidgetViewModel(
            topicsService: MockTopicsService(),
            topicAction: { _ in },
            editAction: { }
        )
        let subject = HomeViewModel(
            analyticsService: MockAnalyticsService(),
            configService: configService,
            topicWidgetViewModel: topicsViewModel,
            searchAction: { },
            recentActivityAction: { }
        )
        let widgets = subject.widgets

        #expect(widgets.count == 1)
    }

}
