import Testing
import Foundation

@testable import govuk_ios

@Suite
struct MaximumLengthValidatorTest {
    @Test(arguments: [
        "1",
        "12",
        "123",
        "1234",
        "12345",
    ])
    func validate_whenTextInputIsLessOrEqualThanRequiredStringLength_returnsTrue(input: String) async {
        let sut = MaximumLengthValidator(length: 5)
        
        #expect(sut.validate(input: input) == true)
    }

    @Test(arguments: [
        "123",
        "1234"
    ])
    func validate_whenTextInputIsGreaterThanRequiredStringLength_returnsFalse(input: String) async {
        let sut = MaximumLengthValidator(length: 2)

        #expect(sut.validate(input: input) == false)
    }

    @Test
    func validate_whenStringIsNil_returnsFalse() {
        let sut = MaximumLengthValidator(length: 5)

        #expect(sut.validate(input: nil) == false)
    }
}
