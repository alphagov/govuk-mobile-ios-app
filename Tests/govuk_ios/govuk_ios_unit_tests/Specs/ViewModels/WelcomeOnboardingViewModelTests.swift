import Foundation
import Testing

@testable import govuk_ios

struct WelcomeOnboardingViewModelTests {
    @Test
    func primaryButtonViewModel_action_completesAction() async {
        let completion = await withCheckedContinuation { continuation in
            let sut = WelcomeOnboardingViewModel(
                completeAction: { continuation.resume(returning: true) }
            )
            let buttonViewModel = sut.primaryButtonViewModel
            buttonViewModel.action()
        }
        #expect(completion)
    }
}
