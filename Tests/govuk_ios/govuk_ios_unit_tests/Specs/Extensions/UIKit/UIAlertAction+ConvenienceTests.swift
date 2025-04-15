import Foundation
import UIKit
import Testing

@testable import govuk_ios

@Suite
struct UIAlertAction_ConvenienceTests {
    @Test
    func close_returnsExpectedResult() {
        let subject = UIAlertAction.close(handler: nil)

        #expect(subject.title == "Close")
        #expect(subject.style == .default)
    }

    @Test
    func cancel_returnsExpectedResult() {
        let subject = UIAlertAction.cancel()

        #expect(subject.title == "Cancel")
        #expect(subject.style == .cancel)
    }

    @Test
    func destructive_returnsExpectedResult() {
        let subject = UIAlertAction.destructive(title: "Test",
                                                handler: nil)

        #expect(subject.title == "Test")
        #expect(subject.style == .destructive)
    }
}
