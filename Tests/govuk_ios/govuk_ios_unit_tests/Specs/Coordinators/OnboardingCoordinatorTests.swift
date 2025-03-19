import UIKit
import Foundation
import Testing

import Onboarding

@testable import govuk_ios

@Suite
@MainActor
struct OnboardingCoordinatorTests {
    @Test
    func start_hasSeenOnboarding_callsDismiss() async {
        let onboardingService = MockOnboardingService()
        onboardingService._stubbedHasSeenOnboarding = true
        let mockNavigationController = UINavigationController()

        let dismissed = await withCheckedContinuation { continuation in
            let sut = OnboardingCoordinator(
                navigationController: mockNavigationController,
                onboardingService: onboardingService,
                analyticsService: MockAnalyticsService(),
                appConfigService: MockAppConfigService(),
                dismissAction: {
                    continuation.resume(returning: true)
                }
            )
            sut.start()
        }
        #expect(dismissed)
    }

    @Test
    func start_hasNotSeenOnboarding_callsFetchSlides() {
        let mockOnboardingService = MockOnboardingService()
        mockOnboardingService._stubbedHasSeenOnboarding = false
        let mockNavigationController = MockNavigationController()
        let sut = OnboardingCoordinator(
            navigationController: mockNavigationController,
            onboardingService: mockOnboardingService,
            analyticsService: MockAnalyticsService(),
            appConfigService: MockAppConfigService(),
            dismissAction: { }
        )
        mockOnboardingService._stubbedFetchSlidesSlides = [OnboardingSlide.arrange]
        sut.start()

        #expect(mockNavigationController._setViewControllers?.count == 1)
    }

    @Test
    func start_hasSeenOnboarding_noSlides_callsDismiss() async {
        let mockOnboardingService = MockOnboardingService()
        mockOnboardingService._stubbedHasSeenOnboarding = true
        let mockNavigationController = UINavigationController()
        let dismissed = await withCheckedContinuation { continuation in
            let sut = OnboardingCoordinator(
                navigationController: mockNavigationController,
                onboardingService: mockOnboardingService,
                analyticsService: MockAnalyticsService(),
                appConfigService: MockAppConfigService(),
                dismissAction: {
                    #expect(mockNavigationController.viewControllers.count == 0)
                    continuation.resume(returning: true)
                }
            )
            mockOnboardingService._stubbedFetchSlidesSlides = []
            sut.start()
        }
        #expect(dismissed)
    }

    @Test
    func start_hasNotSeenOnboarding_doesNotCallDismiss() async throws {
        let mockOnboardingService = MockOnboardingService()
        mockOnboardingService._stubbedHasSeenOnboarding = false
        let mockNavigationController = UINavigationController()
        let complete: Bool = try await withCheckedThrowingContinuation { continuation in
            let sut = OnboardingCoordinator(
                navigationController: mockNavigationController,
                onboardingService: mockOnboardingService,
                analyticsService: MockAnalyticsService(),
                appConfigService: MockAppConfigService(),
                dismissAction: {
                    continuation.resume(with: .failure(TestError.unexpectedMethodCalled))
                }
            )
            mockOnboardingService._stubbedFetchSlidesSlides = OnboardingSlide.arrange(2)
            sut.start()
            continuation.resume(returning: true)
        }
        #expect(complete)
    }

    @Test
    func start_isFeatureEnabled_doesNotCallDismiss() async throws {
        let mockOnboardingService = MockOnboardingService()
        mockOnboardingService._stubbedHasSeenOnboarding = false
        let mockAppConfigService = MockAppConfigService()
        mockAppConfigService.features = [.onboarding]
        let complete: Bool = try await withCheckedThrowingContinuation { continuation in
            let sut = OnboardingCoordinator(
                navigationController: UINavigationController(),
                onboardingService: mockOnboardingService,
                analyticsService: MockAnalyticsService(),
                appConfigService: mockAppConfigService,
                dismissAction: {
                    continuation.resume(with: .failure(TestError.unexpectedMethodCalled))
                }
            )
            mockOnboardingService._stubbedFetchSlidesSlides = OnboardingSlide.arrange(2)
            sut.start()
            continuation.resume(returning: true)
        }
        #expect(complete)
    }

    @Test
    func start_isFeatureNotEnabled_callsDismiss() async {
        let mockOnboardingService = MockOnboardingService()
        mockOnboardingService._stubbedHasSeenOnboarding = false
        let mockAppConfigService = MockAppConfigService()
        mockAppConfigService.features = []
        let dismissed = await withCheckedContinuation { continuation in
            let sut = OnboardingCoordinator(
                navigationController: UINavigationController(),
                onboardingService: mockOnboardingService,
                analyticsService: MockAnalyticsService(),
                appConfigService: mockAppConfigService,
                dismissAction: {
                    continuation.resume(returning: true)
                }
            )
            mockOnboardingService._stubbedFetchSlidesSlides = OnboardingSlide.arrange(2)
            sut.start()
        }
        #expect(dismissed)
    }
}
