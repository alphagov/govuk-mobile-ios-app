import Foundation

protocol TopicsServiceInterface {
    func downloadTopicsList(completion: @escaping FetchTopicsListResult)
    func fetchTopicDetails(topicRef: String,
                           completion: @escaping FetchTopicDetailsResult)
    func fetchAllTopics() -> [Topic]
    func fetchFavoriteTopics() -> [Topic]
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

    func downloadTopicsList(completion: @escaping FetchTopicsListResult) {
        topicsServiceClient.fetchTopicsList(
            completion: { result in
                switch result {
                case .success(let topics):
                    topicsRepository.saveTopicsList(topics)
                    completion(.success(topics))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        )
    }

    func fetchTopicDetails(topicRef: String,
                           completion: @escaping FetchTopicDetailsResult) {
        topicsServiceClient.fetchTopicDetails(
            topicRef: topicRef,
            completion: completion
        )
    }

    func fetchAllTopics() -> [Topic] {
        topicsRepository.fetchAllTopics()
    }

    func setHasEditedTopics() {
        userDefaults.set(
            bool: true,
            forKey: .hasEditedTopics
        )
    }

    func fetchFavoriteTopics() -> [Topic] {
        topicsRepository.fetchFavoriteTopics()
    }

    func save() {
        topicsRepository.saveChanges()
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
