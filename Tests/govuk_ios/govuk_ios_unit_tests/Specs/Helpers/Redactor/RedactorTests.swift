import Foundation
import Testing

@testable import govuk_ios

@Suite
struct RedactorTests {
    @Test
    func redacted_whenRedactorContainsEmail_redactsEmail() async throws {
        let sut = Redactor(redactables: [.email])
        let expectedString = "Hi my postcode is FL52HP and my email is [email]. I have an insurance number: QQ123456B"

        let testStringOne = "Hi my postcode is FL52HP and my email is tom@gmail.com. I have an insurance number: QQ123456B"

        #expect(sut.redacted(inputText: testStringOne) == expectedString)

        let testStringTwo = "Hi my postcode is FL52HP and my email is user+mailbox@subdomain.example.com. I have an insurance number: QQ123456B"

        #expect(sut.redacted(inputText: testStringTwo) == expectedString)

        let testStringThree = "Hi my postcode is FL52HP and my email is jane_doe123@company.co.uk. I have an insurance number: QQ123456B"

        #expect(sut.redacted(inputText: testStringThree) == expectedString)
    }

    @Test
    func redacted_whenRedactorContainsNINumber_redactsNINumber() async throws {
        let sut = Redactor(redactables: [.niNumber])
        let expectedString = "Hi my postcode is FL52HP and my email is tom@gmail.com. I have an insurance number: [NI number]"

        let testStringOne = "Hi my postcode is FL52HP and my email is tom@gmail.com. I have an insurance number: QQ123456B"

        #expect(sut.redacted(inputText: testStringOne) == expectedString)

        let testStringTwo = "Hi my postcode is FL52HP and my email is tom@gmail.com. I have an insurance number: CD 98 76 54 A"

        #expect(sut.redacted(inputText: testStringTwo) == expectedString)

        let testStringThree = "Hi my postcode is FL52HP and my email is tom@gmail.com. I have an insurance number: CD  98  76  54  A"

        #expect(sut.redacted(inputText: testStringThree) == expectedString)
    }

    @Test
    func redacted_whenRedactorContainsPostCode_redactsPostCode() async throws {
        let sut = Redactor(redactables: [.postCode])
        let expectedString = "Hi my postcode is [postcode] and my email is tom@gmail.com. I have an insurance number: QQ123456B"

        let testStringOne = "Hi my postcode is FL52HP and my email is tom@gmail.com. I have an insurance number: QQ123456B"

        #expect(sut.redacted(inputText: testStringOne) == expectedString)

        let testStringTwo = "Hi my postcode is L1 8JQ and my email is tom@gmail.com. I have an insurance number: QQ123456B"

        #expect(sut.redacted(inputText: testStringTwo) == expectedString)

        let testStringThree = "Hi my postcode is EC1A  1BB and my email is tom@gmail.com. I have an insurance number: QQ123456B"

        #expect(sut.redacted(inputText: testStringThree) == expectedString)
    }

    @Test
    func redacted_whenRedactorContainsBothPostCodeAndEmail_redactsPostCodeAndEmail() async throws {
        let sut = Redactor(redactables: [.postCode, .email])
        let expectedString = "Hi my postcode is [postcode] and my email is [email]. I have an insurance number: QQ123456B"

        let testString = "Hi my postcode is FL52HP and my email is tom@gmail.com. I have an insurance number: QQ123456B"

        #expect(sut.redacted(inputText: testString) == expectedString)
    }

    @Test
    func redacted_whenTextContainsMultipleInstancesOfTheSameType_allInstancesAreRedacted() async throws {
        let sut = Redactor(redactables: [.email])
        let expectedString = "Hi my emails are [email] and [email]. I have an insurance number: QQ123456B"

        let testString = "Hi my emails are tom@gmail.com and tommy@gmail.com. I have an insurance number: QQ123456B"

        #expect(sut.redacted(inputText: testString) == expectedString)
    }
}
