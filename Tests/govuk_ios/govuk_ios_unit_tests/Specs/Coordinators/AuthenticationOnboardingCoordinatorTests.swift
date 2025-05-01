import Foundation
import Testing

@testable import govuk_ios

@Suite
class AuthenticationOnboardingCoordinatorTests {
    @Test @MainActor
    func start_shouldntSkipOnboarding_setsOnboarding() {
        let mockAuthenticationService = MockAuthenticationService()
        let mockAuthenticationOnboardingService = MockAuthenticationOnboardingService()
        let mockNavigationController = MockNavigationController()
        let mockCoordinatorBuilder = CoordinatorBuilder.mock
        mockAuthenticationOnboardingService.isFeatureEnabled = true
        let sut = AuthenticationOnboardingCoordinator(
            navigationController: mockNavigationController,
            authenticationService: mockAuthenticationService,
            authenticationOnboardingService: mockAuthenticationOnboardingService,
            analyticsService: MockAnalyticsService(),
            coordinatorBuilder: mockCoordinatorBuilder,
            completionAction: { }
        )
        sut.start(url: nil)

        #expect(mockAuthenticationOnboardingService._receivedFetchSlidesCompletion != nil)
        #expect(mockNavigationController._setViewControllers?.count == .some(1))
    }

    @Test @MainActor
    func start_shouldSkipOnboarding_finishesCoordination() async {
        let mockAuthenticationService = MockAuthenticationService()
        let mockAuthenticationOnboardingService = MockAuthenticationOnboardingService()
        let mockNavigationController = MockNavigationController()
        let mockCoordinatorBuilder = CoordinatorBuilder.mock
        mockAuthenticationOnboardingService.isFeatureEnabled = true
        mockAuthenticationService.refreshToken = UUID().uuidString
        let completion = await withCheckedContinuation { continuation in
            let sut = AuthenticationOnboardingCoordinator(
                navigationController: mockNavigationController,
                authenticationService: mockAuthenticationService,
                authenticationOnboardingService: mockAuthenticationOnboardingService,
                analyticsService: MockAnalyticsService(),
                coordinatorBuilder: mockCoordinatorBuilder,
                completionAction: { continuation.resume(returning: true) }
            )
            sut.start(url: nil)
        }

        #expect(completion)
        #expect(mockNavigationController._setViewControllers?.count == .none)
    }
}
