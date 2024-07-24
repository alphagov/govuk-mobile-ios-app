import Foundation
import XCTest

extension XCTestExpectation {

    static func new() -> XCTestExpectation {
        XCTestExpectation(description: UUID().uuidString)
    }

    func fulfillAfter(_ time: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + time) {
            self.fulfill()
        }
    }
}
