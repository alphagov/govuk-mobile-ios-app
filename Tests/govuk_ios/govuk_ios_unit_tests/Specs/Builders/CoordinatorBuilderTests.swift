import Foundation
import Testing
import Factory
import UIKit

@testable import govuk_ios

@Suite
@MainActor
struct CoordinatorBuilderTests {

    @Test
    func app_returnsExpectedResult() {
        let subject = CoordinatorBuilder(container: Container())
        let mockNavigationController = MockNavigationController()
        let mockInactivityService = MockInactivityService()
        let coordinator = subject.app(
            navigationController: mockNavigationController,
            inactivityService: mockInactivityService
        )

        #expect(coordinator is AppCoordinator)
        #expect(coordinator.root == mockNavigationController)
    }

    @Test
    func home_returnsExpectedResult() {
        let subject = CoordinatorBuilder(container: Container())
        let coordinator = subject.home

        #expect(coordinator is HomeCoordinator)
    }

    @Test
    func settings_returnsExpectedResult() {
        let subject = CoordinatorBuilder(container: Container())
        let coordinator = subject.settings

        #expect(coordinator is SettingsCoordinator)
    }

    @Test
    func launch_returnsExpectedResult() {
        let subject = CoordinatorBuilder(container: Container())
        let mockNavigationController = MockNavigationController()
        let coordinator = subject.launch(
            navigationController: mockNavigationController,
            completion: { _ in }
        )

        #expect(coordinator is LaunchCoordinator)
        #expect(coordinator.root == mockNavigationController)
    }

    @Test
    func appUnavailable_returnsExpectedResult() {
        let subject = CoordinatorBuilder(container: Container())
        let coordinator = subject.appUnavailable(
            navigationController: MockNavigationController(),
            launchResponse: .arrangeAvailable,
            dismissAction: {}
        )

        #expect(coordinator is AppUnavailableCoordinator)
    }

    @Test
    func appRecommendUpdate_returnsExpectedResult() {
        let subject = CoordinatorBuilder(container: Container())
        let coordinator = subject.appRecommendUpdate(
            navigationController: MockNavigationController(),
            launchResponse: .arrangeAvailable,
            dismissAction: {}
        )

        #expect(coordinator is AppRecommendUpdateCoordinator)
    }

    @Test
    func appForcedUpdate_returnsExpectedResult() {
        let subject = CoordinatorBuilder(container: Container())
        let coordinator = subject.appForcedUpdate(
            navigationController: MockNavigationController(),
            launchResponse: .arrangeAvailable,
            dismissAction: {}
        )

        #expect(coordinator is AppForcedUpdateCoordinator)
    }

    @Test
    func analyticsConsent_returnsExpectedResult() {
        let subject = CoordinatorBuilder(container: Container())
        let coordinator = subject.analyticsConsent(
            navigationController: MockNavigationController(),
            dismissAction: {}
        )

        #expect(coordinator is AnalyticsConsentCoordinator)
    }

    @Test
    func tab_returnsExpectedResult() {
        let subject = CoordinatorBuilder(container: Container())
        let mockNavigationController = MockNavigationController()
        let coordinator = subject.tab(
            navigationController: mockNavigationController
        )

        #expect(coordinator is TabCoordinator)
        #expect(coordinator.root == mockNavigationController)
    }

    @Test
    func onboarding_returnsExpectedResult() {
        let subject = CoordinatorBuilder(container: Container())
        let mockNavigationController = MockNavigationController()
        let coordinator = subject.onboarding(
            navigationController: mockNavigationController,
            dismissAction: { }
        )

        #expect(coordinator is OnboardingCoordinator)
    }

    @Test
    func recentActivity_returnsExpectedResult() {
        let subject = CoordinatorBuilder(container: Container())
        let mockNavigationController = MockNavigationController()
        let coordinator = subject.recentActivity(
            navigationController: mockNavigationController
        )

        #expect(coordinator is RecentActivityCoordinator)
    }

    @Test
    func topicDetail_returnsExpectedResult() {
        let subject = CoordinatorBuilder(container: Container())
        let mockNavigationController = MockNavigationController()
        let coordinator = subject.topicDetail(
            Topic(),
            navigationController: mockNavigationController
        )

        #expect(coordinator is TopicDetailsCoordinator)
    }

    @Test
    func editTopics_returnsExpectedResult() {
        let subject = CoordinatorBuilder(container: Container())
        let mockNavigationController = MockNavigationController()
        let coordinator = subject.editTopics(
            navigationController: mockNavigationController,
            didDismissAction: { }
        )

        #expect(coordinator is EditTopicsCoordinator)
    }

    @Test
    func localAuhority_returnsExpectedResult() {
        let subject = CoordinatorBuilder(container: Container())
        let mockNavigationController = MockNavigationController()
        let coordinator = subject.localAuthority(
            navigationController: mockNavigationController,
            dismissAction: {}
        )
        #expect(coordinator is LocalAuthorityServiceCoordinator)
    }

    @Test
    func editLocalAuthority_returnsExpectedResult() {
        let subject = CoordinatorBuilder(container: Container())
        let mockNavigationController = MockNavigationController()
        let coordinator = subject.editLocalAuthority(
            navigationController: mockNavigationController,
            dismissAction: {}
        )
        #expect(coordinator is EditLocalAuthorityCoordinator)
    }

    @Test
    func allTopics_returnsExpectedResult() {
        let subject = CoordinatorBuilder(container: Container())
        let mockNavigationController = MockNavigationController()
        let coordinator = subject.allTopics(
            navigationController: mockNavigationController
        )

        #expect(coordinator is AllTopicsCoordinator)
    }

    @Test
    func topicOnboarding_returnsExpectedResult() {
        let subject = CoordinatorBuilder(container: Container())
        let mockNavigationController = MockNavigationController()
        let coordinator = subject.topicOnboarding(
            navigationController: mockNavigationController,
            didDismissAction: { }
        )

        #expect(coordinator is TopicOnboardingCoordinator)
    }

    @Test
    func notificationOnboarding_returnsExpectedResult() {
        let subject = CoordinatorBuilder(container: Container())
        let mockNavigationController = MockNavigationController()
        let coordinator = subject.notificationOnboarding(
            navigationController: mockNavigationController,
            completion: { }
        )

        #expect(coordinator is NotificationOnboardingCoordinator)
    }

    @Test
    func notificationSettings_returnsExpectedResult() {
        let subject = CoordinatorBuilder(container: Container())
        let mockNavigationController = MockNavigationController()
        let coordinator = subject.notificationSettings(
            navigationController: mockNavigationController,
            completionAction: { },
            dismissAction: { }
        )

        #expect(coordinator is NotificationSettingsCoordinator)
    }

    @Test
    func authenticationOnboarding_returnsExpectedResult() {
        let subject = CoordinatorBuilder(container: Container())
        let mockNavigationController = MockNavigationController()
        let coordinator = subject.authenticationOnboarding(
            navigationController: mockNavigationController,
            completionAction: { }
        )

        #expect(coordinator is AuthenticationOnboardingCoordinator)
    }

    @Test
    func authentication_returnsExpectedResult() {
        let subject = CoordinatorBuilder(container: Container())
        let mockNavigationController = MockNavigationController()
        let coordinator = subject.authentication(
            navigationController: mockNavigationController,
            completionAction: { },
            handleError: { _ in }
        )

        #expect(coordinator is AuthenticationCoordinator)
    }

    @Test
    func localAuthenticationOnboarding_returnsExpectedResult() {
        let subject = CoordinatorBuilder(container: Container())
        let mockNavigationController = MockNavigationController()
        let coordinator = subject.localAuthenticationOnboarding(
            navigationController: mockNavigationController,
            completionAction: { }
        )

        #expect(coordinator is LocalAuthenticationOnboardingCoordinator)
    }


    @Test
    func signOutConfirmation_returnsExpectedResult() {
        let subject = CoordinatorBuilder(container: Container())
        let coordinator = subject.signOutConfirmation()

        #expect(coordinator is SignOutConfirmationCoordinator)
    }

//    @Test
//    func signedOut_returnsExpectedResult() {
//        let subject = CoordinatorBuilder(container: Container())
//        let mockNavigationController = MockNavigationController()
//        let coordinator = subject.signedOut(
//            navigationController: mockNavigationController,
//            completion: { _ in }
//        )
//
//        #expect(coordinator is SignedOutCoordinator)
//    }

    @Test
    func webView_returnsExpectedResult() {
        let subject = CoordinatorBuilder(container: Container())
        let testURL = URL(string: "https://www.gov.uk")!
        let coordinator = subject.webView(url: testURL)

        #expect(coordinator is WebViewCoordinator)
    }

    @Test
    func reauthentication_returnsExpectedResult() {
        let subject = CoordinatorBuilder(container: Container())
        let coordinator = subject.reauthentication(
            navigationController: MockNavigationController(),
            completionAction: { }
        )

        #expect(coordinator is ReauthenticationCoordinator)
    }

    @Test
    func relaunch_returnsExpectedResult() {
        let subject = CoordinatorBuilder(container: Container())
        let coordinator = subject.relaunch(
            navigationController: MockNavigationController(),
            completion: { }
        )

        #expect(coordinator is ReLaunchCoordinator)
    }

    @Test
    func notificationConsent_returnsExpectedResult() {
        let subject = CoordinatorBuilder(container: Container())
        let coordinator = subject.notificationConsent(
            navigationController: MockNavigationController(),
            consentResult: .aligned,
            completion: { }
        )

        #expect(coordinator is NotificationConsentCoordinator)
    }

    @Test
    func safari_returnsExpectedResult() {
        let subject = CoordinatorBuilder(container: Container())
        let coordinator = subject.safari(
            navigationController: UINavigationController(),
            url: URL.arrange
        )

        #expect(coordinator is SafariCoordinator)
    }
}
