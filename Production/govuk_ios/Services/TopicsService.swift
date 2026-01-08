import Foundation
import GOVKit

protocol TopicsServiceInterface {
    func fetchRemoteList(completion: @escaping FetchTopicsListCompletion)
    func fetchDetails(ref: String,
                      completion: @escaping FetchTopicDetailsCompletion)
    func fetchAll() -> [Topic]
    func fetchFavourites() -> [Topic]
    func save()
    func rollback()

    var hasOnboardedTopics: Bool { get }
    func setHasOnboardedTopics()

    func resetOnboarding()
}

class TopicsService: TopicsServiceInterface {
    private let topicsServiceClient: TopicsServiceClientInterface
    private let topicsRepository: () -> TopicsRepositoryInterface
    private let analyticsService: AnalyticsServiceInterface
    private let userDefaultsService: UserDefaultsServiceInterface

    init(topicsServiceClient: TopicsServiceClientInterface,
         analyticsService: AnalyticsServiceInterface,
         userDefaultsService: UserDefaultsServiceInterface,
         topicsRepository: @escaping () -> TopicsRepositoryInterface) {
        self.topicsServiceClient = topicsServiceClient
        self.analyticsService = analyticsService
        self.userDefaultsService = userDefaultsService
        self.topicsRepository = topicsRepository
    }

    func fetchRemoteList(completion: @escaping FetchTopicsListCompletion) {
        topicsServiceClient.fetchList(
            completion: { result in
                switch result {
                case .success(let topics):
                    self.topicsRepository().save(topics: topics)
                    completion(.success(topics))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        )
    }

    func fetchDetails(ref: String,
                      completion: @escaping FetchTopicDetailsCompletion) {
        topicsServiceClient.fetchDetails(
            ref: ref,
            completion: completion
        )
    }

    func fetchAll() -> [Topic] {
        topicsRepository().fetchAll()
    }

    func fetchFavourites() -> [Topic] {
        topicsRepository().fetchFavourites()
    }

    func save() {
        topicsRepository().save()
    }

    func rollback() {
        topicsRepository().rollback()
    }

    func resetOnboarding() {
        userDefaultsService.set(nil, forKey: .topicsOnboardingSeen)
        userDefaultsService.set(nil, forKey: .customisedTopics)
    }

    var hasOnboardedTopics: Bool {
        userDefaultsService.bool(forKey: .topicsOnboardingSeen)
    }

    func setHasOnboardedTopics() {
        userDefaultsService.set(
            bool: true,
            forKey: .topicsOnboardingSeen
        )
    }
}
