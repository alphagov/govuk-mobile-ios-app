import Testing
import UIKit
@testable import govuk_ios

@Suite
@MainActor
struct SignedOutCoordinatorTests {

    @Test
    func start_setsSignedOutView() throws {
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let navigationController = UINavigationController()
        let expectedViewController = UIViewController()
        mockViewControllerBuilder._stubbedSignedOutViewController = expectedViewController

        let sut = SignedOutCoordinator(
            navigationController: navigationController,
            viewControllerBuilder: mockViewControllerBuilder,
            authenticationService: MockAuthenticationService(),
            analyticsService: MockAnalyticsService(),
            completion: { _ in }
        )

        sut.start()

        #expect(navigationController.viewControllers.first == expectedViewController)
    }
}
