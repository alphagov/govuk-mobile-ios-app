import Foundation
import Testing
import Factory

@testable import govuk_ios

@Suite
@MainActor
struct CoordinatorBuilderTests {

    @Test
    func app_returnsExpectedResult() {
        let subject = CoordinatorBuilder(container: Container())
        let mockNavigationController = MockNavigationController()
        let coordinator = subject.app(
            navigationController: mockNavigationController
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
            completionAction: { }
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
}
