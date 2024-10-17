import Foundation

protocol TopicsServiceInterface {
    func downloadTopicsList(completion: @escaping FetchTopicsListResult)
    func downloadTopicDetails(for topicRef: String,
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
        topicsServiceClient.fetchTopicsList { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let topics):
                    topicsRepository.saveTopicsList(topics)
                    completion(.success(topics))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }

    func downloadTopicDetails(for topicRef: String,
                              completion: @escaping FetchTopicDetailsResult) {
        topicsServiceClient.fetchTopicDetails(for: topicRef) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let topicDetail):
                    completion(.success(topicDetail))
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

    func updateFavoriteTopics() {
        topicsRepository.saveChanges()
    }
}
