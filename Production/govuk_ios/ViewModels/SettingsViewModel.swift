import UIKit

protocol SettingsViewModelProtocol {
    var title: String { get }
    var listContent: [GroupedListSection] { get }
}

struct SettingsViewModel: SettingsViewModelProtocol {
    var title: String = "Settings"
    var appVersion: String? {
        getVersionNumber()
    }

    var listContent: [GroupedListSection] {
        [
            .init(
                heading: "About the app",
                rows: [
                    InformationRow(
                        title: "App version number",
                        body: nil,
                        detail: appVersion ?? "-"
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
