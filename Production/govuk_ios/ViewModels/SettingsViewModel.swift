// swiftlint:disable file_length
import UIKit
import GOVKit
import LocalAuthentication

protocol SettingsViewModelInterface: ObservableObject {
    var title: String { get }
    var listContent: [GroupedListSection] { get }
    var scrollToTop: Bool { get set }
    var displayNotificationSettingsAlert: Bool { get set }
    var notificationSettingsAlertTitle: String { get }
    var notificationSettingsAlertBody: String { get }
    var notificationAlertButtonTitle: String { get }
    var notificationsAction: (() -> Void)? { get set }
    var localAuthenticationAction: (() -> Void)? { get set }
    var signoutAction: (() -> Void)? { get set }
    var openAction: ((SettingsViewModelURLParameters) -> Void)? { get set }

    func updateNotificationPermissionState()
    func handleNotificationAlertAction()
    func trackScreen(screen: TrackableScreen)
}

struct SettingsViewModelURLParameters {
    let url: URL
    let trackingTitle: String
    let fullScreen: Bool
}

// swiftlint:disable:next type_body_length
class SettingsViewModel: SettingsViewModelInterface {
    let title: String = String.settings.localized("pageTitle")
    private let analyticsService: AnalyticsServiceInterface
    private let urlOpener: URLOpener
    private let versionProvider: AppVersionProvider
    private let deviceInformationProvider: DeviceInformationProviderInterface
    private let authenticationService: AuthenticationServiceInterface
    private let localAuthenticationService: LocalAuthenticationServiceInterface
    @Published var scrollToTop: Bool = false
    @Published var displayNotificationSettingsAlert: Bool = false
    @Published private(set) var notificationsPermissionState: NotificationPermissionState
    = .notDetermined
    private let notificationService: NotificationServiceInterface
    private let notificationCenter: NotificationCenter
    var notificationsAction: (() -> Void)?
    var localAuthenticationAction: (() -> Void)?
    var notificationAlertButtonTitle: String = String.settings.localized(
        "notificationAlertPrimaryButtonTitle"
    )
    var signoutAction: (() -> Void)?
    var openAction: ((SettingsViewModelURLParameters) -> Void)?
    @Published var userEmail: String?

    init(analyticsService: AnalyticsServiceInterface,
         urlOpener: URLOpener,
         versionProvider: AppVersionProvider,
         deviceInformationProvider: DeviceInformationProviderInterface,
         authenticationService: AuthenticationServiceInterface,
         notificationService: NotificationServiceInterface,
         notificationCenter: NotificationCenter,
         localAuthenticationService: LocalAuthenticationServiceInterface) {
        self.analyticsService = analyticsService
        self.urlOpener = urlOpener
        self.versionProvider = versionProvider
        self.deviceInformationProvider = deviceInformationProvider
        self.authenticationService = authenticationService
        self.notificationService = notificationService
        self.notificationCenter = notificationCenter
        self.localAuthenticationService = localAuthenticationService
        updateNotificationPermissionState()
        observeAppMoveToForeground()
        setEmail()
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
        notificationsPermissionState == .authorized ?
        String.settings.localized("notificationsAlertTitleEnabled") :
        String.settings.localized("notificationsAlertTitleDisabled")
    }

    var notificationSettingsAlertBody: String {
        notificationsPermissionState == .authorized ?
        String.settings.localized("notificationsAlertBodyEnabled") :
        String.settings.localized("notificationsAlertBodyDisabled")
    }

    @objc
    func updateNotificationPermissionState() {
        Task {
            let permissionState = await notificationService.permissionState
            DispatchQueue.main.async {
                self.notificationsPermissionState = permissionState
            }
        }
    }

    func handleNotificationAlertAction() {
        guard [.authorized, .denied].contains(notificationsPermissionState),
              urlOpener.openNotificationSettings()
        else { return }
        notificationService.toggleHasGivenConsent()
        trackNavigationEvent(
            notificationAlertButtonTitle,
            external: false
        )
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

    private func setEmail() {
        Task {
            userEmail = await self.authenticationService.userEmail
        }
    }

    private func getGroupedList() -> [GroupedListSection] {
        return [
            accountSection,
            signoutSection,
            appOptionsSection,
            aboutSection,
            privacyBottomSection
        ].compactMap { $0 }
    }

    private var accountSection: GroupedListSection? {
        guard authenticationService.isSignedIn else { return nil }
        let rowTitle = String.settings.localized("manageAccountRowTitle")
        return GroupedListSection(
            heading: nil,
            rows: [
                InformationRow(
                    id: "settings.email.row",
                    title: String.settings.localized("accountRowTitle"),
                    body: userEmail,
                    imageName: "account_icon",
                    detail: ""),
                LinkRow(
                    id: "settings.account.row",
                    title: rowTitle,
                    action: { [weak self] in
                        self?.openAction?(
                            .init(
                                url: Constants.API.manageAccountURL,
                                trackingTitle: rowTitle,
                                fullScreen: true
                            )
                        )
                        self?.trackNavigationEvent(rowTitle, external: true)
                    }
                )
            ],
            footer: String.settings.localized("accountSectionFooter"))
    }

    private var signoutSection: GroupedListSection? {
        guard authenticationService.isSignedIn else { return nil }
        return GroupedListSection(
            heading: nil,
            rows: [
                DetailRow(
                    id: "settings.signout.row",
                    title: String.settings.localized("signOutRowTitle"),
                    body: "",
                    accessibilityHint: "",
                    destructive: true,
                    action: { [weak self] in
                        self?.handleSignOutPressed()
                    }
                )
            ],
            footer: nil)
    }

    private var aboutSection: GroupedListSection {
        GroupedListSection(
            heading: nil,
            rows: [
                InformationRow(
                    id: "settings.version.row",
                    title: String.settings.localized("appVersionTitle"),
                    body: nil,
                    detail: versionProvider.fullBuildNumber ?? "-"
                ),
                helpAndFeedbackRow()
            ],
            footer: nil
        )
    }

    private var appOptionsSection: GroupedListSection? {
        return GroupedListSection(
            heading: nil,
            rows: appOptionsRows(),
            footer: String.settings.localized("appUsageFooter")
        )
    }

    private var privacyBottomSection: GroupedListSection {
        GroupedListSection(
            heading: nil,
            rows: [
                privacyPolicyRow(),
                accessibilityStatementRow(),
                openSourceLicenceRow(),
                termsAndConditionsRow()
            ],
            footer: nil
        )
    }

    private func privacyPolicyRow() -> GroupedListRow {
        let rowTitle = String.settings.localized("privacyPolicyRowTitle")
        return LinkRow(
            id: "settings.policy.row",
            title: rowTitle,
            body: nil,
            action: { [weak self] in
                self?.openAction?(
                    .init(
                        url: Constants.API.privacyPolicyUrl,
                        trackingTitle: rowTitle,
                        fullScreen: false
                    )
                )
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
                let url = self.deviceInformationProvider
                    .helpAndFeedbackURL(versionProvider: self.versionProvider)
                self.openAction?(
                    .init(
                        url: url,
                        trackingTitle: rowTitle,
                        fullScreen: false
                    )
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

    private func appOptionsRows() -> [GroupedListRow] {
        var appOptionRows = [GroupedListRow]()

        if notificationService.isFeatureEnabled {
            let rowTitle = String.settings.localized("notificationsTitle")
            let isAuthorized = notificationsPermissionState == .authorized
            let notificationRow = DetailRow(
                id: "settings.notifications.row",
                title: rowTitle,
                body: isAuthorized ? String.common.localized("on") : String.common.localized("off"),
                accessibilityHint: String.settings.localized("notificationsAccessibilityHint"),
                action: { [weak self] in
                    self?.handleNotificationSettingsPressed(title: rowTitle)
                }
            )
            appOptionRows.append(notificationRow)
        }
        if localAuthenticationService.biometricsPossible {
            let biometricsTitle = switch localAuthenticationService.deviceCapableAuthType {
            case .touchID:
                String.settings.localized("touchIdTitle")
            case .faceID:
                String.settings.localized("faceIdTitle")
            default:
                ""
            }
            appOptionRows.append(biometricsRow(title: biometricsTitle))
        }
        appOptionRows.append(
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
        )
        return appOptionRows
    }

    private func biometricsRow(title: String) -> GroupedListRow {
        NavigationRow(
            id: "settings.biometrics.row",
            title: title,
            body: nil,
            action: { [weak self] in
                guard let self = self else { return }
                self.trackNavigationEvent(
                    String.settings.localized(title),
                    external: false
                )
                self.localAuthenticationAction?()
            }
        )
    }

    private func handleNotificationSettingsPressed(title: String) {
        if notificationsPermissionState == .notDetermined {
            trackNavigationEvent(
                String.settings.localized(title),
                external: false
            )
            notificationsAction?()
        } else {
            displayNotificationSettingsAlert.toggle()
        }
    }

    private func handleSignOutPressed() {
        trackNavigationEvent(
            String.settings.localized(
                String.settings.localized("signOutRowTitle")
            ),
            external: false
        )
        signoutAction?()
    }

    private func termsAndConditionsRow() -> GroupedListRow {
        let rowTitle = String.settings.localized("termsAndConditionsRowTitle")
        return LinkRow(
            id: "settings.terms.row",
            title: rowTitle,
            body: nil,
            action: { [weak self] in
                self?.openAction?(
                    .init(
                        url: Constants.API.termsAndConditionsUrl,
                        trackingTitle: rowTitle,
                        fullScreen: false
                    )
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
                self?.openAction?(
                    .init(
                        url: Constants.API.accessibilityStatementUrl,
                        trackingTitle: rowTitle,
                        fullScreen: false
                    )
                )
            }
        )
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
// swiftlint:enable file_length
