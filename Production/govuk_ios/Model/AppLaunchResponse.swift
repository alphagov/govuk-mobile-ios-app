import Foundation

struct AppLaunchResponse {
    let configResult: FetchAppConfigResult
    let topicResult: FetchTopicsListResult
    let appVersionProvider: AppVersionProvider

    var isAppAvailable: Bool {
        guard let result = try? configResult.get()
        else { return false }
        return result.config.available
    }

    var isUpdateRequired: Bool {
        switch configResult {
        case .failure(.invalidSignature):
            return true
        case .success(let response):
            return appVersionNumber.isVersion(
                lessThan: response.config.minimumVersion
            )
        default:
            return false
        }
    }

    var isUpdateRecommended: Bool {
        switch configResult {
        case .success(let response):
            return appVersionNumber.isVersion(
                lessThan: response.config.recommendedVersion
            )
        default:
            return false
        }
    }

    private var appVersionNumber: String {
        appVersionProvider.versionNumber ?? ""
    }
}
