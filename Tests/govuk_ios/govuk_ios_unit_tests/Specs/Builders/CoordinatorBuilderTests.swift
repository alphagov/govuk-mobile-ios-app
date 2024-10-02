import Foundation
import XCTest
import Factory
@testable import govuk_ios

class CoordinatorBuilderTests: XCTestCase {

    @MainActor
    func test_app_returnsExpectedResult() {
        let subject = CoordinatorBuilder(container: Container())
        let mockNavigationController = MockNavigationController()
        let coordinator = subject.app(
            navigationController: mockNavigationController
        )

        XCTAssert(coordinator is AppCoordinator)
        XCTAssertEqual(coordinator.root, mockNavigationController)
    }

    @MainActor
    func test_home_returnsExpectedResult() {
        let subject = CoordinatorBuilder(container: Container())
        let coordinator = subject.home

        XCTAssert(coordinator is HomeCoordinator)
    }

    @MainActor
    func test_settings_returnsExpectedResult() {
        let subject = CoordinatorBuilder(container: Container())
        let coordinator = subject.settings

        XCTAssert(coordinator is SettingsCoordinator)
    }

    @MainActor
    func test_launch_returnsExpectedResult() {
        let subject = CoordinatorBuilder(container: Container())
        let mockNavigationController = MockNavigationController()
        let coordinator = subject.launch(
            navigationController: mockNavigationController,
            completion: { }
        )

        XCTAssert(coordinator is LaunchCoordinator)
        XCTAssertEqual(coordinator.root, mockNavigationController)
    }

    @MainActor
    func test_tab_returnsExpectedResult() {
        let subject = CoordinatorBuilder(container: Container())
        let mockNavigationController = MockNavigationController()
        let coordinator = subject.tab(
            navigationController: mockNavigationController
        )

        XCTAssert(coordinator is TabCoordinator)
        XCTAssertEqual(coordinator.root, mockNavigationController)
    }

    @MainActor
    func test_onboarding_returnsExpectedResult() {
        let subject = CoordinatorBuilder(container: Container())
        let mockNavigationController = MockNavigationController()
        let coordinator = subject.onboarding(
            navigationController: mockNavigationController,
            dismissAction: { }
        )

        XCTAssert(coordinator is OnboardingCoordinator)
    }

    @MainActor
    func test_search_returnsExpectedResult() {
        let subject = CoordinatorBuilder(container: Container())
        let mockNavigationController = MockNavigationController()
        let coordinator = subject.search(
            navigationController: mockNavigationController,
            didDismissAction: { }
        )

        XCTAssert(coordinator is SearchCoordinator)
    }

    @MainActor
    func test_recentActivity_returnsExpectedResult() {
        let subject = CoordinatorBuilder(container: Container())
        let mockNavigationController = MockNavigationController()
        let coordinator = subject.recentActivity(
            navigationController: mockNavigationController
        )

        XCTAssert(coordinator is RecentActivityCoordinator)
    }
}
