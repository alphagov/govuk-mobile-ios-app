import Foundation
import Testing
import GOVKit
@testable import GOVKitTestUtilities
@testable import govuk_ios

@Suite
struct AppUnavailableViewModelTests {
    @Test
    func init_hasCorrectInitialState()  {
        let sut = AppUnavailableContainerViewModel()

        #expect(sut.title == "Sorry, the app is unavailable")
        #expect(sut.subheading == "You cannot use the GOV.UK app at the moment. Try again later.")
        #expect(sut.goToGovUkButtonTitle == "Go to the GOV.UK website ↗")
        #expect(sut.goToGovUkAccessibilityButtonTitle == "Go to the GOV.UK website")
        #expect(sut.goToGovUkAccessibilityButtonHint == "Opens in web browser")
    }

    @Test
    func goToGovUkButtonAction_opensURL() {
        let urlOpener = MockURLOpener()
        let sut = AppUnavailableContainerViewModel(
            urlOpener: urlOpener
        )
        sut.goToGovUkButtonViewModel.action()
        #expect(urlOpener._receivedOpenIfPossibleUrl == Constants.API.govukBaseUrl)
    }
}
