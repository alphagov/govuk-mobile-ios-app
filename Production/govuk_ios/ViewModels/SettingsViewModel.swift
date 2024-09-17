import UIKit

protocol SettingsViewModelInterface {
    var title: String { get }
    var listContent: [GroupedListSection] { get }
}

struct SettingsViewModel: SettingsViewModelInterface {
    let title: String = "settingsTitle".localized
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
                heading: "aboutTheAppHeading".localized,
                rows: [
                    InformationRow(
                        title: "appVersionTitle".localized,
                        body: nil,
                        detail: bundle.versionNumber ?? "-"
                    )
                ],
                footer: nil
            ),
            .init(
                heading: "privacyAndLegalHeading".localized,
                rows: [
                    ToggleRow(
                        title: "appUsageTitle".localized,
                        isOn: hasAcceptedAnalytics,
                        action: { isOn in
                            analyticsService.setAcceptedAnalytics(accepted: isOn)
                        }
                    )
                ],
                footer: "appUsageFooter".localized
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
        let rowTitle = "privacyPolicyTitle".localized
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
        let rowTitle = "settingsOpenSourceLicenseTitle".localized
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
