import Foundation

protocol TopicsServiceInterface {
    func downloadTopicsList(completion: @escaping FetchTopicsListResult)
    func fetchAllTopics() -> [Topic]
    func fetchFavoriteTopics() -> [Topic]
    func updateFavoriteTopics()
    func hasTopicsBeenEdited() -> Bool
    func setHasEditedTopics()
}

class TopicsService: TopicsServiceInterface {
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
        topicsServiceClient.fetchTopicsList { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let topics):
                    self.topicsRepository.saveTopicsList(topics)
                    completion(.success(topics))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }

    func fetchAllTopics() -> [Topic] {
        topicsRepository.fetchAllTopics()
    }

    func fetchFavoriteTopics() -> [Topic] {
        topicsRepository.fetchFavoriteTopics()
    }

    func hasTopicsBeenEdited() -> Bool {
        userDefaults.bool(forKey: .hasEditedTopics)
    }

    func setHasEditedTopics() {
        userDefaults.set(
            bool: true,
            forKey: .hasEditedTopics
        )
    }

    func updateFavoriteTopics() {
        topicsRepository.saveChanges()
    }
}
