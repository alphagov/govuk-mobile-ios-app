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
}
