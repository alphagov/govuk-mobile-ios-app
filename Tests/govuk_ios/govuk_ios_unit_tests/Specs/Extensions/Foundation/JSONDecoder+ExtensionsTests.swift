import Foundation
import Testing

@testable import govuk_ios

@Suite
struct JSONDecoder_ExtensionsTests {

    @Test
    func decode_success_returnsExpectedResult() throws {
        let expectedTitle = UUID().uuidString
        let object = TestCodableObject(title: expectedTitle)
        let data = try JSONEncoder().encode(object)
        let result: TestCodableObject = try JSONDecoder().decode(from: data)
        #expect(result.title == expectedTitle)
    }

    @Test
    func decode_failure_returnsExpectedResult() throws {
        let object = TestSecondCodableObject(count: 10)
        let data = try JSONEncoder().encode(object)
        #expect(
            throws: Error.self,
            performing: {
                let _: TestCodableObject = try JSONDecoder().decode(from: data)
            }
        )
    }
}

struct TestCodableObject: Codable {
    let title: String
}

struct TestSecondCodableObject: Codable {
    let count: Int
}
