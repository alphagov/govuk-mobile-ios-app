import Testing
import Foundation

@testable import govuk_ios

@Suite
struct MaximumLengthValidatorTest {

    @Test
    func validate_whenTextInputIsLessOrEqualThanRequiredStringLength_returnsTrue() async throws {
        let sut = MaximumLengthValidator(length: 5)
        
        let testStringOne = "Seven"

        #expect(sut.validate(input: testStringOne) == true)

        let testStringTwo = "Six"

        #expect(sut.validate(input: testStringTwo) == true)
    }

    @Test
    func validate_whenTextInputIsGreaterThanRequiredStringLength_returnsFalse() async throws {
        let sut = MaximumLengthValidator(length: 5)

        let testString = "sentence"

        #expect(sut.validate(input: testString) == false)
    }

    @Test
    func validate_whenStringIsNil_returnsFalse() {
        let sut = MaximumLengthValidator(length: 5)

        #expect(sut.validate(input: nil) == false)
    }

}
