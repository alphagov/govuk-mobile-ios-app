import Foundation

extension String {
    static var common: LocalStringBuilder {
        .init(
            tableName: "Common",
            bundle: .main
        )
    }

    static var home: LocalStringBuilder {
        .init(
            tableName: "Home",
            bundle: .main
        )
    }

    static var settings: LocalStringBuilder {
        .init(
            tableName: "Settings",
            bundle: .main
        )
    }

    static var search: LocalStringBuilder {
        .init(
            tableName: "Search",
            bundle: .main
        )
    }

    static var onboarding: LocalStringBuilder {
        .init(
            tableName: "Onboarding",
            bundle: .main
        )
    }
}

extension String {
    struct LocalStringBuilder {
        let tableName: String
        let bundle: Bundle

        func localized(_ key: String,
                       comment: String = "") -> String {
            NSLocalizedString(
                key,
                tableName: tableName,
                bundle: bundle,
                comment: comment
            )
        }
    }
}
