import Testing
import Foundation

@testable import govuk_ios

struct MinimumLengthValidatorTests {
    @Test
    func validate_whenTextInputIsGreaterOrEqualThanRequiredStringLength_returnsTrue() async throws {
        let sut = MinimumLengthValidator(requiredStringLength: 5)
        let testString = "Seven"

        #expect(sut.validate(input: testString) == true)
    }

    @Test
    func validate_whenTextInputIsLessThanRequiredStringLength_returnsFalse() async throws {
        let sut = MinimumLengthValidator(requiredStringLength: 5)
        let testString = "Four"

        #expect(sut.validate(input: testString) == false)
    }
}
