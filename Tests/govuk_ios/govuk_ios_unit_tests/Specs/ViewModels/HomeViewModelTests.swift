import Foundation
import UIKit
import Testing

@testable import govuk_ios
@testable import GOVKitTestUtilities

@Suite
struct HomeViewModelTests {
    @Test
    func widgets_returnsArrayOfWidgets() async {
        let topicsViewModel = TopicsWidgetViewModel(
            topicsService: MockTopicsService(),
            analyticsService: MockAnalyticsService(),
            topicAction: { _ in },
            allTopicsAction: { }
        )
        let subject = HomeViewModel(
            analyticsService: MockAnalyticsService(),
            configService: MockAppConfigService(),
            notificationService: MockNotificationService(),
            topicsWidgetViewModel: topicsViewModel,
            urlOpener: { },
            searchService: { },
            activityService: { },
            localAuthorityService: { },
            localAuthorityAction: { },
            editLocalAuthorityAction: { _ in },
            feedbackAction: { _ in },
            notificationsAction: MockURLOpener(),
            recentActivityAction: MockSearchService(),
            openURLAction: MockActivityService(),
            openAction: MockLocalAuthorityService()
        )
        let widgets = await subject.widgets

        #expect((widgets as Any) is [WidgetView])
        #expect(widgets.count == 2)
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
            allTopicsAction: { }
        )
        let subject = HomeViewModel(
            analyticsService: MockAnalyticsService(),
            configService: configService,
            notificationService: mockNotificationService,
            topicsWidgetViewModel: topicsViewModel,
            localAuthorityAction: { },
            editLocalAuthorityAction: { },
            feedbackAction: { },
            notificationsAction: { },
            recentActivityAction: { },
            openURLAction: { _ in },
            openAction: { _ in },
            urlOpener: MockURLOpener(),
            searchService: MockSearchService(),
            activityService: MockActivityService(),
            localAuthorityService: MockLocalAuthorityService()
        )
        let widgets = await subject.widgets

        #expect(widgets.count == 0)
    }

}
