import Testing
import Foundation

@testable import govuk_ios

@Suite
struct StringValidatorTests {

    @Test
    func validate_whenStringValidatorContainsNonNillValidator_returnsCorrectValue() async throws {
        let sut = StringValidator(validators: [NonNilValidator()])

        let testStringOne = "Seven"

        #expect(sut.validate(input: testStringOne) == true)

        let testStringTwo = ""

        #expect(sut.validate(input: testStringTwo) == false)
    }

    @Test
    func validate_whenStringValidatorContainsLengthValidator_returnsCorrectValue() async throws {
        let sut = StringValidator(validators: [MaximumLengthValidator(requiredStringLength: 5)])

        let testStringOne = "Seven"

        #expect(sut.validate(input: testStringOne) == true)

        let testStringTwo = "Six"

        #expect(sut.validate(input: testStringTwo) == false)
    }

    @Test
    func validate_whenStringValidatorContainsLengthValidatorAndNonNilVlidator_returnsCorrectValue() async throws {
        let sut = StringValidator(validators: [MaximumLengthValidator(requiredStringLength: 5), NonNilValidator()])

        let testString = "Six"

        #expect(sut.validate(input: testString) == false)
    }
}
