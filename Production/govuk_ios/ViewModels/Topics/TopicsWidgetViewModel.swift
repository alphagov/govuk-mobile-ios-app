import Foundation

final class TopicsWidgetViewModel {
    var topics = [Topic]()
    let topicsService: TopicsServiceInterface
    let topicAction: ((Topic) -> Void)?

    init(topicsService: TopicsServiceInterface,
         topicAction: ((Topic) -> Void)?) {
        self.topicsService = topicsService
        self.topicAction = topicAction
    }

    func fetchTopics(completion: FetchTopicsListResult?) {
        topicsService.fetchTopics { result in
            switch result {
            case .success(let topics):
                self.topics = topics
            case .failure(let error):
                print(error)
            }
            completion?(result)
        }
    }
}
