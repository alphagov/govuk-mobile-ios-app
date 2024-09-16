import Foundation
import XCTest

@testable import govuk_ios

class SettingsViewModelTests: XCTestCase {
    
    var sut: SettingsViewModel!
    var mockAnalyticsService: MockAnalyticsService!
    
    override func setUp() {
        super.setUp()
        mockAnalyticsService = MockAnalyticsService()
        sut = SettingsViewModel(
            analyticsService: mockAnalyticsService,
            urlOpener: MockURLOpener(),
            bundle: .main
        )
    }
    
    override func tearDown() {
        sut = nil
        mockAnalyticsService = nil
        super.tearDown()
    }
    
    func test_title_isCorrect() {
        XCTAssertEqual(sut.title, "Settings")
    }
    
    func test_listContent_isCorrect() throws {
        continueAfterFailure = false
        XCTAssertEqual(sut.listContent.count, 3)
        XCTAssertEqual(sut.listContent[2].rows.count, 2)
        continueAfterFailure = true
        
        let aboutTheAppSection = sut.listContent[0]
        XCTAssertEqual(aboutTheAppSection.heading, "About the app")
        let appVersionRow = try XCTUnwrap(aboutTheAppSection.rows.first as? InformationRow)
        XCTAssertEqual(appVersionRow.title, "App version number")
        XCTAssertEqual(appVersionRow.detail, Bundle.main.versionNumber)

        let privacySection = sut.listContent[1]
        XCTAssertEqual(privacySection.heading, "Privacy and legal")
        let toggleRow = try XCTUnwrap(privacySection.rows.first as? ToggleRow)
        XCTAssertEqual(toggleRow.title, "Share app usage statistics")
        
        let linkSection = sut.listContent[2]
        XCTAssertEqual(linkSection.rows[0].title, "Privacy policy")
        XCTAssertEqual(linkSection.rows[1].title, "Open source licenses")
        
    }
    
    func test_analytics_isToggledOnThenOff() throws {
        continueAfterFailure = false
        XCTAssertEqual(sut.listContent.count, 3)
        continueAfterFailure = true
        sut.analyticsService.setAcceptedAnalytics(accepted: true)
        let privacySection = sut.listContent[1]
        let toggleRow = try XCTUnwrap(privacySection.rows.first as? ToggleRow)
        XCTAssertTrue(toggleRow.isOn)
        toggleRow.isOn = false
        XCTAssertEqual(sut.analyticsService.permissionState, .denied)
    }
    
    func test_analytics_isToggledOffThenOn() throws {
        continueAfterFailure = false
        XCTAssertEqual(sut.listContent.count, 3)
        continueAfterFailure = true
        sut.analyticsService.setAcceptedAnalytics(accepted: false)
        let privacySection = sut.listContent[1]
        let toggleRow = try XCTUnwrap(privacySection.rows.first as? ToggleRow)
        XCTAssertFalse(toggleRow.isOn)
        toggleRow.isOn = true
        XCTAssertEqual(sut.analyticsService.permissionState, .accepted)
    }
    
    func test_privacyPolicy_action() throws {
        continueAfterFailure = false
        XCTAssertEqual(sut.listContent.count, 3)
        continueAfterFailure = true
        
        let linkSection = sut.listContent[2]
        let privacyPolicyRow = try XCTUnwrap(linkSection.rows.first as? LinkRow)
        privacyPolicyRow.action()
        let receivedTitle = mockAnalyticsService._trackedEvents.first?.params?["text"] as? String
        XCTAssertEqual(receivedTitle, privacyPolicyRow.title)
    }
    
    func test_openSettings_action() throws {
        continueAfterFailure = false
        XCTAssertEqual(sut.listContent.count, 3)
        continueAfterFailure = true
        
        let linkSection = sut.listContent[2]
        let settingsRow = try XCTUnwrap(linkSection.rows.last as? LinkRow)
        settingsRow.action()
        let receivedTitle = mockAnalyticsService._trackedEvents.first?.params?["text"] as? String
        XCTAssertEqual(receivedTitle, settingsRow.title)
    }
}
