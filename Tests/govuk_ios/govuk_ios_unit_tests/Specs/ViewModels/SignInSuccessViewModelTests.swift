import Testing

@testable import govuk_ios
@testable import GOVKit

struct SignInSuccessViewModelTests {

    @Test
    func signInRetryButton_callsCompletion() {
        var didCallCompletion = false

        let sut = SignInSuccessViewModel(
            completion: {
                didCallCompletion = true
            }
        )

        sut.primaryButtonViewModel.action()

        #expect(didCallCompletion)
    }

}
