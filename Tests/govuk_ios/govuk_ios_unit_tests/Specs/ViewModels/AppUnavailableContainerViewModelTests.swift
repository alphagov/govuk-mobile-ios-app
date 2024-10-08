import Foundation
import Testing

@testable import govuk_ios

@Suite
struct AppUnavailableViewModelTests {
    @Test
    func init_hasCorrectInitialState()  {
        let sut = AppUnavailableContainerViewModel ()

        #expect(sut.title == "Sorry, the app is unavailable")
        #expect(sut.subheading == "You cannot use the GOV.UK app at the moment. Try again later.")
        #expect(sut.goToGovUkButtonTitle == "Go to GOV.UK ↗")
        #expect(sut.goToGovUkAccessibilityButtonTitle == "Go to the GOV.UK website")
        #expect(sut.goToGovUkAccessibilityButtonHint == "Opens in web browser")
        #expect(sut.govUkUrl == "https://www.gov.uk")
    }

    @Test
    func goToGovUkButtonAction_opensURL() {
        let urlOpener = MockURLOpener()
        let sut = AppUnavailableContainerViewModel(
            urlOpener: urlOpener
        )
        sut.goToGovUkButtonViewModel.action()
        #expect(urlOpener._receivedOpenIfPossibleUrlString == "https://www.gov.uk")
    }
}
