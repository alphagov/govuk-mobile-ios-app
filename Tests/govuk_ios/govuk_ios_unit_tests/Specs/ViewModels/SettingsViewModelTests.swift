import Foundation
import UIKit
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
            notificationService: MockNotificationService(),
            notificationCenter: .default
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
    func test_notificationPermissionState_whenNotificationsPermissionStateisAuthorized_returnsCorrectState() async {
        let result = await withCheckedContinuation { continuation in
            let mockNotificationService = MockNotificationService()
            let expectedPermission: NotificationPermissionState = .authorized
            mockNotificationService._stubbededPermissionState = expectedPermission
            let sut = SettingsViewModel(
                analyticsService: MockAnalyticsService(),
                urlOpener: MockURLOpener(),
                versionProvider: MockAppVersionProvider(),
                deviceInformationProvider: MockDeviceInformationProvider(),
                notificationService: mockNotificationService,
                notificationCenter: .init()
            )
            sut.$notificationsPermissionState
                .receive(on: DispatchQueue.main)
                .sink { value in
                    guard expectedPermission == value
                    else { return }
                    continuation.resume(returning: sut.notificationsPermissionState)
                }.store(in: &cancellables)
        }
        #expect(result == .authorized)
    }

    @Test
    func notificationPermissionState_whenNotificationsPermissionStateisDenied_returnsCorrectState() async {
        let result = await withCheckedContinuation { continuation in
            let mockNotificationService = MockNotificationService()
            let expectedPermission: NotificationPermissionState = .denied
            mockNotificationService._stubbededPermissionState = expectedPermission
            let sut = SettingsViewModel(
                analyticsService: MockAnalyticsService(),
                urlOpener: MockURLOpener(),
                versionProvider: MockAppVersionProvider(),
                deviceInformationProvider: MockDeviceInformationProvider(),
                notificationService: mockNotificationService,
                notificationCenter: .init()
            )
            sut.$notificationsPermissionState
                .receive(on: DispatchQueue.main)
                .sink { value in
                    guard expectedPermission == value
                    else { return }
                    continuation.resume(returning: sut.notificationsPermissionState)
                }.store(in: &cancellables)
        }
        #expect(result == .denied)
    }


    @Test
    func notificationSettingsAlertTitle_whenNotificationsPermissionStateisAuthorized_returnsCorrectText() async {
        let result = await withCheckedContinuation { continuation in
            let mockNotificationService = MockNotificationService()
            let expectedPermission: NotificationPermissionState = .authorized
            mockNotificationService._stubbededPermissionState = expectedPermission
            let sut = SettingsViewModel(
                analyticsService: MockAnalyticsService(),
                urlOpener: MockURLOpener(),
                versionProvider: MockAppVersionProvider(),
                deviceInformationProvider: MockDeviceInformationProvider(),
                notificationService: mockNotificationService,
                notificationCenter: .init()
            )
            sut.$notificationsPermissionState
                .receive(on: DispatchQueue.main)
                .sink { value in
                    guard expectedPermission == value
                    else { return }
                    continuation.resume(returning: sut)
                }.store(in: &cancellables)
        }
        #expect(result.notificationSettingsAlertTitle == "Turn off notifications")
    }


    @Test
    func notificationSettingsAlertTitle_whenNotificationsPermissionStateisDenied_returnsCorrectText() async {
        let result = await withCheckedContinuation { continuation in
            let mockNotificationService = MockNotificationService()
            let expectedPermission: NotificationPermissionState = .denied
            mockNotificationService._stubbededPermissionState = expectedPermission
            let sut = SettingsViewModel(
                analyticsService: MockAnalyticsService(),
                urlOpener: MockURLOpener(),
                versionProvider: MockAppVersionProvider(),
                deviceInformationProvider: MockDeviceInformationProvider(),
                notificationService: mockNotificationService,
                notificationCenter: .init()
            )
            sut.$notificationsPermissionState
                .receive(on: DispatchQueue.main)
                .sink { value in
                    guard expectedPermission == value
                    else { return }
                    continuation.resume(returning: sut.notificationSettingsAlertTitle)
                }.store(in: &cancellables)
        }
        #expect(result == "Turn on notifications")
    }

    @Test
    func notificationSettingsAlertBody_whenNotificationsPermissionStateisDenied_returnsCorrectText() async {
        let result = await withCheckedContinuation { continuation in
            let mockNotificationService = MockNotificationService()
            let expectedPermission: NotificationPermissionState = .denied
            mockNotificationService._stubbededPermissionState = expectedPermission
            let sut = SettingsViewModel(
                analyticsService: MockAnalyticsService(),
                urlOpener: MockURLOpener(),
                versionProvider: MockAppVersionProvider(),
                deviceInformationProvider: MockDeviceInformationProvider(),
                notificationService: mockNotificationService,
                notificationCenter: .init()
            )
            sut.$notificationsPermissionState
                .receive(on: DispatchQueue.main)
                .sink { value in
                    guard expectedPermission == value
                    else { return }
                    continuation.resume(returning: sut.notificationSettingsAlertBody)
                }.store(in: &cancellables)
        }
        #expect(result == String.settings.localized("settingsNotificationsAlertBodyDisabled"))
    }

    @Test
    func notificationSettingsAlertBody_whenNotificationsPermissionStateisAuthorised_returnsCorrectText() async {
        let result = await withCheckedContinuation { continuation in
            let mockNotificationService = MockNotificationService()
            let expectedPermission: NotificationPermissionState = .authorized
            mockNotificationService._stubbededPermissionState = expectedPermission
            let sut = SettingsViewModel(
                analyticsService: MockAnalyticsService(),
                urlOpener: MockURLOpener(),
                versionProvider: MockAppVersionProvider(),
                deviceInformationProvider: MockDeviceInformationProvider(),
                notificationService: mockNotificationService,
                notificationCenter: .init()
            )
            sut.$notificationsPermissionState
                .receive(on: DispatchQueue.main)
                .sink { value in
                    guard expectedPermission == value
                    else { return }
                    continuation.resume(returning: sut.notificationSettingsAlertBody)
                }.store(in: &cancellables)
        }
        #expect(result == String.settings.localized("settingsNotificationsAlertBodyEnabled"))
    }

    @Test
    func notificationSettingsAlertTitle_whenAppComesIntoForegroundAfterAuthorisationDenied_returnsCorrectText() async {
        let result = await withCheckedContinuation { continuation in
            let mockNotifcationCenter = NotificationCenter()

            let mockNotificationService = MockNotificationService()
            mockNotificationService._stubbededPermissionState = .authorized
            let sut = SettingsViewModel(
                analyticsService: MockAnalyticsService(),
                urlOpener: MockURLOpener(),
                versionProvider: MockAppVersionProvider(),
                deviceInformationProvider: MockDeviceInformationProvider(),
                notificationService: mockNotificationService,
                notificationCenter: mockNotifcationCenter
            )
            let tester = SettingsViewModelTester(settingsViewModel: sut)
            let expectedPermission: NotificationPermissionState = .denied
            mockNotificationService._stubbededPermissionState = expectedPermission
            tester.objectWillChange
                .receive(on: DispatchQueue.main)
                .sink { _ in
                    guard expectedPermission == tester.settingsViewModel.notificationsPermissionState
                    else { return }
                    continuation.resume(returning: tester.settingsViewModel)
                }.store(in: &cancellables)
            mockNotifcationCenter.post(
                name: UIApplication.willEnterForegroundNotification,
                object: nil
            )
        }
        #expect(result.notificationSettingsAlertTitle == "Turn on notifications")
    }


    @Test
    func notificationSettingsAlertBody_whenAppComesIntoForegroundAfterAuthorisationDenied_returnsCorrectText() async {
        let result = await withCheckedContinuation { continuation in
            let mockNotifcationCenter = NotificationCenter()

            let mockNotificationService = MockNotificationService()
            mockNotificationService._stubbededPermissionState = .authorized
            let sut = SettingsViewModel(
                analyticsService: MockAnalyticsService(),
                urlOpener: MockURLOpener(),
                versionProvider: MockAppVersionProvider(),
                deviceInformationProvider: MockDeviceInformationProvider(),
                notificationService: mockNotificationService,
                notificationCenter: mockNotifcationCenter
            )
            let tester = SettingsViewModelTester(settingsViewModel: sut)
            let expectedPermission: NotificationPermissionState = .denied
            mockNotificationService._stubbededPermissionState = expectedPermission
            tester.objectWillChange
                .receive(on: DispatchQueue.main)
                .sink { _ in
                    guard expectedPermission == tester.settingsViewModel.notificationsPermissionState
                    else { return }
                    continuation.resume(returning: tester.settingsViewModel)
                }.store(in: &cancellables)
            mockNotifcationCenter.post(
                name: UIApplication.willEnterForegroundNotification,
                object: nil
            )
        }
        #expect(result.notificationSettingsAlertBody == String.settings.localized("settingsNotificationsAlertBodyDisabled"))
    }

    @Test
    func notificationSettingsAlertTitle_whenAppComesIntoForegroundAfterAuthorisationAccepted_returnsCorrectText() async {
        let result = await withCheckedContinuation { continuation in
            let mockNotifcationCenter = NotificationCenter()

            let mockNotificationService = MockNotificationService()
            mockNotificationService._stubbededPermissionState = .denied
            let sut = SettingsViewModel(
                analyticsService: MockAnalyticsService(),
                urlOpener: MockURLOpener(),
                versionProvider: MockAppVersionProvider(),
                deviceInformationProvider: MockDeviceInformationProvider(),
                notificationService: mockNotificationService,
                notificationCenter: mockNotifcationCenter
            )
            let tester = SettingsViewModelTester(settingsViewModel: sut)
            let expectedPermission: NotificationPermissionState = .authorized
            mockNotificationService._stubbededPermissionState = expectedPermission
            tester.objectWillChange
                .receive(on: DispatchQueue.main)
                .sink { _ in
                    guard expectedPermission == tester.settingsViewModel.notificationsPermissionState
                    else { return }
                    continuation.resume(returning: tester.settingsViewModel)
                }.store(in: &cancellables)
            mockNotifcationCenter.post(
                name: UIApplication.willEnterForegroundNotification,
                object: nil
            )
        }
        #expect(result.notificationSettingsAlertTitle == "Turn off notifications")
    }

    @Test
    func notificationSettingsAlertBody_whenAppComesIntoForegroundAfterAuthorisationAccepted_returnsCorrectText() async {
        let result = await withCheckedContinuation { continuation in
            let mockNotifcationCenter = NotificationCenter()

            let mockNotificationService = MockNotificationService()
            mockNotificationService._stubbededPermissionState = .denied
            let sut = SettingsViewModel(
                analyticsService: MockAnalyticsService(),
                urlOpener: MockURLOpener(),
                versionProvider: MockAppVersionProvider(),
                deviceInformationProvider: MockDeviceInformationProvider(),
                notificationService: mockNotificationService,
                notificationCenter: mockNotifcationCenter
            )
            let tester = SettingsViewModelTester(settingsViewModel: sut)
            let expectedPermission: NotificationPermissionState = .authorized
            mockNotificationService._stubbededPermissionState = expectedPermission
            tester.objectWillChange
                .receive(on: DispatchQueue.main)
                .sink { _ in
                    guard expectedPermission == tester.settingsViewModel.notificationsPermissionState
                    else { return }
                    continuation.resume(returning: tester.settingsViewModel)
                }.store(in: &cancellables)
            mockNotifcationCenter.post(
                name: UIApplication.willEnterForegroundNotification,
                object: nil
            )
        }
        #expect(result.notificationSettingsAlertBody == String.settings.localized("settingsNotificationsAlertBodyEnabled"))
    }

    @Test
    func handleNotificationAlertAction_authorized() async {
        let urlString = await withCheckedContinuation { continuation in
            let mockNotificationService = MockNotificationService()
            let expectedPermission: NotificationPermissionState = .authorized
            mockNotificationService._stubbededPermissionState = expectedPermission
            let mockURLOpener = MockURLOpener()
            let sut = SettingsViewModel(
                analyticsService: MockAnalyticsService(),
                urlOpener: mockURLOpener,
                versionProvider: MockAppVersionProvider(),
                deviceInformationProvider: MockDeviceInformationProvider(),
                notificationService: mockNotificationService,
                notificationCenter: .init()
            )
            sut.$notificationsPermissionState
                .receive(on: DispatchQueue.main)
                .sink { value in
                    guard expectedPermission == value
                    else { return }
                    sut.handleNotificationAlertAction()
                    let urlString = mockURLOpener._receivedOpenIfPossibleUrlString
                    continuation.resume(returning: urlString)
                }.store(in: &cancellables)
        }
        #expect(urlString == UIApplication.openSettingsURLString)
    }

    @Test
    func handleNotificationAlertAction_denied() async {
        let urlString = await withCheckedContinuation { continuation in
            let mockNotificationService = MockNotificationService()
            let expectedPermission: NotificationPermissionState = .denied
            mockNotificationService._stubbededPermissionState = expectedPermission
            let mockURLOpener = MockURLOpener()
            let sut = SettingsViewModel(
                analyticsService: MockAnalyticsService(),
                urlOpener: mockURLOpener,
                versionProvider: MockAppVersionProvider(),
                deviceInformationProvider: MockDeviceInformationProvider(),
                notificationService: mockNotificationService,
                notificationCenter: .init()
            )
            sut.$notificationsPermissionState
                .receive(on: DispatchQueue.main)
                .sink { value in
                    guard expectedPermission == value
                    else { return }
                    sut.handleNotificationAlertAction()
                    let urlString = mockURLOpener._receivedOpenIfPossibleUrlString
                    continuation.resume(returning: urlString)
                }.store(in: &cancellables)
        }
        #expect(urlString == UIApplication.openSettingsURLString)
    }

    @Test
    func handleNotificationAlertAction_whenNotificationPermissionIsAuthorized_tracksEventCorrectly()  async throws {
        let result: String = await withCheckedContinuation { continuation in
            let mockNotificationService = MockNotificationService()
            let analyticsService = MockAnalyticsService()
            let expectedPermission: NotificationPermissionState = .authorized
            mockNotificationService._stubbededPermissionState = expectedPermission
            let sut = SettingsViewModel(
                analyticsService: analyticsService,
                urlOpener: mockURLOpener,
                versionProvider: MockAppVersionProvider(),
                deviceInformationProvider: MockDeviceInformationProvider(),
                notificationService: mockNotificationService,
                notificationCenter: .init()
             )
            sut.$notificationsPermissionState
                .receive(on: DispatchQueue.main)
                .sink(
                    receiveValue: { value in
                        guard expectedPermission == value
                        else { return }
                        sut.handleNotificationAlertAction()
                        let trackingText = analyticsService._trackedEvents.first?.params?["text"]
                        as? String
                        continuation.resume(returning: trackingText!)
                    }
                ).store(in: &cancellables)
        }
        #expect(result == "Continue")
    }

    @Test
    func handleNotificationAlertAction_whenNotificationPermissionIsDenied_tracksEventCorrectly()  async throws {
        let result: String = await withCheckedContinuation { continuation in
            let mockNotificationService = MockNotificationService()
            let analyticsService = MockAnalyticsService()
            let expectedPermission: NotificationPermissionState = .denied
            mockNotificationService._stubbededPermissionState = expectedPermission
            let sut = SettingsViewModel(
                analyticsService: analyticsService,
                urlOpener: mockURLOpener,
                versionProvider: MockAppVersionProvider(),
                deviceInformationProvider: MockDeviceInformationProvider(),
                notificationService: mockNotificationService,
                notificationCenter: .init()
            )
            sut.$notificationsPermissionState
                .receive(on: DispatchQueue.main)
                .sink(
                    receiveValue: { value in
                        guard expectedPermission == value
                        else { return }
                        sut.handleNotificationAlertAction()
                        let trackingText = analyticsService._trackedEvents.first?.params?["text"]
                        as? String
                        continuation.resume(returning: trackingText!)
                    }
                ).store(in: &cancellables)
        }
        #expect(result == "Continue")
    }
}

class SettingsViewModelTester: ObservableObject {
    @Published var settingsViewModel: SettingsViewModel
    private var cancellables: Set<AnyCancellable> = []

    init(settingsViewModel: SettingsViewModel) {
        self.settingsViewModel = settingsViewModel
        observe()
    }

    private func observe() {
        settingsViewModel.objectWillChange
            .sink(receiveValue: objectWillChange.send)
            .store(in: &self.cancellables)
    }
}
