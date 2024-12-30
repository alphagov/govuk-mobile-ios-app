import Testing
import Foundation

@testable import govuk_ios

@Suite
struct StringValidatorTests {
    @Test
    func validate_valid_callsInternalValidators_returnsCorrectValue() {
        let mockOne = MockValidator()
        let mockTwo = MockValidator()
        let sut = StringValidator(
            validators: [
                mockOne,
                mockTwo
            ]
        )
        let input = "Test"
        let result = sut.validate(input: input)
        #expect(result == true)
        #expect(mockOne._validateReceivedInput == input)
        #expect(mockTwo._validateReceivedInput == input)
    }

    @Test
    func validate_invalid_returnsExpectedValue_doesntCallOtherValidators() {
        let mockOne = MockValidator()
        mockOne._stubbedValidateReturnValue = false
        let mockTwo = MockValidator()
        let sut = StringValidator(
            validators: [
                mockOne,
                mockTwo
            ]
        )
        let input = "Test"
        let result = sut.validate(input: input)
        #expect(result == false)
        #expect(mockOne._validateReceivedInput == input)
        #expect(mockTwo._validateReceivedInput == nil)
    }
}
