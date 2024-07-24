import UIKit
import Foundation
import XCTest

@testable import govuk_ios

class PermitCoordinatorTests: XCTestCase {
    @MainActor
    func test_start_showsViewController() {
        let mockNavigationController = MockNavigationController()
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let mockPermitViewController = UIViewController()
        mockViewControllerBuilder._stubbedPermitViewController = mockPermitViewController
        let subject = PermitCoordinator(
            permitId: "test", 
            navigationController: mockNavigationController,
            viewControllerBuilder: mockViewControllerBuilder
        )

        subject.start()

        XCTAssertEqual(mockNavigationController._pushedViewController, mockPermitViewController)
    }

    @MainActor
    func test_finishAction_callsFinish() {
        let mockNavigationController = MockNavigationController()
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let mockPermitViewController = UIViewController()
        mockViewControllerBuilder._stubbedPermitViewController = mockPermitViewController
        let mockParentCoordinator = MockBaseCoordinator()
        let subject = PermitCoordinator(
            permitId: "test",
            navigationController: mockNavigationController,
            viewControllerBuilder: mockViewControllerBuilder
        )

        mockParentCoordinator.present(subject, animated: false)
        mockNavigationController._stubbedPresentingViewController = mockParentCoordinator.root
        let expectation = expectation()
        mockParentCoordinator._childDidFinishHandler = { coordinator in
            XCTAssertEqual(coordinator, subject)
            expectation.fulfill()
        }

        mockViewControllerBuilder._receivedPermitFinishAction?()

        XCTAssertTrue(mockNavigationController._dismissCalled)
        wait(for: [expectation])
    }

}
