import Foundation
import Testing
import UIKit

@testable import govuk_ios

@Suite
@MainActor
class WelcomeOnboardingCoordinatorTests {
    @Test
    func start_notSignedIn_setsOnboarding() {
        let mockAuthenticationService = MockAuthenticationService()
        let mockNavigationController = MockNavigationController()
        let mockCoordinatorBuilder = CoordinatorBuilder.mock
        mockAuthenticationService._stubbedIsSignedIn = false
        let sut = WelcomeOnboardingCoordinator(
            navigationController: mockNavigationController,
            authenticationService: mockAuthenticationService,
            onboardingAnalyticsService: MockAnalyticsService(),
            analyticsService: MockAnalyticsService(),
            coordinatorBuilder: mockCoordinatorBuilder,
            viewControllerBuilder: MockViewControllerBuilder(),
            completionAction: { }
        )
        sut.start(url: nil)

        #expect(mockNavigationController._setViewControllers?.count == .some(1))
    }

    @Test
    func start_signedIn_finishesCoordination() async {
        let mockAuthenticationService = MockAuthenticationService()
        let mockNavigationController = MockNavigationController()
        let mockCoordinatorBuilder = CoordinatorBuilder.mock
        mockAuthenticationService._stubbedIsSignedIn = true
        let completion = await withCheckedContinuation { continuation in
            let sut = WelcomeOnboardingCoordinator(
                navigationController: mockNavigationController,
                authenticationService: mockAuthenticationService,
                onboardingAnalyticsService: MockAnalyticsService(),
                analyticsService: MockAnalyticsService(),
                coordinatorBuilder: mockCoordinatorBuilder,
                viewControllerBuilder: MockViewControllerBuilder(),
                completionAction: { continuation.resume(returning: true) }
            )
            sut.start(url: nil)
        }

        #expect(completion)
        #expect(mockNavigationController._setViewControllers?.count == .none)
    }

    @Test
    func authenticationError_starts_SignInErrorCoordinator() {
        let mockAuthenticationService = MockAuthenticationService()
        let mockNavigationController = MockNavigationController()
        let mockCoordinatorBuilder = CoordinatorBuilder.mock
        let mockViewControllerBuilder = MockViewControllerBuilder()

        let stubbedWelcomeOnboardingViewController = UIViewController()
        mockViewControllerBuilder._stubbedWelcomeOnboardingViewController = stubbedWelcomeOnboardingViewController

        let stubbedSignInErrorViewController = UIViewController()
        mockViewControllerBuilder._stubbedSignInErrorViewController = stubbedSignInErrorViewController

        let sut = WelcomeOnboardingCoordinator(
            navigationController: mockNavigationController,
            authenticationService: mockAuthenticationService,
            onboardingAnalyticsService: MockAnalyticsService(),
            analyticsService: MockAnalyticsService(),
            coordinatorBuilder: mockCoordinatorBuilder,
            viewControllerBuilder: mockViewControllerBuilder,
            completionAction: { }
        )

        sut.start(url: nil)

        mockViewControllerBuilder._receivedWelcomeOnboardingCompletion?()
        mockCoordinatorBuilder._receivedAuthenticationHandleError?(.loginFlow(.accessDenied))

        #expect(mockNavigationController._setViewControllers?.first == stubbedSignInErrorViewController)
    }

    @Test
    func userCancelledError_does_not_start_SignInErrorCoordinator() {
        let mockAuthenticationService = MockAuthenticationService()
        let mockNavigationController = MockNavigationController()
        let mockCoordinatorBuilder = CoordinatorBuilder.mock
        let mockViewControllerBuilder = MockViewControllerBuilder()

        let stubbedWelcomeOnboardingViewController = UIViewController()
        mockViewControllerBuilder._stubbedWelcomeOnboardingViewController = stubbedWelcomeOnboardingViewController

        let stubbedSignInErrorViewController = UIViewController()
        mockViewControllerBuilder._stubbedSignInErrorViewController = stubbedSignInErrorViewController

        let sut = WelcomeOnboardingCoordinator(
            navigationController: mockNavigationController,
            authenticationService: mockAuthenticationService,
            onboardingAnalyticsService: MockAnalyticsService(),
            analyticsService: MockAnalyticsService(),
            coordinatorBuilder: mockCoordinatorBuilder,
            viewControllerBuilder: mockViewControllerBuilder,
            completionAction: { }
        )

        sut.start(url: nil)

        mockViewControllerBuilder._receivedWelcomeOnboardingCompletion?()
        mockCoordinatorBuilder._receivedAuthenticationHandleError?(.loginFlow(.userCancelled))

        #expect(mockNavigationController._setViewControllers?.first == stubbedWelcomeOnboardingViewController)
    }

    @Test
    func signinErrorCompletion_setsWelcomOnboarding() {
        let mockAuthenticationService = MockAuthenticationService()
        let mockNavigationController = MockNavigationController()
        let mockCoordinatorBuilder = CoordinatorBuilder.mock
        let mockViewControllerBuilder = MockViewControllerBuilder()

        let stubbedWelcomeOnboardingViewController = UIViewController()
        mockViewControllerBuilder._stubbedWelcomeOnboardingViewController = stubbedWelcomeOnboardingViewController

        let stubbedSignInErrorViewController = UIViewController()
        mockViewControllerBuilder._stubbedSignInErrorViewController = stubbedSignInErrorViewController

        let sut = WelcomeOnboardingCoordinator(
            navigationController: mockNavigationController,
            authenticationService: mockAuthenticationService,
            onboardingAnalyticsService: MockAnalyticsService(),
            analyticsService: MockAnalyticsService(),
            coordinatorBuilder: mockCoordinatorBuilder,
            viewControllerBuilder: mockViewControllerBuilder,
            completionAction: { }
        )

        sut.start(url: nil)

        mockViewControllerBuilder._receivedWelcomeOnboardingCompletion?()
        mockCoordinatorBuilder._receivedAuthenticationHandleError?(.loginFlow(.accessDenied))
        mockViewControllerBuilder._receivedSignInErrorCompletion?()

        #expect(mockNavigationController._setViewControllers?.first == stubbedWelcomeOnboardingViewController)
    }
}
