import Foundation
import XCTest
import Testing

@testable import govuk_ios

@Suite
struct RedactorTests {
    @Test
    func redact_returnsExpectedResult() {
        let mockRedactor = MockRedactor()
        mockRedactor._stubbedRedactedString = UUID().uuidString
        let sut = CompoundRedactor(
            redactors: [
                mockRedactor
            ]
        )
        let text = """
        the cat in the hat
        """
        let result = sut.redact(text)
        #expect(mockRedactor._receivedInputText == text)
        #expect(result == mockRedactor._stubbedRedactedString)
    }

    @Test
    func pii_redact_returnsExpectedResult() {
        let sut = Redactor.pii
        let text = """
        Hi my postcode is FL52HP and my email is test@gmail.com.
        I have an insurance number: QQ123456B
        """
        let result = sut.redact(text)
        let expected = """
        Hi my postcode is [postcode] and my email is [email].
        I have an insurance number: [NI number]
        """
        #expect(result == expected)
    }
}

class MockRedactor: Redactor {
    var _receivedInputText: String?
    var _stubbedRedactedString: String?
    override func redact(_ text: String) -> String {
        _receivedInputText = text
        return _stubbedRedactedString!
    }
}
