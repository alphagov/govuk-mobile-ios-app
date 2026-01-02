import Foundation
import CoreData

@testable import govuk_ios

extension AppLaunchResponse {
    static var arrangeAvailable: AppLaunchResponse {
        .arrange(
            configResult: .success(.arrange)
        )
    }

    static var arrangeUnavailable: AppLaunchResponse {
        .arrange(
            configResult: .success(.arrange(config: .arrange(available: false)))
        )
    }

    static func arrange(minVersion: String,
                        recommendedVersion: String,
                        currentVersion: String) -> AppLaunchResponse {
        let versionProvider = MockAppVersionProvider()
        versionProvider.versionNumber = currentVersion
        let config = Config.arrange(
            minimumVersion: minVersion,
            recommendedVersion: recommendedVersion
        )
        return .arrange(
            configResult: .success(.arrange(config: config)),
            appVersionProvider: versionProvider
        )
    }

    static func arrange(configResult: FetchAppConfigResult = .success(.arrange),
                        topicResult: FetchTopicsListResult? = nil,
                        appVersionProvider: AppVersionProvider? = nil,
                        remoteConfigFetchResult: RemoteConfigFetchResult = .success) -> AppLaunchResponse {
        let topic = topicResult ?? .success(TopicResponseItem.arrangeMultiple)
        let provider = appVersionProvider ?? MockAppVersionProvider()
        return .init(
            configResult: configResult,
            topicResult: topic,
            notificationConsentResult: .aligned,
            remoteConfigFetchResult: remoteConfigFetchResult,
            appVersionProvider: provider
        )
    }
}

extension AppLaunchResponse: @retroactive Equatable {
    public static func == (lhs: AppLaunchResponse, rhs: AppLaunchResponse) -> Bool {
        lhs.configResult == rhs.configResult &&
        lhs.topicResult == rhs.topicResult &&
        lhs.notificationConsentResult == rhs.notificationConsentResult &&
        lhs.appVersionProvider.fullBuildNumber == rhs.appVersionProvider.fullBuildNumber
    }
}
