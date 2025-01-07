import Foundation
import XCTest
import Testing

@testable import govuk_ios

@Suite
struct RegexRedactorTests {
    @Test
    func defaultReplacementString() {
        let sut = RegexRedactor(
            pattern: "cat"
        )
        let text = """
        the cat in the hat
        """
        let result = sut.redact(text)
        #expect(result == "the [redacted] in the hat")
    }

    @Test
    func customReplacementString() {
        let sut = RegexRedactor(
            pattern: "cat",
            replacementText: "[dog]"
        )
        let text = """
        the cat in the hat
        """
        let result = sut.redact(text)
        #expect(result == "the [dog] in the hat")
    }
}
