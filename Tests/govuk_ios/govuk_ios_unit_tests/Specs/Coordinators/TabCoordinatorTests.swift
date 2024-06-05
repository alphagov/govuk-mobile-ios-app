import Foundation
import XCTest

@testable import govuk_ios

class TabCoordinatorTests: XCTestCase {

    override class func setUp() {
        super.setUp()
        UIView.setAnimationsEnabled(false)
    }

    @MainActor 
    func test_start_showsTabs() {
        let mockCoordinatorBuilder = MockCoordinatorBuilder(
            container: .init()
        )

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
        XCTAssertEqual(subject.childCoordinators.count, 3)
        let expectedCoordinators = [
            mockRedCoordinator,
            mockBlueCoordinator,
            mockGreenCoordinator
        ]
        expectedCoordinators.forEach {
            XCTAssertTrue($0._startCalled)
            XCTAssert($0.parentCoordinator === subject)
        }
    }

}
