import Foundation
import XCTest

@testable import govuk_ios

class HomeDeeplinkRouteTests: XCTestCase {

    @MainActor
    func test_pattern_returnsCorrectValue() {
        let subject = HomeDeeplinkRoute(
            coordinatorBuilder: .mock
        )

        XCTAssertEqual(subject.pattern, "/home")
    }

    @MainActor
    func test_action_presentsHomeViewController() {
        let mockCoordinatorBuilder = MockCoordinatorBuilder()
        let subject = HomeDeeplinkRoute(
            coordinatorBuilder: mockCoordinatorBuilder
        )
        let mockNavigationController = MockNavigationController()
        let mockParentCoodinator = MockBaseCoordinator(navigationController: mockNavigationController)
        let mockHomeCoodinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedHomeCoordinator = mockHomeCoodinator

        subject.action(
            parent: mockParentCoodinator,
            params: [:]
        )

        XCTAssertTrue(mockHomeCoodinator._startCalled)
    }
}
