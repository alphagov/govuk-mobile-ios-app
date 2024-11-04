import Foundation

protocol TopicsServiceInterface {
    func fetchRemoteList(completion: @escaping FetchTopicsListResult)
    func fetchDetails(ref: String,
                      completion: @escaping FetchTopicDetailsResult)
    func fetchAll() -> [Topic]
    func fetchFavorites() -> [Topic]
    func save()

    func setHasEditedTopics()
    var hasTopicsBeenEdited: Bool { get }
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

    func fetchFavorites() -> [Topic] {
        topicsRepository.fetchFavorites()
    }

    func save() {
        topicsRepository.save()
    }

    func setHasEditedTopics() {
        userDefaults.set(
            bool: true,
            forKey: .hasEditedTopics
        )
    }

    var hasOnboardedTopics: Bool {
        userDefaults.bool(forKey: .hasOnboardedTopics)
    }

    func setHasOnboardedTopics() {
        userDefaults.set(
            bool: true,
            forKey: .hasOnboardedTopics
        )
    }

    var hasTopicsBeenEdited: Bool {
        userDefaults.bool(forKey: .hasEditedTopics)
    }
}
