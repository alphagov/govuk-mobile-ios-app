import Testing
import Foundation

@testable import govuk_ios

struct MinimumLengthValidatorTests {
    @Test
    func validate_whenTextInputIsGreaterOrEqualThanRequiredStringLength_returnsTrue() {
        let sut = MinimumLengthValidator(requiredStringLength: 5)

        let testStringOne = "Seven"

        #expect(sut.validate(input: testStringOne) == true)

        let testStringTwo = "Chromatic"

        #expect(sut.validate(input: testStringTwo) == true)
    }

    @Test
    func validate_whenTextInputIsLessThanRequiredStringLength_returnsFalse() {
        let sut = MinimumLengthValidator(requiredStringLength: 5)
        let testString = "Four"

        #expect(sut.validate(input: testString) == false)
    }
}
