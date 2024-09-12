import Foundation
import XCTest

@testable import govuk_ios

class SettingsViewModelTests: XCTestCase {
    func test_title_isCorrect() {
        let subject = SettingsViewModel()
        XCTAssertEqual(subject.title, "Settings")
    }
    
    func test_listContent_isCorrect() throws {
        let subject = SettingsViewModel()
        let listContent = try XCTUnwrap(subject.listContent.first)
        XCTAssertEqual(listContent.heading, "About the app")
        let row = try XCTUnwrap(listContent.rows.first as? InformationRow)
        XCTAssertEqual(row.title, "App version number")
        XCTAssertEqual(row.detail, getVersionNumber())
    }
}

extension SettingsViewModelTests {
    func getVersionNumber() -> String? {
        let dict = Bundle.main.infoDictionary
        let versionString = dict?["CFBundleShortVersionString"] as? String
        return versionString
    }
}
