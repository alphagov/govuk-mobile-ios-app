import Testing
import Foundation

@testable import govuk_ios

@Suite
struct NonNilValidatorTests {

    @Test
    func validate_whenInputIsNil_returnsFalse() async throws {
        let sut = NonNilValidator()
        let testString = ""

        #expect(sut.validate(input: testString) == false)
    }

    @Test
    func validate_whenInputIsNotNil_returnsTrue() async throws {
        let sut = NonNilValidator()
        let testString = "Not nill"
        
        #expect(sut.validate(input: testString) == true)
    }
}
