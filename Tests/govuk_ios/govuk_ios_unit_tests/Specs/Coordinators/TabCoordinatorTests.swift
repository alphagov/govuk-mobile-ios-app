import Foundation
import XCTest

@testable import govuk_ios

class TabCoordinatorTests: XCTestCase {
    @MainActor 
    func test_start_showsTabs() {
        let mockCoordinatorBuilder = MockCoordinatorBuilder()

        let mockRedCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedRedCoordinator = mockRedCoordinator

        let mockBlueCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedBlueCoordinator = mockBlueCoordinator

        let mockGreenCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedGreenCoordinator = mockGreenCoordinator

        let navigationController = UINavigationController()
        let subject = TabCoordinator(
            coordinatorBuilder: mockCoordinatorBuilder,
            navigationController: navigationController
        )

        subject.start()

        XCTAssertEqual(navigationController.viewControllers.count, 1)
        let tabController = navigationController.viewControllers.first as? UITabBarController
        XCTAssertEqual(tabController?.viewControllers?.count, 3)
        let expectedCoordinators = [
            mockRedCoordinator,
            mockBlueCoordinator,
            mockGreenCoordinator
        ]
        expectedCoordinators.forEach {
            XCTAssertTrue($0._startCalled)
        }
    }

    @MainActor
    func test_requestFocus_selectsTabs() {
        let mockCoordinatorBuilder = MockCoordinatorBuilder()

        let mockRedCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedRedCoordinator = mockRedCoordinator

        let mockBlueCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedBlueCoordinator = mockBlueCoordinator

        let mockGreenCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedGreenCoordinator = mockGreenCoordinator

        let navigationController = UINavigationController()
        let subject = TabCoordinator(
            coordinatorBuilder: mockCoordinatorBuilder,
            navigationController: navigationController
        )

        subject.start()

        let tabController = navigationController.viewControllers.first as? UITabBarController
        XCTAssertEqual(tabController?.selectedIndex, 0)

        mockCoordinatorBuilder._receivedBlueRequestFocus?(mockBlueCoordinator.root)

        XCTAssertEqual(tabController?.selectedIndex, 1)
    }

}
