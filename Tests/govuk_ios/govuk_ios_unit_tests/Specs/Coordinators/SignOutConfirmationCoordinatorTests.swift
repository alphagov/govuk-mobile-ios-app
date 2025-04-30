import Testing
import UIKit
@testable import govuk_ios

struct SignOutConfirmationCoordinatorTests {

    @Test
    @MainActor
    func start_setsSignOutConfirmationView() throws {
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let navigationController = UINavigationController()
        let expectedViewController = UIViewController()
        mockViewControllerBuilder._stubbedSignOutConfirmationViewController = expectedViewController

        let sut = SignOutConfirmationCoordinator(
            navigationController: navigationController,
            viewControllerBuilder: mockViewControllerBuilder,
            authenticationService: MockAuthenticationService(),
            analyticsService: MockAnalyticsService()
        )

        sut.start()

        #expect(navigationController.viewControllers.first == expectedViewController)
    }
}
