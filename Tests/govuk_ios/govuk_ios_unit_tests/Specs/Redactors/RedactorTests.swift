import Foundation
import XCTest
import Testing

@testable import govuk_ios

@Suite
struct RedactorTests {
    @Test
    func redact_returnsExpectedResult() {
        let string = UUID().uuidString
        let sut = Redactor()
        let result = sut.redact(string)

        #expect(result == string)
    }
}
