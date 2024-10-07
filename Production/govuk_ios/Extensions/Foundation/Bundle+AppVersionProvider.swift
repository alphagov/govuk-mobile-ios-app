import Foundation

protocol AppVersionProvider {
    var versionNumber: String? { get }
}

extension Bundle: AppVersionProvider {
    var versionNumber: String? {
        infoDictionary?["CFBundleShortVersionString"] as? String
    }
}
