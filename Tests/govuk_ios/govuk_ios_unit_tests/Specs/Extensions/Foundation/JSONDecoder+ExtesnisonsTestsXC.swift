import Foundation
import XCTest

@testable import govuk_ios

final class JSONDecoder_ExtesnisonsTestsXC: XCTestCase {

    func test_decode_success_returnsExptedResult() throws {
        let expectedTitle = UUID().uuidString
        let object = TestCodableObject(title: expectedTitle)
        let data = try JSONEncoder().encode(object)
        let result: TestCodableObject = try JSONDecoder().decode(from: data)
        XCTAssertEqual(result.title, expectedTitle)
    }

    func test_decode_failure_returnsExptedResult() throws {
        let object = TestSecondCodableObject(count: 10)
        let data = try JSONEncoder().encode(object)
        do {
            let _: TestCodableObject = try JSONDecoder().decode(from: data)
        } catch {
            XCTAssertNotNil(error)
        }
    }
}
