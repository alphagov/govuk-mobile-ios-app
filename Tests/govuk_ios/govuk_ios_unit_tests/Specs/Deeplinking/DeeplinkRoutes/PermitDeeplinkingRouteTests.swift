import Foundation
import XCTest

@testable import govuk_ios

class PermitDeeplinkRouteTests: XCTestCase {

    @MainActor
    func test_pattern_returnsCorrectValue() {
        let subject = PermitDeeplinkRoute(
            coordinatorBuilder: .mock
        )

        XCTAssertEqual(subject.pattern, "/driving/permit/:permit_id")
    }

    @MainActor
    func test_action_presentsPermitViewController() {
        let mockCoordinatorBuilder = MockCoordinatorBuilder()
        let subject = PermitDeeplinkRoute(
            coordinatorBuilder: mockCoordinatorBuilder
        )
        let mockNavigationController = MockNavigationController()
        let mockParentCoodinator = MockBaseCoordinator(navigationController: mockNavigationController)
        let mockPermitCoodinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedPermitCoordinator = mockPermitCoodinator

        subject.action(
            parent: mockParentCoodinator,
            params: [
                "permit_id": "test_id"
            ]
        )

        XCTAssertNotNil(mockNavigationController._presentedViewController)
        XCTAssertTrue(mockPermitCoodinator._startCalled)
    }

    @MainActor
    func test_action_passesCorrectParams() {
        let mockCoordinatorBuilder = MockCoordinatorBuilder()
        let subject = PermitDeeplinkRoute(
            coordinatorBuilder: mockCoordinatorBuilder
        )

        subject.action(
            parent: MockBaseCoordinator(),
            params: [
                "permit_id": "test_id"
            ]
        )

        XCTAssertEqual(mockCoordinatorBuilder._receivedPermitPermitId, "test_id")
    }

    @MainActor
    func test_action_noParams_doesNothing() {
        let mockCoordinatorBuilder = MockCoordinatorBuilder()
        let mockPermitCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedPermitCoordinator = mockPermitCoordinator
        let subject = PermitDeeplinkRoute(
            coordinatorBuilder: mockCoordinatorBuilder
        )

        subject.action(
            parent: MockBaseCoordinator(),
            params: [
                "permit": "test_id"
            ]
        )

        XCTAssertFalse(mockPermitCoordinator._startCalled)
    }

}
