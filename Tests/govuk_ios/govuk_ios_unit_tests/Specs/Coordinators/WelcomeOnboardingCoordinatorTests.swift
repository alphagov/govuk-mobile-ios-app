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
            coordinatorBuilder: mockCoordinatorBuilder,
            viewControllerBuilder: MockViewControllerBuilder(),
            analyticsService: MockAnalyticsService(),
            deviceInformationProvider: MockDeviceInformationProvider(),
            versionProvider: MockAppVersionProvider(),
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
                coordinatorBuilder: mockCoordinatorBuilder,
                viewControllerBuilder: MockViewControllerBuilder(),
                analyticsService: MockAnalyticsService(),
                deviceInformationProvider: MockDeviceInformationProvider(),
                versionProvider: MockAppVersionProvider(),
                completionAction: { continuation.resume(returning: true) }
            )
            sut.start(url: nil)
        }

        #expect(completion)
        #expect(mockNavigationController._setViewControllers?.count == .none)
    }

    @Test
    func authenticationError_startsSignInErrorCoordinator() {
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
            coordinatorBuilder: mockCoordinatorBuilder,
            viewControllerBuilder: mockViewControllerBuilder,
            analyticsService: MockAnalyticsService(),
            deviceInformationProvider: MockDeviceInformationProvider(),
            versionProvider: MockAppVersionProvider(),
            completionAction: { }
        )

        sut.start(url: nil)

        mockViewControllerBuilder._stubbedWelcomeOnboardingViewModel?.completeAction()
        mockCoordinatorBuilder._receivedAuthenticationErrorAction?(.loginFlow(.init(reason: .authorizationAccessDenied)))

        #expect(mockNavigationController._pushedViewController == stubbedSignInErrorViewController)
    }

    @Test
    func authenticationError_tracksError() {
        let mockAuthenticationService = MockAuthenticationService()
        let mockNavigationController = MockNavigationController()
        let mockCoordinatorBuilder = CoordinatorBuilder.mock
        let mockViewControllerBuilder = MockViewControllerBuilder()

        let stubbedWelcomeOnboardingViewController = UIViewController()
        mockViewControllerBuilder._stubbedWelcomeOnboardingViewController = stubbedWelcomeOnboardingViewController

        let stubbedSignInErrorViewController = UIViewController()
        mockViewControllerBuilder._stubbedSignInErrorViewController = stubbedSignInErrorViewController

        let mockAnalyticsService = MockAnalyticsService()
        let sut = WelcomeOnboardingCoordinator(
            navigationController: mockNavigationController,
            authenticationService: mockAuthenticationService,
            coordinatorBuilder: mockCoordinatorBuilder,
            viewControllerBuilder: mockViewControllerBuilder,
            analyticsService: mockAnalyticsService,
            deviceInformationProvider: MockDeviceInformationProvider(),
            versionProvider: MockAppVersionProvider(),
            completionAction: { }
        )

        sut.start(url: nil)

        let expectedError = AuthenticationError.loginFlow(.init(reason: .authorizationAccessDenied))
        mockViewControllerBuilder._stubbedWelcomeOnboardingViewModel?.completeAction()
        mockCoordinatorBuilder._receivedAuthenticationErrorAction?(expectedError)

        #expect((mockAnalyticsService._trackErrorReceivedErrors.first as? AuthenticationError) == expectedError)
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
            coordinatorBuilder: mockCoordinatorBuilder,
            viewControllerBuilder: mockViewControllerBuilder,
            analyticsService: MockAnalyticsService(),
            deviceInformationProvider: MockDeviceInformationProvider(),
            versionProvider: MockAppVersionProvider(),
            completionAction: { }
        )

        sut.start(url: nil)

        mockCoordinatorBuilder._receivedAuthenticationErrorAction?(.loginFlow(.init(reason: .userCancelled)))

        #expect(mockNavigationController._setViewControllers?.first == stubbedWelcomeOnboardingViewController)
    }

    @Test
    func signInErrorCompletion_setsWelcomOnboarding() {
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
            coordinatorBuilder: mockCoordinatorBuilder,
            viewControllerBuilder: mockViewControllerBuilder,
            analyticsService: MockAnalyticsService(),
            deviceInformationProvider: MockDeviceInformationProvider(),
            versionProvider: MockAppVersionProvider(),
            completionAction: { }
        )

        sut.start(url: nil)

        mockCoordinatorBuilder._receivedAuthenticationErrorAction?(.loginFlow(.init(reason: .authorizationAccessDenied)))
        mockViewControllerBuilder._receivedSignInErrorRetryAction?()

        #expect(mockNavigationController._setViewControllers?.first == stubbedWelcomeOnboardingViewController)
    }

    @Test
    func signInErrorCompletion_feedbackAction_setsWelcomOnboarding() {
        let mockAuthenticationService = MockAuthenticationService()
        let mockNavigationController = MockNavigationController()
        let mockCoordinatorBuilder = CoordinatorBuilder.mock
        let mockViewControllerBuilder = MockViewControllerBuilder()

        let mockSafariCoordinator = MockBaseCoordinator()
        mockCoordinatorBuilder._stubbedSafariCoordinator = mockSafariCoordinator

        let stubbedWelcomeOnboardingViewController = UIViewController()
        mockViewControllerBuilder._stubbedWelcomeOnboardingViewController = stubbedWelcomeOnboardingViewController

        let stubbedSignInErrorViewController = UIViewController()
        mockViewControllerBuilder._stubbedSignInErrorViewController = stubbedSignInErrorViewController

        let sut = WelcomeOnboardingCoordinator(
            navigationController: mockNavigationController,
            authenticationService: mockAuthenticationService,
            coordinatorBuilder: mockCoordinatorBuilder,
            viewControllerBuilder: mockViewControllerBuilder,
            analyticsService: MockAnalyticsService(),
            deviceInformationProvider: MockDeviceInformationProvider(),
            versionProvider: MockAppVersionProvider(),
            completionAction: { }
        )

        sut.start(url: nil)

        let expectedError = AuthenticationError.unknown(TestError.anyError)
        mockViewControllerBuilder._stubbedWelcomeOnboardingViewModel?.completeAction()
        mockCoordinatorBuilder._receivedAuthenticationErrorAction?(expectedError)
        mockViewControllerBuilder._receivedSignInErrorFeedbackAction?(expectedError)

        #expect(mockNavigationController._setViewControllers?.first == stubbedWelcomeOnboardingViewController)
        #expect(mockSafariCoordinator._startCalled)
    }
}
