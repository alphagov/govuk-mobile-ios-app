import Testing
import Foundation

@testable import govuk_ios

struct MinimumLengthValidatorTests {
    @Test(arguments: [
        "ABC",
        "ABCD",
        "ABCDE",
    ])
    func validate_whenTextInputIsGreaterOrEqualThanRequiredStringLength_returnsTrue(input: String) {
        let sut = MinimumLengthValidator(length: 3)
        #expect(sut.validate(input: input) == true)
    }

    @Test(arguments: [
        "A",
        "AB",
        "ABC",
        "ABCD"
    ])
    func validate_whenTextInputIsLessThanRequiredStringLength_returnsFalse(input: String) {
        let sut = MinimumLengthValidator(length: 5)
        #expect(sut.validate(input: input) == false)
    }

    @Test
    func validate_whenStringIsNil_returnsFalse() {
        let sut = MinimumLengthValidator(length: 5)

        #expect(sut.validate(input: nil) == false)
    }
}
