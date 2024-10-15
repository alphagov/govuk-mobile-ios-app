import Foundation
import CoreData

final class TopicsWidgetViewModel {
    @Inject(\.analyticsService) private(set) var analyticsService: AnalyticsServiceInterface
    let topicsService: TopicsServiceInterface
    let topicAction: ((Topic) -> Void)?
    let editAction: (([Topic]) -> Void)?

    var downloadError: TopicsListError?

    var favoriteTopics: [Topic] {
        topicsService.fetchFavoriteTopics()
    }

    init(topicsService: TopicsServiceInterface,
         topicAction: ((Topic) -> Void)?,
         editAction: (([Topic]) -> Void)?) {
        self.topicsService = topicsService
        self.topicAction = topicAction
        self.editAction = editAction

        self.fetchTopics()
    }

    func fetchTopics() {
        topicsService.downloadTopicsList { result in
            if case .failure(let error) = result {
                self.downloadError = error
            }
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
        guard let action = editAction else { return }
        let topics = topicsService.fetchAllTopics()
        let event = AppEvent.buttonNavigation(
            text: "EditTopics",
            external: false
        )
        analyticsService.track(event: event)
        action(topics)
    }
}
