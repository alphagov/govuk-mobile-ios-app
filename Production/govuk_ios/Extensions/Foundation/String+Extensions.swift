import Foundation

extension String {
    static var common: LocalStringBuilder {
        .init(
            tableName: "Common",
            bundle: .main
        )
    }

    static var appAvailability: LocalStringBuilder {
        .init(
            tableName: "AppAvailability",
            bundle: .main
        )
    }

    static var home: LocalStringBuilder {
        .init(
            tableName: "Home",
            bundle: .main
        )
    }

    static var recentActivity: LocalStringBuilder {
        .init(
            tableName: "RecentActivity",
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

 extension String {
    func redactPii() -> String {
        let postcodePattern = "([A-Za-z]{1,2}[0-9]{1,2}[A-Za-z]? *[0-9][A-Za-z]{2})"
        var redactedOutput = self.replacingOccurrences(
            of: postcodePattern, with: "[postcode]", options: .regularExpression, range: nil
        )

        let emailPattern = "[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        redactedOutput = redactedOutput.replacingOccurrences(
            of: emailPattern, with: "[email]", options: .regularExpression, range: nil
        )

        let niPattern = "[A-Za-z]{2} *[0-9]{2} *[0-9]{2} *[0-9]{2} *[A-Za-z]"
        redactedOutput = redactedOutput.replacingOccurrences(
            of: niPattern, with: "[NI number]", options: .regularExpression, range: nil
        )

        return redactedOutput
    }
 }

extension String {
    public func isVersion(lessThan targetVersion: String) -> Bool {
        return compare(toVersion: targetVersion) == .orderedAscending
    }

    private func compare(toVersion targetVersion: String) -> ComparisonResult {
        let versionDelimiter = "."
        var versionArray = self.components(separatedBy: versionDelimiter)
        var targetVersionArray = targetVersion.components(separatedBy: versionDelimiter)
        let spareCount = versionArray.count - targetVersionArray.count
        if spareCount == 0 {
            return self.compare(targetVersion, options: .numeric)
        } else {
            let spareZeros = repeatElement("0", count: abs(spareCount))
            if spareCount > 0 {
                targetVersionArray.append(contentsOf: spareZeros)
            } else {
                versionArray.append(contentsOf: spareZeros)
            }
            return versionArray.joined(separator: versionDelimiter)
                .compare(targetVersionArray.joined(separator: versionDelimiter), options: .numeric)
        }
    }
}
