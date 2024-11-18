import Foundation

protocol AppLaunchServiceInterface {
    func fetch(completion: @escaping (sending AppLaunchResponse) -> Void)
}

struct AppLaunchService: AppLaunchServiceInterface {
    private let configService: AppConfigServiceInterface
    private let topicService: TopicsServiceInterface

    init(configService: AppConfigServiceInterface,
         topicService: TopicsServiceInterface) {
        self.configService = configService
        self.topicService = topicService
    }

    func fetch(completion: @escaping (sending AppLaunchResponse) -> Void) {
        Task {
            async let configResult = await fetchConfig()
            async let topicResult = await fetchTopics()
            let response = await AppLaunchResponse(
                configResult: configResult,
                topicResult: topicResult
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
}
