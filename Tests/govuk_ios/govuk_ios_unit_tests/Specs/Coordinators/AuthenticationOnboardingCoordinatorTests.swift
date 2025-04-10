import Foundation
import Testing
import UIKit

import Onboarding

@testable import govuk_ios

@Suite
class AuthenticationOnboardingCoordinatorTests {
    @MainActor @Test
    func start_startsOnboarding() {
        let mockAuthenticationOnboardingService = MockAuthenticationOnboardingService()
        let mockNavigationController = MockNavigationController()
        let mockCoordinatorBuilder = CoordinatorBuilder.mock
        let sut = AuthenticationOnboardingCoordinator(
            navigationController: mockNavigationController,
            analyticsService: MockAnalyticsService(),
            authenticationOnboardingService: mockAuthenticationOnboardingService,
            coordinatorBuilder: mockCoordinatorBuilder,
            completionAction: {}
        )
        sut.start(url: nil)

        #expect(mockNavigationController._setViewControllers?.count == .some(1))
    }
}
