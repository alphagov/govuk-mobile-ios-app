import Foundation
import XCTest

@testable import govuk_ios

final class AppUnavailableViewModelTests: XCTestCase {
    func test_init_hasCorrectInitialState() throws {
        let sut = AppUnavailableContainerViewModel ()

        XCTAssertEqual(sut.title, "Sorry, the app is unavailable")
        XCTAssertEqual(sut.subheading, "You cannot use the GOV.UK app at the moment. Try again later.")
        XCTAssertEqual(sut.goToGovUkButtonTitle, "Go to GOV.UK ↗")
        XCTAssertEqual(sut.goToGovUkAccessibilityButtonTitle, "Go to GOV.UK")
        XCTAssertEqual(sut.goToGovUkAccessibilityButtonHint, "Opens in web browser")
        XCTAssertEqual(sut.govUkUrl, "https://www.gov.uk")
    }

    func test_openGovUk_opensURL() throws {
        let urlOpener = MockURLOpener()
        let sut = AppUnavailableContainerViewModel(
            urlOpener: urlOpener
        )
        sut.openGovUk()
        XCTAssertEqual(urlOpener._receivedOpenIfPossibleUrlString, "https://www.gov.uk")
    }
}
