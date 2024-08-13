import XCTest

import Onboarding

@testable import govuk_ios

final class OnboardingCoordinatorTests: XCTestCase {
    func test_start_hasSeenOnboarding_callsDismiss() throws {
        let onboardingService = MockOnboardingService()
        onboardingService._stubbedHasSeenOnboarding = true
        let mockNavigationController = UINavigationController()
        let expectation = expectation()
        let sut = OnboardingCoordinator(
            navigationController: mockNavigationController,
            onboardingService: onboardingService,
            analyticsService: MockAnalyticsService(),
            dismissAction: {
                expectation.fulfill()
            }
        )
        sut.start()
        wait(for: [expectation], timeout: 1)
    }

    func test_start_hasNotSeenOnboarding_callsFetchSlides() throws {
        let mockOnboardingService = MockOnboardingService()
        mockOnboardingService._stubbedHasSeenOnboarding = false
        let mockNavigationController = MockNavigationController()
        let sut = OnboardingCoordinator(
            navigationController: mockNavigationController,
            onboardingService: mockOnboardingService,
            analyticsService: MockAnalyticsService(),
            dismissAction: { }
        )
        mockOnboardingService._stubbedFetchSlidesSlides = [OnboardingSlide.arrange]
        sut.start()

        XCTAssertEqual(mockNavigationController._setViewControllers?.count, 1)
    }

    func test_start_hasSeenOnboarding_noSlides_callsDismiss() throws {
        let mockOnboardingService = MockOnboardingService()
        mockOnboardingService._stubbedHasSeenOnboarding = true
        let mockNavigationController = UINavigationController()
        let expectation = expectation()
        let sut = OnboardingCoordinator(
            navigationController: mockNavigationController,
            onboardingService: mockOnboardingService, 
            analyticsService: MockAnalyticsService(),
            dismissAction: {
                XCTAssertEqual(mockNavigationController.viewControllers.count, 0)
                expectation.fulfill()
            }
        )
        mockOnboardingService._stubbedFetchSlidesSlides = []
        sut.start()
        wait(for: [expectation], timeout: 1)
    }

    func test_start_hasNotSeenOnboarding_doesNotCallDismiss() throws {
        let mockOnboardingService = MockOnboardingService()
        mockOnboardingService._stubbedHasSeenOnboarding = false
        let mockNavigationController = UINavigationController()
        let sut = OnboardingCoordinator(
            navigationController: mockNavigationController,
            onboardingService: mockOnboardingService, 
            analyticsService: MockAnalyticsService(),
            dismissAction: {
                XCTFail()
            }
        )
        mockOnboardingService._stubbedFetchSlidesSlides = OnboardingSlide.arrange(2)
        sut.start()
    }
}
