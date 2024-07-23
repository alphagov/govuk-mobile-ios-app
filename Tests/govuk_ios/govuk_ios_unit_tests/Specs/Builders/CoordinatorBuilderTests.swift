import Foundation
import XCTest

@testable import govuk_ios

class CoordinatorBuilderTests: XCTestCase {

    @MainActor
    func test_app_returnsExpectedResult() {
        let subject = CoordinatorBuilder()
        let mockNavigationController = MockNavigationController()
        let coordinator = subject.app(
            navigationController: mockNavigationController
        )

        XCTAssert(coordinator is AppCoordinator)
        XCTAssertEqual(coordinator.root, mockNavigationController)
    }
    
    @MainActor
    func test_home_returnsExpectedResult() {
        let subject = CoordinatorBuilder()
        let coordinator = subject.home

        XCTAssert(coordinator is HomeCoordinator)
    }
    
    @MainActor
    func test_settings_returnsExpectedResult() {
        let subject = CoordinatorBuilder()
        let coordinator = subject.settings

        XCTAssert(coordinator is SettingsCoordinator)
    }

    @MainActor
    func test_launch_returnsExpectedResult() {
        let subject = CoordinatorBuilder()
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
        let subject = CoordinatorBuilder()
        let mockNavigationController = MockNavigationController()
        let coordinator = subject.tab(
            navigationController: mockNavigationController
        )

        XCTAssert(coordinator is TabCoordinator)
        XCTAssertEqual(coordinator.root, mockNavigationController)
    }

    @MainActor
    func test_driving_returnsExpectedResult() {
        let subject = CoordinatorBuilder()
        let mockNavigationController = MockNavigationController()
        let coordinator = subject.driving(
            navigationController: mockNavigationController
        )

        XCTAssert(coordinator is DrivingCoordinator)
    }

    @MainActor
    func test_permit_returnsExpectedResult() {
        let subject = CoordinatorBuilder()
        let mockNavigationController = MockNavigationController()
        let coordinator = subject.permit(
            permitId: "123",
            navigationController: mockNavigationController
        )

        XCTAssert(coordinator is PermitCoordinator)
    }

    @MainActor
    func test_next_returnsExpectedResult() {
        let subject = CoordinatorBuilder()
        let mockNavigationController = MockNavigationController()
        let coordinator = subject.next(
            title: "Title",
            navigationController: mockNavigationController
        )

        XCTAssert(coordinator is NextCoordinator)
    }
}
