import Foundation

protocol AppVersionProvider {
    var versionNumber: String? { get }
    var buildNumber: String? { get }
}

extension AppVersionProvider {
    var fullBuildNumber: String? {
        guard let versionNumber, let buildNumber
        else { return nil }
        return "\(versionNumber) (\(buildNumber))"
    }
}

extension Bundle: AppVersionProvider {
    var versionNumber: String? {
        infoDictionary?["CFBundleShortVersionString"] as? String
    }

    var buildNumber: String? {
        infoDictionary?["CFBundleVersion"] as? String
    }
}
