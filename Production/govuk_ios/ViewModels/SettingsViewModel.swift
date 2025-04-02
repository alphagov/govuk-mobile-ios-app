import UIKit
import GOVKit

protocol SettingsViewModelInterface: ObservableObject {
    var title: String { get }
    var listContent: [GroupedListSection] { get }
    func trackScreen(screen: TrackableScreen)
    var scrollToTop: Bool { get set }
    var displayNotificationSettingsAlert: Bool { get set }
    func handleNotificationAlertAction()
    var notificationSettingsAlertTitle: String { get }
    var notificationSettingsAlertBody: String { get }
    var notificationAlertButtonTitle: String { get }
    var notificationsAction: () -> Void { get set }
    func updateNotificationPermissionState()
}

// swiftlint:disable:next type_body_length
class SettingsViewModel: SettingsViewModelInterface {
    let title: String = String.settings.localized("pageTitle")
    private let analyticsService: AnalyticsServiceInterface
    private let urlOpener: URLOpener
    private let versionProvider: AppVersionProvider
    private let deviceInformationProvider: DeviceInformationProviderInterface
    @Published var scrollToTop: Bool = false
    @Published var displayNotificationSettingsAlert: Bool = false
    @Published private(set) var notificationsPermissionState: NotificationPermissionState
    = .notDetermined
    private let notificationService: NotificationServiceInterface
    private let notificationCenter: NotificationCenter
    var notificationsAction: () -> Void = {}
    var notificationAlertButtonTitle: String = String.settings.localized(
        "settingsNotificationAlertPrimaryButtonTitle"
    )

    init(analyticsService: AnalyticsServiceInterface,
         urlOpener: URLOpener,
         versionProvider: AppVersionProvider,
         deviceInformationProvider: DeviceInformationProviderInterface,
         notificationService: NotificationServiceInterface,
         notificationCenter: NotificationCenter) {
        self.analyticsService = analyticsService
        self.urlOpener = urlOpener
        self.versionProvider = versionProvider
        self.deviceInformationProvider = deviceInformationProvider
        self.notificationService = notificationService
        self.notificationCenter = notificationCenter
        updateNotificationPermissionState()
        observeAppMoveToForeground()
    }

    private func observeAppMoveToForeground() {
        notificationCenter.addObserver(
            self,
            selector: #selector(updateNotificationPermissionState),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }

    var notificationSettingsAlertTitle: String {
        if notificationsPermissionState == .authorized {
            return String.settings.localized("settingsNotificationsAlertTitleEnabled")
        } else {
            return String.settings.localized("settingsNotificationsAlertTitleDisabled")
        }
    }

    var notificationSettingsAlertBody: String {
        if notificationsPermissionState == .authorized {
            return String.settings.localized("settingsNotificationsAlertBodyEnabled")
        } else {
            return String.settings.localized("settingsNotificationsAlertBodyDisabled")
        }
    }

    @objc
     func updateNotificationPermissionState() {
         Task {
             let authorizationStatus = await notificationService.authorizationStatus
             DispatchQueue.main.async {
                 self.notificationsPermissionState = authorizationStatus
             }
         }
    }

    func handleNotificationAlertAction() {
        switch notificationsPermissionState {
        case .authorized, .denied:
            if urlOpener.openSettings() {
                trackNavigationEvent(
                    notificationAlertButtonTitle,
                    external: false
                )
            }
        default:
            break
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
        getGroupedList()
    }

    private func getGroupedList() -> [GroupedListSection] {
        var rows: [GroupedListSection] = []
        rows.append(GroupedListSection(
            heading: GroupedListHeader(
                title: String.settings.localized("aboutTheAppHeading"),
                icon: nil
            ),
            rows: [helpAndFeedbackRow(),
                   InformationRow(
                    id: "settings.version.row",
                    title: String.settings.localized("appVersionTitle"),
                    body: nil,
                    detail: versionProvider.fullBuildNumber ?? "-"
                   )
                  ],
            footer: nil)
        )
        if notificationService.isFeatureEnabled {
            rows.append(
                GroupedListSection(
                    heading: GroupedListHeader(
                        title: String.settings.localized("settingsNotificationsTitle"),
                        icon: nil
                    ),
                    rows: [notificationsSettingsRow()],
                    footer: nil)
            )
        }
        rows.append(
            GroupedListSection(
                heading: GroupedListHeader(
                    title: String.settings.localized("privacyAndLegalHeading"),
                    icon: nil
                ),
                rows: [getSettingsRows()],
                footer: String.settings.localized("appUsageFooter")
            )
        )
        rows.append(
            GroupedListSection(
                heading: nil,
                rows: getPrivacyAndLegalRows(),
                footer: nil )
        )
        return rows
    }

    private func getSettingsRows() -> GroupedListRow {
        let settingsPrivacyRow = ToggleRow(
            id: "settings.privacy.row",
            title: String.settings.localized("appUsageTitle"),
            isOn: hasAcceptedAnalytics,
            action: { [weak self] isOn in
                self?.analyticsService.setAcceptedAnalytics(
                    accepted: isOn
                )
            }
        )
        return settingsPrivacyRow
    }

    private func getPrivacyAndLegalRows() -> [GroupedListRow] {
        var rows: [GroupedListRow] = []
        rows.append(privacyPolicyRow())
        rows.append(accessibilityStatementRow())
        rows.append(openSourceLicenceRow())
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
                    self?.trackNavigationEvent(rowTitle, external: true)
                }
            }
        )
    }

    private func helpAndFeedbackRow() -> GroupedListRow {
        let rowTitle = String.settings.localized("helpAndFeedbackSettingsTitle")
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
                    self?.trackNavigationEvent(
                        rowTitle,
                        external: true
                    )
                }
            }
        )
    }

    private func notificationsSettingsRow() -> GroupedListRow {
        let rowTitle = String.settings.localized("settingsNotificationsTitle")
        return NotificationSettingsRow(
            id: "settings.notifications.row",
            title: rowTitle,
            body: nil,
            isAuthorized: notificationsPermissionState == .authorized,
            action: { [weak self] in
                if self?.notificationsPermissionState == .notDetermined {
                    self?.trackNavigationEvent(
                        String.settings.localized(rowTitle),
                        external: false
                    )
                    self?.notificationsAction()
                } else {
                    self?.displayNotificationSettingsAlert.toggle()
                }
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
            trackNavigationEvent(eventTitle, external: true)
        }
    }

    private func trackNavigationEvent(_ title: String,
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
