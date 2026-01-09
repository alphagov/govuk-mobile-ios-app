import Foundation

struct AppLaunchResponse {
    let configResult: FetchAppConfigResult
    let topicResult: FetchTopicsListResult
    let notificationConsentResult: NotificationConsentResult
    let remoteConfigFetchResult: RemoteConfigFetchResult
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
        guard case .success(let response) = configResult
        else { return false }
        return appVersionNumber.isVersion(
            lessThan: response.config.recommendedVersion
        )
    }

    private var appVersionNumber: String {
        appVersionProvider.versionNumber ?? ""
    }
}
