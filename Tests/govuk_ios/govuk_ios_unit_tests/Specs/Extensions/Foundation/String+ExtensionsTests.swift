import Foundation
import UIKit
import XCTest

@testable import govuk_ios

class String_ExtensionsTests: XCTestCase {
    func test_common_hasCorrectValues() {
        let sut = String.common
        XCTAssertEqual(sut.tableName, "Common")
    }

    func test_home_hasCorrectValues() {
        let sut = String.home
        XCTAssertEqual(sut.tableName, "Home")
    }

    func test_settings_hasCorrectValues() {
        let sut = String.settings
        XCTAssertEqual(sut.tableName, "Settings")
    }

    func test_search_hasCorrectValues() {
        let sut = String.search
        XCTAssertEqual(sut.tableName, "Search")
    }

    func test_onboarding_hasCorrectValues() {
        let sut = String.onboarding
        XCTAssertEqual(sut.tableName, "Onboarding")
    }

    func test_localized_returnsExpectedResult() {
        let sut = String.LocalStringBuilder(
            tableName: "TestStrings",
            bundle: Bundle(for: self.classForCoder)
        )
        XCTAssertEqual(sut.localized("testString"), "Test string 123")
    }
}
