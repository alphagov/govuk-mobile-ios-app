import UIKit

protocol SettingsViewModelProtocol {
    var title: String { get }
    var listContent: [GroupedListSection] { get }
}

struct SettingsViewModel: SettingsViewModelProtocol {
    var title: String = "settingsTitle".localized
    var analyticsService: AnalyticsServiceInterface
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
            .init(heading: "privacyAndLegalHeading".localized,
                  rows: [
                    ToggleRow(title: "appUsageTitle".localized,
                            isOn: hasAcceptedAnalytics,
                            action: { isOn in
                                analyticsService.setAcceptedAnalytics(accepted: isOn)
                            })],
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
