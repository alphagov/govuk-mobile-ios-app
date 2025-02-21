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
    var notificationUpSellText: String { get }
    func handleAlertAction()
}

class SettingsViewModel: SettingsViewModelInterface {
    var showUpsell = PassthroughSubject<Bool, Error>()
    let title: String = String.settings.localized("pageTitle")
    private let analyticsService: AnalyticsServiceInterface
    private let urlOpener: URLOpener
    private let versionProvider: AppVersionProvider
    private let deviceInformationProvider: DeviceInformationProviderInterface
    private var notificationpPermissionState: NotificationPermissionState?
    @Published var scrollToTop: Bool = false
    @Published var showNotificationUpsellAlert: Bool = false

    init(analyticsService: AnalyticsServiceInterface,
         urlOpener: URLOpener,
         versionProvider: AppVersionProvider,
         deviceInformationProvider: DeviceInformationProviderInterface) {
        self.analyticsService = analyticsService
        self.urlOpener = urlOpener
        self.versionProvider = versionProvider
        self.deviceInformationProvider = deviceInformationProvider
        checkNotificationPermissionStatus()
    }

    enum NotificationPermissionState {
        case notDetermined
        case denied
        case authorized
    }
    // create callback to show onboarding notficaitons
    // remember to put this behind a feature flagg 

    private func checkNotificationPermissionStatus() {
        let current = UNUserNotificationCenter.current()
        current.getNotificationSettings(completionHandler: { [weak self] (settings) in
            switch settings.authorizationStatus {
            case .authorized:
                self?.notificationpPermissionState = .authorized
            case .denied:
                self?.notificationpPermissionState = .denied
            default:
                self?.notificationpPermissionState = .notDetermined
            }
        })
    }

    var notificationUpSellText: String {
        switch notificationpPermissionState {
        case .authorized:
            return" auth"
        case .denied:
            return "denied"
        default:
            // handle undetermined case
            return "undetermined"
        }
    }

    internal func handleAlertAction() {
        switch notificationpPermissionState {
        case .authorized, .denied:
            urlOpener.openSettings()
        default:
            // handle undetermined case
            print("undetermined")
        }
    }

    private var hasAcceptedAnalytics: Bool {
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
                rows: [
                    privacyPolicyRow(),
                    accessibilityStatementRow(),
                    openSourceLicenceRow(),
                    termsAndConditionsRow(),
                    notificationsSettingsRow()
                ],
                footer: nil
            )
        ]
    }

    private func privacyPolicyRow() -> GroupedListRow {
        let rowTitle = String.settings.localized("privacyPolicyRowTitle")
        return LinkRow(
            id: "settings.policy.row",
            title: rowTitle,
            body: nil,
            action: { [weak self] in
                if self?.urlOpener.openIfPossible(Constants.API.privacyPolicyUrl) == true {
                    self?.trackLinkEvent(rowTitle)
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
                    self?.trackLinkEvent(rowTitle)
                }
            }
        )
    }

    private func notificationsSettingsRow() -> GroupedListRow {
        let rowTitle = String.settings.localized("openNotificationsSettings")
        return LinkRow(
            id: "settings.notifications.row",
            title: rowTitle,
            body: nil,
            action: { [weak self] in
                self?.showNotificationUpsellAlert = true
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
            trackLinkEvent(eventTitle)
        }
    }

    private func trackLinkEvent(_ title: String) {
        let event = AppEvent.buttonNavigation(
            text: title,
            external: true
        )
        analyticsService.track(event: event)
    }

    func trackScreen(screen: TrackableScreen) {
        analyticsService.track(screen: screen)
    }
}
