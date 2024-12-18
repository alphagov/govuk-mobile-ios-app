import Testing
import Foundation

@testable import govuk_ios

@Suite
struct CharValidatorTests {

    @Test
    func validate_whenInputContainsSpecialCharactersReturnsFalse() async throws {
        let sut = CharValidator()
        let testString = "hello:!*u"

        #expect(sut.validate(input: testString) == false)
    }

}
