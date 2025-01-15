import Foundation
import UIKit
import Testing

@testable import GOVKitTestUtilities
@testable import govuk_ios

@Suite
@MainActor
struct UIApplication_URLOpenerTests {
    @Test
    func openSettings_opensExpectedURL() {
        let sut = MockURLOpener()
        sut.openSettings()

        #expect(sut._receivedOpenIfPossibleUrlString == UIApplication.openSettingsURLString)
    }

    @Test
    func openIfPossible_string_invalidURL_returnsFalse() {
        let sut = UIApplication.shared
        let result = sut.openIfPossible("")

        #expect(result == false)
    }

    @Test
    func openIfPossible_string_valueURL_returnsTrue() {
        let sut = UIApplication.shared
        let result = sut.openIfPossible("https://www.gov.uk")

        #expect(result == true)
    }

    @Test
    func openIfPossible_url_unableToOpen_returnsFalse() throws {
        let sut = UIApplication.shared

        let url = try #require(URL(string: "test"))
        let result = sut.openIfPossible(url)

        #expect(result == false)
    }
}
