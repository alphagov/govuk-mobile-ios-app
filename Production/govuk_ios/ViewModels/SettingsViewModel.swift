import UIKit

struct SettingsViewModel {
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
                    ),
                    InformationRow(
                        title: "App version number 1",
                        body: nil,
                        detail: "1"
                    ),
                    InformationRow(
                        title: "App version number 2",
                        body: nil,
                        detail: "2"
                    ),
                    InformationRow(
                        title: "App version number 3",
                        body: nil,
                        detail: "3"
                    ),
                    InformationRow(
                        title: "App version number 4",
                        body: nil,
                        detail: "4"
                    ),
                    InformationRow(
                        title: "App version number 5",
                        body: nil,
                        detail: "5"
                    ),
                    InformationRow(
                        title: "App version number 6",
                        body: nil,
                        detail: "6"
                    ),
                    InformationRow(
                        title: "App version number 7",
                        body: nil,
                        detail: appVersion ?? "-"
                    ),
                    InformationRow(
                        title: "App version number 8",
                        body: nil,
                        detail: appVersion ?? "-"
                    ),
                    InformationRow(
                        title: "App version number 9",
                        body: nil,
                        detail: appVersion ?? "-"
                    ),
                    InformationRow(
                        title: "App version number 10",
                        body: nil,
                        detail: appVersion ?? "-"
                    ),
                    InformationRow(
                        title: "App version number 11",
                        body: nil,
                        detail: appVersion ?? "-"
                    ),
                    InformationRow(
                        title: "App version number 12",
                        body: nil,
                        detail: appVersion ?? "-"
                    ),
                    InformationRow(
                        title: "App version number 13",
                        body: nil,
                        detail: appVersion ?? "-"
                    ),
                    InformationRow(
                        title: "App version number 14",
                        body: nil,
                        detail: appVersion ?? "-"
                    ),
                    InformationRow(
                        title: "App version number 15",
                        body: nil,
                        detail: appVersion ?? "-"
                    ),
                    InformationRow(
                        title: "App version number 16",
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
