import Foundation

extension String {
    static var common: LocalStringBuilder {
        .init(tableName: "Common")
    }

    static var home: LocalStringBuilder {
        .init(tableName: "Home")
    }

    static var settings: LocalStringBuilder {
        .init(tableName: "Settings")
    }

    static var search: LocalStringBuilder {
        .init(tableName: "Search")
    }

    static var onboarding: LocalStringBuilder {
        .init(tableName: "Onboarding")
    }
}

extension String {
    struct LocalStringBuilder {
        let tableName: String

        func localized(_ key: String,
                       comment: String = "") -> String {
            NSLocalizedString(
                key,
                tableName: tableName,
                comment: comment
            )
        }
    }
}
