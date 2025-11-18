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
            dismissEditAction: { }
        )
        let mockConfigService = MockAppConfigService()
        mockConfigService._stubbedEmergencyBanners =
        [
            .init(
                id: "emergency",
                title: "National Emergency",
                body: "This is a Level 1 emergency",
                link: nil,
                type: "national-emergency",
                allowsDismissal: true
            ),
            .init(
                id: "bridges",
                title: "His Majesty King Henry VIII",
                body: "1621 - 1854",
                link: nil,
                type: "notable-death",
                allowsDismissal: false
            )
        ]

        let mockChatService = MockChatService()
        mockChatService._stubbedIsEnabled = true
        mockChatService._stubbedChatOptInAvailable = true
        mockChatService.chatOptedIn = true

        let subject = HomeViewModel(
            analyticsService: MockAnalyticsService(),
            configService: mockConfigService,
            notificationService: MockNotificationService(),
            userDefaultsService: MockUserDefaultsService(),
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
        #expect(widgets.count == 5)
    }

    @Test
    func widgets_featureDisabled_doesntReturnWidget() async {
        let configService = MockAppConfigService()
        configService.features = []

        let topicsViewModel = TopicsWidgetViewModel(
            topicsService: MockTopicsService(),
            analyticsService: MockAnalyticsService(),
            topicAction: { _ in },
            dismissEditAction: { }
        )
        let subject = HomeViewModel(
            analyticsService: MockAnalyticsService(),
            configService: configService,
            notificationService: MockNotificationService(),
            userDefaultsService: MockUserDefaultsService(),
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

    @Test
    func emergencyBanners_have_correct_sort_priority() throws {
        let topicsViewModel = TopicsWidgetViewModel(
            topicsService: MockTopicsService(),
            analyticsService: MockAnalyticsService(),
            topicAction: { _ in },
            dismissEditAction: { }
        )

        let mockConfigService = MockAppConfigService()
        mockConfigService._stubbedEmergencyBanners =
        [
            .init(
                id: "emergency",
                title: "National Emergency",
                body: "This is a Level 1 emergency",
                link: nil,
                type: "national-emergency",
                allowsDismissal: true
            ),
            .init(
                id: "bridges",
                title: "His Majesty King Henry VIII",
                body: "1621 - 1854",
                link: nil,
                type: "notable-death",
                allowsDismissal: false
            )
        ]

        let mockAnalyticsService = MockAnalyticsService()
        let subject = HomeViewModel(
            analyticsService: mockAnalyticsService,
            configService: mockConfigService,
            notificationService: MockNotificationService(),
            userDefaultsService: MockUserDefaultsService(),
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
        try #require(widgets.count >= 2)
        let bannerOne = try #require(widgets[0].content as? EmergencyBannerWidgetView)
        #expect(bannerOne.viewModel.sortPriority == 20)
        let bannerTwo = try #require(widgets[1].content as? EmergencyBannerWidgetView)
        #expect(bannerTwo.viewModel.sortPriority == 10)
    }
}
