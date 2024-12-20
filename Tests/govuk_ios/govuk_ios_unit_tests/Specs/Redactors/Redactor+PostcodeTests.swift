import Foundation
import XCTest
import Testing

@testable import govuk_ios

@Suite
struct Redactor_PostcodeTests {
    @Test(arguments: [
        "L1 8JQ",
        "W1A 0AX",
        "L10 9HL",
        "EH1 1YZ",
        "CF10 1AA",
        "EC1A 1BB",
        "L18JQ",
        "W1A0AX",
        "L109HL",
        "EH11YZ",
        "CF101AA",
        "EC1A1BB",
        "L1  8JQ",
        "W1A  0AX",
        "L10  9HL",
        "EH1  1YZ",
        "CF10  1AA",
        "EC1A  1BB"
    ])
    func redact_validPostcode_returnsExpectedResult(postcode: String) {
        let sut = Redactor.postcode
        let result = sut.redact(postcode)
        #expect(result == "[postcode]")
    }

    @Test(arguments: [
        "L1 8JQ",
        "W1A 0AX",
        "L10 9HL",
        "EH1 1YZ",
        "CF10 1AA",
        "EC1A 1BB",
        "L18JQ",
        "W1A0AX",
        "L109HL",
        "EH11YZ",
        "CF101AA",
        "EC1A1BB",
        "L1  8JQ",
        "W1A  0AX",
        "L10  9HL",
        "EH1  1YZ",
        "CF10  1AA",
        "EC1A  1BB"
    ])
    func redact_inSentence_returnsExpectedResult(postcode: String) {
        let input = "Universal credit \(postcode) allowance"
        let sut = Redactor.postcode
        let result = sut.redact(input)
        let expected = "Universal credit [postcode] allowance"
        #expect(result == expected)
    }

    func redact_withMultiplePostcodes_returnsExpectedResult() {
        let sut = RegexRedactor.postcode
        let text = "Here is my postcode: TS1 8RF & L18JQ"

        let result = sut.redact(text)
        #expect(result == "Here is my postcode: [postcode] & [postcode]")
    }

    func redact_noPostcode_returnsExpectedResult() {
        let sut = RegexRedactor.postcode
        let text = "Here is my postcode: only messing"

        let result = sut.redact(text)
        #expect(result == "Here is my postcode: only messing")
    }
}
