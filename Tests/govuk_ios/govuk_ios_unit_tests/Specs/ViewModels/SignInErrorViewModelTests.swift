import Testing

@testable import govuk_ios
@testable import GOVKit

struct SignInErrorViewModelTests {

    @Test
    func signInRetryButton_callsCompletion() {
        var didCallCompletion = false

        let sut = SignInErrorViewModel(
            error: .genericError,
            completion: {
                didCallCompletion = true
            }
        )

        sut.primaryButtonViewModel.action()

        #expect(didCallCompletion)
    }

}
