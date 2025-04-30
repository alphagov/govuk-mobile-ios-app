import Testing

@testable import govuk_ios
@testable import GOVKit

struct SignedOutViewModelTests {

    @Test
    func signInButton_action_tracksNavigationEvent() throws {
        let mockAuthenticationService = MockAuthenticationService()
        let mockAnalyticsService = MockAnalyticsService()
        var didCallCompletion = false
        let sut = SignedOutViewModel(
            authenticationService: mockAuthenticationService,
            analyticsService: mockAnalyticsService,
            completion: {
                didCallCompletion = true
            }
        )

        sut.signInButtonViewModel.action()

        #expect(didCallCompletion)
        #expect(mockAnalyticsService._trackedEvents.first?.params?["text"] as? String == String.signOut.localized("signInButtonTitle"))
    }
}
