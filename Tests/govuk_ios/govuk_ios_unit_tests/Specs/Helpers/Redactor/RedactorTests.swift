import Foundation
import Testing

@testable import govuk_ios 

struct RedactorTests {
    let testString = "Hi my postcode is FL52HP and my email is tom@gmail.com. I have an insurance number: QQ123456B"

    @Test
    func redact_whenRedactorContainsEmailRedactable_redactsEmail() async throws {
        let sut = Redactor(redactables: [.email])

        let redactedString = sut.redact(inputText: testString)

        #expect(redactedString == "Hi my postcode is FL52HP and my email is [email]. I have an insurance number: QQ123456B")
    }

    @Test
    func redact_whenRedactorContainsNINumberRedactable_redactsNINumber() async throws {
        let sut = Redactor(redactables: [.niNumber])

        let redactedString = sut.redact(inputText: testString)

        #expect(redactedString == "Hi my postcode is FL52HP and my email is tom@gmail.com. I have an insurance number: [NI number]")
    }

    @Test
    func redact_whenRedactorContainsPostCodeRedactable_redactsPostCode() async throws {
        let sut = Redactor(redactables: [.postCode])

        let redactedString = sut.redact(inputText: testString)

        #expect(redactedString == "Hi my postcode is [postcode] and my email is tom@gmail.com. I have an insurance number: QQ123456B")
    }

    @Test
    func redact_whenRedactorContainsBothPostCodeAndEmailRedactables_redactsPostCodeAndEmail() async throws {
        let sut = Redactor(redactables: [.postCode, .email])

        let redactedString = sut.redact(inputText: testString)

        #expect(redactedString == "Hi my postcode is [postcode] and my email is [email]. I have an insurance number: QQ123456B")
    }
}
