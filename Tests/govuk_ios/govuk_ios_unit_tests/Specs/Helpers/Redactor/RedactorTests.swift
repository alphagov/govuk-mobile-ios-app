import Foundation
import Testing

@testable import govuk_ios

@Suite
struct RedactorTests {
    @Test
    func redacted_whenRedactorContainsEmail_redactsEmail() async throws {
        let sut = Redactor.email
        let expectedString = "Hi my postcode is FL52HP and my email is [email]. I have an insurance number: QQ123456B"

        let testStringOne = "Hi my postcode is FL52HP and my email is tom@gmail.com. I have an insurance number: QQ123456B"

        #expect(sut.redact(testStringOne) == expectedString)

        let testStringTwo = "Hi my postcode is FL52HP and my email is user+mailbox@subdomain.example.com. I have an insurance number: QQ123456B"

        #expect(sut.redact(testStringTwo) == expectedString)

        let testStringThree = "Hi my postcode is FL52HP and my email is jane_doe123@company.co.uk. I have an insurance number: QQ123456B"

        #expect(sut.redact(testStringThree) == expectedString)
    }

    @Test
    func redacted_whenRedactorContainsNINumber_redactsNINumber() async throws {
        let sut = Redactor.nino
        let expectedString = "Hi my postcode is FL52HP and my email is tom@gmail.com. I have an insurance number: [NI number]"

        let testStringOne = "Hi my postcode is FL52HP and my email is tom@gmail.com. I have an insurance number: QQ123456B"

        #expect(sut.redact(testStringOne) == expectedString)

        let testStringTwo = "Hi my postcode is FL52HP and my email is tom@gmail.com. I have an insurance number: CD 98 76 54 A"

        #expect(sut.redact(testStringTwo) == expectedString)

        let testStringThree = "Hi my postcode is FL52HP and my email is tom@gmail.com. I have an insurance number: CD  98  76  54  A"

        #expect(sut.redact(testStringThree) == expectedString)
    }

    @Test
    func redacted_whenRedactorContainsPostCode_redactsPostCode() async throws {
        let sut = Redactor.postCode
        let expectedString = "Hi my postcode is [postcode] and my email is tom@gmail.com. I have an insurance number: QQ123456B"

        let testStringOne = "Hi my postcode is FL52HP and my email is tom@gmail.com. I have an insurance number: QQ123456B"

        #expect(sut.redact(testStringOne) == expectedString)

        let testStringTwo = "Hi my postcode is L1 8JQ and my email is tom@gmail.com. I have an insurance number: QQ123456B"

        #expect(sut.redact(testStringTwo) == expectedString)

        let testStringThree = "Hi my postcode is EC1A  1BB and my email is tom@gmail.com. I have an insurance number: QQ123456B"

        #expect(sut.redact(testStringThree) == expectedString)
    }

    @Test
    func redacted_whenTextContainsMultipleInstancesOfTheSameType_allInstancesAreRedacted() async throws {
        let sut = Redactor.email
        let expectedString = "Hi my emails are [email] and [email]. I have an insurance number: QQ123456B"

        let testString = "Hi my emails are tom@gmail.com and tommy@gmail.com. I have an insurance number: QQ123456B"

        #expect(sut.redact(testString) == expectedString)
    }
}
