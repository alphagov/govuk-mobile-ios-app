import Foundation

protocol AppVersionProvider {
    var versionNumber: String? { get }
}

extension Bundle: AppVersionProvider {}
