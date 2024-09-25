import Foundation
import Testing

@testable import govuk_ios

@Suite
struct JSONDecoder_ExtensionsTests {

    @Test
    func decode_success_returnsExptedResult() throws {
        let expectedTitle = UUID().uuidString
        let object = TestCodableObject(title: expectedTitle)
        let data = try JSONEncoder().encode(object)
        let result: TestCodableObject = try JSONDecoder().decode(from: data)
        #expect(result.title == expectedTitle)
    }

    @Test
    func decode_failure_returnsExptedResult() throws {
        let object = TestSecondCodableObject(count: 10)
        let data = try JSONEncoder().encode(object)
        do {
            let _: TestCodableObject = try JSONDecoder().decode(from: data)
        } catch {
            #expect(error != nil)
        }
    }
}

struct TestCodableObject: Codable {
    let title: String
}

struct TestSecondCodableObject: Codable {
    let count: Int
}
