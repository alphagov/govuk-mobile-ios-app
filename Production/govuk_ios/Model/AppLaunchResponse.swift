import Foundation

struct AppLaunchResponse {
    let configResult: FetchAppConfigResult
    let topicResult: FetchTopicsListResult
    let notificationConsentResult: NotificationConsentResult
    let appVersionProvider: AppVersionProvider
    let remoteConfigResult: Result<Void, Error>

    var isAppAvailable: Bool {
        guard let result = try? configResult.get()
        else { return false }
        guard let remoteConfigResult = try? remoteConfigResult.get()
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
