import Testing

@testable import govuk_ios
@testable import GOVKit

struct SignInErrorViewModelTests {

    @Test
    func signInRetryButton_tracksNavigationEvent() {
        let mockAnalyticsService = MockAnalyticsService()
        var didCallCompletion = false

        let sut = SignInErrorViewModel(
            analyticsService: mockAnalyticsService,
            completion: {
                didCallCompletion = true
            }
        )

        sut.buttonViewModel.action()

        #expect(didCallCompletion)
        #expect(mockAnalyticsService._trackedEvents.first?.params?["text"] as? String == String.signOut.localized("signInRetryButtonTitle"))
    }

}
