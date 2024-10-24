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
        try #require(sut.listContent[2].rows.count == 4)

        let aboutTheAppSection = sut.listContent[0]
        #expect(aboutTheAppSection.heading == "About the app")
        let helpAndFeedbackRow = try #require(aboutTheAppSection.rows.first as? LinkRow)
        #expect(helpAndFeedbackRow.title == "Help and feedback")
        #expect(helpAndFeedbackRow.isWebLink == true)

        let appBundleInformation = try #require(aboutTheAppSection.rows[1] as? InformationRow)
        #expect(appBundleInformation.title == "App version number")
        #expect(appBundleInformation.detail == Bundle.main.versionNumber)

        let privacySection = sut.listContent[1]
        #expect(privacySection.heading == "Privacy and legal")
        let toggleRow = try #require(privacySection.rows.first as? ToggleRow)
        #expect(toggleRow.title == "Share app usage statistics")

        let linkSection = sut.listContent[2]
        #expect(linkSection.rows[0].title == "Privacy policy")
        #expect(linkSection.rows[1].title == "Accessibility statement")
        #expect(linkSection.rows[2].title == "Open source licences")
        #expect(linkSection.rows[3].title == "Terms and conditions")
    }
    
    @Test
    func analytics_toggledOnThenOff_deniesPermissions() throws {
        sut.analyticsService.setAcceptedAnalytics(accepted: true)
        let privacySection = sut.listContent[1]
        let toggleRow = try #require(privacySection.rows.first as? ToggleRow)
        #expect(toggleRow.isOn)
        toggleRow.isOn = false
        #expect(sut.analyticsService.permissionState == .denied)
    }
    
    @Test
    func analytics_toggledOffThenOn_acceptsPermissions() throws {
        sut.analyticsService.setAcceptedAnalytics(accepted: false)
        let privacySection = sut.listContent[1]
        let toggleRow = try #require(privacySection.rows.first as? ToggleRow)
        #expect(toggleRow.isOn == false)
        toggleRow.isOn = true
        #expect(sut.analyticsService.permissionState == .accepted)
    }
    
    @Test
    func privacyPolicy_action_tracksEvent() throws {
        let linkSection = sut.listContent[2]
        let privacyPolicyRow = try #require(linkSection.rows[0] as? LinkRow)
        privacyPolicyRow.action()
        let receivedTitle = mockAnalyticsService._trackedEvents.first?.params?["text"] as? String
        #expect(receivedTitle == privacyPolicyRow.title)
    }

    @Test
    func accessibilityStatement_action_tracksEvent() throws {
        let linkSection = sut.listContent[2]
        let accessibilityStatementRow = try #require(linkSection.rows[1] as? LinkRow)
        accessibilityStatementRow.action()
        let receivedTitle = mockAnalyticsService._trackedEvents.first?.params?["text"] as? String
        #expect(receivedTitle == accessibilityStatementRow.title)
    }

    @Test
    func openSourceLicences_action_tracksEvent() throws {
        let linkSection = sut.listContent[2]
        let openSourceLicencesRow = try #require(linkSection.rows[2] as? LinkRow)
        openSourceLicencesRow.action()
        let receivedTitle = mockAnalyticsService._trackedEvents.first?.params?["text"] as? String
        #expect(receivedTitle == openSourceLicencesRow.title)
    }

    @Test
    func termsAndConditions_action_tracksEvent() throws {
        let linkSection = sut.listContent[2]
        let termsAndConditionsRow = try #require(linkSection.rows[3] as? LinkRow)
        termsAndConditionsRow.action()
        let receivedTitle = mockAnalyticsService._trackedEvents.first?.params?["text"] as? String
        #expect(receivedTitle == termsAndConditionsRow.title)
    }

    @Test
    func helpAndFeedback_action_tracksEvent() throws {
        let aboutTheAppSection = sut.listContent[0]
        let helpAndFeedbackRow = try #require(aboutTheAppSection.rows.first as? LinkRow)

        helpAndFeedbackRow.action()

        let receivedTrackingTitle = mockAnalyticsService._trackedEvents.first?.params?["text"] as? String
        #expect(receivedTrackingTitle == helpAndFeedbackRow.title)
    }
}
