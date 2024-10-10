import Foundation
import Testing

@testable import govuk_ios

@Suite
struct AppRecommendUpdateContainerViewModelTests {
    @Test
    func init_hasCorrectInitialState() throws {
        let sut = AppRecommendUpdateContainerViewModel (dismissAction: {})

        #expect(sut.title == "You’re using an old version of the app")
        #expect(sut.subheading == "You can update your app if you want to get the latest features and improvements.")
        #expect(sut.updateButtonTitle == "Update")
        #expect(sut.skipButtonTitle == "Skip")
    }

    @Test
    func updateButtonAction_opensURL() throws {
        let urlOpener = MockURLOpener()
        let sut = AppForcedUpdateContainerViewModel(
            urlOpener: urlOpener
        )
        sut.updateButtonViewModel.action()
        #expect(urlOpener._receivedOpenIfPossibleUrlString ==
                       "https://beta.itunes.apple.com/v1/app/6572293285")
    }

    @Test
    func skipButtonAction_callsDismiss() async throws {
        let dismissCalled = await withCheckedContinuation { continuation in
            let sut = AppRecommendUpdateContainerViewModel(
                dismissAction: {
                    continuation.resume(returning: true)
                }
            )
            sut.skipButtonViewModel.action()
        }
        #expect(dismissCalled)
    }
}
