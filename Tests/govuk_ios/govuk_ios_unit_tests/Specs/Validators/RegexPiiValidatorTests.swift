import Testing

@testable import govuk_ios
struct RegexPiiValidatorTests {

    @Test(arguments: [
        "07555666777",
        "(01234)555666",
        "01234 555666",
        "(01234) 555666",
        "+441234567890",
        "+(44)1234567890",
        "+44 1234567890",
        "+(44) 1234567890",
        "+44 1234 567890",
        "+(44) 1234 567890",
        "+44 1234 567 890",
        "+(44) 1234 567 890",
        "+11234567",
        "+112345678",
        "+1123456789",
        "+11234567890",
        "+121234567890",
        "+1231234567890",
        "+(123)1234567890",
        "+1 1234567",
        "+1 12345678",
        "+1 123456789",
        "+1 1234567890",
        "+12 1234567890",
        "+123 1234567890",
        "+(123) 1234567890",
        "+1 123 4567890",
        "+(123) 123 4567",
        "+1-123-4567890",
        "+(123)-123-4567",
        "+1.123.4567890",
        "+(123).123.4567",
        "My phone number is 07777 123456"
    ])
    func regexValidator_detectsPhoneNumber(_ phoneNumber: String) {
        let sut = RegexValidator.pii
        #expect(sut.validate(input: phoneNumber))
    }

    @Test(arguments: [
        "1234567890123",
        "12345678901234",
        "123456789012345",
        "1234567890123456",
        "My credit card is 123456789012345"
    ])
    func regexValidator_detectsCreditCard(_ creditCard: String) {
        let sut = RegexValidator.pii
        #expect(sut.validate(input: creditCard))
    }

    @Test(arguments: [
        "test@gmail.com",
        "test.user@yahoo.co.uk",
        "My email is test_test@gmail.com"
    ])
    func regexValidator_detectsEmail(_ email: String) {
        let sut = RegexValidator.pii
        #expect(sut.validate(input: email))
    }

    @Test(arguments: [
        "AB 12 34 56 A",
        "AB123456A",
        "AB 123 456 A",
        "AB 123 456A",
        "AB123456 A",
        "AB 123456A",
        "My NIN is AB123456A"
    ])
    func regexValidator_detectsNationalInsuranceNumber(_ nin: String) {
        let sut = RegexValidator.pii
        #expect(sut.validate(input: nin))
    }

    @Test(arguments: [
        "www.gov.uk",
        "4 @ £5 each",
        "12345",
    ])
    func regexValidator_doesNotDetectNonPii(_ nonPii: String) {
        let sut = RegexValidator.pii
        #expect(!sut.validate(input: nonPii))
    }
}
