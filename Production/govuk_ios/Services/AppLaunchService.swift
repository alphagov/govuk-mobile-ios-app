import Foundation

protocol AppLaunchServiceInterface {
    func fetch(completion: @escaping (sending AppLaunchResponse) -> Void)
}

struct AppLaunchService: AppLaunchServiceInterface {
    private let configService: AppConfigServiceInterface
    private let topicService: TopicsServiceInterface
    private let notificationService: NotificationServiceInterface
    private let remoteConfigService: RemoteConfigServiceInterface

    init(configService: AppConfigServiceInterface,
         topicService: TopicsServiceInterface,
         notificationService: NotificationServiceInterface,
         remoteConfigService: RemoteConfigServiceInterface) {
        self.configService = configService
        self.topicService = topicService
        self.notificationService = notificationService
        self.remoteConfigService = remoteConfigService
    }

    func fetch(completion: @escaping (sending AppLaunchResponse) -> Void) {
        Task {
            async let configResult = fetchConfig()
            async let topicResult = fetchTopics()
            async let notificationResult = notificationService.fetchConsentAlignment()
            async let remoteConfigResult = fetchRemoteConfig()
            let response = await AppLaunchResponse(
                configResult: configResult,
                topicResult: topicResult,
                notificationConsentResult: notificationResult,
                remoteConfigFetchResult: remoteConfigResult,
                appVersionProvider: Bundle.main
            )
            DispatchQueue.main.async {
                completion(response)
            }
        }
    }

    private func fetchTopics() async -> FetchTopicsListResult {
        await withCheckedContinuation { continuation in
            topicService.fetchRemoteList(
                completion: continuation.resume
            )
        }
    }

    private func fetchConfig() async -> FetchAppConfigResult {
        await withCheckedContinuation { continuation in
            configService.fetchAppConfig(
                completion: continuation.resume
            )
        }
    }

    private func fetchRemoteConfig() async -> RemoteConfigFetchResult {
        await remoteConfigService.fetch()
    }
}
