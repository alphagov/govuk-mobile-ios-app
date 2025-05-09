import Testing
import UIKit
@testable import govuk_ios

struct SignInErrorCoordinatorTests {

    @Test
    @MainActor
    func start_setsSigninErrorView() {
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let navigationController = UINavigationController()
        let expectedViewController = UIViewController()
        mockViewControllerBuilder._stubbedSignInErrorViewController = expectedViewController

        let sut = SignInErrorCoordinator(
            navigationController: navigationController,
            viewControllerBuilder: mockViewControllerBuilder,
            analyticsService: MockAnalyticsService(),
            completion: { })

        sut.start()

        #expect(navigationController.viewControllers.first == expectedViewController)
    }

    @Test
    @MainActor
    func finish_callsCompletion() {
        let mockBaseCoordinator = MockBaseCoordinator()
        let mockViewControllerBuilder = MockViewControllerBuilder()
        let navigationController = UINavigationController()
        let expectedViewController = UIViewController()
        mockViewControllerBuilder._stubbedSignInErrorViewController = expectedViewController

        var didFinish = false
        let sut = SignInErrorCoordinator(
            navigationController: navigationController,
            viewControllerBuilder: mockViewControllerBuilder,
            analyticsService: MockAnalyticsService(),
            completion: {
                didFinish = true
            }
        )

        mockBaseCoordinator.start(sut)
        mockViewControllerBuilder._receivedSignInErrorCompletion?()
        #expect(didFinish)
        #expect(mockBaseCoordinator._childDidFinishReceivedChild == sut)
    }

}
