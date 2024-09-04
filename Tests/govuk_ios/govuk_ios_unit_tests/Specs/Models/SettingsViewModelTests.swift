import Foundation
import XCTest

@testable import govuk_ios

class SettingsViewModelTests: XCTestCase {
    func test_title_isCorrect() {
        let subject = SettingsViewModel()
        XCTAssertEqual(subject.title, "Settings")
    }
}
