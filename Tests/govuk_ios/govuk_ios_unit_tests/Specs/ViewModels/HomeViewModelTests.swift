import Foundation
import UIKit
import Testing

@testable import govuk_ios

@Suite
struct HomeViewModelTests {
    @Test
    func widgets_returnsArrayOfWidgets() async {
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
            notificationService: MockNotificationService(),
            topicWidgetViewModel: topicsViewModel,
            feedbackAction: { },
            searchAction: { () -> Void in _ = true },
            notificationsAction: { },
            recentActivityAction: { }
        )
        let widgets = await subject.widgets

        #expect((widgets as Any) is [WidgetView])
        #expect(widgets.count == 4)
    }

    @Test
    func widgets_featureDisabled_doesntReturnWidget() async {
        let configService = MockAppConfigService()
        configService.features = []

        let mockNotificationService = MockNotificationService()
        mockNotificationService._stubbedShouldRequestPermission = false

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
            notificationService: mockNotificationService,
            topicWidgetViewModel: topicsViewModel,
            feedbackAction: { },
            searchAction: { },
            notificationsAction: { },
            recentActivityAction: { }
        )
        let widgets = await subject.widgets

        #expect(widgets.count == 0)
    }

}
