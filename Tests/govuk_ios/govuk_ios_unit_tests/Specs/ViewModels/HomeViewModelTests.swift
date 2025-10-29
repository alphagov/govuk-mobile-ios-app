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
            topicAction: { _ in }
        )
        let mockConfigService = MockAppConfigService()
        mockConfigService._stubbedAlertBanner = .init(
            id: "test",
            body: "test",
            link: nil
        )
        mockConfigService._stubbedChatBanner = .init(
            id: "test",
            title: "test",
            body: "test",
            link: mockConfigService._stubbedChatBannerLink
        )
        mockConfigService._stubbedUserFeedbackBanner = .init(
            body: "test",
            link: mockConfigService._stubbedUserFeedbackBannerLink
        )

        let mockChatService = MockChatService()
        mockChatService._stubbedIsEnabled = true
        mockChatService._stubbedChatOptInAvailable = true
        mockChatService.chatOptedIn = true

        let subject = HomeViewModel(
            analyticsService: MockAnalyticsService(),
            configService: mockConfigService,
            notificationService: MockNotificationService(),
            topicsWidgetViewModel: topicsViewModel,
            urlOpener: MockURLOpener(),
            searchService: MockSearchService(),
            activityService: MockActivityService(),
            localAuthorityService: MockLocalAuthorityService(),
<<<<<<< HEAD
            localAuthorityAction: { },
            editLocalAuthorityAction: { },
            feedbackAction: { },
            notificationsAction: {},
            recentActivityAction: { } ,
            openURLAction: {_ in } ,
            openAction: {_ in }
=======
            userDefaultService: MockUserDefaultsService(),
            chatService: mockChatService
>>>>>>> develop
        )

        let widgets = subject.widgets
      
        #expect((widgets as Any) is [HomepageWidget])
        #expect(widgets.count == 3)
    }

    @Test
    func widgets_featureDisabled_doesntReturnWidget() async {
        let configService = MockAppConfigService()
        configService.features = []

        let topicsViewModel = TopicsWidgetViewModel(
            topicsService: MockTopicsService(),
            analyticsService: MockAnalyticsService(),
            topicAction: { _ in }
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
<<<<<<< HEAD
            localAuthorityAction: { },
            editLocalAuthorityAction: { },
            feedbackAction: { },
            notificationsAction: {},
            recentActivityAction: { } ,
            openURLAction: {_ in } ,
            openAction: {_ in }
=======
            userDefaultService: MockUserDefaultsService(),
            chatService: MockChatService()
>>>>>>> develop
        )
        let widgets = subject.widgets

        #expect(widgets.count == 0)
    }

    @Test
    func trackScreen_trackCorrectScreen() {
        let topicsViewModel = TopicsWidgetViewModel(
            topicsService: MockTopicsService(),
            analyticsService: MockAnalyticsService(),
            topicAction: { _ in }
        )

        let mockAnalyticsService = MockAnalyticsService()
        let subject = HomeViewModel(
            analyticsService: mockAnalyticsService,
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
        let view = HomeContentView(
            viewModel: subject
        )
        subject.trackScreen(screen: view)

        let screens = mockAnalyticsService._trackScreenReceivedScreens
        #expect(screens.count == 1)
        #expect(screens.first?.trackingName == "Homepage")
        #expect(screens.first?.trackingClass == "HomeContentView")
    }
}
