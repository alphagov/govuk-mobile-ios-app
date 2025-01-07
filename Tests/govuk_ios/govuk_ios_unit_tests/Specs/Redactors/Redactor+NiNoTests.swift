import Foundation
import XCTest
import Testing

@testable import govuk_ios

@Suite
struct Redactor_NiNoTests {
    @Test(arguments: [
        "CD987654A",
        "CD 98 76 54 A",
        "CD  98  76  54  A"
    ])
    func redact_validInput_returnsExpectedResult(nino: String) {
        let sut = Redactor.nino
        let result = sut.redact(nino)
        #expect(result == "[NI number]")
    }

    @Test(arguments: [
        "CD987654A",
        "CD 98 76 54 A",
        "CD  98  76  54  A"
    ])
    func redact_inSentence_returnsExpectedResult(nino: String) {
        let input = "Self assessment \(nino) tax return"

        let sut = Redactor.nino
        let result = sut.redact(input)
        let expected = "Self assessment [NI number] tax return"
        #expect(result == expected)
    }

    func redact_withMultipleNationalInsuranceNumbers_returnsExpectedResult() {
        let sut = Redactor.nino
        let text = "Here is my national insurance number: QQ123456B & CD  98  76  54  A"

        let result = sut.redact(text)
        #expect(result == "Here is my national insurance number: [NI number] & [NI number]")
    }

    func redact_noNationalInsuranceNumber_returnsExpectedResult() {
        let sut = Redactor.nino
        let text = "Here is my national insurance number: only messing"

        let result = sut.redact(text)
        #expect(result == "Here is my national insurance number: only messing")
    }
}
