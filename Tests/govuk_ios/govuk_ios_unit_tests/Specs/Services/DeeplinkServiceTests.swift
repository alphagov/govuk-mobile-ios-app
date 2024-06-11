import UIKit
import Foundation
import XCTest

@testable import govuk_ios

class DeeplinkServiceTests: XCTestCase {

    func test_handle_callsCompletion() {
        let subject = DeeplinkService()

        let expectation = expectation(description: #function)
        subject.handle(
            url: nil,
            completion: {
                expectation.fulfill()
            }
        )
        wait(for: [expectation], timeout: 2)
    }
}
