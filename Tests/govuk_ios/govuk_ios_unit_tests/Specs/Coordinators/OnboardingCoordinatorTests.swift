import XCTest
@testable import govuk_ios

final class OnboardingCoordinatorTests: XCTestCase {
    func test_start_hasSeenOnboarding_callsDismiss() throws {
        let onboardingService = MockOnBoardingService()
        onboardingService.setHasSeenOnboarding()
        let mockNavigationController = UINavigationController()
        let expectation = expectation(description: "did finish expecation")
        let sut = OnboardingCoordinator(
            navigationController: mockNavigationController,
            onboardingService: onboardingService,
            dismissAction: {
                expectation.fulfill()
            }
        )
        sut.start()
        wait(for: [expectation], timeout: 1)
    }

    func test_start_hasNotSeenOnboarding_doesNotCallDismiss() throws {
        let onboardingService = MockOnBoardingService()
        let mockNavigationController = UINavigationController()
        let sut = OnboardingCoordinator(
            navigationController:mockNavigationController,
            onboardingService: onboardingService,
            dismissAction: {
                XCTFail()
            }
        )
        sut.start()
    }
}

