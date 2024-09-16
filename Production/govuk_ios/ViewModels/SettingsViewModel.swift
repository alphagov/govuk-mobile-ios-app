import UIKit

protocol SettingsViewModelInterface {
    var title: String { get }
    var listContent: [GroupedListSection] { get }
}

struct SettingsViewModel: SettingsViewModelInterface {
    let title: String = "settingsTitle".localized
    let analyticsService: AnalyticsServiceInterface
    let urlOpener: URLOpener
    var appVersion: String? {
        getVersionNumber()
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
                heading: "aboutTheAppHeading".localized,
                rows: [
                    InformationRow(
                        title: "appVersionTitle".localized,
                        body: nil,
                        detail: appVersion ?? "-"
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
                footer: nil
            ),
            .init(
                heading: nil,
                rows: [
                    LinkRow(
                        title: "settingsOpenSourceLicenseTitle".localized,
                        body: nil,
                        action: {
                            urlOpener.openSettings()
                        }
                    )
                ],
                footer: nil
            )
        ]
    }
}

extension SettingsViewModel {
    private func getVersionNumber() -> String? {
        let dict = Bundle.main.infoDictionary
        let versionString = dict?["CFBundleShortVersionString"] as? String
        return versionString
    }
}
