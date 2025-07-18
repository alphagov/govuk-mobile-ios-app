import Testing
import UIKit

@testable import GOVKitTestUtilities
@testable import govuk_ios

struct SignOutConfirmationCoordinatorTests {

    @Test
    @MainActor
    func start_setsSignOutConfirmationView() {
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

//    @Test
//    @MainActor
//    func attemptingSignout_callsFinish() async {
//        let mockViewControllerBuilder = MockViewControllerBuilder()
//        let mockNavigationController = MockNavigationController()
//        let mockCoordinator = MockBaseCoordinator()
//        let expectedViewController = UIViewController()
//
//        mockViewControllerBuilder._stubbedSignOutConfirmationViewController = expectedViewController
//
//
//        var sut: SignOutConfirmationCoordinator!
//        _ = await withCheckedContinuation { continuation in
//            sut = SignOutConfirmationCoordinator(
//                navigationController: mockNavigationController,
//                viewControllerBuilder: mockViewControllerBuilder,
//                authenticationService: MockAuthenticationService(),
//                analyticsService: MockAnalyticsService()
//            )
//            mockCoordinator.start(sut)
//            continuation.resume()
//        }
//
//        mockViewControllerBuilder._receivedSignOutConfirmationCompletion?(true)
//        #expect(mockCoordinator._childDidFinishReceivedChild == sut)
//    }
//
//    @Test
//    @MainActor
//    func cancellingSignout_doesNotCallFinish() async {
//        let mockViewControllerBuilder = MockViewControllerBuilder()
//        let mockNavigationController = MockNavigationController()
//        let mockCoordinator = MockBaseCoordinator()
//        let expectedViewController = UIViewController()
//
//        mockViewControllerBuilder._stubbedSignOutConfirmationViewController = expectedViewController
//
//
//        var sut: SignOutConfirmationCoordinator!
//        _ = await withCheckedContinuation { continuation in
//            sut = SignOutConfirmationCoordinator(
//                navigationController: mockNavigationController,
//                viewControllerBuilder: mockViewControllerBuilder,
//                authenticationService: MockAuthenticationService(),
//                analyticsService: MockAnalyticsService()
//            )
//            mockCoordinator.start(sut)
//            continuation.resume()
//        }
//
//        mockViewControllerBuilder._receivedSignOutConfirmationCompletion?(false)
//        #expect(mockCoordinator._childDidFinishReceivedChild == nil)
//    }
}
