import Foundation
import UIKit
import Testing

@testable import govuk_ios

@Suite
@MainActor
struct UIAlertController_ConvenienceTests {
    @Test
    func unhandledDeeplinkAlert_returnsExpectedResult() {
        let subject = UIAlertController.unhandledDeeplinkAlert

        #expect(subject.title == "Page not found")
        #expect(subject.message == "Update the app to the latest version.\n\nIf you’re already using the latest version, try again later.")
        #expect(subject.actions.count == 1)
        #expect(subject.actions.first?.title == "Close")
    }

    @Test
    func generalAlert_returnsExpectedResult() {
        let expectedTitle = UUID().uuidString
        let expectedMessage = UUID().uuidString
        let subject = UIAlertController.generalAlert(
            title: expectedTitle,
            message: expectedMessage,
            handler: nil
        )

        #expect(subject.title == expectedTitle)
        #expect(subject.message == expectedMessage)
        #expect(subject.actions.count == 1)
        #expect(subject.actions.first?.title == "Close")
    }

    @Test
    func destructiveAlert_returnsExpectedResult() {
        let expectedTitle = UUID().uuidString
        let expectedButtonTitle = UUID().uuidString
        let expectedMessage = UUID().uuidString
        let subject = UIAlertController.destructiveAlert(
            title: expectedTitle,
            buttonTitle: expectedButtonTitle,
            message: expectedMessage,
            handler: nil
        )

        #expect(subject.title == expectedTitle)
        #expect(subject.message == expectedMessage)
        #expect(subject.actions.count == 2)
        #expect(subject.actions.first?.title == "Cancel")
        #expect(subject.actions.last?.title == expectedButtonTitle)
    }
}
