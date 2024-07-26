import Foundation
import XCTest

@testable import govuk_ios

class DrivingDeeplinkRouteTests: XCTestCase {

    @MainActor
    func test_pattern_returnsCorrectValue() {
        let subject = DrivingDeeplinkRoute(
            coordinatorBuilder: .mock
        )

        XCTAssertEqual(subject.pattern, "/driving")
    }

    @MainActor
    func test_action_presentsPermitViewController() {
        let mockCoordinatorBuilder = MockCoordinatorBuilder.mock
        let subject = DrivingDeeplinkRoute(
            coordinatorBuilder: mockCoordinatorBuilder
        )
        let mockNavigationController = MockNavigationController()
        let mockParentCoodinator = MockBaseCoordinator(navigationController: mockNavigationController)
        let mockDrivingCoodinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedDrivingCoordinator = mockDrivingCoodinator

        subject.action(
            parent: mockParentCoodinator,
            params: [:]
        )

        XCTAssertTrue(mockDrivingCoodinator._startCalled)
    }

}
