import Testing
import UIKit

@testable import govuk_ios

struct SignInSuccessCoordinatorTests {

    @Test
    @MainActor
    func start_newAuth_setsViewController() {
        let mockNavigationController = MockNavigationController()
        let mockAuthenticationService = MockAuthenticationService()
        mockAuthenticationService._stubbedIsReauth = false
        var didCallCompletion = false
        let sut = SignInSuccessCoordinator(
            navigationController: mockNavigationController,
            analyticsService: MockAnalyticsService(),
            authenticationService: mockAuthenticationService,
            completion: {
                didCallCompletion = true
            })

        sut.start()

        #expect(mockNavigationController._setViewControllers?.count == .some(1))
        #expect(!didCallCompletion)
    }

    func start_reauth_callsCompletion() {
        let mockNavigationController = MockNavigationController()
        let mockAuthenticationService = MockAuthenticationService()
        mockAuthenticationService._stubbedIsReauth = true
        var didCallCompletion = false
        let sut = SignInSuccessCoordinator(
            navigationController: mockNavigationController,
            analyticsService: MockAnalyticsService(),
            authenticationService: mockAuthenticationService,
            completion: {
                didCallCompletion = true
            })

        sut.start()

        #expect(mockNavigationController._setViewControllers?.count == .some(0))
        #expect(didCallCompletion)
    }

}
