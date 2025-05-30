import Foundation
import Testing

@testable import govuk_ios

@Suite
class AuthenticationOnboardingCoordinatorTests {
    @Test @MainActor
    func start_notSignedIn_setsOnboarding() {
        let mockAuthenticationService = MockAuthenticationService()
        let mockAuthenticationOnboardingService = MockAuthenticationOnboardingService()
        let mockNavigationController = MockNavigationController()
        let mockCoordinatorBuilder = CoordinatorBuilder.mock
        mockAuthenticationOnboardingService.isFeatureEnabled = true
        mockAuthenticationService._stubbedIsSignedIn = false
        let sut = AuthenticationOnboardingCoordinator(
            navigationController: mockNavigationController,
            authenticationService: mockAuthenticationService,
            authenticationOnboardingService: mockAuthenticationOnboardingService,
            onboardingAnalyticsService: MockAnalyticsService(),
            analyticsService: MockAnalyticsService(),
            coordinatorBuilder: mockCoordinatorBuilder,
            viewControllerBuilder: MockViewControllerBuilder(),
            completionAction: { }
        )
        sut.start(url: nil)

        #expect(mockAuthenticationOnboardingService._receivedFetchSlidesCompletion != nil)
        #expect(mockNavigationController._setViewControllers?.count == .some(1))
    }

    @Test @MainActor
    func start_signedIn_finishesCoordination() async {
        let mockAuthenticationService = MockAuthenticationService()
        let mockAuthenticationOnboardingService = MockAuthenticationOnboardingService()
        let mockNavigationController = MockNavigationController()
        let mockCoordinatorBuilder = CoordinatorBuilder.mock
        mockAuthenticationOnboardingService.isFeatureEnabled = true
        mockAuthenticationService._stubbedIsSignedIn = true
        let completion = await withCheckedContinuation { continuation in
            let sut = AuthenticationOnboardingCoordinator(
                navigationController: mockNavigationController,
                authenticationService: mockAuthenticationService,
                authenticationOnboardingService: mockAuthenticationOnboardingService,
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

    @Test @MainActor
    func start_featureDisabled_finishesCoordination() async {
        let mockAuthenticationService = MockAuthenticationService()
        let mockAuthenticationOnboardingService = MockAuthenticationOnboardingService()
        let mockNavigationController = MockNavigationController()
        let mockCoordinatorBuilder = CoordinatorBuilder.mock
        mockAuthenticationOnboardingService.isFeatureEnabled = false
        mockAuthenticationService._stubbedIsSignedIn = false
        let completion = await withCheckedContinuation { continuation in
            let sut = AuthenticationOnboardingCoordinator(
                navigationController: mockNavigationController,
                authenticationService: mockAuthenticationService,
                authenticationOnboardingService: mockAuthenticationOnboardingService,
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

//    @Test @MainActor
//    func authenticationError_starts_SignInErrorCoordinator() async throws {
//        let mockAuthenticationService = MockAuthenticationService()
//        let mockAuthenticationOnboardingService = MockAuthenticationOnboardingService()
//        let mockNavigationController = MockNavigationController()
//        let mockCoordinatorBuilder = CoordinatorBuilder.mock
//        mockAuthenticationOnboardingService.isFeatureEnabled = true
//
//        let sut = AuthenticationOnboardingCoordinator(
//            navigationController: mockNavigationController,
//            authenticationService: mockAuthenticationService,
//            authenticationOnboardingService: mockAuthenticationOnboardingService,
//            onboardingAnalyticsService: MockAnalyticsService(),
//            analyticsService: MockAnalyticsService(),
//            coordinatorBuilder: mockCoordinatorBuilder,
//            viewControllerBuilder: MockViewControllerBuilder(),
//            completionAction: { }
//        )
//
//        sut.showError(.genericError)
//        #expect(sut.childCoordinators.count == 1)
//    }

//    @Test @MainActor
//    func userCancelledError_does_not_start_SignInErrorCoordinator() async throws {
//        let mockAuthenticationService = MockAuthenticationService()
//        let mockAuthenticationOnboardingService = MockAuthenticationOnboardingService()
//        let mockNavigationController = MockNavigationController()
//        let mockCoordinatorBuilder = CoordinatorBuilder.mock
//        mockAuthenticationOnboardingService.isFeatureEnabled = true
//
//        let sut = AuthenticationOnboardingCoordinator(
//            navigationController: mockNavigationController,
//            authenticationService: mockAuthenticationService,
//            authenticationOnboardingService: mockAuthenticationOnboardingService,
//            onboardingAnalyticsService: MockAnalyticsService(),
//            analyticsService: MockAnalyticsService(),
//            coordinatorBuilder: mockCoordinatorBuilder,
//            viewControllerBuilder: MockViewControllerBuilder(),
//            completionAction: { }
//        )
//
//        sut.showError(.loginFlow(.userCancelled))
//        #expect(sut.childCoordinators.count == 0)
//    }

//    @Test @MainActor
//    func completingSignInError_setsOnboarding() async throws {
//        let mockAuthenticationService = MockAuthenticationService()
//        let mockAuthenticationOnboardingService = MockAuthenticationOnboardingService()
//        let mockNavigationController = MockNavigationController()
//        let mockCoordinatorBuilder = CoordinatorBuilder.mock
//        mockAuthenticationOnboardingService.isFeatureEnabled = true
//
//        let sut = AuthenticationOnboardingCoordinator(
//            navigationController: mockNavigationController,
//            authenticationService: mockAuthenticationService,
//            authenticationOnboardingService: mockAuthenticationOnboardingService,
//            onboardingAnalyticsService: MockAnalyticsService(),
//            analyticsService: MockAnalyticsService(),
//            coordinatorBuilder: mockCoordinatorBuilder,
//            viewControllerBuilder: MockViewControllerBuilder(),
//            completionAction: { }
//        )
//
//        sut.showError(.genericError)
//        #expect(sut.childCoordinators.count == 1)
//        mockCoordinatorBuilder._receivedSignInErrorCompletion?()
//        #expect(mockAuthenticationOnboardingService._receivedFetchSlidesCompletion != nil)
//        #expect(mockNavigationController._setViewControllers?.count == .some(1))
//    }
}
