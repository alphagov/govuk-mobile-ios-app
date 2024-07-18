import Foundation
import XCTest

@testable import govuk_ios

class BlueCoordinatorTests: XCTestCase {
    @MainActor
    func test_start_showsViewController() {
        let navigationController = UINavigationController()
        let subject = BlueCoordinator(
            navigationController: navigationController,
            coordinatorBuilder: .mock,
            viewControllerBuilder: .mock,
            deeplinkStore: .init(routes: [])
        )

        subject.start()

        XCTAssertEqual(navigationController.viewControllers.count, 1)
    }

    @MainActor
    func test_startDriving_startsDrivingCoordinator() {
        let navigationController = UINavigationController()
        let mockCoordinatorBuilder = CoordinatorBuilder.mock
        let mockDrivingCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedDrivingCoordinator = mockDrivingCoordinator
        let mockViewControllerBuilder = ViewControllerBuilder.mock
        let subject = BlueCoordinator(
            navigationController: navigationController,
            coordinatorBuilder: mockCoordinatorBuilder,
            viewControllerBuilder: mockViewControllerBuilder,
            deeplinkStore: .init(routes: [])
        )

        subject.start()

        mockViewControllerBuilder._receivedBlueShowNextAction?()

        XCTAssertTrue(mockDrivingCoordinator._startCalled)
    }

    @MainActor
    func test_route_callsDeeplinkStore() {
        let navigationController = UINavigationController()
        let mockRoute = MockDeeplinkRoute(pattern: "/test")
        let mockDeeplinkDataStore = DeeplinkDataStore(routes: [
            mockRoute
        ])

        let subject = BlueCoordinator(
            navigationController: navigationController,
            coordinatorBuilder: .mock,
            viewControllerBuilder: .mock,
            deeplinkStore: mockDeeplinkDataStore
        )

        let url = URL(string: "govuk://gov.uk/test")!
        let result = subject.route(for: url)

        XCTAssertEqual(result?.url, url)
        XCTAssertEqual(result?.route.pattern, mockRoute.pattern)
    }

    @MainActor
    func test_start_withMatchingURL_dismissesModals() {
        let navigationController = MockNavigationController()
        let mockRoute = MockDeeplinkRoute(pattern: "/test")
        let mockDeeplinkDataStore = DeeplinkDataStore(routes: [
            mockRoute
        ])

        let subject = BlueCoordinator(
            navigationController: navigationController,
            coordinatorBuilder: .mock,
            viewControllerBuilder: .mock,
            deeplinkStore: mockDeeplinkDataStore
        )

        let url = URL(string: "govuk://gov.uk/test")
        subject.start(url: url)

        let actionExpectation = expectation(description: "action expectation")
        actionExpectation.fulfillAfter(0.2)
        waitForExpectations(
            timeout: 0.5,
            handler: { _ in
                Task { @MainActor in
                    XCTAssertTrue(navigationController._dismissCalled)
                }
            }
        )
    }
}
