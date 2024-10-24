import UIKit

protocol SettingsViewModelInterface: ObservableObject {
    var title: String { get }
    var listContent: [GroupedListSection] { get }
    func trackScreen(screen: TrackableScreen)
}

class SettingsViewModel: SettingsViewModelInterface {
    let title: String = String.settings.localized("pageTitle")
    let analyticsService: AnalyticsServiceInterface
    let urlOpener: URLOpener
    let bundle: Bundle

    init(analyticsService: AnalyticsServiceInterface,
         urlOpener: URLOpener,
         bundle: Bundle) {
        self.analyticsService = analyticsService
        self.urlOpener = urlOpener
        self.bundle = bundle
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
                heading: String.settings.localized("aboutTheAppHeading"),
                rows: [
                    helpAndFeedbackRow(),
                    InformationRow(
                        id: "settings.version.row",
                        title: String.settings.localized("appVersionTitle"),
                        body: nil,
                        detail: bundle.versionNumber ?? "-"
                    )
                ],
                footer: nil
            ),
            .init(
                heading: String.settings.localized("privacyAndLegalHeading"),
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
                    termsAndConditionsRow()
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
                if self?.urlOpener.openIfPossible(Constants.API.helpAndFeedbackUrl) == true {
                    self?.trackLinkEvent(rowTitle)
                }
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

    private func termsAndConditionsRow() -> GroupedListRow {
        let rowTitle = String.settings.localized("termsAndConditionsRowTitle")
        return LinkRow(
            id: "settings.terms.row",
            title: rowTitle,
            body: nil,
            action: {
                if urlOpener.openIfPossible(Constants.API.termsAndConditionsURL) {
                    trackLinkEvent(rowTitle)
                }
            }
        )
    }

    private func accessibilityStatementRow() -> GroupedListRow {
        let rowTitle = String.settings.localized("accessibilityStatementRowTitle")
        return LinkRow(
            id: "settings.accessibility.row",
            title: rowTitle,
            body: nil,
            action: {
                if urlOpener.openIfPossible(Constants.API.accessibilityStatementURL) {
                    trackLinkEvent(rowTitle)
                }
            }
        )
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
