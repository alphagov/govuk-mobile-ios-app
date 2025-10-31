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
    func signInRetryButton_generic_callsCompletion() async {
        await confirmation() { confirmation in
            let sut = SignInErrorViewModel(
                error: .genericError,
                feedbackAction: { error in
                    #expect(error == .genericError)
                    confirmation()
                },
                retryAction: { }
            )
            sut.primaryButtonViewModel.action()
        }
    }
}
