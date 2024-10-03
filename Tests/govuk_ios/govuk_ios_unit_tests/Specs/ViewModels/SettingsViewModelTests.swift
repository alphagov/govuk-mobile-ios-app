import Foundation
import Testing

@testable import govuk_ios

@Suite
struct SettingsViewModelTests {

    let sut: SettingsViewModel
    let mockAnalyticsService: MockAnalyticsService

    init() {
        mockAnalyticsService = MockAnalyticsService()
        sut = SettingsViewModel(
            analyticsService: mockAnalyticsService,
            urlOpener: MockURLOpener(),
            bundle: .main
        )
    }

    @Test
    func title_isCorrect() {
        #expect(sut.title == "Settings")
    }
    
    @Test
    func listContent_isCorrect() throws {
        try #require(sut.listContent.count == 3)
        try #require(sut.listContent[2].rows.count == 2)

        let aboutTheAppSection = sut.listContent[0]
        #expect(aboutTheAppSection.heading == "About the app")
        let appVersionRow = try #require(aboutTheAppSection.rows.first as? InformationRow)
        #expect(appVersionRow.title == "App version number")
        #expect(appVersionRow.detail == Bundle.main.versionNumber)

        let privacySection = sut.listContent[1]
        #expect(privacySection.heading == "Privacy and legal")
        let toggleRow = try #require(privacySection.rows.first as? ToggleRow)
        #expect(toggleRow.title == "Share app usage statistics")

        let linkSection = sut.listContent[2]
        #expect(linkSection.rows[0].title == "Privacy policy")
        #expect(linkSection.rows[1].title == "Open source licences")
    }
    
    @Test
    func analytics_toggledOnThenOff_deniesPermissions() throws {
        #expect(sut.listContent.count == 3)

        sut.analyticsService.setAcceptedAnalytics(accepted: true)
        let privacySection = sut.listContent[1]
        let toggleRow = try #require(privacySection.rows.first as? ToggleRow)
        #expect(toggleRow.isOn)
        toggleRow.isOn = false
        #expect(sut.analyticsService.permissionState == .denied)
    }
    
    @Test
    func analytics_toggledOffThenOn_acceptsPermissions() throws {
        try #require(sut.listContent.count == 3)
        sut.analyticsService.setAcceptedAnalytics(accepted: false)
        let privacySection = sut.listContent[1]
        let toggleRow = try #require(privacySection.rows.first as? ToggleRow)
        #expect(toggleRow.isOn == false)
        toggleRow.isOn = true
        #expect(sut.analyticsService.permissionState == .accepted)
    }
    
    @Test
    func privacyPolicy_action_tracksEvent() throws {
        try #require(sut.listContent.count == 3)

        let linkSection = sut.listContent[2]
        let privacyPolicyRow = try #require(linkSection.rows.first as? LinkRow)
        privacyPolicyRow.action()
        let receivedTitle = mockAnalyticsService._trackedEvents.first?.params?["text"] as? String
        #expect(receivedTitle == privacyPolicyRow.title)
    }
    
    @Test
    func openSettings_action_tracksEvent() throws {
        try #require(sut.listContent.count == 3)

        let linkSection = sut.listContent[2]
        let settingsRow = try #require(linkSection.rows.last as? LinkRow)
        settingsRow.action()
        let receivedTitle = mockAnalyticsService._trackedEvents.first?.params?["text"] as? String
        #expect(receivedTitle == settingsRow.title)
    }
}
