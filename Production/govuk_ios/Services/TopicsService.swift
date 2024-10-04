import Foundation

protocol TopicsServiceInterface {
    func fetchTopics(completion: @escaping FetchTopicsListResult)
}

struct TopicsService: TopicsServiceInterface {
    private let topicsServiceClient: TopicsServiceClientInterface

    init(topicsServiceClient: TopicsServiceClientInterface) {
        self.topicsServiceClient = topicsServiceClient
    }

    func fetchTopics(completion: @escaping FetchTopicsListResult) {
        topicsServiceClient.fetchTopicsList { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let topics):
                    let sortedTopics = topics.sorted(by: {
                        $0.title < $1.title
                    })
                    completion(.success(sortedTopics))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
