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
            completion: { }
        )

        #expect(coordinator is LaunchCoordinator)
        #expect(coordinator.root == mockNavigationController)
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
    func search_returnsExpectedResult() {
        let subject = CoordinatorBuilder(container: Container())
        let mockNavigationController = MockNavigationController()
        let coordinator = subject.search(
            navigationController: mockNavigationController,
            didDismissAction: { }
        )

        #expect(coordinator is SearchCoordinator)
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

        #expect(coordinator is TopicsCoordinator)
    }
    
    @Test
    func editTopics_returnsExpectedResult() {
        let subject = CoordinatorBuilder(container: Container())
        let mockNavigationController = MockNavigationController()
        let coordinator = subject.editTopics(
            [Topic](),
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
            navigationController: mockNavigationController,
            topics: [Topic()]
        )

        #expect(coordinator is AllTopicsCoordinator)
    }
}
