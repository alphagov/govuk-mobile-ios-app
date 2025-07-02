import Testing
import UIKit

@testable import GOVKitTestUtilities
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

    @Test
    func completionCalled_withAuthStatus() throws {
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let mockAuthenticationService = MockAuthenticationService()
        mockAuthenticationService._stubbedIsSignedIn = true
        let navigationController = UINavigationController()
        let expectedViewController = UIViewController()
        mockViewControllerBuilder._stubbedSignedOutViewController = expectedViewController

        var isAuthenticated = false
        let sut = SignedOutCoordinator(
            navigationController: navigationController,
            viewControllerBuilder: mockViewControllerBuilder,
            authenticationService: mockAuthenticationService,
            analyticsService: MockAnalyticsService(),
            completion: { signedIn in
                isAuthenticated = signedIn
            }
        )

        sut.start()
        mockViewControllerBuilder
            ._receivedSignedOutCompletion?()
        #expect(isAuthenticated)
    }
}
