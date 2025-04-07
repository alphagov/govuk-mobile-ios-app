import Foundation
import Testing
import UIKit

import Onboarding

@testable import govuk_ios

@Suite
class AuthenticationOnboardingCoordinatorTests {
    @Test
    func start_startsOnboarding() async {
        let mockAuthenticationService = MockAuthenticationService()
        let mockNavigationController = await MockNavigationController()
        let sut = await AuthenticationOnboardingCoordinator(
            navigationController: mockNavigationController,
            analyticsService: MockAnalyticsService(),
            authenticationService: mockAuthenticationService,
            completionAction: {}
        )
        await sut.start(url: nil)

        await #expect(mockNavigationController._setViewControllers?.count == .some(1))
    }
}
