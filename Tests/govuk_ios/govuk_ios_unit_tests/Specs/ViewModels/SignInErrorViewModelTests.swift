import Testing

@testable import govuk_ios
@testable import GOVKit

struct SignInErrorViewModelTests {

    @Test
    func signInRetryButton_noneGeneric_callsCompletion() async {
        await confirmation() { confirmation in
            let sut = SignInErrorViewModel(
                error: .attestation(.tokenGeneration),
                feedbackAction: { _ in },
                retryAction: {
                    #expect(true)
                    confirmation()
                }
            )
            sut.primaryButtonViewModel.action()
        }
    }

    @Test
    func signInRetryButton_unknown_callsCompletion() async {
        await confirmation() { confirmation in
            let expectedError = AuthenticationError.unknown(TestError.anyError)
            let sut = SignInErrorViewModel(
                error: expectedError,
                feedbackAction: { error in
                    #expect(error == expectedError)
                    confirmation()
                },
                retryAction: { }
            )
            sut.primaryButtonViewModel.action()
        }
    }
}
