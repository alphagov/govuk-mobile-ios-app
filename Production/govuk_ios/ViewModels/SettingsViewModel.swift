import UIKit

protocol SettingsViewModelInterface {
    var title: String { get }
    var listContent: [GroupedListSection] { get }
}

struct SettingsViewModel: SettingsViewModelInterface {
    let title: String = String.settings.localized("pageTitle")
    let analyticsService: AnalyticsServiceInterface
    let urlOpener: URLOpener
    let bundle: Bundle

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
                    InformationRow(
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
                        title: String.settings.localized("appUsageTitle"),
                        isOn: hasAcceptedAnalytics,
                        action: { isOn in
                            analyticsService.setAcceptedAnalytics(accepted: isOn)
                        }
                    )
                ],
                footer: String.settings.localized("appUsageFooter")
            ),
            .init(
                heading: nil,
                rows: [
                    privacyPolicyRow(),
                    openSourceLicenseRow()
                ],
                footer: nil
            )
        ]
    }

    private func privacyPolicyRow() -> GroupedListRow {
        let rowTitle = String.settings.localized("privacyPolicyRowTitle")
        return LinkRow(
            title: rowTitle,
            body: nil,
            action: {
                if urlOpener.openIfPossible(Constants.API.privacyPolicyUrl) {
                    trackLinkEvent(rowTitle)
                }
            }
        )
    }

    private func openSourceLicenseRow() -> GroupedListRow {
        let rowTitle = String.settings.localized("openSourceLicenseRowTitle")
        return LinkRow(
            title: rowTitle,
            body: nil,
            isWebLink: false,
            action: {
                if urlOpener.openSettings() {
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
}
