import Foundation
import UIKit
import XCTest

@testable import govuk_ios

class UIAlertController_ConvenienceTests: XCTestCase {
    func test_unhandledDeeplinkAlert_returnsExpectedResult() {
        let subject = UIAlertController.unhandledDeeplinkAlert

        XCTAssertEqual(subject.title, "Page not found")
        XCTAssertEqual(subject.message, "Try again later.")
        XCTAssertEqual(subject.actions.count, 1)
        XCTAssertEqual(subject.actions.first?.title, "OK")
    }

    func test_generalAlert_returnsExpectedResult() {
        let expectedTitle = UUID().uuidString
        let expectedMessage = UUID().uuidString
        let subject = UIAlertController.generalAlert(
            title: expectedTitle,
            message: expectedMessage,
            handler: nil
        )

        XCTAssertEqual(subject.title, expectedTitle)
        XCTAssertEqual(subject.message, expectedMessage)
        XCTAssertEqual(subject.actions.count, 1)
        XCTAssertEqual(subject.actions.first?.title, "OK")
    }

}
