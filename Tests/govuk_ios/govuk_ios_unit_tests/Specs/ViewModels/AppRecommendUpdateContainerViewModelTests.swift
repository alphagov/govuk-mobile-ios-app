import Foundation
import Testing
import GOVKit

@testable import govuk_ios

@Suite
struct AppRecommendUpdateContainerViewModelTests {
    @Test
    func init_hasCorrectInitialState() {
        let sut = AppRecommendUpdateContainerViewModel (dismissAction: {})

        #expect(sut.title == "You’re using an old version of the app")
        #expect(sut.subheading == "You can update your app if you want to get the latest features and improvements.")
        #expect(sut.updateButtonTitle == "Update")
        #expect(sut.skipButtonTitle == "Skip")
    }

    @Test
    func updateButtonAction_opensURL() {
        let urlOpener = MockURLOpener()
        let sut = AppForcedUpdateContainerViewModel(
            urlOpener: urlOpener
        )
        sut.updateButtonViewModel.action()
        #expect(urlOpener._receivedOpenIfPossibleUrl == Constants.API.appStoreAppUrl)
    }

    @Test
    func skipButtonAction_callsDismiss() async {
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
