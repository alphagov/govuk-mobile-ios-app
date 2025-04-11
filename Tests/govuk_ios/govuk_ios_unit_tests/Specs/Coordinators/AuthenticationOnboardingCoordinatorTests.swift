import Foundation
import Testing

@testable import govuk_ios

@Suite
class AuthenticationOnboardingCoordinatorTests {
    @Test @MainActor
    func start_hasNotSeenOnboarding_setsOnboarding() {
        let mockAuthenticationOnboardingService = MockAuthenticationOnboardingService()
        let mockNavigationController = MockNavigationController()
        let mockCoordinatorBuilder = CoordinatorBuilder.mock

        let sut = AuthenticationOnboardingCoordinator(
            navigationController: mockNavigationController,
            analyticsService: MockAnalyticsService(),
            authenticationOnboardingService: mockAuthenticationOnboardingService,
            coordinatorBuilder: mockCoordinatorBuilder,
            completionAction: { }
        )
        sut.start(url: nil)

        #expect(mockAuthenticationOnboardingService._receivedFetchSlidesCompletion != nil)
        #expect(mockNavigationController._setViewControllers?.count == .some(1))
    }

    @Test @MainActor
    func start_hasSeenOnboarding_finishesCoordination() async {
        let mockAuthenticationOnboardingService = MockAuthenticationOnboardingService()
        let mockNavigationController = MockNavigationController()
        let mockCoordinatorBuilder = CoordinatorBuilder.mock
        mockAuthenticationOnboardingService._stubbedHasSeenOnboarding = true

        let completion = await withCheckedContinuation { continuation in
            let sut = AuthenticationOnboardingCoordinator(
                navigationController: mockNavigationController,
                analyticsService: MockAnalyticsService(),
                authenticationOnboardingService: mockAuthenticationOnboardingService,
                coordinatorBuilder: mockCoordinatorBuilder,
                completionAction: { continuation.resume(returning: true) }
            )
            sut.start(url: nil)
        }

        #expect(completion)
        #expect(mockNavigationController._setViewControllers?.count == .none)
    }

    @Test @MainActor
    func start_featureDisablaed_finishesCoordination() async {
        let mockAuthenticationOnboardingService = MockAuthenticationOnboardingService()
        let mockNavigationController = MockNavigationController()
        let mockCoordinatorBuilder = CoordinatorBuilder.mock
        mockAuthenticationOnboardingService._stubbedHasSeenOnboarding = false
        mockAuthenticationOnboardingService._stubbedFeatureEnabled = false

        let completion = await withCheckedContinuation { continuation in
            let sut = AuthenticationOnboardingCoordinator(
                navigationController: mockNavigationController,
                analyticsService: MockAnalyticsService(),
                authenticationOnboardingService: mockAuthenticationOnboardingService,
                coordinatorBuilder: mockCoordinatorBuilder,
                completionAction: { continuation.resume(returning: true) }
            )
            sut.start(url: nil)
        }

        #expect(completion)
        #expect(mockNavigationController._setViewControllers?.count == .none)
    }
}
