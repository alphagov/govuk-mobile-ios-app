import Testing

@testable import govuk_ios
@testable import GOVKit

struct SignOutConfirmationViewModelTests {

    @Test
    func signOut_action_calls_signOut() throws {
        let mockAuthenticationService = MockAuthenticationService()
        let mockAnalyticsService = MockAnalyticsService()
        mockAuthenticationService._stubbedIsSignedIn = true
        var didCallCompletion = false
        let sut = SignOutConfirmationViewModel(
            authenticationService: mockAuthenticationService,
            analyticsService: mockAnalyticsService,
            completion: { _ in
                didCallCompletion = true
            }
        )

        sut.signOutButtonViewModel.action()

        #expect(didCallCompletion)
        #expect(mockAuthenticationService.isSignedIn == false)
    }

    @Test
    func cancel_action_cancels_signout() throws {
        let mockAuthenticationService = MockAuthenticationService()
        let mockAnalyticsService = MockAnalyticsService()
        mockAuthenticationService._stubbedIsSignedIn = true
        var didCallCompletion = false
        let sut = SignOutConfirmationViewModel(
            authenticationService: mockAuthenticationService,
            analyticsService: mockAnalyticsService,
            completion: { _ in 
                didCallCompletion = true
            }
        )

        sut.cancelButtonViewModel.action()

        #expect(didCallCompletion)
        #expect(mockAuthenticationService.isSignedIn == true)
    }

    @Test
    func signOut_action_tracks_navigationEvent() throws {
        let mockAuthenticationService = MockAuthenticationService()
        let mockAnalyticsService = MockAnalyticsService()
        mockAuthenticationService._stubbedIsSignedIn = true
        let sut = SignOutConfirmationViewModel(
            authenticationService: mockAuthenticationService,
            analyticsService: mockAnalyticsService,
            completion: { _ in }
        )

        sut.signOutButtonViewModel.action()

        #expect(mockAnalyticsService._trackedEvents.count == 1)
        #expect(mockAnalyticsService._trackedEvents.first?.params?["text"] as? String == "Sign out")
    }

    @Test
    func cancel_action_tracks_navigationEvent() throws {
        let mockAuthenticationService = MockAuthenticationService()
        let mockAnalyticsService = MockAnalyticsService()
        mockAuthenticationService._stubbedIsSignedIn = true
        let sut = SignOutConfirmationViewModel(
            authenticationService: mockAuthenticationService,
            analyticsService: mockAnalyticsService,
            completion: { _ in }
        )

        sut.cancelButtonViewModel.action()

        #expect(mockAnalyticsService._trackedEvents.count == 1)
        #expect(mockAnalyticsService._trackedEvents.first?.params?["text"] as? String == "Cancel")
    }
}
