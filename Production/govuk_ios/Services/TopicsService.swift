import Foundation
import GOVKit

protocol TopicsServiceInterface {
    func fetchRemoteList(completion: @escaping FetchTopicsListCompletion)
    func fetchDetails(ref: String,
                      completion: @escaping FetchTopicDetailsCompletion)
    func fetchAll() -> [Topic]
    func fetchFavourites() -> [Topic]
    func save()

    func setHasCustomisedTopics()
    var hasCustomisedTopics: Bool { get }

    var hasOnboardedTopics: Bool { get }
    func setHasOnboardedTopics()

    func resetOnboarding()
}

struct TopicsService: TopicsServiceInterface {
    private let topicsServiceClient: TopicsServiceClientInterface
    private let topicsRepository: TopicsRepositoryInterface
    private let analyticsService: AnalyticsServiceInterface
    private let userDefaultsService: UserDefaultsServiceInterface

    init(topicsServiceClient: TopicsServiceClientInterface,
         topicsRepository: TopicsRepositoryInterface,
         analyticsService: AnalyticsServiceInterface,
         userDefaultsService: UserDefaultsServiceInterface) {
        self.topicsServiceClient = topicsServiceClient
        self.topicsRepository = topicsRepository
        self.analyticsService = analyticsService
        self.userDefaultsService = userDefaultsService
    }

    func fetchRemoteList(completion: @escaping FetchTopicsListCompletion) {
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
                      completion: @escaping FetchTopicDetailsCompletion) {
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

    func setHasCustomisedTopics() {
        userDefaultsService.set(
            bool: true,
            forKey: .customisedTopics
        )
        analyticsService.set(
            userProperty: .topicsCustomised
        )
    }

    var hasCustomisedTopics: Bool {
        userDefaultsService.bool(forKey: .customisedTopics)
    }
}
