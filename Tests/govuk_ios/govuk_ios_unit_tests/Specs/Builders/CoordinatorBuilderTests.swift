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
    func test_red_returnsExpectedResult() {
        let subject = CoordinatorBuilder(container: Container())
        let coordinator = subject.red

        XCTAssertEqual(coordinator.root.tabBarItem.title, "Red")
        XCTAssertTrue(coordinator.root.navigationBar.prefersLargeTitles)
    }

    @MainActor
    func test_blue_returnsExpectedResult() {
        let subject = CoordinatorBuilder(container: Container())
        let coordinator = subject.blue

        XCTAssertEqual(coordinator.root.tabBarItem.title, "Blue")
        XCTAssertFalse(coordinator.root.navigationBar.prefersLargeTitles)
    }

    @MainActor
    func test_green_returnsExpectedResult() {
        let subject = CoordinatorBuilder(container: Container())
        let coordinator = subject.green

        XCTAssertEqual(coordinator.root.tabBarItem.title, "Green")
        XCTAssertFalse(coordinator.root.navigationBar.prefersLargeTitles)
    }

    @MainActor
    func test_driving_returnsExpectedResult() {
        let subject = CoordinatorBuilder(container: Container())
        let mockNavigationController = MockNavigationController()
        let coordinator = subject.driving(
            navigationController: mockNavigationController
        )

        XCTAssert(coordinator is DrivingCoordinator)
    }

    @MainActor
    func test_permit_returnsExpectedResult() {
        let subject = CoordinatorBuilder(container: Container())
        let mockNavigationController = MockNavigationController()
        let coordinator = subject.permit(
            permitId: "123",
            navigationController: mockNavigationController
        )

        XCTAssert(coordinator is PermitCoordinator)
    }

    @MainActor
    func test_next_returnsExpectedResult() {
        let subject = CoordinatorBuilder(container: Container())
        let mockNavigationController = MockNavigationController()
        let coordinator = subject.next(
            title: "Title",
            navigationController: mockNavigationController
        )

        XCTAssert(coordinator is NextCoordinator)
    }
}
