import Foundation
import UIKit
import Testing

@testable import govuk_ios

@Suite
struct String_ExtensionsTests {
    @Test
    func common_hasCorrectValues() {
        let sut = String.common
        #expect(sut.tableName == "Common")
    }

    @Test
    func home_hasCorrectValues() {
        let sut = String.home
        #expect(sut.tableName == "Home")
    }

    @Test
    func settings_hasCorrectValues() {
        let sut = String.settings
        #expect(sut.tableName == "Settings")
    }

    @Test
    func search_hasCorrectValues() {
        let sut = String.search
        #expect(sut.tableName == "Search")
    }

    @Test
    func onboarding_hasCorrectValues() {
        let sut = String.onboarding
        #expect(sut.tableName == "Onboarding")
    }

    @Test
    func localized_returnsExpectedResult() {
        let sut = String.LocalStringBuilder(
            tableName: "TestStrings",
            bundle: .current
        )
        #expect(sut.localized("testString") == "Test string 123")
    }

    @Test
    func redactPII_givenPostcode_redactsCorrectly() {
        let redactedPostcodeText = "[postcode]"

        #expect(redactedPostcodeText == "L1 8JQ".redactPii())
        #expect(redactedPostcodeText == "W1A 0AX".redactPii())
        #expect(redactedPostcodeText == "L10 9HL".redactPii())
        #expect(redactedPostcodeText == "EH1 1YZ".redactPii())
        #expect(redactedPostcodeText == "CF10 1AA".redactPii())
        #expect(redactedPostcodeText == "EC1A 1BB".redactPii())

        #expect(redactedPostcodeText == "L18JQ".redactPii())
        #expect(redactedPostcodeText == "W1A0AX".redactPii())
        #expect(redactedPostcodeText == "L109HL".redactPii())
        #expect(redactedPostcodeText == "EH11YZ".redactPii())
        #expect(redactedPostcodeText == "CF101AA".redactPii())
        #expect(redactedPostcodeText == "EC1A1BB".redactPii())

        #expect(redactedPostcodeText == "L1  8JQ".redactPii())
        #expect(redactedPostcodeText == "W1A  0AX".redactPii())
        #expect(redactedPostcodeText == "L10  9HL".redactPii())
        #expect(redactedPostcodeText == "EH1  1YZ".redactPii())
        #expect(redactedPostcodeText == "CF10  1AA".redactPii())
        #expect(redactedPostcodeText == "EC1A  1BB".redactPii())

        let expected = "Universal credit \(redactedPostcodeText) allowance"

        #expect(expected == "Universal credit L1 8JQ allowance".redactPii())
        #expect(expected == "Universal credit W1A 0AX allowance".redactPii())
        #expect(expected == "Universal credit L10 9HL allowance".redactPii())
        #expect(expected == "Universal credit EH1 1YZ allowance".redactPii())
        #expect(expected == "Universal credit CF10 1AA allowance".redactPii())
        #expect(expected == "Universal credit EC1A 1BB allowance".redactPii())

        #expect(expected == "Universal credit L18JQ allowance".redactPii())
        #expect(expected == "Universal credit W1A0AX allowance".redactPii())
        #expect(expected == "Universal credit L109HL allowance".redactPii())
        #expect(expected == "Universal credit EH11YZ allowance".redactPii())
        #expect(expected == "Universal credit CF101AA allowance".redactPii())
        #expect(expected == "Universal credit EC1A1BB allowance".redactPii())

        #expect(expected == "Universal credit L1  8JQ allowance".redactPii())
        #expect(expected == "Universal credit W1A  0AX allowance".redactPii())
        #expect(expected == "Universal credit L10  9HL allowance".redactPii())
        #expect(expected == "Universal credit EH1  1YZ allowance".redactPii())
        #expect(expected == "Universal credit CF10  1AA allowance".redactPii())
        #expect(expected == "Universal credit EC1A  1BB allowance".redactPii())
    }

    @Test
    func redactPII_givenEmail_redactsCorrectly() {
        let redactedEmailText = "[email]"

        #expect(redactedEmailText == "john.doe@example.com".redactPii())
        #expect(redactedEmailText == "jane_doe123@company.co.uk".redactPii())
        #expect(redactedEmailText == "user.name+tag@domain.org".redactPii())
        #expect(redactedEmailText == "contact@sub.domain.net".redactPii())
        #expect(redactedEmailText == "firstname.lastname@company.com".redactPii())
        #expect(redactedEmailText == "user+mailbox@subdomain.example.com".redactPii())

        let expected = "Self assessment \(redactedEmailText) tax return"

        #expect(expected == "Self assessment john.doe@example.com tax return".redactPii())
        #expect(expected == "Self assessment jane_doe123@company.co.uk tax return".redactPii())
        #expect(expected == "Self assessment user.name+tag@domain.org tax return".redactPii())
        #expect(expected == "Self assessment contact@sub.domain.net tax return".redactPii())
        #expect(expected == "Self assessment firstname.lastname@company.com tax return".redactPii())
        #expect(expected == "Self assessment user+mailbox@subdomain.example.com tax return".redactPii())
    }

    @Test
    func redactPII_givenNINumber_redactsCorrectly() {
        let redactedNINumberText = "[NI number]"

        #expect(redactedNINumberText == "CD987654A".redactPii())
        #expect(redactedNINumberText == "CD 98 76 54 A".redactPii())
        #expect(redactedNINumberText == "CD  98  76  54  A".redactPii())

        let expected = "Child benefit \(redactedNINumberText) allowance"

        #expect(expected == "Child benefit CD987654A allowance".redactPii())
        #expect(expected == "Child benefit CD 98 76 54 A allowance".redactPii())
        #expect(expected == "Child benefit CD  98  76  54  A allowance".redactPii())
    }

    @Test
    func isVersion_returnsExpectedResult() {
        #expect("1.0.0".isVersion(lessThan: "1.0.0") == false)
        #expect("1.0.0".isVersion(lessThan: "1.0.1") == true)
        #expect("1.0.1".isVersion(lessThan: "1.0.0") == false)

        #expect("1".isVersion(lessThan: "2.0.0") == true)
        #expect("1.0".isVersion(lessThan: "2.0") == true)
        #expect("1.0.0".isVersion(lessThan: "2") == true)

        #expect("2.0.0".isVersion(lessThan: "1") == false)
        #expect("2.0".isVersion(lessThan: "1.0") == false)
        #expect("2".isVersion(lessThan: "1.0.0") == false)

        #expect("100.0.0".isVersion(lessThan: "0.0.100") == false)
        #expect("0.100.0".isVersion(lessThan: "0.100.0") == false)
        #expect("0.0.100".isVersion(lessThan: "100.0.0") == true)
    }
}
