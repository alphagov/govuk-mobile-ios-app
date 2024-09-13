import Foundation
import XCTest

@testable import govuk_ios

class SettingsViewModelTests: XCTestCase {
    
    var sut: SettingsViewModel!
    
    override func setUp() {
        super.setUp()
        sut = SettingsViewModel(
            analyticsService: MockAnalyticsService()
        )
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_title_isCorrect() {
        XCTAssertEqual(sut.title, "Settings")
    }
    
    func test_listContent_isCorrect() throws {
        continueAfterFailure = false
        XCTAssertEqual(sut.listContent.count, 2)
        continueAfterFailure = true
        
        let aboutTheAppSection = sut.listContent[0]
        XCTAssertEqual(aboutTheAppSection.heading, "About the app")
        let appVersionRow = try XCTUnwrap(aboutTheAppSection.rows.first as? InformationRow)
        XCTAssertEqual(appVersionRow.title, "App version number")
        XCTAssertEqual(appVersionRow.detail, getVersionNumber())
        
        let privacySection = sut.listContent[1]
        XCTAssertEqual(privacySection.heading, "Privacy and legal")
        let toggleRow = try XCTUnwrap(privacySection.rows.first as? ToggleRow)
        XCTAssertEqual(toggleRow.title, "Share app usage statistics")
    }
    
    func test_analytics_isToggled() throws {
        continueAfterFailure = false
        XCTAssertEqual(sut.listContent.count, 2)
        continueAfterFailure = true
        let privacySection = sut.listContent[1]
        let toggleRow = try XCTUnwrap(privacySection.rows.first as? ToggleRow)
        XCTAssertEqual(sut.analyticsService.permissionState, .accepted)
        toggleRow.isOn = false
        XCTAssertEqual(sut.analyticsService.permissionState, .denied)
        toggleRow.isOn = true
        XCTAssertEqual(sut.analyticsService.permissionState, .accepted)
    }
}

extension SettingsViewModelTests {
    func getVersionNumber() -> String? {
        let dict = Bundle.main.infoDictionary
        let versionString = dict?["CFBundleShortVersionString"] as? String
        return versionString
    }
}
