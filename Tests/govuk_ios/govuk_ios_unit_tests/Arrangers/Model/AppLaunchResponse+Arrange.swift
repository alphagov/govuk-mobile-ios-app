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
                        topicResult: FetchTopicsListResult = .success(TopicResponseItem.arrangeMultiple),
                        appVersionProvider: AppVersionProvider = MockAppVersionProvider()) -> AppLaunchResponse {
        .init(
            configResult: configResult,
            topicResult: topicResult,
            appVersionProvider: appVersionProvider
        )
    }
}
