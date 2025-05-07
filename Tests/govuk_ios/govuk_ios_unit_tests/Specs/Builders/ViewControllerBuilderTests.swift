import Foundation
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
            localAuthorityService: MockLocalAuthorityService()
        )

        let actions = ViewControllerBuilder.HomeActions(
            feedbackAction: {},
            notificationsAction: {},
            recentActivityAction: {},
            localAuthorityAction: {},
            editLocalAuthorityAction: {}
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
            notificationCenter: .default
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
        let coreData = CoreDataRepository.arrangeAndLoad
        Container.shared.coreDataRepository.register {
            coreData
        }
        let subject = ViewControllerBuilder()
        let result = subject.recentActivity(
            analyticsService: MockAnalyticsService(),
            activityService: MockActivityService()
        ) as? TrackableScreen

        #expect(result?.trackingClass == String(describing: RecentActivityListViewController.self))
        #expect(result?.trackingName == "Pages you've visited")
        #expect(result?.trackingTitle == "Pages you've visited")
    }

    @Test
    func notificationSettings_returnsExpectedResult() {
        let coreData = CoreDataRepository.arrangeAndLoad
        Container.shared.coreDataRepository.register {
            coreData
        }
        let subject = ViewControllerBuilder()
        let result = subject.notificationSettings(
            analyticsService: MockAnalyticsService(),
            notificationService: MockNotificationService(),
            completeAction: {}
        )

        #expect(result is HostingViewController<NotificationSettingsView>)
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
            webViewAction: { }
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
            dismissAction: {}
        )
        let rootView = (result as? HostingViewController<LocalAuthorityPostcodeEntryView>)?.rootView
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

        func webViewController_returnsExpectedViewController() {
            let subject = ViewControllerBuilder()
            let testURL = URL(string: "https://www.gov.uk")!
            let viewController = subject.webViewController(for: testURL)

            #expect(viewController is WebViewController)
        }
    }

    @Test
    func signOutConfirmation_returnsExpectedResult() {
        let subject = ViewControllerBuilder()
        let result = subject.signOutConfirmation(
            authenticationService:MockAuthenticationService(),
            analyticsService: MockAnalyticsService(),
            completion: { }
        )
        let rootView = (result as? HostingViewController<SignOutConfirmationView>)?.rootView
        #expect(rootView != nil)
    }

    @Test
    func signedOut_returnsExpectedResult() {
        let subject = ViewControllerBuilder()
        let result = subject.signedOut(
            authenticationService:MockAuthenticationService(),
            analyticsService: MockAnalyticsService(),
            completion: { }
        )
        let rootView = (result as? HostingViewController<SignedOutView>)?.rootView
        #expect(rootView != nil)
    }
}
