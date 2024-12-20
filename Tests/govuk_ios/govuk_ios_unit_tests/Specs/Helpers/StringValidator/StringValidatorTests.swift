import Testing
import Foundation

@testable import govuk_ios

@Suite
struct StringValidatorTests {

    @Test
    func validate_whenStringValidatorContainsMinimumLengthValidator_returnsCorrectValue() {
        let sut = StringValidator(validators: [MinimumLengthValidator(requiredStringLength: 5)])

        let testStringOne = "Seven"

        #expect(sut.validate(input: testStringOne) == true)

        let testStringTwo = "Six"

        #expect(sut.validate(input: testStringTwo) == false)
    }

    @Test
    func validate_whenStringValidatorContainsMaximumLengthValidator_returnsCorrectValue() {
        let sut = StringValidator(validators: [MaximumLengthValidator(requiredStringLength: 5)])

        let testStringOne = "Seven"

        #expect(sut.validate(input: testStringOne) == true)

        let testStringTwo = "Chromatic"

        #expect(sut.validate(input: testStringTwo) == false)
    }

}
