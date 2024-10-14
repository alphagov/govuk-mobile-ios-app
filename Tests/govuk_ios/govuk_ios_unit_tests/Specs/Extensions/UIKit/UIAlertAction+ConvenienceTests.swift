import Foundation
import UIKit
import Testing

@testable import govuk_ios

@Suite
struct UIAlertAction_ConvenienceTests {
    @Test
    func ok_returnsExpectedResult() {
        let subject = UIAlertAction.ok(handler: nil)

        #expect(subject.title == "OK")
        #expect(subject.style == .default)
    }

    @Test
    func cancel_returnsExpectedResult() {
        let subject = UIAlertAction.cancel(handler: nil)

        #expect(subject.title == "Cancel")
        #expect(subject.style == .default)
    }

    @Test
    func clearAll_returnsExpectedResult() {
        let subject = UIAlertAction.clearAll(handler: nil)

        #expect(subject.title == "Clear all")
        #expect(subject.style == .destructive)
    }
}
