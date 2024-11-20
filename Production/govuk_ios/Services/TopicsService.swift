import Foundation

protocol TopicsServiceInterface {
    func fetchRemoteList(completion: @escaping FetchTopicsListResult)
    func fetchDetails(ref: String,
                      completion: @escaping FetchTopicDetailsResult)
    func fetchAll() -> [Topic]
    func fetchFavourites() -> [Topic]
    func save()

    func setHasCustomisedTopics()
    var hasCustomisedTopics: Bool { get }

    var hasOnboardedTopics: Bool { get }
    func setHasOnboardedTopics()
}

struct TopicsService: TopicsServiceInterface {
    private let topicsServiceClient: TopicsServiceClientInterface
    private let topicsRepository: TopicsRepositoryInterface
    private let analyticsService: AnalyticsServiceInterface
    private let userDefaults: UserDefaults

    init(topicsServiceClient: TopicsServiceClientInterface,
         topicsRepository: TopicsRepositoryInterface,
         analyticsService: AnalyticsServiceInterface,
         userDefaults: UserDefaults) {
        self.topicsServiceClient = topicsServiceClient
        self.topicsRepository = topicsRepository
        self.analyticsService = analyticsService
        self.userDefaults = userDefaults
    }

    func fetchRemoteList(completion: @escaping FetchTopicsListResult) {
        topicsServiceClient.fetchList(
            completion: { result in
                switch result {
                case .success(let topics):
                    topicsRepository.save(topics: topics)
                    completion(.success(topics))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        )
    }

    func fetchDetails(ref: String,
                      completion: @escaping FetchTopicDetailsResult) {
        topicsServiceClient.fetchDetails(
            ref: ref,
            completion: completion
        )
    }

    func fetchAll() -> [Topic] {
        topicsRepository.fetchAll()
    }

    func fetchFavourites() -> [Topic] {
        topicsRepository.fetchFavourites()
    }

    func save() {
        topicsRepository.save()
    }

    var hasOnboardedTopics: Bool {
        userDefaults.bool(forKey: .topicsOnboardingSeen)
    }

    func setHasOnboardedTopics() {
        userDefaults.set(
            bool: true,
            forKey: .topicsOnboardingSeen
        )
    }

    func setHasCustomisedTopics() {
        userDefaults.set(
            bool: true,
            forKey: .customisedTopics
        )
        analyticsService.set(
            userProperty: .topicsCustomised
        )
    }

    var hasCustomisedTopics: Bool {
        userDefaults.bool(forKey: .customisedTopics)
    }
}
