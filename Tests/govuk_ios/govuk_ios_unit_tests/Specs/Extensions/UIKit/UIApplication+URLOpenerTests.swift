import Foundation
import UIKit
import XCTest

@testable import govuk_ios

class UIApplication_URLOpenerTests: XCTestCase {
    func test_openSettings_opensExpectedURL() {
        let sut = MockURLOpener()
        sut.openSettings()

        XCTAssertEqual(sut._receivedOpenIfPossibleUrlString, UIApplication.openSettingsURLString)
    }
}
