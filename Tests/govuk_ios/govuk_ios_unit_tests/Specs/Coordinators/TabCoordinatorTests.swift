import Foundation
import XCTest
import Factory

@testable import govuk_ios

class TabCoordinatorTests: XCTestCase {
    @MainActor 
    func test_start_showsTabs() {
        let mockCoordinatorBuilder = MockCoordinatorBuilder(container: Container())

        let mockHomeCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedHomeCoordinator = mockHomeCoordinator

        let mockSettingsCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedSettingsCoordinator = mockSettingsCoordinator

        let navigationController = UINavigationController()
        let subject = TabCoordinator(
            coordinatorBuilder: mockCoordinatorBuilder,
            navigationController: navigationController
        )

        subject.start()

        XCTAssertEqual(navigationController.viewControllers.count, 1)
        let tabController = navigationController.viewControllers.first as? UITabBarController
        XCTAssertEqual(tabController?.viewControllers?.count, 2)
        let expectedCoordinators = [
            mockHomeCoordinator,
            mockSettingsCoordinator
        ]
        expectedCoordinators.forEach {
            XCTAssertTrue($0._startCalled)
        }
    }

    @MainActor
    func test_start_withKnownURL_selectsTabs() {
        let mockCoordinatorBuilder = MockCoordinatorBuilder(container: Container())

        let mockHomeCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedHomeCoordinator = mockHomeCoordinator
        
        let mockSettingsCoordinator = MockBaseCoordinator()
        let mockRoute = MockDeeplinkRoute(pattern: "/test")
        mockSettingsCoordinator._stubbedRoute = .mock(
            parent: mockSettingsCoordinator,
            route: mockRoute
        )
        mockCoordinatorBuilder._stubbedSettingsCoordinator = mockSettingsCoordinator
        
        let navigationController = UINavigationController()
        let subject = TabCoordinator(
            coordinatorBuilder: mockCoordinatorBuilder,
            navigationController: navigationController
        )

        let url = URL(string: "govuk://gov.uk/test")
        subject.start(url: url)
        let tabController = navigationController.viewControllers.first as? UITabBarController
        
        XCTAssertEqual(tabController?.selectedIndex, 1)
        XCTAssert(mockRoute._actionCalled)
    }

    @MainActor
    func test_start_unknownURL_selectsTabs() {
        let mockCoordinatorBuilder = MockCoordinatorBuilder(container: Container())

        let mockHomeCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedHomeCoordinator = mockHomeCoordinator

        let mockSettingsCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedSettingsCoordinator = mockSettingsCoordinator

        let navigationController = UINavigationController()
        let subject = TabCoordinator(
            coordinatorBuilder: mockCoordinatorBuilder,
            navigationController: navigationController
        )

        let url = URL(string: "govuk://gov.uk/unknown")
        subject.start(url: url)
        let tabController = navigationController.viewControllers.first as? UITabBarController

        XCTAssertEqual(tabController?.selectedIndex, 0)
    }
}
