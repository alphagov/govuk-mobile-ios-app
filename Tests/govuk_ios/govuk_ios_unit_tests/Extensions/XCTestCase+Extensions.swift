import Foundation
import XCTest

extension XCTestCase {
    
    func expectation() -> XCTestExpectation {
        expectation(description: UUID().uuidString)
    }

}
