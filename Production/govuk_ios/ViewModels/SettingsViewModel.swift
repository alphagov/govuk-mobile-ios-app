import UIKit
import GOVKit
import Combine
import SwiftUI

protocol SettingsViewModelInterface: ObservableObject {
    var title: String { get }
    var listContent: [GroupedListSection] { get }
    func trackScreen(screen: TrackableScreen)
    var scrollToTop: Bool { get set }
    var showNotificationUpsellAlert: Bool { get set }
    var notificationSettingsAlertText: String { get }
    func handleAlertAction()
    var alertButtonText: String { get }
    func setNotificationAuthStatus()
}

class SettingsViewModel: SettingsViewModelInterface {
    @Published var authNotifications: NotificationPermissionState = .notDetermined
    let title: String = String.settings.localized("pageTitle")
    private let analyticsService: AnalyticsServiceInterface
    private let urlOpener: URLOpener
    private let versionProvider: AppVersionProvider
    private let deviceInformationProvider: DeviceInformationProviderInterface
    @Published var scrollToTop: Bool = false
    @Published var showNotificationUpsellAlert: Bool = false
    private let dismissAction: () -> Void
    private let notificationService: NotificationServiceInterface

    init(analyticsService: AnalyticsServiceInterface,
         urlOpener: URLOpener,
         versionProvider: AppVersionProvider,
         deviceInformationProvider: DeviceInformationProviderInterface,
         notificationService: NotificationServiceInterface,
         dismissAction: @escaping () -> Void) {
        self.analyticsService = analyticsService
        self.urlOpener = urlOpener
        self.versionProvider = versionProvider
        self.deviceInformationProvider = deviceInformationProvider
        self.dismissAction = dismissAction
        self.notificationService = notificationService
        setNotificationAuthStatus()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(
            self, selector: #selector(appMovedToForeground),
            name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    @objc func appMovedToForeground() {
        setNotificationAuthStatus()
    }

    let notificationSettingsAlertText = String.settings.localized(
        "settingsPushNotificationsAlertText"
    )

    let alertButtonText = String.settings.localized(
        "settingsNotificationsAlertButtonText"
    )

     func setNotificationAuthStatus() {
         notificationService.returnUserNotificationStatus { [weak self] authSettings in
             switch authSettings.authorizationStatus {
             case .authorized:
                 DispatchQueue.main.async {
                     self?.authNotifications = .authorized
                 }
             case .denied:
                 DispatchQueue.main.async {
                     self?.authNotifications = .denied
                 }
             default:
                 self?.authNotifications = .notDetermined
             }
         }
    }

    enum NotificationPermissionState {
        case notDetermined
        case denied
        case authorized
    }
    func handleAlertAction() {
        switch authNotifications {
        case .authorized, .denied:
            urlOpener.openSettings()
            if urlOpener.openSettings() == true {
                trackLinkEvent(
                    String.settings.localized("openNotificationsSettings"),
                    external: false
                )
            }
        default:
            trackLinkEvent(
                String.settings.localized("openNotificationsSettings"),
                external: false
            )
            dismissAction()
        }
    }

    var hasAcceptedAnalytics: Bool {
        switch analyticsService.permissionState {
        case .denied, .unknown:
            return false
        case .accepted:
            return true
        }
    }

    var listContent: [GroupedListSection] {
        [
            .init(
                heading: GroupedListHeader(
                    title: String.settings.localized("aboutTheAppHeading"),
                    icon: nil
                ),
                rows: [
                    helpAndFeedbackRow(),
                    InformationRow(
                        id: "settings.version.row",
                        title: String.settings.localized("appVersionTitle"),
                        body: nil,
                        detail: versionProvider.fullBuildNumber ?? "-"
                    )
                ],
                footer: nil
            ),
            .init(
                heading: GroupedListHeader(
                    title: String.settings.localized("privacyAndLegalHeading"),
                    icon: nil
                ),
                rows: [
                    ToggleRow(
                        id: "settings.privacy.row",
                        title: String.settings.localized("appUsageTitle"),
                        isOn: hasAcceptedAnalytics,
                        action: { [weak self] isOn in
                            self?.analyticsService.setAcceptedAnalytics(
                                accepted: isOn
                            )
                        }
                    )
                ],
                footer: String.settings.localized("appUsageFooter")
            ),
            .init(
                heading: nil,
                rows: returnPrivacyAndLegalRows(),
                footer: nil
            )
        ]
    }

    private func returnPrivacyAndLegalRows() -> [GroupedListRow] {
        var rows: [GroupedListRow] = []
        rows.append(privacyPolicyRow())
        rows.append(accessibilityStatementRow())
        rows.append(openSourceLicenceRow())
        if notificationService.isFeatureEnabled {
            rows.append(notificationsSettingsRow())
        }
        rows.append(termsAndConditionsRow())
        return rows
    }

    private func privacyPolicyRow() -> GroupedListRow {
        let rowTitle = String.settings.localized("privacyPolicyRowTitle")
        return LinkRow(
            id: "settings.policy.row",
            title: rowTitle,
            body: nil,
            action: { [weak self] in
                if self?.urlOpener.openIfPossible(Constants.API.privacyPolicyUrl) == true {
                    self?.trackLinkEvent(rowTitle, external: true)
                }
            }
        )
    }

    private func helpAndFeedbackRow() -> GroupedListRow {
        let rowTitle = String.settings.localized(
            "helpAndFeedbackSettingsTitle"
        )

        return LinkRow(
            id: "settings.helpAndfeedback.row",
            title: rowTitle,
            body: nil,
            action: { [weak self] in
                guard let self else { return }
                self.openURLIfPossible(
                    url: self.deviceInformationProvider.helpAndFeedbackURL(
                        versionProvider: self.versionProvider
                    ),
                    eventTitle: rowTitle
                )
            }
        )
    }

    private func openSourceLicenceRow() -> GroupedListRow {
        let rowTitle = String.settings.localized("openSourceLicenceRowTitle")
        return LinkRow(
            id: "settings.licence.row",
            title: rowTitle,
            body: nil,
            action: { [weak self] in
                if self?.urlOpener.openSettings() == true {
                    self?.trackLinkEvent(rowTitle, external: true)
                }
            }
        )
    }

    private func notificationsSettingsRow() -> GroupedListRow {
        let rowTitle = String.settings.localized("openNotificationsSettings")
        return NotificationSettingsRow(
            id: "settings.notifications.row",
            title: rowTitle,
            body: nil,
            isAuthorized: authNotifications == .authorized ? true : false,
            action: { [weak self] in
                self?.showNotificationUpsellAlert.toggle()
            }
        )
    }

    private func termsAndConditionsRow() -> GroupedListRow {
        let rowTitle = String.settings.localized("termsAndConditionsRowTitle")
        return LinkRow(
            id: "settings.terms.row",
            title: rowTitle,
            body: nil,
            action: { [weak self] in
                self?.openURLIfPossible(
                    url: Constants.API.termsAndConditionsUrl,
                    eventTitle: rowTitle
                )
            }
        )
    }

    private func accessibilityStatementRow() -> GroupedListRow {
        let rowTitle = String.settings.localized("accessibilityStatementRowTitle")
        return LinkRow(
            id: "settings.accessibility.row",
            title: rowTitle,
            body: nil,
            action: { [weak self] in
                self?.openURLIfPossible(
                    url: Constants.API.accessibilityStatementUrl,
                    eventTitle: rowTitle
                )
            }
        )
    }

    private func openURLIfPossible(url: URL,
                                   eventTitle: String) {
        if urlOpener.openIfPossible(url) {
            trackLinkEvent(eventTitle, external: true)
        }
    }

    private func trackLinkEvent(_ title: String,
                                external: Bool) {
        let event = AppEvent.buttonNavigation(
            text: title,
            external: external
        )
        analyticsService.track(event: event)
    }

    func trackScreen(screen: TrackableScreen) {
        analyticsService.track(screen: screen)
    }
}
