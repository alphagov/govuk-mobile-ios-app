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
    let mockAuthenticationService = MockAuthenticationService()
    let mockLocalAuthenticationService = MockLocalAuthenticationService()

    init() {
        mockVersionProvider.versionNumber = "123"
        mockVersionProvider.buildNumber = "456"
        mockAuthenticationService._stubbedIsSignedIn = true
        mockAuthenticationService._stubbedUserEmail = "test@example.com"

        sut = SettingsViewModel(
            analyticsService: mockAnalyticsService,
            urlOpener: mockURLOpener,
            versionProvider: mockVersionProvider,
            deviceInformationProvider: mockDeviceInformationProvider,
            authenticationService: mockAuthenticationService,
            notificationService: mockNotificationsService,
            notificationCenter: .default,
            localAuthenticationService: mockLocalAuthenticationService
        )
    }

    @Test
    func title_isCorrect() {
        #expect(sut.title == "Settings")
    }

    @Test
    func listContent_isCorrect() throws {
        try #require(sut.listContent.count == 5)
        try #require(sut.listContent[0].rows.count == 2)
        try #require(sut.listContent[1].rows.count == 1)
        try #require(sut.listContent[2].rows.count == 3)
        try #require(sut.listContent[3].rows.count == 2)
        try #require(sut.listContent[4].rows.count == 4)

        let manageAccountSection = sut.listContent[0]
        #expect(manageAccountSection.heading?.title == nil)
        try #require(manageAccountSection.rows.count == 2)
        #expect(manageAccountSection.rows[0].title == "Your GOV.UK One Login")
        #expect(manageAccountSection.rows[1].title == "Manage your GOV.UK One Login")

        let signOutSection = sut.listContent[1]
        let signOutRow = try #require(signOutSection.rows.first as? DetailRow)
        #expect(signOutRow.title == "Sign out")

        let optionsSection = sut.listContent[2]
        #expect(optionsSection.heading?.title == nil)
        let notificationRow = try #require(optionsSection.rows.first as? DetailRow)
        #expect(notificationRow.title == "Notifications")
        let biometricsRow = try #require(optionsSection.rows[1] as? NavigationRow)
        #expect(biometricsRow.title == "Face ID")
        let analyticsRow = try #require(optionsSection.rows[2] as? ToggleRow)
        #expect(analyticsRow.title == "Share app usage statistics")

        let aboutSection = sut.listContent[3]
        let helpAndFeedbackRow = try #require(aboutSection.rows.last as? LinkRow)
        var openedURL: URL?
        var openedTitle: String?
        sut.openAction = { params in
            openedURL = params.url
            openedTitle = params.trackingTitle
        }
        helpAndFeedbackRow.action()
        let expectedUrl = "https://www.gov.uk/contact/govuk-app?app_version=123%20(456)&phone=Apple%20iPhone16,2%2018.1"
        #expect(helpAndFeedbackRow.title == "Help and feedback")
        #expect(openedURL?.absoluteString == expectedUrl)
        #expect(openedTitle == helpAndFeedbackRow.title)

        let appBundleInformation = try #require(aboutSection.rows.first as? InformationRow)
        #expect(appBundleInformation.title == "App version number")
        #expect(appBundleInformation.detail == "123 (456)")

        let privacyAndLegalSection = sut.listContent[4]
        #expect(privacyAndLegalSection.rows[0].title == "Privacy notice")
        #expect(privacyAndLegalSection.rows[1].title == "Accessibility statement")
        #expect(privacyAndLegalSection.rows[2].title == "Open source licences")
        #expect(privacyAndLegalSection.rows[3].title == "Terms and conditions")
    }

    @Test
    func biometrics_disabled_removesBiometricsRow() {
        mockLocalAuthenticationService._stubbedBiometricsPossible = false
        let appOptionsSection = sut.listContent[2]
        let faceIDRowExists = appOptionsSection.rows.contains { row in
            row.title == "Face ID"
        }
        #expect(!faceIDRowExists)
    }

    @Test
    func analytics_toggledOnThenOff_deniesPermissions() throws {
        mockAnalyticsService.setAcceptedAnalytics(accepted: true)
        let appOptionsSection = sut.listContent[2]
        let toggleRow = try #require(appOptionsSection.rows.last as? ToggleRow)
        #expect(toggleRow.isOn)
        toggleRow.isOn = false
        #expect(mockAnalyticsService.permissionState == .denied)
    }

    @Test
    func analytics_toggledOffThenOn_acceptsPermissions() throws {
        mockAnalyticsService.setAcceptedAnalytics(accepted: false)
        let appOptionsSection = sut.listContent[2]
        let toggleRow = try #require(appOptionsSection.rows.last as? ToggleRow)
        #expect(toggleRow.isOn == false)
        toggleRow.isOn = true
        #expect(mockAnalyticsService.permissionState == .accepted)
    }

    @Test
    func privacyPolicy_action_tracksEvent() throws {
        var receivedURL: URL?
        var receivedTitle: String?
        sut.openAction = { params in
            receivedURL = params.url
            receivedTitle = params.trackingTitle
        }
        let linkSection = sut.listContent[4]
        let privacyPolicyRow = try #require(linkSection.rows[0] as? LinkRow)
        privacyPolicyRow.action()
        #expect(receivedURL == Constants.API.privacyPolicyUrl)
        #expect(receivedTitle == privacyPolicyRow.title)
    }

    @Test
    func accessibilityStatement_action_tracksEvent() throws {
        var receivedURL: URL?
        var receivedTitle: String?
        sut.openAction = { params in
            receivedURL = params.url
            receivedTitle = params.trackingTitle
        }
        let linkSection = sut.listContent[4]
        let accessibilityStatementRow = try #require(linkSection.rows[1] as? LinkRow)
        accessibilityStatementRow.action()
        #expect(receivedURL == Constants.API.accessibilityStatementUrl)
        #expect(receivedTitle == accessibilityStatementRow.title)
    }

    @Test
    func openSourceLicences_action_tracksEvent() throws {
        let linkSection = sut.listContent[4]
        let openSourceLicencesRow = try #require(linkSection.rows[2] as? LinkRow)
        openSourceLicencesRow.action()
        let receivedTitle = mockAnalyticsService._trackedEvents.first?.params?["text"] as? String
        #expect(receivedTitle == openSourceLicencesRow.title)
    }

    @Test
    func termsAndConditions_action_tracksEvent() throws {
        var receivedURL: URL?
        var receivedTitle: String?
        sut.openAction = { params in
            receivedURL = params.url
            receivedTitle = params.trackingTitle
        }
        let linkSection = sut.listContent[4]
        let termsAndConditionsRow = try #require(linkSection.rows[3] as? LinkRow)
        termsAndConditionsRow.action()
        #expect(receivedURL == Constants.API.termsAndConditionsUrl)
        #expect(receivedTitle == termsAndConditionsRow.title)
    }

    @Test
    func helpAndFeedback_action_tracksEvent() throws {
        var receivedURL: URL?
        var receivedTitle: String?
        sut.openAction = { params in
            receivedURL = params.url
            receivedTitle = params.trackingTitle
        }
        let aboutTheAppSection = sut.listContent[3]
        let helpAndFeedbackRow = try #require(aboutTheAppSection.rows.last as? LinkRow)
        helpAndFeedbackRow.action()
        let expectedUrl = "https://www.gov.uk/contact/govuk-app?app_version=123%20(456)&phone=Apple%20iPhone16,2%2018.1"
        #expect(receivedURL?.absoluteString == expectedUrl)
        #expect(receivedTitle == helpAndFeedbackRow.title)
    }

    @Test
    func manageYourAccount_action_tracksEvent() throws {
        var receivedURL: URL?
        sut.openAction = { params in
            receivedURL = params.url
        }
        let accountSection = sut.listContent[0]
        let manageAccountRow = try #require(accountSection.rows.last as? LinkRow)

        manageAccountRow.action()

        let receivedTrackingTitle = mockAnalyticsService._trackedEvents.first?.params?["text"] as? String
        let expectedUrl = "https://home.account.gov.uk/"
        #expect(receivedURL?.absoluteString == expectedUrl)
        #expect(receivedTrackingTitle == manageAccountRow.title)
    }

    @Test
    func signOut_action_tracksEvent() throws {
        let signOutSection = sut.listContent[1]
        let signOutRow = try #require(signOutSection.rows.last as? DetailRow)

        signOutRow.action()

        let receivedTrackingTitle = mockAnalyticsService._trackedEvents.first?.params?["text"] as? String
        #expect(receivedTrackingTitle == signOutRow.title)
    }

    @MainActor
    @Test(
        .serialized,
        arguments: [
            NotificationPermissionState.authorized,
            .denied,
            .notDetermined
        ]
    )
    func notificationPermissionStates_returnCorrectState(
        _ expectedPermission: NotificationPermissionState
    ) async {
        var subscription: AnyCancellable?
        let result = await withCheckedContinuation { continuation in
            let mockNotificationService = MockNotificationService()
            mockNotificationService._stubbededPermissionState = expectedPermission
            let sut = SettingsViewModel(
                analyticsService: MockAnalyticsService(),
                urlOpener: MockURLOpener(),
                versionProvider: MockAppVersionProvider(),
                deviceInformationProvider: MockDeviceInformationProvider(),
                authenticationService: MockAuthenticationService(),
                notificationService: mockNotificationService,
                notificationCenter: .init(),
                localAuthenticationService: MockLocalAuthenticationService()
            )
            subscription = sut.$notificationsPermissionState
                .receive(on: DispatchQueue.main)
                .sink { value in
                    guard expectedPermission == value
                    else { return }
                    continuation.resume(returning: sut.notificationsPermissionState)
                    subscription?.cancel()
                }
        }
        #expect(result == expectedPermission)
    }

    @Test(arguments:
            zip([NotificationPermissionState.authorized,
                 .denied],
                [String.settings.localized("notificationsAlertTitleEnabled"),
                 String.settings.localized("notificationsAlertTitleDisabled")
                ])
    )
    func notificationSettingsAlertTitles_returnCorrectText(
        _ expectedPermission: NotificationPermissionState,
        _ expectedTitle: String
    ) async {
        var subscription: AnyCancellable?
        let result = await withCheckedContinuation { continuation in
            let mockNotificationService = MockNotificationService()
            mockNotificationService._stubbededPermissionState = expectedPermission
            let sut = SettingsViewModel(
                analyticsService: MockAnalyticsService(),
                urlOpener: MockURLOpener(),
                versionProvider: MockAppVersionProvider(),
                deviceInformationProvider: MockDeviceInformationProvider(),
                authenticationService: MockAuthenticationService(),
                notificationService: mockNotificationService,
                notificationCenter: .init(),
                localAuthenticationService: MockLocalAuthenticationService()
            )
            subscription = sut.$notificationsPermissionState
                .receive(on: DispatchQueue.main)
                .sink { value in
                    guard expectedPermission == value
                    else { return }
                    continuation.resume(returning: sut)
                    subscription?.cancel()
                }
        }
        #expect(result.notificationSettingsAlertTitle == expectedTitle)
    }

    @Test(arguments: zip([NotificationPermissionState.authorized,
                          .denied],
                         [String.settings.localized("notificationsAlertBodyEnabled"),
                          String.settings.localized("notificationsAlertBodyDisabled")
                         ])
    )
    func notificationSettingsAlertBodys_returnCorrectText(
        _ expectedPermission: NotificationPermissionState,
        _ expectedAlertBody: String
    ) async {
        var subscription: AnyCancellable?
        let result = await withCheckedContinuation { continuation in
            let mockNotificationService = MockNotificationService()
            mockNotificationService._stubbededPermissionState = expectedPermission
            let sut = SettingsViewModel(
                analyticsService: MockAnalyticsService(),
                urlOpener: MockURLOpener(),
                versionProvider: MockAppVersionProvider(),
                deviceInformationProvider: MockDeviceInformationProvider(),
                authenticationService: MockAuthenticationService(),
                notificationService: mockNotificationService,
                notificationCenter: .init(),
                localAuthenticationService: MockLocalAuthenticationService()
            )
            subscription = sut.$notificationsPermissionState
                .receive(on: DispatchQueue.main)
                .sink { value in
                    guard expectedPermission == value
                    else { return }
                    continuation.resume(returning: sut.notificationSettingsAlertBody)
                    subscription?.cancel()
                }
        }
        #expect(result == expectedAlertBody)
    }

    @Test(arguments:
            [NotificationPermissionState.authorized,
             .denied]
    )
    func handleNotificationAlertAction_opensSettings(
        _ expectedPermission: NotificationPermissionState
    ) async {
        var cancellables = Set<AnyCancellable>()
        let urlString = await withCheckedContinuation { continuation in
            let mockNotificationService = MockNotificationService()
            mockNotificationService._stubbededPermissionState = expectedPermission
            let mockURLOpener = MockURLOpener()
            let sut = SettingsViewModel(
                analyticsService: MockAnalyticsService(),
                urlOpener: mockURLOpener,
                versionProvider: MockAppVersionProvider(),
                deviceInformationProvider: MockDeviceInformationProvider(),
                authenticationService: MockAuthenticationService(),
                notificationService: mockNotificationService,
                notificationCenter: .init(),
                localAuthenticationService: MockLocalAuthenticationService()
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
        #expect(urlString == UIApplication.openNotificationSettingsURLString)
    }

    @Test(
        arguments:
            [
                NotificationPermissionState.authorized,
                .denied
            ]
    )
    func handleNotificationAlertAction_togglesConsent(
        _ expectedPermission: NotificationPermissionState
    ) async {
        var cancellables = Set<AnyCancellable>()
        let mockNotificationService = MockNotificationService()
        await withCheckedContinuation { continuation in
            mockNotificationService._stubbededPermissionState = expectedPermission
            let mockURLOpener = MockURLOpener()
            let sut = SettingsViewModel(
                analyticsService: MockAnalyticsService(),
                urlOpener: mockURLOpener,
                versionProvider: MockAppVersionProvider(),
                deviceInformationProvider: MockDeviceInformationProvider(),
                authenticationService: MockAuthenticationService(),
                notificationService: mockNotificationService,
                notificationCenter: .init(),
                localAuthenticationService: MockLocalAuthenticationService()
            )
            sut.$notificationsPermissionState
                .receive(on: DispatchQueue.main)
                .sink { value in
                    guard expectedPermission == value
                    else { return }
                    sut.handleNotificationAlertAction()
                    continuation.resume()
                }.store(in: &cancellables)
            mockURLOpener._stubbedOpenResult = true
        }
        #expect(mockNotificationService._toggleHasGivenConsentCalled)
    }

    @Test(
        arguments:
            [
                NotificationPermissionState.authorized,
                .denied
            ]
    )
    func handleNotificationAlertActions_tracksEventCorrectly(
        _ expectedPermission: NotificationPermissionState
    ) async throws {
        var cancellables = Set<AnyCancellable>()
        let result: String = await withCheckedContinuation { continuation in
            let mockNotificationService = MockNotificationService()
            let analyticsService = MockAnalyticsService()
            mockNotificationService._stubbededPermissionState = expectedPermission
            let sut = SettingsViewModel(
                analyticsService: analyticsService,
                urlOpener: mockURLOpener,
                versionProvider: MockAppVersionProvider(),
                deviceInformationProvider: MockDeviceInformationProvider(),
                authenticationService: MockAuthenticationService(),
                notificationService: mockNotificationService,
                notificationCenter: .init(),
                localAuthenticationService: MockLocalAuthenticationService()
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
    func notificationSettingsAlertTitles_whenAppComesIntoForeground_returnsCorrectText() async {
        var cancellables = Set<AnyCancellable>()
        let result = await withCheckedContinuation { continuation in
            let mockNotifcationCenter = NotificationCenter()

            let mockNotificationService = MockNotificationService()
            mockNotificationService._stubbededPermissionState = .authorized
            let sut = SettingsViewModel(
                analyticsService: MockAnalyticsService(),
                urlOpener: MockURLOpener(),
                versionProvider: MockAppVersionProvider(),
                deviceInformationProvider: MockDeviceInformationProvider(),
                authenticationService: MockAuthenticationService(),
                notificationService: mockNotificationService,
                notificationCenter: mockNotifcationCenter,
                localAuthenticationService: MockLocalAuthenticationService()
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
                    cancellables.removeAll()
                }.store(in: &cancellables)
            mockNotifcationCenter.post(
                name: UIApplication.willEnterForegroundNotification,
                object: nil
            )
        }
        #expect(result.notificationSettingsAlertTitle == String.settings.localized(
            "notificationsAlertTitleDisabled")
        )
    }

    @MainActor
    @Test
    func notificationSettingsAlertBody_whenAppComesIntoForegroundAfterAuthorisationDenied_returnsCorrectText() async {
        var cancellables = Set<AnyCancellable>()
        let result = await withCheckedContinuation { continuation in
            let mockNotifcationCenter = NotificationCenter()

            let mockNotificationService = MockNotificationService()
            mockNotificationService._stubbededPermissionState = .authorized
            let sut = SettingsViewModel(
                analyticsService: MockAnalyticsService(),
                urlOpener: MockURLOpener(),
                versionProvider: MockAppVersionProvider(),
                deviceInformationProvider: MockDeviceInformationProvider(),
                authenticationService: MockAuthenticationService(),
                notificationService: mockNotificationService,
                notificationCenter: mockNotifcationCenter,
                localAuthenticationService: MockLocalAuthenticationService()
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
                    cancellables.removeAll()
                }.store(in: &cancellables)
            mockNotifcationCenter.post(
                name: UIApplication.willEnterForegroundNotification,
                object: nil
            )
        }
        #expect(result.notificationSettingsAlertBody == String.settings.localized(
            "notificationsAlertBodyDisabled")
        )
    }

    @Test
    func notificationSettingsAlertTitle_whenAppComesIntoForegroundAfterAuthorisationAccepted_returnsCorrectText() async {
        var cancellables = Set<AnyCancellable>()
        let result = await withCheckedContinuation { continuation in
            let mockNotifcationCenter = NotificationCenter()

            let mockNotificationService = MockNotificationService()
            mockNotificationService._stubbededPermissionState = .denied
            let sut = SettingsViewModel(
                analyticsService: MockAnalyticsService(),
                urlOpener: MockURLOpener(),
                versionProvider: MockAppVersionProvider(),
                deviceInformationProvider: MockDeviceInformationProvider(),
                authenticationService: MockAuthenticationService(),
                notificationService: mockNotificationService,
                notificationCenter: mockNotifcationCenter,
                localAuthenticationService: MockLocalAuthenticationService()
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
                    cancellables.removeAll()
                }.store(in: &cancellables)
            mockNotifcationCenter.post(
                name: UIApplication.willEnterForegroundNotification,
                object: nil
            )
        }
        #expect(result.notificationSettingsAlertTitle == String.settings.localized(
            "notificationsAlertTitleEnabled")
        )
    }

    @Test
    func notificationSettingsAlertBody_whenAppComesIntoForegroundAfterAuthorisationAccepted_returnsCorrectText() async {
        var cancellables = Set<AnyCancellable>()
        let result = await withCheckedContinuation { continuation in
            let mockNotifcationCenter = NotificationCenter()

            let mockNotificationService = MockNotificationService()
            mockNotificationService._stubbededPermissionState = .denied
            let sut = SettingsViewModel(
                analyticsService: MockAnalyticsService(),
                urlOpener: MockURLOpener(),
                versionProvider: MockAppVersionProvider(),
                deviceInformationProvider: MockDeviceInformationProvider(),
                authenticationService: MockAuthenticationService(),
                notificationService: mockNotificationService,
                notificationCenter: mockNotifcationCenter,
                localAuthenticationService: MockLocalAuthenticationService()
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
                    cancellables.removeAll()
                }.store(in: &cancellables)
            mockNotifcationCenter.post(
                name: UIApplication.willEnterForegroundNotification,
                object: nil
            )
        }
        #expect(result.notificationSettingsAlertBody == String.settings.localized(
            "notificationsAlertBodyEnabled")
        )
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
