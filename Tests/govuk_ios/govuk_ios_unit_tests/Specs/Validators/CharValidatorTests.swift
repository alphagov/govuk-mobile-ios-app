import Testing
import Foundation

@testable import govuk_ios

@Suite
struct CharValidatorTests {
    @Test(arguments: [
        "*",
        "-",
        "}",
        "{"
    ])
    func validate_whenInputContainsSpecialCharacters_returnsFalse(input: String) {
        let sut = CharValidator()
        #expect(sut.validate(input: "test string \(input)") == false)
    }
    
    @Test
    func validate_whenInputContainsNoSpecialCharacters_returnsTrue() {
        let sut = CharValidator()
        #expect(sut.validate(input: "test string") == true)
    }

    @Test
    func validate_whenStringIsNil_returnsFalse() {
        let sut = CharValidator()
        
        #expect(sut.validate(input: nil) == false)
    }
}
