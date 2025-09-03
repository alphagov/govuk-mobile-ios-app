import Foundation
import SafariServices
import Testing
import SwiftUI
import CoreData
import Factory
import GOVKit

@testable import GOVKitTestUtilities
@testable import govuk_ios

@MainActor
@Suite
struct ViewControllerBuilderTests {

    @Test
    func home_returnsExpectedResult() {
        let subject = ViewControllerBuilder()
        let viewModel = TopicsWidgetViewModel(
            topicsService: MockTopicsService(),
            analyticsService: MockAnalyticsService(),
            topicAction: { _ in },
            editAction: { },
            allTopicsAction: { }
        )
        let dependencies = ViewControllerBuilder.HomeDependencies(
            analyticsService: MockAnalyticsService(),
            configService: MockAppConfigService(),
            notificationService: MockNotificationService(),
            searchService: MockSearchService(),
            activityService: MockActivityService(),
            topicWidgetViewModel: viewModel,
            localAuthorityService: MockLocalAuthorityService(),
            userDefaultService: MockUserDefaultsService()
        )

        let actions = ViewControllerBuilder.HomeActions(
            feedbackAction: {},
            notificationsAction: {},
            recentActivityAction: {},
            localAuthorityAction: {},
            editLocalAuthorityAction: {},
            openURLAction: { _ in },
            openSearchAction: { _ in }
        )

        let result = subject.home(dependencies: dependencies, actions: actions)

        #expect(result is HomeViewController)
    }

    @Test
    func settings_returnsExpectedResult() {
        let subject = ViewControllerBuilder()
        let viewModel = SettingsViewModel(
            analyticsService: MockAnalyticsService(),
            urlOpener: MockURLOpener(),
            versionProvider: MockAppVersionProvider(),
            deviceInformationProvider: MockDeviceInformationProvider(),
            authenticationService: MockAuthenticationService(),
            notificationService: MockNotificationService(),
            notificationCenter: .default,
            localAuthenticationService: MockLocalAuthenticationService()
        )
        let result = subject.settings(
            viewModel: viewModel
        )
        #expect(result.title == "Settings")
        #expect(result.navigationItem.largeTitleDisplayMode == .always)
        #expect(result is HostingViewController<SettingsView<SettingsViewModel>>)
    }

    @Test
    func recentActivity_returnsExpectedResult() {
        let subject = ViewControllerBuilder()
        let result = subject.recentActivity(
            analyticsService: MockAnalyticsService(),
            activityService: MockActivityService(),
            selectedAction: { _ in }
        ) as? TrackableScreen

        #expect(result?.trackingClass == String(describing: RecentActivityListViewController.self))
        #expect(result?.trackingName == "Pages you've visited")
        #expect(result?.trackingTitle == "Pages you've visited")
    }

    @Test
    func notificationSettings_returnsExpectedResult() {
        let subject = ViewControllerBuilder()
        let result = subject.notificationSettings(
            analyticsService: MockAnalyticsService(),
            completeAction: { },
            dismissAction: { },
            viewPrivacyAction: { }
        )

        #expect(result is HostingViewController<NotificationsOnboardingView>)
    }

    @Test
    func topicDetail_returnsExpectedResult() {
        let subject = ViewControllerBuilder()
        let result = subject.topicDetail(
            topic: MockDisplayableTopic(ref: "", title: ""),
            topicsService: MockTopicsService(),
            analyticsService: MockAnalyticsService(),
            activityService: MockActivityService(),
            subtopicAction: { _ in },
            stepByStepAction: { _ in },
            openAction: { _ in }
        )

        let rootView = (result as? HostingViewController<TopicDetailView<TopicDetailViewModel>>)?.rootView
        #expect(rootView != nil)
    }

    @Test
    func editTopics_returnsExpectedResult() {
        let subject = ViewControllerBuilder()
        let result = subject.editTopics(
            analyticsService: MockAnalyticsService(),
            topicsService: MockTopicsService(),
            dismissAction: { }
        )

        let rootView = (result as? HostingViewController<EditTopicsView>)?.rootView
        #expect(rootView != nil)
    }

    @Test
    func allTopics_returnsExpectedResult() {
        let subject = ViewControllerBuilder()
        let result = subject.allTopics(
            analyticsService: MockAnalyticsService(),
            topicAction: { _ in },
            topicsService: MockTopicsService()
        )

        #expect(result is AllTopicsViewController)
    }

    @Test
    func topicOnboarding_returnsExpectedResult() {
        let subject = ViewControllerBuilder()
        let result = subject.topicOnboarding(
            topics: [],
            analyticsService: MockAnalyticsService(),
            topicsService: MockTopicsService(),
            dismissAction: { }
        )

        #expect(result is TopicOnboardingViewController)
    }

    @Test
    func localAuthorityPostcodeEntryView_returnsExpectedResult() {
        let subject = ViewControllerBuilder()
        let result = subject.localAuthorityPostcodeEntryView(
            analyticsService: MockAnalyticsService(),
            localAuthorityService: MockLocalAuthorityService(),
            resolveAmbiguityAction: { _, _ in },
            localAuthoritySelected: {_ in },
            dismissAction: {}
        )
        let rootView = (result as? HostingViewController<LocalAuthorityPostcodeEntryView>)?.rootView
        #expect(rootView != nil)
    }

    @Test
    func localAuthorityConfirmationView_returnsExpectedResult() {
        let authority = Authority(
            name: "Test",
            homepageUrl: "Test",
            tier: "unitary",
            slug: "test slug",
            parent: nil
        )
        let subject = ViewControllerBuilder()
        let result = subject.localAuthorityConfirmationScreen(
            analyticsService: MockAnalyticsService(),
            localAuthorityItem: authority,
            dismiss: {}
        )
        let rootView = (result as? HostingViewController<LocalAuthorityConfirmationView>)?.rootView
        #expect(rootView != nil)
    }


    @Test
    func localAuthorityExaplainerView_returnsExpectedResult() {
        let subject = ViewControllerBuilder()
        let result = subject.localAuthorityExplainerView(
            analyticsService: MockAnalyticsService(),
            navigateToPostCodeEntryViewAction: {},
            dismissAction: {}
        )
        let rootView = (result as? HostingViewController<LocalAuthorityExplainerView>)?.rootView
        #expect(rootView != nil)

    }

    @Test
    func webViewController_returnsExpectedViewController() {
        let subject = ViewControllerBuilder()
        let testURL = URL(string: "https://www.gov.uk")!
        let viewController = subject.web(for: testURL)

        #expect(viewController is WebViewController)
    }

    @Test
    func signOutConfirmation_returnsExpectedResult() {
        let subject = ViewControllerBuilder()
        let result = subject.signOutConfirmation(
            authenticationService:MockAuthenticationService(),
            analyticsService: MockAnalyticsService(),
            completion: { _ in }
        )
        let rootView = (result as? HostingViewController<SignOutConfirmationView>)?.rootView
        #expect(rootView != nil)
    }

    @Test
    func signInError_returnsExpectedResult() {
        let subject = ViewControllerBuilder()
        let result = subject.signInError(
            completion: { }
        )
        let rootView = (result as? HostingViewController<InfoView>)?.rootView
        #expect(rootView != nil)
    }

    @Test
    func safari_returnsExpectedResult() {
        let subject = ViewControllerBuilder()
        let result = subject.safari(
            url: .arrange
        )

        #expect(result is SFSafariViewController)
    }

    @Test
    func welcomeOnboarding_returnsExpectedResult() {
        let subject = ViewControllerBuilder()
        let result = subject.welcomeOnboarding(
            completion: { }
        )

        let rootView = (result as? HostingViewController<WelcomeOnboardingView>)?.rootView
        #expect(rootView != nil)
    }

    @Test
    func notificationConsentAlert_returnsExpectedResult() {
        let subject = ViewControllerBuilder()

        let result = subject.notificationConsentAlert(
            analyticsService: MockAnalyticsService(),
            viewPrivacyAction: { },
            grantConsentAction: { },
            openSettingsAction: { _ in }
        )

        #expect(result is NotificationConsentAlertViewController)
    }

    @Test
    func faceIdSettings_returnsExpectedResult() {
        let subject = ViewControllerBuilder()
        let result = subject.faceIdSettings(
            analyticsService: MockAnalyticsService(),
            authenticationService: MockAuthenticationService(),
            localAuthenticationService: MockLocalAuthenticationService(),
            urlOpener: MockURLOpener()
        )

        let rootView = (result as? HostingViewController<FaceIdSettingsView>)?.rootView
        #expect(rootView != nil)
    }

    @Test
    func touchIdSettings_returnsExpectedResult() {
        let subject = ViewControllerBuilder()
        let result = subject.touchIdSettings(
            analyticsService: MockAnalyticsService(),
            authenticationService: MockAuthenticationService(),
            localAuthenticationService: MockLocalAuthenticationService(),
            urlOpener: MockURLOpener()
        )

        let rootView = (result as? HostingViewController<TouchIdSettingsView>)?.rootView
        #expect(rootView != nil)
    }

    @Test
    func chat_returnsExpectedResult() {
        let subject = ViewControllerBuilder()
        let result = subject.chat(
            analyticsService: MockAnalyticsService(),
            chatService: MockChatService(),
            openURLAction: { _ in },
            handleError: { _ in }
        )

        let rootView = (result as? HostingViewController<ChatView>)?.rootView
        #expect(rootView != nil)
    }

    @Test
    func chatError_returnsExpectedResult() {
        let subject = ViewControllerBuilder()
        let result = subject.chatError(
            analyticsService: MockAnalyticsService(),
            error: ChatError.apiUnavailable,
            action: { }
        )
        
        let rootView = (result as? HostingViewController<InfoView>)?.rootView
        #expect(rootView != nil)
    }

    @Test
    func chatInfoOnboarding_returnsExpectedResult() {
        let subject = ViewControllerBuilder()
        let result = subject.chatInfoOnboarding(
            analyticsService: MockAnalyticsService(),
            completionAction: { },
            cancelOnboardingAction: { }
        )

        let rootView = (result as? HostingViewController<InfoView>)?.rootView
        #expect(rootView != nil)
    }

    @Test
    func chatConsentOnboarding_returnsExpectedResult() {
        let subject = ViewControllerBuilder()
        let result = subject.chatConsentOnboarding(
            analyticsService: MockAnalyticsService(),
            chatService: MockChatService(),
            cancelOnboardingAction: { },
            completionAction: { }
        )

        let rootView = (result as? HostingViewController<ChatConsentOnboardingView>)?.rootView
        #expect(rootView != nil)
    }

    @Test
    func chatOptIn_returnsExpectedResult() {
        let subject = ViewControllerBuilder()
        let result = subject.chatOptIn(
            analyticsService: MockAnalyticsService(),
            chatService: MockChatService(),
            openURLAction: { _ in },
            completionAction: { }
        )

        let rootView = (result as? HostingViewController<ChatOptInView>)?.rootView
        #expect(rootView != nil)
    }
}
