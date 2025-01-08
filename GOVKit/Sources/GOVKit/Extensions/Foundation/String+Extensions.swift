import Foundation

extension String {
    public static var common: LocalStringBuilder {
        .init(
            tableName: "Common",
            bundle: .module
        )
    }
}

extension String {
    public struct LocalStringBuilder {
        let tableName: String
        let bundle: Bundle
        
        public init(tableName: String,
                    bundle: Bundle) {
            self.tableName = tableName
            self.bundle = bundle
        }

        public func localized(_ key: String,
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
