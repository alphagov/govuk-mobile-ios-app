import Foundation
import Testing
import Combine

@testable import govuk_ios
@testable import GOVKit
@testable import GOVKitTestUtilities

@Suite(.serialized)
class SettingsViewModelTests {

    let sut: SettingsViewModel
    let mockAnalyticsService: MockAnalyticsService = MockAnalyticsService()
    let mockURLOpener: MockURLOpener = MockURLOpener()
    let mockVersionProvider = MockAppVersionProvider()
    let mockDeviceInformationProvider = MockDeviceInformationProvider()
    let mockNotificationsService = MockNotificationService()
    private var cancellables = Set<AnyCancellable>()

    init() {
        mockVersionProvider.versionNumber = "123"
        mockVersionProvider.buildNumber = "456"

        sut = SettingsViewModel(
            analyticsService: mockAnalyticsService,
            urlOpener: mockURLOpener,
            versionProvider: mockVersionProvider,
            deviceInformationProvider: mockDeviceInformationProvider,
            notificationService: MockNotificationService()
        )
    }

    @Test
    func title_isCorrect() {
        #expect(sut.title == "Settings")
    }

    @Test
    func listContent_isCorrect() throws {
        try #require(sut.listContent.count == 4)
        try #require(sut.listContent[2].rows.count == 1)
        try #require(sut.listContent[3].rows.count == 4)

        let aboutTheAppSection = sut.listContent[0]
        #expect(aboutTheAppSection.heading?.title == "About the app")

        let helpAndFeedbackRow = try #require(aboutTheAppSection.rows.first as? LinkRow)
        let expectedUrl = "https://www.gov.uk/contact/govuk-app?app_version=123%20(456)&phone=Apple%20iPhone16,2%2018.1"
        helpAndFeedbackRow.action()
        #expect(helpAndFeedbackRow.title == "Help and feedback")
        #expect(helpAndFeedbackRow.isWebLink == true)
        #expect(mockURLOpener._receivedOpenIfPossibleUrl?.absoluteString == expectedUrl)

        let appBundleInformation = try #require(aboutTheAppSection.rows[1] as? InformationRow)
        #expect(appBundleInformation.title == "App version number")
        #expect(appBundleInformation.detail == "123 (456)")

        let notificationsSection = sut.listContent[1]
        #expect(notificationsSection.heading?.title == "Notifications")
        let notificationRow = try #require(notificationsSection.rows.first as? NotificationSettingsRow)
        #expect(notificationRow.title == "Notifications")

        let privacyAndLegalSection = sut.listContent[3]
        #expect(privacyAndLegalSection.rows[0].title == "Privacy notice")
        #expect(privacyAndLegalSection.rows[1].title == "Accessibility statement")
        #expect(privacyAndLegalSection.rows[2].title == "Open source licences")
        #expect(privacyAndLegalSection.rows[3].title == "Terms and conditions")
    }

    @Test
    func analytics_toggledOnThenOff_deniesPermissions() throws {
        mockAnalyticsService.setAcceptedAnalytics(accepted: true)
        let privacySection = sut.listContent[2]
        let toggleRow = try #require(privacySection.rows.first as? ToggleRow)
        #expect(toggleRow.isOn)
        toggleRow.isOn = false
        #expect(mockAnalyticsService.permissionState == .denied)
    }

    @Test
    func analytics_toggledOffThenOn_acceptsPermissions() throws {
        mockAnalyticsService.setAcceptedAnalytics(accepted: false)
        let privacySection = sut.listContent[2]
        let toggleRow = try #require(privacySection.rows.first as? ToggleRow)
        #expect(toggleRow.isOn == false)
        toggleRow.isOn = true
        #expect(mockAnalyticsService.permissionState == .accepted)
    }

    @Test
    func privacyPolicy_action_tracksEvent() throws {
        let linkSection = sut.listContent[3]
        let privacyPolicyRow = try #require(linkSection.rows[0] as? LinkRow)
        privacyPolicyRow.action()
        let receivedTitle = mockAnalyticsService._trackedEvents.first?.params?["text"] as? String
        #expect(mockURLOpener._receivedOpenIfPossibleUrl == Constants.API.privacyPolicyUrl)
        #expect(receivedTitle == privacyPolicyRow.title)
    }

    @Test
    func accessibilityStatement_action_tracksEvent() throws {
        let linkSection = sut.listContent[3]
        let accessibilityStatementRow = try #require(linkSection.rows[1] as? LinkRow)
        accessibilityStatementRow.action()
        let receivedTitle = mockAnalyticsService._trackedEvents.first?.params?["text"] as? String
        #expect(mockURLOpener._receivedOpenIfPossibleUrl == Constants.API.accessibilityStatementUrl)
        #expect(receivedTitle == accessibilityStatementRow.title)
    }

    @Test
    func openSourceLicences_action_tracksEvent() throws {
        let linkSection = sut.listContent[3]
        let openSourceLicencesRow = try #require(linkSection.rows[2] as? LinkRow)
        openSourceLicencesRow.action()
        let receivedTitle = mockAnalyticsService._trackedEvents.first?.params?["text"] as? String
        #expect(receivedTitle == openSourceLicencesRow.title)
    }

    @Test
    func termsAndConditions_action_tracksEvent() throws {
        let linkSection = sut.listContent[3]
        let termsAndConditionsRow = try #require(linkSection.rows[3] as? LinkRow)
        termsAndConditionsRow.action()
        let receivedTitle = mockAnalyticsService._trackedEvents.first?.params?["text"] as? String
        #expect(mockURLOpener._receivedOpenIfPossibleUrl == Constants.API.termsAndConditionsUrl)
        #expect(receivedTitle == termsAndConditionsRow.title)
    }

    @Test
    func helpAndFeedback_action_tracksEvent() throws {
        let aboutTheAppSection = sut.listContent[0]
        let helpAndFeedbackRow = try #require(aboutTheAppSection.rows.first as? LinkRow)

        helpAndFeedbackRow.action()

        let receivedTrackingTitle = mockAnalyticsService._trackedEvents.first?.params?["text"] as? String
        let expectedUrl = "https://www.gov.uk/contact/govuk-app?app_version=123%20(456)&phone=Apple%20iPhone16,2%2018.1"
        #expect(mockURLOpener._receivedOpenIfPossibleUrl?.absoluteString == expectedUrl)
        #expect(receivedTrackingTitle == helpAndFeedbackRow.title)
    }

    @Test
    func notificationPermissionState_whenNotificationPermissionIsDenied_isSetToDenied() async throws {
        let sut = SettingsViewModel(
            analyticsService: MockAnalyticsService(),
            urlOpener: MockURLOpener(),
            versionProvider: mockVersionProvider,
            deviceInformationProvider: mockDeviceInformationProvider,
            notificationService: mockNotificationsService
        )

        let result = await withCheckedContinuation { continutation in
            sut.$notificationsPermissionState
                .dropFirst()
                .receive(on: DispatchQueue.main)
                .sink(
                    receiveValue: { value in
                        continutation.resume(returning: value)
                    }
                ).store(in: &cancellables)
            mockNotificationsService._receivedCompletion?(.denied)
        }
        #expect(result == .denied)
    }

    @Test
    func notificationPermissionState_whenNotificationPermissionIsAuthorized_isSetToAuthorized() async throws {
        let sut = SettingsViewModel(
            analyticsService: MockAnalyticsService(),
            urlOpener: MockURLOpener(),
            versionProvider: mockVersionProvider,
            deviceInformationProvider: mockDeviceInformationProvider,
            notificationService: mockNotificationsService
        )

        let result = await withCheckedContinuation { continutation in
            sut.$notificationsPermissionState
                .dropFirst()
                .receive(on: DispatchQueue.main)
                .sink(
                    receiveValue: { value in
                        continutation.resume(returning: value)
                    }
                ).store(in: &cancellables)
            mockNotificationsService._receivedCompletion?(.authorized)
        }
        #expect(result == .authorized)
    }

    @Test
    func notificationSettingsAlertTitle_whenNotificationPermissionIsAuthorized_setsCorrectTitle() async  {
        let sut = SettingsViewModel(
            analyticsService: MockAnalyticsService(),
            urlOpener: MockURLOpener(),
            versionProvider: mockVersionProvider,
            deviceInformationProvider: mockDeviceInformationProvider,
            notificationService: mockNotificationsService
        )

        let result = await withCheckedContinuation { continutation in
            sut.$notificationsPermissionState
                .dropFirst()
                .receive(on: DispatchQueue.main)
                .sink(
                    receiveValue: { value in
                        continutation.resume(returning: sut.notificationSettingsAlertTitle)
                    }
                ).store(in: &cancellables)
            mockNotificationsService._receivedCompletion?(.authorized)
        }
        #expect(result == String.settings.localized("settingsNotificationsAlertTitleEnabled"))
    }

    @Test
    func notificationSettingsAlertTitle_whenNotificationPermissionIsDenied_setsCorrectTitle() async  {
        let sut = SettingsViewModel(
            analyticsService: MockAnalyticsService(),
            urlOpener: MockURLOpener(),
            versionProvider: mockVersionProvider,
            deviceInformationProvider: mockDeviceInformationProvider,
            notificationService: mockNotificationsService
        )

        let result = await withCheckedContinuation { continutation in
            sut.$notificationsPermissionState
                .dropFirst()
                .receive(on: DispatchQueue.main)
                .sink(
                    receiveValue: { value in
                        continutation.resume(returning: sut.notificationSettingsAlertTitle)
                    }
                ).store(in: &cancellables)
            mockNotificationsService._receivedCompletion?(.denied)
        }
        #expect(result == String.settings.localized("settingsNotificationsAlertTitleDisabled"))
    }

    @Test
    func notificationSettingsAlertBody_whenNotificationPermissionIsAuthorized_setsCorrectText() async {
        let sut = SettingsViewModel(
            analyticsService: MockAnalyticsService(),
            urlOpener: MockURLOpener(),
            versionProvider: mockVersionProvider,
            deviceInformationProvider: mockDeviceInformationProvider,
            notificationService: mockNotificationsService
        )

        let result = await withCheckedContinuation { continutation in
            sut.$notificationsPermissionState
                .dropFirst()
                .receive(on: DispatchQueue.main)
                .sink(
                    receiveValue: { value in
                        continutation.resume(returning: sut.notificationSettingsAlertBody)
                    }
                ).store(in: &cancellables)
            mockNotificationsService._receivedCompletion?(.authorized)
        }
        #expect(result == String.settings.localized("settingsNotificationsAlertBodyEnabled"))

    }

    @Test
    func notificationSettingsAlertBody_whenNotificationPermissionIsDenied_setsCorrectText() async {
        let sut = SettingsViewModel(
            analyticsService: MockAnalyticsService(),
            urlOpener: MockURLOpener(),
            versionProvider: mockVersionProvider,
            deviceInformationProvider: mockDeviceInformationProvider,
            notificationService: mockNotificationsService
        )

        let result = await withCheckedContinuation { continutation in
            sut.$notificationsPermissionState
                .dropFirst()
                .receive(on: DispatchQueue.main)
                .sink(
                    receiveValue: { value in
                        continutation.resume(returning: sut.notificationSettingsAlertBody)
                    }
                ).store(in: &cancellables)
            mockNotificationsService._receivedCompletion?(.denied)
        }
        #expect(result == String.settings.localized("settingsNotificationsAlertBodyDisabled"))

    }

    @Test
    func handleNotificationAlertAction_whenNotificationPermissionIsDenied_tracksEventCorrectly()  async throws {
        let notiifcationservice = MockNotificationService()
        let analyticsService = MockAnalyticsService()
        var receivedTitle = ""
        let result = await withCheckedContinuation { continuation in
            let sut = SettingsViewModel(
                analyticsService: analyticsService,
                urlOpener: MockURLOpener(),
                versionProvider: mockVersionProvider,
                deviceInformationProvider: mockDeviceInformationProvider,
                notificationService: notiifcationservice
            )
            sut.$notificationsPermissionState
                .dropFirst()
                .receive(on: DispatchQueue.main)
                .sink(
                    receiveValue: { _ in
                        sut.handleNotificationAlertAction()
                        let trackingText = analyticsService._trackedEvents.first?.params?["text"]
                        as? String
                        receivedTitle = trackingText!
                        continuation.resume(returning: sut.notificationAlertButtonTitle)
                    }
                ).store(in: &cancellables)
            notiifcationservice._receivedCompletion?(.denied)
        }
        #expect(receivedTitle == result)
    }

    @Test
    func handleNotificationAlertAction_whenNotificationPermissionIsAuthorized_tracksEventCorrectly()  async throws {
        let notiifcationservice = MockNotificationService()
        let analyticsService = MockAnalyticsService()
        var receivedTrackingTitle = ""
        let result = await withCheckedContinuation { continuation in
            let sut = SettingsViewModel(
                analyticsService: analyticsService,
                urlOpener: MockURLOpener(),
                versionProvider: mockVersionProvider,
                deviceInformationProvider: mockDeviceInformationProvider,
                notificationService: notiifcationservice
            )

            sut.$notificationsPermissionState
                .dropFirst()
                .receive(on: DispatchQueue.main)
                .sink(
                    receiveValue: { _ in
                        sut.handleNotificationAlertAction()
                        let trackingText = analyticsService._trackedEvents.first?.params?["text"]
                        as? String
                        receivedTrackingTitle = trackingText!
                        continuation.resume(returning: sut.notificationAlertButtonTitle)
                    }
                ).store(in: &cancellables)
            notiifcationservice._receivedCompletion?(.authorized)
        }
        #expect(receivedTrackingTitle == result)
    }
}

