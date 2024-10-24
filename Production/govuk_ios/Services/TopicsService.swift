import Foundation

protocol TopicsServiceInterface {
    func downloadTopicsList(completion: @escaping FetchTopicsListResult)
    func fetchTopicDetails(topicRef: String,
                           completion: @escaping FetchTopicDetailsResult)
    func fetchAllTopics() -> [Topic]
    func fetchFavoriteTopics() -> [Topic]
    func updateFavoriteTopics()
}

struct TopicsService: TopicsServiceInterface {
    private let topicsServiceClient: TopicsServiceClientInterface
    private let topicsRepository: TopicsRepositoryInterface

    init(topicsServiceClient: TopicsServiceClientInterface,
         topicsRepository: TopicsRepositoryInterface) {
        self.topicsServiceClient = topicsServiceClient
        self.topicsRepository = topicsRepository
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

    func fetchFavoriteTopics() -> [Topic] {
        topicsRepository.fetchFavoriteTopics()
    }

    func updateFavoriteTopics() {
        topicsRepository.saveChanges()
    }
}
