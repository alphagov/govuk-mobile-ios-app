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
                        id: UUID().uuidString,
                        title: "App version number",
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
                        id: UUID().uuidString,
                        title: "appUsageTitle".localized,
                        isOn: hasAcceptedAnalytics,
                        action: { isOn in
                            analyticsService.setAcceptedAnalytics(accepted: isOn)
                        }
                    )
                ],
                footer: nil
            ),
            .init(
                heading: nil,
                rows: [
                    openSourceLicenseRow()
                ],
                footer: nil
            )
        ]
    }

    private func openSourceLicenseRow() -> GroupedListRow {
        let rowTitle = "settingsOpenSourceLicenseTitle".localized
        return LinkRow(
            id: UUID().uuidString,
            title: rowTitle,
            body: nil,
            action: {
                if urlOpener.openSettings() {
                    let event = AppEvent.buttonNavigation(
                        text: rowTitle,
                        external: true
                    )
                    analyticsService.track(event: event)
                }
            }
        )
    }
}
