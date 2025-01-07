import Foundation
import XCTest
import Testing

@testable import govuk_ios

@Suite
struct Redactor_EmailTests {
    @Test(arguments: [
        "john.doe@example.com",
        "jane_doe123@company.co.uk",
        "user.name+tag@domain.org",
        "contact@sub.domain.net",
        "firstname.lastname@company.com",
        "user+mailbox@subdomain.example.com"
    ])
    func redact_validEmail_returnsExpectedResult(email: String) {
        let sut = RegexRedactor.email
        let result = sut.redact(email)
        #expect(result == "[email]")
    }

    @Test(arguments: [
        "john.doe@example.com",
        "jane_doe123@company.co.uk",
        "user.name+tag@domain.org",
        "contact@sub.domain.net",
        "firstname.lastname@company.com",
        "user+mailbox@subdomain.example.com"
    ])
    func redact_inSentence_returnsExpectedResult(email: String) {
        let input = "Self assessment \(email) tax return"

        let sut = RegexRedactor.email
        let result = sut.redact(input)
        let expected = "Self assessment [email] tax return"
        #expect(result == expected)
    }

    func redact_mutipleEmails_returnsExpectedResult() {
        let sut = RegexRedactor.email
        let text = "Here is my email: test@test.com & testagain@email.com"

        let result = sut.redact(text)
        #expect(result == "Here is my email: [email] & [email]")
    }

    func redact_noEmail_returnsExpectedResult() {
        let sut = RegexRedactor.email
        let text = "Here is my email: only messing"

        let result = sut.redact(text)
        #expect(result == "Here is my email: only messing")
    }

}
