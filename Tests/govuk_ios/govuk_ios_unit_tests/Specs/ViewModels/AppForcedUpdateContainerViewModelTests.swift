import Foundation
import Testing
import GOVKit
@testable import govuk_ios

@Suite
struct AppForcedUpdateContainerViewModelTests {
    @Test
    func init_hasCorrectInitialState() throws {
        let sut = AppForcedUpdateContainerViewModel ()

        #expect(sut.title == "You need to update your app")
        #expect(sut.subheading == "You're using an old version of the app. Update your app to continue.")
        #expect(sut.updateButtonTitle == "Update")
    }

    @Test
    func updateButtonAction_opensURL() throws {
        let urlOpener = MockURLOpener()
        let sut = AppForcedUpdateContainerViewModel(
            urlOpener: urlOpener
        )
        sut.updateButtonViewModel.action()
        #expect(urlOpener._receivedOpenIfPossibleUrl == Constants.API.appStoreAppUrl)
    }
}
