import Foundation
import UIKit
import Testing

@testable import GOVKit

@Suite
@MainActor
struct UIApplication_URLOpenerTests {
    @Test
    func openIfPossible_string_invalidURL_returnsFalse() {
        let sut = TestURLOpener()
        let result = sut.openIfPossible("")

        #expect(result == false)
    }

    @Test
    func openIfPossible_string_valueURL_returnsTrue() {
        let sut = TestURLOpener()
        let result = sut.openIfPossible("https://www.gov.uk")

        #expect(result == true)
    }
}

struct TestURLOpener: URLOpener {
    func openIfPossible(_ url: URL) -> Bool {
        true
    }
    func canOpenURL(_ url: URL) -> Bool {
        true
    }
}
