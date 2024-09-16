import Foundation
import UIKit
import XCTest

@testable import govuk_ios

class UIApplication_URLOpenerTests: XCTestCase {
    func test_openSettings_opensExpectedURL() {
        let sut = MockURLOpener()
        sut.openSettings()

        XCTAssertEqual(sut._receivedOpenIfPossibleUrlString, UIApplication.openSettingsURLString)
    }

    func test_openIfPossible_string_invalidURL_returnsFalse() {
        let sut = UIApplication.shared
        let result = sut.openIfPossible("")

        XCTAssertFalse(result)
    }

    func test_openIfPossible_string_valueURL_returnsTrue() {
        let sut = UIApplication.shared
        let result = sut.openIfPossible("https://www.gov.uk")

        XCTAssertTrue(result)
    }

    func test_openIfPossible_url_unableToOpen_returnsFalse() {
        let sut = UIApplication.shared
        guard let url = URL(string: "test")
        else { return XCTFail("Test requires url") }
        let result = sut.openIfPossible(url)

        XCTAssertFalse(result)
    }
}
