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
            urlOpener: MockURLOpener(),
            searchService: MockSearchService(),
            activityService: MockActivityService(),
            localAuthorityService: MockLocalAuthorityService(),
            localAuthorityAction: { },
            editLocalAuthorityAction: { },
            feedbackAction: { },
            notificationsAction: {},
            recentActivityAction: { } ,
            openURLAction: {_ in } ,
            openAction: {_ in }
        )

        let widgets = subject.widgets

        #expect((widgets as Any) is [HomepageWidget])
        for item in widgets {
            print(item)
        }
        #expect(widgets.count == 1)
    }

    @Test
    func widgets_featureDisabled_doesntReturnWidget() async {
        let configService = MockAppConfigService()
        configService.features = []

        let topicsViewModel = TopicsWidgetViewModel(
            topicsService: MockTopicsService(),
            analyticsService: MockAnalyticsService(),
            topicAction: { _ in },
            allTopicsAction: { }
        )
        let subject = HomeViewModel(
            analyticsService: MockAnalyticsService(),
            configService: configService,
            notificationService: MockNotificationService(),
            topicsWidgetViewModel: topicsViewModel,
            urlOpener: MockURLOpener(),
            searchService: MockSearchService(),
            activityService: MockActivityService(),
            localAuthorityService: MockLocalAuthorityService(),
            localAuthorityAction: { },
            editLocalAuthorityAction: { },
            feedbackAction: { },
            notificationsAction: {},
            recentActivityAction: { } ,
            openURLAction: {_ in } ,
            openAction: {_ in }
        )
        let widgets = subject.widgets

        #expect(widgets.count == 0)
    }

}
