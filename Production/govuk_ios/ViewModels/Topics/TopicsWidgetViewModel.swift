import Foundation

final class TopicsWidgetViewModel {
    @Inject(\.analyticsService) private(set) var analyticsService: AnalyticsServiceInterface
    var topics = [Topic]()
    let topicsService: TopicsServiceInterface
    let topicAction: ((Topic) -> Void)?
    let editAction: (([Topic]) -> Void)?

    init(topicsService: TopicsServiceInterface,
         topicAction: ((Topic) -> Void)?,
         editAction: (([Topic]) -> Void)?) {
        self.topicsService = topicsService
        self.topicAction = topicAction
        self.editAction = editAction
    }

    func fetchTopics(completion: FetchTopicsListResult?) {
        topicsService.fetchTopics { result in
            self.topics = (try? result.get()) ?? []
            completion?(result)
        }
    }

    func didTapTopic(_ topic: Topic) {
        guard let action = topicAction else { return }
        let event = AppEvent.buttonNavigation(
            text: topic.ref,
            external: false
        )
        analyticsService.track(event: event)
        action(topic)
    }

    @objc
    func didTapEdit() {
        editAction?(self.topics)
    }
}
