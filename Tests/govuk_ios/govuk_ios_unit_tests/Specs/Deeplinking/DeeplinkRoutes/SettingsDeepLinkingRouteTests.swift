import Foundation
import XCTest

@testable import govuk_ios

class SettingsDeeplinkRouteTests: XCTestCase {

    @MainActor
    func test_pattern_returnsCorrectValue() {
        let subject = SettingsDeeplinkRoute(
            coordinatorBuilder: .mock
        )

        XCTAssertEqual(subject.pattern, "/settings")
    }

    @MainActor
    func test_action_presentsSettingsViewController() {
        let mockCoordinatorBuilder = MockCoordinatorBuilder()
        let subject = SettingsDeeplinkRoute(
            coordinatorBuilder: mockCoordinatorBuilder
        )
        let mockNavigationController = MockNavigationController()
        let mockParentCoodinator = MockBaseCoordinator(navigationController: mockNavigationController)
        let mockSettingsCoodinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedSettingsCoordinator = mockSettingsCoodinator

        subject.action(
            parent: mockParentCoodinator,
            params: [:]
        )

        XCTAssertTrue(mockSettingsCoodinator._startCalled)
    }
}
