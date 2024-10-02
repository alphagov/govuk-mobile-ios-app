import Foundation

final class TopicsWidgetViewModel {
    @Inject(\.analyticsService) private(set) var analyticsService: AnalyticsServiceInterface
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

    func didTapTopic(_ topic: Topic) {
        guard let action = topicAction else { return }
        let event = AppEvent.buttonNavigation(
            text: topic.ref,
            external: false)
        analyticsService.track(event: event)
        action(topic)
    }
}
