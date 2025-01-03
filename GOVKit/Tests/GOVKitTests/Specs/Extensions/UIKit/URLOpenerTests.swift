import Foundation
import UIKit
import Testing
import GOVKitTestUtilities

@testable import GOVKit

@Suite
@MainActor
struct UIApplication_URLOpenerTests {
    @Test
    func openIfPossible_string_invalidURL_returnsFalse() {
        let sut = MockURLOpener()
        let result = sut.openIfPossible("")

        #expect(result == false)
    }

    @Test
    func openIfPossible_string_valueURL_returnsTrue() {
        let sut = MockURLOpener()
        let result = sut.openIfPossible("https://www.gov.uk")

        #expect(result == true)
    }
}
