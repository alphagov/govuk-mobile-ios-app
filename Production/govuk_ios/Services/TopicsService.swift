import Foundation

protocol TopicsServiceInterface {
    func fetchRemoteList(completion: @escaping FetchTopicsListCompletion)
    func fetchDetails(ref: String,
                      completion: @escaping FetchTopicDetailsCompletion)
    func fetchAll() -> [Topic]
    func fetchFavourites() -> [Topic]
    func save()

    func setHasPersonalisedTopics()
    var hasPersonalisedTopics: Bool { get }

    var hasOnboardedTopics: Bool { get }
    func setHasOnboardedTopics()
}

struct TopicsService: TopicsServiceInterface {
    private let topicsServiceClient: TopicsServiceClientInterface
    private let topicsRepository: TopicsRepositoryInterface
    private let userDefaults: UserDefaults

    init(topicsServiceClient: TopicsServiceClientInterface,
         topicsRepository: TopicsRepositoryInterface,
         userDefaults: UserDefaults) {
        self.topicsServiceClient = topicsServiceClient
        self.topicsRepository = topicsRepository
        self.userDefaults = userDefaults
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

    func setHasPersonalisedTopics() {
        userDefaults.set(
            bool: true,
            forKey: .personalisedTopics
        )
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

    var hasPersonalisedTopics: Bool {
        userDefaults.bool(forKey: .personalisedTopics)
    }
}
